Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E762514B64E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbgA1OEF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:04:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727240AbgA1OEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:04:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E58FC205F4;
        Tue, 28 Jan 2020 14:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220244;
        bh=V2hyUtKtmBpeEvnFIAn2SdN6aD677gTdSswgSIWPcvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p3MUxM7ZtJ7cdfvocdMrbf1tD2bxPpMNGC0u38io1xANeL4C+/dlxSlKE7MWO3Pai
         gJG3Bja0Qz+K/j+F5FmWChD+OLrK/lixokCVUks81ePTUNyosSckwfYj8vpjzjsnIr
         FRiyMcD8MgOD93/QLVLrhYpNsQVNtkRLojiiHOis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 5.4 073/104] readdir: make user_access_begin() use the real access range
Date:   Tue, 28 Jan 2020 15:00:34 +0100
Message-Id: <20200128135827.387564443@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 3c2659bd1db81ed6a264a9fc6262d51667d655ad upstream.

In commit 9f79b78ef744 ("Convert filldir[64]() from __put_user() to
unsafe_put_user()") I changed filldir to not do individual __put_user()
accesses, but instead use unsafe_put_user() surrounded by the proper
user_access_begin/end() pair.

That make them enormously faster on modern x86, where the STAC/CLAC
games make individual user accesses fairly heavy-weight.

However, the user_access_begin() range was not really the exact right
one, since filldir() has the unfortunate problem that it needs to not
only fill out the new directory entry, it also needs to fix up the
previous one to contain the proper file offset.

It's unfortunate, but the "d_off" field in "struct dirent" is _not_ the
file offset of the directory entry itself - it's the offset of the next
one.  So we end up backfilling the offset in the previous entry as we
walk along.

But since x86 didn't really care about the exact range, and used to be
the only architecture that did anything fancy in user_access_begin() to
begin with, the filldir[64]() changes did something lazy, and even
commented on it:

	/*
	 * Note! This range-checks 'previous' (which may be NULL).
	 * The real range was checked in getdents
	 */
	if (!user_access_begin(dirent, sizeof(*dirent)))
		goto efault;

and it all worked fine.

But now 32-bit ppc is starting to also implement user_access_begin(),
and the fact that we faked the range to only be the (possibly not even
valid) previous directory entry becomes a problem, because ppc32 will
actually be using the range that is passed in for more than just "check
that it's user space".

This is a complete rewrite of Christophe's original patch.

By saving off the record length of the previous entry instead of a
pointer to it in the filldir data structures, we can simplify the range
check and the writing of the previous entry d_off field.  No need for
any conditionals in the user accesses themselves, although we retain the
conditional EINTR checking for the "was this the first directory entry"
signal handling latency logic.

Fixes: 9f79b78ef744 ("Convert filldir[64]() from __put_user() to unsafe_put_user()")
Link: https://lore.kernel.org/lkml/a02d3426f93f7eb04960a4d9140902d278cab0bb.1579697910.git.christophe.leroy@c-s.fr/
Link: https://lore.kernel.org/lkml/408c90c4068b00ea8f1c41cca45b84ec23d4946b.1579783936.git.christophe.leroy@c-s.fr/
Reported-and-tested-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/readdir.c |   73 ++++++++++++++++++++++++++++-------------------------------
 1 file changed, 35 insertions(+), 38 deletions(-)

--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -206,7 +206,7 @@ struct linux_dirent {
 struct getdents_callback {
 	struct dir_context ctx;
 	struct linux_dirent __user * current_dir;
-	struct linux_dirent __user * previous;
+	int prev_reclen;
 	int count;
 	int error;
 };
@@ -214,12 +214,13 @@ struct getdents_callback {
 static int filldir(struct dir_context *ctx, const char *name, int namlen,
 		   loff_t offset, u64 ino, unsigned int d_type)
 {
-	struct linux_dirent __user * dirent;
+	struct linux_dirent __user *dirent, *prev;
 	struct getdents_callback *buf =
 		container_of(ctx, struct getdents_callback, ctx);
 	unsigned long d_ino;
 	int reclen = ALIGN(offsetof(struct linux_dirent, d_name) + namlen + 2,
 		sizeof(long));
+	int prev_reclen;
 
 	buf->error = verify_dirent_name(name, namlen);
 	if (unlikely(buf->error))
@@ -232,28 +233,24 @@ static int filldir(struct dir_context *c
 		buf->error = -EOVERFLOW;
 		return -EOVERFLOW;
 	}
-	dirent = buf->previous;
-	if (dirent && signal_pending(current))
+	prev_reclen = buf->prev_reclen;
+	if (prev_reclen && signal_pending(current))
 		return -EINTR;
-
-	/*
-	 * Note! This range-checks 'previous' (which may be NULL).
-	 * The real range was checked in getdents
-	 */
-	if (!user_access_begin(dirent, sizeof(*dirent)))
-		goto efault;
-	if (dirent)
-		unsafe_put_user(offset, &dirent->d_off, efault_end);
 	dirent = buf->current_dir;
+	prev = (void __user *) dirent - prev_reclen;
+	if (!user_access_begin(prev, reclen + prev_reclen))
+		goto efault;
+
+	/* This might be 'dirent->d_off', but if so it will get overwritten */
+	unsafe_put_user(offset, &prev->d_off, efault_end);
 	unsafe_put_user(d_ino, &dirent->d_ino, efault_end);
 	unsafe_put_user(reclen, &dirent->d_reclen, efault_end);
 	unsafe_put_user(d_type, (char __user *) dirent + reclen - 1, efault_end);
 	unsafe_copy_dirent_name(dirent->d_name, name, namlen, efault_end);
 	user_access_end();
 
-	buf->previous = dirent;
-	dirent = (void __user *)dirent + reclen;
-	buf->current_dir = dirent;
+	buf->current_dir = (void __user *)dirent + reclen;
+	buf->prev_reclen = reclen;
 	buf->count -= reclen;
 	return 0;
 efault_end:
@@ -267,7 +264,6 @@ SYSCALL_DEFINE3(getdents, unsigned int,
 		struct linux_dirent __user *, dirent, unsigned int, count)
 {
 	struct fd f;
-	struct linux_dirent __user * lastdirent;
 	struct getdents_callback buf = {
 		.ctx.actor = filldir,
 		.count = count,
@@ -285,8 +281,10 @@ SYSCALL_DEFINE3(getdents, unsigned int,
 	error = iterate_dir(f.file, &buf.ctx);
 	if (error >= 0)
 		error = buf.error;
-	lastdirent = buf.previous;
-	if (lastdirent) {
+	if (buf.prev_reclen) {
+		struct linux_dirent __user * lastdirent;
+		lastdirent = (void __user *)buf.current_dir - buf.prev_reclen;
+
 		if (put_user(buf.ctx.pos, &lastdirent->d_off))
 			error = -EFAULT;
 		else
@@ -299,7 +297,7 @@ SYSCALL_DEFINE3(getdents, unsigned int,
 struct getdents_callback64 {
 	struct dir_context ctx;
 	struct linux_dirent64 __user * current_dir;
-	struct linux_dirent64 __user * previous;
+	int prev_reclen;
 	int count;
 	int error;
 };
@@ -307,11 +305,12 @@ struct getdents_callback64 {
 static int filldir64(struct dir_context *ctx, const char *name, int namlen,
 		     loff_t offset, u64 ino, unsigned int d_type)
 {
-	struct linux_dirent64 __user *dirent;
+	struct linux_dirent64 __user *dirent, *prev;
 	struct getdents_callback64 *buf =
 		container_of(ctx, struct getdents_callback64, ctx);
 	int reclen = ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
 		sizeof(u64));
+	int prev_reclen;
 
 	buf->error = verify_dirent_name(name, namlen);
 	if (unlikely(buf->error))
@@ -319,30 +318,27 @@ static int filldir64(struct dir_context
 	buf->error = -EINVAL;	/* only used if we fail.. */
 	if (reclen > buf->count)
 		return -EINVAL;
-	dirent = buf->previous;
-	if (dirent && signal_pending(current))
+	prev_reclen = buf->prev_reclen;
+	if (prev_reclen && signal_pending(current))
 		return -EINTR;
-
-	/*
-	 * Note! This range-checks 'previous' (which may be NULL).
-	 * The real range was checked in getdents
-	 */
-	if (!user_access_begin(dirent, sizeof(*dirent)))
-		goto efault;
-	if (dirent)
-		unsafe_put_user(offset, &dirent->d_off, efault_end);
 	dirent = buf->current_dir;
+	prev = (void __user *)dirent - prev_reclen;
+	if (!user_access_begin(prev, reclen + prev_reclen))
+		goto efault;
+
+	/* This might be 'dirent->d_off', but if so it will get overwritten */
+	unsafe_put_user(offset, &prev->d_off, efault_end);
 	unsafe_put_user(ino, &dirent->d_ino, efault_end);
 	unsafe_put_user(reclen, &dirent->d_reclen, efault_end);
 	unsafe_put_user(d_type, &dirent->d_type, efault_end);
 	unsafe_copy_dirent_name(dirent->d_name, name, namlen, efault_end);
 	user_access_end();
 
-	buf->previous = dirent;
-	dirent = (void __user *)dirent + reclen;
-	buf->current_dir = dirent;
+	buf->prev_reclen = reclen;
+	buf->current_dir = (void __user *)dirent + reclen;
 	buf->count -= reclen;
 	return 0;
+
 efault_end:
 	user_access_end();
 efault:
@@ -354,7 +350,6 @@ int ksys_getdents64(unsigned int fd, str
 		    unsigned int count)
 {
 	struct fd f;
-	struct linux_dirent64 __user * lastdirent;
 	struct getdents_callback64 buf = {
 		.ctx.actor = filldir64,
 		.count = count,
@@ -372,9 +367,11 @@ int ksys_getdents64(unsigned int fd, str
 	error = iterate_dir(f.file, &buf.ctx);
 	if (error >= 0)
 		error = buf.error;
-	lastdirent = buf.previous;
-	if (lastdirent) {
+	if (buf.prev_reclen) {
+		struct linux_dirent64 __user * lastdirent;
 		typeof(lastdirent->d_off) d_off = buf.ctx.pos;
+
+		lastdirent = (void __user *) buf.current_dir - buf.prev_reclen;
 		if (__put_user(d_off, &lastdirent->d_off))
 			error = -EFAULT;
 		else


