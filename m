Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0667F37C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406927AbfHBJ5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:57:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:36968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406943AbfHBJ5i (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:57:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23CE12067D;
        Fri,  2 Aug 2019 09:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739857;
        bh=qqQRERP4CjYLgDWYYpOGk3PLzdza4KuNMw5LdUcIO9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLUY4emijBlDGIYhbfcLgOI4/0akGEsqqb7Bcsh8mlYeiaK+vvD8Htvwcs0lpMdWB
         iGftSE01Pb2Qi71nTZBbPi2Xh8TBN3TzBSY635Mhm9IwGQOoFLByhbOxwF3CDU7AqM
         rxFC35pQxJVgRguN4sVQ3+IKbwSoBSQW6Pbpwny8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Jankowski <shasta@toxcorp.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Alexey Izbyshev <izbyshev@ispras.ru>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.2 17/20] /proc/<pid>/cmdline: add back the setproctitle() special case
Date:   Fri,  2 Aug 2019 11:40:11 +0200
Message-Id: <20190802092103.351754105@linuxfoundation.org>
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

commit d26d0cd97c88eb1a5704b42e41ab443406807810 upstream.

This makes the setproctitle() special case very explicit indeed, and
handles it with a separate helper function entirely.  In the process, it
re-instates the original semantics of simply stopping at the first NUL
character when the original last NUL character is no longer there.

[ The original semantics can still be seen in mm/util.c: get_cmdline()
  that is limited to a fixed-size buffer ]

This makes the logic about when we use the string lengths etc much more
obvious, and makes it easier to see what we do and what the two very
different cases are.

Note that even when we allow walking past the end of the argument array
(because the setproctitle() might have overwritten and overflowed the
original argv[] strings), we only allow it when it overflows into the
environment region if it is immediately adjacent.

[ Fixed for missing 'count' checks noted by Alexey Izbyshev ]

Link: https://lore.kernel.org/lkml/alpine.LNX.2.21.1904052326230.3249@kich.toxcorp.com/
Fixes: 5ab827189965 ("fs/proc: simplify and clarify get_mm_cmdline() function")
Cc: Jakub Jankowski <shasta@toxcorp.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexey Izbyshev <izbyshev@ispras.ru>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/proc/base.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 77 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -209,12 +209,53 @@ static int proc_root_link(struct dentry
 	return result;
 }
 
+/*
+ * If the user used setproctitle(), we just get the string from
+ * user space at arg_start, and limit it to a maximum of one page.
+ */
+static ssize_t get_mm_proctitle(struct mm_struct *mm, char __user *buf,
+				size_t count, unsigned long pos,
+				unsigned long arg_start)
+{
+	char *page;
+	int ret, got;
+
+	if (pos >= PAGE_SIZE)
+		return 0;
+
+	page = (char *)__get_free_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	ret = 0;
+	got = access_remote_vm(mm, arg_start, page, PAGE_SIZE, FOLL_ANON);
+	if (got > 0) {
+		int len = strnlen(page, got);
+
+		/* Include the NUL character if it was found */
+		if (len < got)
+			len++;
+
+		if (len > pos) {
+			len -= pos;
+			if (len > count)
+				len = count;
+			len -= copy_to_user(buf, page+pos, len);
+			if (!len)
+				len = -EFAULT;
+			ret = len;
+		}
+	}
+	free_page((unsigned long)page);
+	return ret;
+}
+
 static ssize_t get_mm_cmdline(struct mm_struct *mm, char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	unsigned long arg_start, arg_end;
+	unsigned long arg_start, arg_end, env_start, env_end;
 	unsigned long pos, len;
-	char *page;
+	char *page, c;
 
 	/* Check if process spawned far enough to have cmdline. */
 	if (!mm->env_end)
@@ -223,14 +264,46 @@ static ssize_t get_mm_cmdline(struct mm_
 	spin_lock(&mm->arg_lock);
 	arg_start = mm->arg_start;
 	arg_end = mm->arg_end;
+	env_start = mm->env_start;
+	env_end = mm->env_end;
 	spin_unlock(&mm->arg_lock);
 
 	if (arg_start >= arg_end)
 		return 0;
 
+	/*
+	 * We allow setproctitle() to overwrite the argument
+	 * strings, and overflow past the original end. But
+	 * only when it overflows into the environment area.
+	 */
+	if (env_start != arg_end || env_end < env_start)
+		env_start = env_end = arg_end;
+	len = env_end - arg_start;
+
 	/* We're not going to care if "*ppos" has high bits set */
-	/* .. but we do check the result is in the proper range */
-	pos = arg_start + *ppos;
+	pos = *ppos;
+	if (pos >= len)
+		return 0;
+	if (count > len - pos)
+		count = len - pos;
+	if (!count)
+		return 0;
+
+	/*
+	 * Magical special case: if the argv[] end byte is not
+	 * zero, the user has overwritten it with setproctitle(3).
+	 *
+	 * Possible future enhancement: do this only once when
+	 * pos is 0, and set a flag in the 'struct file'.
+	 */
+	if (access_remote_vm(mm, arg_end-1, &c, 1, FOLL_ANON) == 1 && c)
+		return get_mm_proctitle(mm, buf, count, pos, arg_start);
+
+	/*
+	 * For the non-setproctitle() case we limit things strictly
+	 * to the [arg_start, arg_end[ range.
+	 */
+	pos += arg_start;
 	if (pos < arg_start || pos >= arg_end)
 		return 0;
 	if (count > arg_end - pos)


