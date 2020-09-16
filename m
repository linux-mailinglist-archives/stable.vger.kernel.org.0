Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1108026C1D9
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 12:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgIPKlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 06:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbgIPKfH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 06:35:07 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4BB420738;
        Wed, 16 Sep 2020 10:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600252500;
        bh=2WNf3KDCUecl5eFuMkxTxjfqrT1crue8SlcugLFsiFk=;
        h=Subject:To:From:Date:From;
        b=QPRDMabd/LihZEGRMkcAGX5L8fjWyBufxZC7KVtK93hL3T6joQfpcofqIvk2kcd2/
         X9J83GvnN58MCX2V7+nn3exgTt7oTU0++/AIBkqXEKLhK2vprefK4uQeqyCV1XDVtH
         s7TYFqRD5x1kDqTHuvzmqkZXCidgdl5ITysFC7PY=
Subject: patch "USB: UAS: fix disconnect by unplugging a hub" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Sep 2020 12:35:33 +0200
Message-ID: <160025253311123@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: UAS: fix disconnect by unplugging a hub

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 325b008723b2dd31de020e85ab9d2e9aa4637d35 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Wed, 16 Sep 2020 11:40:25 +0200
Subject: USB: UAS: fix disconnect by unplugging a hub

The SCSI layer can go into an ugly loop if you ignore that a device is
gone. You need to report an error in the command rather than in the
return value of the queue method.

We need to specifically check for ENODEV. The issue goes back to the
introduction of the driver.

Fixes: 115bb1ffa54c3 ("USB: Add UAS driver")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200916094026.30085-2-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/uas.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 08f9296431e9..8183504e3abb 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -662,8 +662,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	if (devinfo->resetting) {
 		cmnd->result = DID_ERROR << 16;
 		cmnd->scsi_done(cmnd);
-		spin_unlock_irqrestore(&devinfo->lock, flags);
-		return 0;
+		goto zombie;
 	}
 
 	/* Find a free uas-tag */
@@ -699,6 +698,16 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		cmdinfo->state &= ~(SUBMIT_DATA_IN_URB | SUBMIT_DATA_OUT_URB);
 
 	err = uas_submit_urbs(cmnd, devinfo);
+	/*
+	 * in case of fatal errors the SCSI layer is peculiar
+	 * a command that has finished is a success for the purpose
+	 * of queueing, no matter how fatal the error
+	 */
+	if (err == -ENODEV) {
+		cmnd->result = DID_ERROR << 16;
+		cmnd->scsi_done(cmnd);
+		goto zombie;
+	}
 	if (err) {
 		/* If we did nothing, give up now */
 		if (cmdinfo->state & SUBMIT_STATUS_URB) {
@@ -709,6 +718,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 	}
 
 	devinfo->cmnd[idx] = cmnd;
+zombie:
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 	return 0;
 }
-- 
2.28.0


