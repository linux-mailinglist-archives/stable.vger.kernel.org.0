Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0689033BAC9
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhCOOKT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:10:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233813AbhCOOC3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DBEF64EF1;
        Mon, 15 Mar 2021 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816949;
        bh=WdSA0u9QNjoXc1vg2BJB76lxbzJAX+Hz+pf+MzpjaqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lo23kSgQbvfcmll83Xgvg1UsVcYpu7MrFacaknUd2DPpx9ODLyjS7ta2KRTSVNqjD
         fqgScvjCZZIR69dlTG+X2/SpPQoEThEFkI7QZzchOoL8ByaZUTylMSkjeSMmQcvoT8
         tjQ22TsSP1Ixb4n0OWKxWEkRPnLR87RLJ1C5ZLF0=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zqiang <qiang.zhang@windriver.com>,
        Pete Zaitcev <zaitcev@redhat.com>
Subject: [PATCH 5.10 206/290] USB: usblp: fix a hang in poll() if disconnected
Date:   Mon, 15 Mar 2021 14:54:59 +0100
Message-Id: <20210315135548.887601251@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pete Zaitcev <zaitcev@redhat.com>

commit 9de2c43acf37a17dc4c69ff78bb099b80fb74325 upstream.

Apparently an application that opens a device and calls select()
on it, will hang if the decice is disconnected. It's a little
surprising that we had this bug for 15 years, but apparently
nobody ever uses select() with a printer: only write() and read(),
and those work fine. Well, you can also select() with a timeout.

The fix is modeled after devio.c. A few other drivers check the
condition first, then do not add the wait queue in case the
device is disconnected. We doubt that's completely race-free.
So, this patch adds the process first, then locks properly
and checks for the disconnect.

Reviewed-by: Zqiang <qiang.zhang@windriver.com>
Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210303221053.1cf3313e@suzdal.zaitcev.lan
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -494,16 +494,24 @@ static int usblp_release(struct inode *i
 /* No kernel lock - fine */
 static __poll_t usblp_poll(struct file *file, struct poll_table_struct *wait)
 {
-	__poll_t ret;
+	struct usblp *usblp = file->private_data;
+	__poll_t ret = 0;
 	unsigned long flags;
 
-	struct usblp *usblp = file->private_data;
 	/* Should we check file->f_mode & FMODE_WRITE before poll_wait()? */
 	poll_wait(file, &usblp->rwait, wait);
 	poll_wait(file, &usblp->wwait, wait);
+
+	mutex_lock(&usblp->mut);
+	if (!usblp->present)
+		ret |= EPOLLHUP;
+	mutex_unlock(&usblp->mut);
+
 	spin_lock_irqsave(&usblp->lock, flags);
-	ret = ((usblp->bidir && usblp->rcomplete) ? EPOLLIN  | EPOLLRDNORM : 0) |
-	   ((usblp->no_paper || usblp->wcomplete) ? EPOLLOUT | EPOLLWRNORM : 0);
+	if (usblp->bidir && usblp->rcomplete)
+		ret |= EPOLLIN  | EPOLLRDNORM;
+	if (usblp->no_paper || usblp->wcomplete)
+		ret |= EPOLLOUT | EPOLLWRNORM;
 	spin_unlock_irqrestore(&usblp->lock, flags);
 	return ret;
 }


