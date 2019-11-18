Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C92010048C
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 12:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfKRLob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 06:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbfKRLob (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 06:44:31 -0500
Received: from localhost (unknown [89.205.134.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADAEF20730;
        Mon, 18 Nov 2019 11:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574077470;
        bh=b61lnPz5HnXesPl4wgl7ZorFIShBaej0J4fj0Kkl2y8=;
        h=Subject:To:From:Date:From;
        b=sKidJlx9emBo0gQw+HJmK84Gqo+R0Vi8oYQU9I/HUjc9n+ZoDfvGiQL01wVvJpgCE
         /ELnSegszjZjfIvgkKncdnSe8LUfjMNwYTkhsu4EdtmlbokIeIg8PPb81E8mUIhuXm
         8peFjzbnMHg1L+u/qPYNq7na1bFKzsurFL0xpN6k=
Subject: patch "USB: uas: honor flag to avoid CAPACITY16" added to usb-testing
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 12:44:27 +0100
Message-ID: <15740774678266@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: uas: honor flag to avoid CAPACITY16

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From bff000cae1eec750d62e265c4ba2db9af57b17e1 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 14 Nov 2019 12:27:56 +0100
Subject: USB: uas: honor flag to avoid CAPACITY16

Copy the support over from usb-storage to get feature parity

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191114112758.32747-2-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/uas.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 34538253f12c..def2d4aba549 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -825,6 +825,10 @@ static int uas_slave_configure(struct scsi_device *sdev)
 		sdev->wce_default_on = 1;
 	}
 
+	/* Some disks cannot handle READ_CAPACITY_16 */
+	if (devinfo->flags & US_FL_NO_READ_CAPACITY_16)
+		sdev->no_read_capacity_16 = 1;
+
 	/*
 	 * Some disks return the total number of blocks in response
 	 * to READ CAPACITY rather than the highest block number.
-- 
2.24.0


