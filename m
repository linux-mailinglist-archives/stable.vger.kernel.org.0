Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C873A852
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387622AbfFIQ7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:59:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387620AbfFIQ7J (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:59:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A910D2081C;
        Sun,  9 Jun 2019 16:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099549;
        bh=qKTnaaciZEPFd4Ws7n2MMLts6KGjRfyCVx80ut2XR4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHgG3nj7MEZXK+WPmXMRkLFcVYHJODBQGcqYDJSl/2pD7G8oFqAKTq7nu61cxUzPR
         Ly4Wu5Zq6MKr31Kp4HdCpQxzuoIxgl9kSlYl7zShUXLfzX7CfN3jLIsodPiTqQuXSr
         TRnNpYvKjFsFPPu1uU4dHRoFyqEhQRj6WTGXA/KM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.4 079/241] Revert "scsi: sd: Keep disk read-only when re-reading partition"
Date:   Sun,  9 Jun 2019 18:40:21 +0200
Message-Id: <20190609164150.050102308@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

commit 8acf608e602f6ec38b7cc37b04c80f1ce9a1a6cc upstream.

This reverts commit 20bd1d026aacc5399464f8328f305985c493cde3.

This patch introduced regressions for devices that come online in
read-only state and subsequently switch to read-write.

Given how the partition code is currently implemented it is not
possible to persist the read-only flag across a device revalidate
call. This may need to get addressed in the future since it is common
for user applications to proactively call BLKRRPART.

Reverting this commit will re-introduce a regression where a
device-initiated revalidate event will cause the admin state to be
forgotten. A separate patch will address this issue.

Fixes: 20bd1d026aac ("scsi: sd: Keep disk read-only when re-reading partition")
Cc: <stable@vger.kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/sd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2396,7 +2396,6 @@ sd_read_write_protect_flag(struct scsi_d
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
-	int disk_ro = get_disk_ro(sdkp->disk);
 	int old_wp = sdkp->write_prot;
 
 	set_disk_ro(sdkp->disk, 0);
@@ -2437,7 +2436,7 @@ sd_read_write_protect_flag(struct scsi_d
 			  "Test WP failed, assume Write Enabled\n");
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
-		set_disk_ro(sdkp->disk, sdkp->write_prot || disk_ro);
+		set_disk_ro(sdkp->disk, sdkp->write_prot);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
 			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
 				  sdkp->write_prot ? "on" : "off");


