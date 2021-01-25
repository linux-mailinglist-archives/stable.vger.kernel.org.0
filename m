Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3937302AF5
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 20:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731281AbhAYS5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:57:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:41888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731222AbhAYSz6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AC2C206B2;
        Mon, 25 Jan 2021 18:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600913;
        bh=6tVQUVr25ZiJks9+fnfFmWcoiU3ovUG3q9kzTo9P4yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DqDCg7B2Dzeh3z4BJk1LIcccF4ye4Fm5TS4yrBgo2tOx71LcNcrzQF8WPukGFBFYf
         YpQpg2Vf1ChcKyvNzIN9g67lVe6iYZdWYx8wobwauSxQHrTPepAGt8O4VrCyilok+w
         EKXvfZq7OCtt67/mPPPSJcdGw64X0nk4FHhmeMVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jirislaby@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 189/199] tty: fix up hung_up_tty_write() conversion
Date:   Mon, 25 Jan 2021 19:40:11 +0100
Message-Id: <20210125183224.153251115@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 17749851eb9ca2298e7c3b81aae4228961b36f28 upstream.

In commit "tty: implement write_iter", I left the write_iter conversion
of the hung up tty case alone, because I incorrectly thought it didn't
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
@@ -437,8 +437,7 @@ static ssize_t hung_up_tty_read(struct f
 	return 0;
 }
 
-static ssize_t hung_up_tty_write(struct file *file, const char __user *buf,
-				 size_t count, loff_t *ppos)
+static ssize_t hung_up_tty_write(struct kiocb *iocb, struct iov_iter *from)
 {
 	return -EIO;
 }
@@ -504,7 +503,7 @@ static const struct file_operations cons
 static const struct file_operations hung_up_tty_fops = {
 	.llseek		= no_llseek,
 	.read		= hung_up_tty_read,
-	.write		= hung_up_tty_write,
+	.write_iter	= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
 	.unlocked_ioctl	= hung_up_tty_ioctl,
 	.compat_ioctl	= hung_up_tty_compat_ioctl,
@@ -1045,7 +1044,9 @@ static ssize_t tty_write(struct kiocb *i
 	if (tty->ops->write_room == NULL)
 		tty_err(tty, "missing write_room method\n");
 	ld = tty_ldisc_ref_wait(tty);
-	if (!ld || !ld->ops->write)
+	if (!ld)
+		return hung_up_tty_write(iocb, from);
+	if (!ld->ops->write)
 		ret = -EIO;
 	else
 		ret = do_tty_write(ld->ops->write, tty, file, from);


