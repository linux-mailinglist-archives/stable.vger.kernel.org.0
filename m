Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9767615834C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 20:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgBJTJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 14:09:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727003AbgBJTJS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 14:09:18 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D3AE20842;
        Mon, 10 Feb 2020 19:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581361758;
        bh=SzvuG7qmLJxNXRT+RpNTl4J7PqW3CqKZcfca9x71Aoc=;
        h=Subject:To:From:Date:From;
        b=T7sw79plg9AWLS/yfRJJBr0Wd2xBpMaJMFZXQslq9dGYoGxCOrIBx08RBzocuTvXf
         cr/D/UEZN8cs6s23Ts7ZFMUpniiS+N1Evwsya2GMpgTQQWnvGcK5j5ES3Ms6zEZU5B
         TOeIW8jjZp6k4JwWD/kiCkKHFdnNwDA+cUGh+Fxs=
Subject: patch "usb: uas: fix a plug & unplug racing" added to usb-linus
To:     ejh@nvidia.com, gregkh@linuxfoundation.org, oneukum@suse.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Feb 2020 11:09:17 -0800
Message-ID: <15813617572113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: uas: fix a plug & unplug racing

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3e99862c05a9caa5a27969f41566b428696f5a9a Mon Sep 17 00:00:00 2001
From: EJ Hsu <ejh@nvidia.com>
Date: Thu, 30 Jan 2020 01:25:06 -0800
Subject: usb: uas: fix a plug & unplug racing

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
 drivers/usb/storage/uas.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 95bba3ba6ac6..3670fda02c34 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -45,6 +45,7 @@ struct uas_dev_info {
 	struct scsi_cmnd *cmnd[MAX_CMNDS];
 	spinlock_t lock;
 	struct work_struct work;
+	struct work_struct scan_work;      /* for async scanning */
 };
 
 enum {
@@ -114,6 +115,17 @@ static void uas_do_work(struct work_struct *work)
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
@@ -982,6 +994,7 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	init_usb_anchor(&devinfo->data_urbs);
 	spin_lock_init(&devinfo->lock);
 	INIT_WORK(&devinfo->work, uas_do_work);
+	INIT_WORK(&devinfo->scan_work, uas_scan_work);
 
 	result = uas_configure_endpoints(devinfo);
 	if (result)
@@ -998,7 +1011,9 @@ static int uas_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	if (result)
 		goto free_streams;
 
-	scsi_scan_host(shost);
+	/* Submit the delayed_work for SCSI-device scanning */
+	schedule_work(&devinfo->scan_work);
+
 	return result;
 
 free_streams:
@@ -1166,6 +1181,12 @@ static void uas_disconnect(struct usb_interface *intf)
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
-- 
2.25.0


