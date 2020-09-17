Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF59426E46D
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgIQSsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728580AbgIQQpZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 12:45:25 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76BC0221E8;
        Thu, 17 Sep 2020 16:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600361113;
        bh=A1DalWJzZMBA41/JBJP/0BOwIVlRdS7ln/z6tuGAMjI=;
        h=Subject:To:From:Date:From;
        b=ULx5J65iHsBuW7vFRomUCXgcrhjKY1weUmnwpSxgbMDDXsrWrcLNcNR8pPw3AKge1
         HRviWg/4SN2bFkimS8oy6DwVVW3ZnZKEfl4vr1G/koAlPMbqFjIJr956Bkk8QKHEI8
         dwn13sBujFx/uAlhuYOsf2jpGvM2pJhmBbrwhkOQ=
Subject: patch "usblp: fix race between disconnect() and read()" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 17 Sep 2020 18:45:44 +0200
Message-ID: <16003611444047@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usblp: fix race between disconnect() and read()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9cdabcb3ef8c24ca3a456e4db7b012befb688e73 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 17 Sep 2020 12:34:27 +0200
Subject: usblp: fix race between disconnect() and read()

read() needs to check whether the device has been
disconnected before it tries to talk to the device.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: syzbot+be5b5f86a162a6c281e6@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/20200917103427.15740-1-oneukum@suse.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 084c48c5848f..67cbd42421be 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -827,6 +827,11 @@ static ssize_t usblp_read(struct file *file, char __user *buffer, size_t len, lo
 	if (rv < 0)
 		return rv;
 
+	if (!usblp->present) {
+		count = -ENODEV;
+		goto done;
+	}
+
 	if ((avail = usblp->rstatus) < 0) {
 		printk(KERN_ERR "usblp%d: error %d reading from printer\n",
 		    usblp->minor, (int)avail);
-- 
2.28.0


