Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2E030BFCF
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbhBBNmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232655AbhBBNkU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:40:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E35B64F45;
        Tue,  2 Feb 2021 13:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273180;
        bh=+UndgE/qHOkarTR18Z7vRWC0kJB26ZIpz1g/b12oPNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0IyHzYsaCzhwXNwdqGKKQ53Fjpj0In6f3/OBJqI0YCUlqHFO5dBGPL6MYfklVn0y
         vqahqAO7s8guDXzHLewC3jYQbNWqP9crPVSH8VWT8mO5pYsoYkErH6iN9rg0lnXa9N
         wkJ7yScenEz3Pdo2VgDFoqRVMk/qTQ+BTKysWWKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.10 003/142] tty: avoid using vfs_iocb_iter_write() for redirected console writes
Date:   Tue,  2 Feb 2021 14:36:06 +0100
Message-Id: <20210202132957.832406996@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit a9cbbb80e3e7dd38ceac166e0698f161862a18ae upstream.

It turns out that the vfs_iocb_iter_{read,write}() functions are
entirely broken, and don't actually use the passed-in file pointer for
IO - only for the preparatory work (permission checking and for the
write_iter function lookup).

That worked fine for overlayfs, which always builds the new iocb with
the same file pointer that it passes in, but in the general case it ends
up doing nonsensical things (and could cause an iterator call that
doesn't even match the passed-in file pointer).

This subtly broke the tty conversion to write_iter in commit
9bb48c82aced ("tty: implement write_iter"), because the console
redirection didn't actually end up redirecting anything, since the
passed-in file pointer was basically ignored, and the actual write was
done with the original non-redirected console tty after all.

The main visible effect of this is that the console messages were no
longer logged to /var/log/boot.log during graphical boot.

Fix the issue by simply not using the vfs write "helper" function at
all, and just redirecting the write entirely internally to the tty
layer.  Do the target writability permission checks when actually
registering the target tty with TIOCCONS instead of at write time.

Fixes: 9bb48c82aced ("tty: implement write_iter")
Reported-and-tested-by: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_io.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1027,9 +1027,8 @@ void tty_write_message(struct tty_struct
  *	write method will not be invoked in parallel for each device.
  */
 
-static ssize_t tty_write(struct kiocb *iocb, struct iov_iter *from)
+static ssize_t file_tty_write(struct file *file, struct kiocb *iocb, struct iov_iter *from)
 {
-	struct file *file = iocb->ki_filp;
 	struct tty_struct *tty = file_tty(file);
  	struct tty_ldisc *ld;
 	ssize_t ret;
@@ -1052,6 +1051,11 @@ static ssize_t tty_write(struct kiocb *i
 	return ret;
 }
 
+static ssize_t tty_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	return file_tty_write(iocb->ki_filp, iocb, from);
+}
+
 ssize_t redirected_tty_write(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *p = NULL;
@@ -1061,9 +1065,13 @@ ssize_t redirected_tty_write(struct kioc
 		p = get_file(redirect);
 	spin_unlock(&redirect_lock);
 
+	/*
+	 * We know the redirected tty is just another tty, we can can
+	 * call file_tty_write() directly with that file pointer.
+	 */
 	if (p) {
 		ssize_t res;
-		res = vfs_iocb_iter_write(p, iocb, iter);
+		res = file_tty_write(p, iocb, iter);
 		fput(p);
 		return res;
 	}
@@ -2306,6 +2314,12 @@ static int tioccons(struct file *file)
 			fput(f);
 		return 0;
 	}
+	if (file->f_op->write_iter != tty_write)
+		return -ENOTTY;
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
+	if (!(file->f_mode & FMODE_CAN_WRITE))
+		return -EINVAL;
 	spin_lock(&redirect_lock);
 	if (redirect) {
 		spin_unlock(&redirect_lock);


