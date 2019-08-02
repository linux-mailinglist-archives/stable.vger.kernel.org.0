Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 929AF7F372
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406938AbfHBJ5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406927AbfHBJ5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:57:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D4152087E;
        Fri,  2 Aug 2019 09:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739855;
        bh=5W4dctkklet+YRqJmdWU9pIKj5QywGjKwTBSpZG1DD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkzUikPbbagiZk0mpGiWrdiDs+eolBqcTwJtZXIvmIuTi/Wj1GIqrKP0fmQP4cI3y
         4RvYx1fUpEajCJERNim/53q2gxALKoEs5Wugxb/tnGzZat3Lpm+NBc7pW6J8e8ATbc
         xyP212RPFZCTH2jITyBrN1RaZvUzNSEcSoyhogDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Izbyshev <izbyshev@ispras.ru>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 16/20] /proc/<pid>/cmdline: remove all the special cases
Date:   Fri,  2 Aug 2019 11:40:10 +0200
Message-Id: <20190802092103.111388932@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092055.131876977@linuxfoundation.org>
References: <20190802092055.131876977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 3d712546d8ba9f25cdf080d79f90482aa4231ed4 upstream.

Start off with a clean slate that only reads exactly from arg_start to
arg_end, without any oddities.  This simplifies the code and in the
process removes the case that caused us to potentially leak an
uninitialized byte from the temporary kernel buffer.

Note that in order to start from scratch with an understandable base,
this simplifies things _too_ much, and removes all the legacy logic to
handle setproctitle() having changed the argument strings.

We'll add back those special cases very differently in the next commit.

Link: https://lore.kernel.org/lkml/20190712160913.17727-1-izbyshev@ispras.ru/
Fixes: f5b65348fd77 ("proc: fix missing final NUL in get_mm_cmdline() rewrite")
Cc: Alexey Izbyshev <izbyshev@ispras.ru>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/base.c |   71 ++++++---------------------------------------------------
 1 file changed, 8 insertions(+), 63 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -212,7 +212,7 @@ static int proc_root_link(struct dentry
 static ssize_t get_mm_cmdline(struct mm_struct *mm, char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	unsigned long arg_start, arg_end, env_start, env_end;
+	unsigned long arg_start, arg_end;
 	unsigned long pos, len;
 	char *page;
 
@@ -223,36 +223,18 @@ static ssize_t get_mm_cmdline(struct mm_
 	spin_lock(&mm->arg_lock);
 	arg_start = mm->arg_start;
 	arg_end = mm->arg_end;
-	env_start = mm->env_start;
-	env_end = mm->env_end;
 	spin_unlock(&mm->arg_lock);
 
 	if (arg_start >= arg_end)
 		return 0;
 
-	/*
-	 * We have traditionally allowed the user to re-write
-	 * the argument strings and overflow the end result
-	 * into the environment section. But only do that if
-	 * the environment area is contiguous to the arguments.
-	 */
-	if (env_start != arg_end || env_start >= env_end)
-		env_start = env_end = arg_end;
-
-	/* .. and limit it to a maximum of one page of slop */
-	if (env_end >= arg_end + PAGE_SIZE)
-		env_end = arg_end + PAGE_SIZE - 1;
-
 	/* We're not going to care if "*ppos" has high bits set */
-	pos = arg_start + *ppos;
-
 	/* .. but we do check the result is in the proper range */
-	if (pos < arg_start || pos >= env_end)
+	pos = arg_start + *ppos;
+	if (pos < arg_start || pos >= arg_end)
 		return 0;
-
-	/* .. and we never go past env_end */
-	if (env_end - pos < count)
-		count = env_end - pos;
+	if (count > arg_end - pos)
+		count = arg_end - pos;
 
 	page = (char *)__get_free_page(GFP_KERNEL);
 	if (!page)
@@ -262,48 +244,11 @@ static ssize_t get_mm_cmdline(struct mm_
 	while (count) {
 		int got;
 		size_t size = min_t(size_t, PAGE_SIZE, count);
-		long offset;
-
-		/*
-		 * Are we already starting past the official end?
-		 * We always include the last byte that is *supposed*
-		 * to be NUL
-		 */
-		offset = (pos >= arg_end) ? pos - arg_end + 1 : 0;
 
-		got = access_remote_vm(mm, pos - offset, page, size + offset, FOLL_ANON);
-		if (got <= offset)
+		got = access_remote_vm(mm, pos, page, size, FOLL_ANON);
+		if (got <= 0)
 			break;
-		got -= offset;
-
-		/* Don't walk past a NUL character once you hit arg_end */
-		if (pos + got >= arg_end) {
-			int n = 0;
-
-			/*
-			 * If we started before 'arg_end' but ended up
-			 * at or after it, we start the NUL character
-			 * check at arg_end-1 (where we expect the normal
-			 * EOF to be).
-			 *
-			 * NOTE! This is smaller than 'got', because
-			 * pos + got >= arg_end
-			 */
-			if (pos < arg_end)
-				n = arg_end - pos - 1;
-
-			/* Cut off at first NUL after 'n' */
-			got = n + strnlen(page+n, offset+got-n);
-			if (got < offset)
-				break;
-			got -= offset;
-
-			/* Include the NUL if it existed */
-			if (got < size)
-				got++;
-		}
-
-		got -= copy_to_user(buf, page+offset, got);
+		got -= copy_to_user(buf, page, got);
 		if (unlikely(!got)) {
 			if (!len)
 				len = -EFAULT;


