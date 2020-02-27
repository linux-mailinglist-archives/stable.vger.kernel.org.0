Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B67E171F4B
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgB0OAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:00:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731935AbgB0OAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:00:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90FCD2073D;
        Thu, 27 Feb 2020 14:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812003;
        bh=G5VPVzGmHIUVhj9m7B4QywZ6P6fWuOGfq879D4Ri7Ug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHNLqa0PbjsmLG8gYO9G31+cbqQsV0C01akgBe8TGyUfPI2B5APMA6JFkaK/1cpq3
         EgDlcPsOqhg8N8QJ1y4t6bNksvbeiruYdfsmy2w5+lCEab+9R6PTcH8ErzN6OjogrL
         0nLDU26VxE3AAyxXbese/CwKz3PoSHzaN+JjmmbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, EJ Hsu <ejh@nvidia.com>,
        Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.14 183/237] usb: uas: fix a plug & unplug racing
Date:   Thu, 27 Feb 2020 14:36:37 +0100
Message-Id: <20200227132309.826483145@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: EJ Hsu <ejh@nvidia.com>

commit 3e99862c05a9caa5a27969f41566b428696f5a9a upstream.

When a uas disk is plugged into an external hub, uas_probe()
will be called by the hub thread to do the probe. It will
first create a SCSI host and then do the scan for this host.
During the scan, it will probe the LUN using SCSI INQUERY command
which will be packed in the URB and submitted to uas disk.

There might be a chance that this external hub with uas disk
attached is unplugged during the scan. In this case, uas driver
will fail to submit the URB (due to the NOTATTACHED state of uas
device) and try to put this SCSI command back to request queue
waiting for next chance to run.

In normal case, this cycle will terminate when hub thread gets
disconnection event and calls into uas_disconnect() accordingly.
But in this case, uas_disconnect() will not be called because
hub thread of external hub gets stuck waiting for the completion
of this SCSI command. A deadlock happened.

In this fix, uas will call scsi_scan_host() asynchronously to
avoid the blocking of hub thread.

Signed-off-by: EJ Hsu <ejh@nvidia.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200130092506.102760-1-ejh@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/storage/uas.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -46,6 +46,7 @@ struct uas_dev_info {
 	struct scsi_cmnd *cmnd[MAX_CMNDS];
 	spinlock_t lock;
 	struct work_struct work;
+	struct work_struct scan_work;      /* for async scanning */
 };
 
 enum {
@@ -115,6 +116,17 @@ out:
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
 
+static void uas_scan_work(struct work_struct *work)
+{
+	struct uas_dev_info *devinfo =
+		container_of(work, struct uas_dev_info, scan_work);
+	struct Scsi_Host *shost = usb_get_intfdata(devinfo->intf);
+
+	dev_dbg(&devinfo->intf->dev, "starting scan\n");
+	scsi_scan_host(shost);
+	dev_dbg(&devinfo->intf->dev, "scan complete\n");
+}
+
 static void uas_add_work(struct uas_cmd_info *cmdinfo)
 {
 	struct scsi_pointer *scp = (void *)cmdinfo;
@@ -989,6 +1001,7 @@ static int uas_probe(struct usb_interfac
 	init_usb_anchor(&devinfo->data_urbs);
 	spin_lock_init(&devinfo->lock);
 	INIT_WORK(&devinfo->work, uas_do_work);
+	INIT_WORK(&devinfo->scan_work, uas_scan_work);
 
 	result = uas_configure_endpoints(devinfo);
 	if (result)
@@ -1005,7 +1018,9 @@ static int uas_probe(struct usb_interfac
 	if (result)
 		goto free_streams;
 
-	scsi_scan_host(shost);
+	/* Submit the delayed_work for SCSI-device scanning */
+	schedule_work(&devinfo->scan_work);
+
 	return result;
 
 free_streams:
@@ -1173,6 +1188,12 @@ static void uas_disconnect(struct usb_in
 	usb_kill_anchored_urbs(&devinfo->data_urbs);
 	uas_zap_pending(devinfo, DID_NO_CONNECT);
 
+	/*
+	 * Prevent SCSI scanning (if it hasn't started yet)
+	 * or wait for the SCSI-scanning routine to stop.
+	 */
+	cancel_work_sync(&devinfo->scan_work);
+
 	scsi_remove_host(shost);
 	uas_free_streams(devinfo);
 	scsi_host_put(shost);


