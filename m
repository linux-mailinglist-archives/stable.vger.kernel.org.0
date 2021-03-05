Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13EB32E89F
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhCEM15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:27:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231712AbhCEM1e (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:27:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74EB56502E;
        Fri,  5 Mar 2021 12:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947253;
        bh=bP7NK91T05ZDrtJLO2JguKGmgNzXhj1/2ixIejtjAWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LamL6VJM3l/R0RqkJIHO7FAZoWuv5Yjb0JQtH/R0viZhmMmTDpLHMXdbRn3dsuccJ
         vebo5fbKIh+JoEF3P8cE9cw8H1o+sFzGEDBYWibLhtjk/VhlJQytpt4liEeO9GgDi1
         5HB+LNCT0lP4NN5bMO+YlPwuEDlDh+j0jFxD/rF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 097/104] tty: fix up hung_up_tty_read() conversion
Date:   Fri,  5 Mar 2021 13:21:42 +0100
Message-Id: <20210305120907.930252612@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.166929741@linuxfoundation.org>
References: <20210305120903.166929741@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit ddc5fda7456178e2cbc87675b370920d98360daf upstream.

In commit "tty: implement read_iter", I left the read_iter conversion of
the hung up tty case alone, because I incorrectly thought it didn't
matter.

Jiri showed me the errors of my ways, and pointed out the problems with
that incomplete conversion.  Fix it all up.

Reported-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/CAHk-=wh+-rGsa=xruEWdg_fJViFG8rN9bpLrfLz=_yBYh2tBhA@mail.gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_io.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -429,8 +429,7 @@ struct tty_driver *tty_find_polling_driv
 EXPORT_SYMBOL_GPL(tty_find_polling_driver);
 #endif
 
-static ssize_t hung_up_tty_read(struct file *file, char __user *buf,
-				size_t count, loff_t *ppos)
+static ssize_t hung_up_tty_read(struct kiocb *iocb, struct iov_iter *to)
 {
 	return 0;
 }
@@ -502,7 +501,7 @@ static const struct file_operations cons
 
 static const struct file_operations hung_up_tty_fops = {
 	.llseek		= no_llseek,
-	.read		= hung_up_tty_read,
+	.read_iter	= hung_up_tty_read,
 	.write_iter	= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
 	.unlocked_ioctl	= hung_up_tty_ioctl,
@@ -928,8 +927,10 @@ static ssize_t tty_read(struct kiocb *io
 	/* We want to wait for the line discipline to sort out in this
 	   situation */
 	ld = tty_ldisc_ref_wait(tty);
+	if (!ld)
+		return hung_up_tty_read(iocb, to);
 	i = -EIO;
-	if (ld && ld->ops->read)
+	if (ld->ops->read)
 		i = iterate_tty_read(ld, tty, file, to);
 	tty_ldisc_deref(ld);
 


