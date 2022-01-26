Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81CA49D14C
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 18:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233685AbiAZR5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 12:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244070AbiAZR5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 12:57:50 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B44FC06173B
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 09:57:50 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so5067321pjj.4
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 09:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bu8dpK8FOO82WqLK7bIdjtIRb6U6eKUm/fxnN5hhOLU=;
        b=EoIiY8c1gw6Q0sWPnfH6bzTGeFRJpM8VgS/+dwNgxelKm0pW7P+qHLF5fkmPxGp+8A
         sf1gOTfqdIBrGMeGHmkBytn0/MsT1cc3xrWC9fLzo1a6yD1YflUhO/Z3sCmA9w6+jX9P
         RshDUfIKSaSJFspjZf/6VHnQxMQF7zijnW1Wo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bu8dpK8FOO82WqLK7bIdjtIRb6U6eKUm/fxnN5hhOLU=;
        b=nSPLBEUeIR9IADD+gJlZR+30ZIBz0/riARxlNLKD0/AkQPBnuNN9EiIOLkdp+IP/i5
         zh6UfzhZWKLMeca1Ib9AhNXgmaaIfZ01PbNHC1x9U/LivzxsvncZlsz0e5OBxgfZzcuR
         0QO53aaqoOQGB2ZhO6vn6sCjf7vXF/MuKromgxDkRZMrlIi3Sr0Af5jJi3FJ2dlh8hWG
         B63LjoUSWBemGyVsBYckOpIDhF5+opADK6NgrxXqNC+RYwETxkaadxg6mGi73qOMrxJb
         RkI7hYUUisii07mWdfKTFdDPxyOMn5laQvjKpsGw17OrXERJJKEIJ+TPuXpRn56LYFwZ
         JZww==
X-Gm-Message-State: AOAM5311tph+Koup584lA7f/cFFgTLjp+pv7MRTQvjpg+10cAEl7g5nk
        +IBA3Upz+8mRPz5AT0mYeOy9Kfb2WM1kXQ==
X-Google-Smtp-Source: ABdhPJyMpShiL28dh9NYPZph22H9TXQaralr0gYIruVT7ZCW8+I5Bv0VI7CuFITmtS6ujmf8bYxlEA==
X-Received: by 2002:a17:902:a404:: with SMTP id p4mr263780plq.2.1643219869683;
        Wed, 26 Jan 2022 09:57:49 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k16sm8650124pgh.45.2022.01.26.09.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 09:57:49 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Ariadne Conill <ariadne@dereferenced.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] fs/binfmt_elf: Add padding NULL when argc == 0
Date:   Wed, 26 Jan 2022 09:57:47 -0800
Message-Id: <20220126175747.3270945-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4170; h=from:subject; bh=nU8KNNO5tauigcRzAerwVslBvcoB9EWNWElP4nO/EqM=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBh8Yuajn59ZUtWtAgMEfYOk4zJmlQsPZ615MVcTp0A Nqyv3b6JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYfGLmgAKCRCJcvTf3G3AJg5VD/ 9dlYywEJpU2xSj/LVcgtU5Dkpx8YWd4fQXVbWDTWm7S4ztJs95C6xH2tlVsQoLxvKeEKh3BXLucA9f 2m1Ifm4Zf2a7svGhs2ML2/oYGJq9HZhPBPn7A/0JHu5QWObkDyxY25T2gcyrsJAum5fnlyHH/r6ehe 9F9PahwMJMUJUT5W9l/HpccDfHkGMPIOQ1RY0wyUpn0ZOcs5keZq3nDF+VPyCy0FuwewJiRAVC2TUL M7wpFdOSNdI6vrcJYyzp2WCBG0C36BsnI3ZzWFoy3mgvkkvU3OBvvB/AAUYaUdyPk5En9a7X2KyhBw pSbEpHB21PNaiATsUP0kx8j2XYXH4iOp02y3CsZU0KeO1vGN3qwqt8RaXY0qE57kzS/6mjqgVUDt9W ALy7qKtGrVmdFUtrQ2cc8YGbPBLZNrbO2sCNmvQfR5ebEDSFgsdEZmbsd4SXQi12FtSv3GHzTUe/5y sHgQbPTPj/h1Cj2l1EI5Bxc9fKSRjqQB/ghD3I5KrvYG0z/uRAur9G4iFCO5yYiGmDXV9a5yeOuggB Bv/xIgohqhPzReqrNTff5eJge810sOYMRZGPB8Oz5TwvQFBkeo5kWu0KVIz5AmxQSBf3jGvFBHaCbH sfPDfGebCDaOW6Jul032Hg7dKOzixcz2LBce4qeidtfmJ5TbNjG21MNcm+PQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Ariadne Conill:

"In several other operating systems, it is a hard requirement that the
first argument to execve(2) be the name of a program, thus prohibiting
a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
but it is not an explicit requirement[1]:

    The argument arg0 should point to a filename string that is
    associated with the process being started by one of the exec
    functions.
...
Interestingly, Michael Kerrisk opened an issue about this in 2008[2],
but there was no consensus to support fixing this issue then.
Hopefully now that CVE-2021-4034 shows practical exploitative use[3]
of this bug in a shellcode, we can reconsider."

An examination of existing[4] users of execve(..., NULL, NULL) shows
mostly test code, or example rootkit code. While rejecting a NULL argv
would be preferred, it looks like the main cause of userspace confusion
is an assumption that argc >= 1, and buggy programs may skip argv[0]
when iterating. To protect against userspace bugs of this nature, insert
an extra NULL pointer in argv when argc == 0, so that argv[1] != envp[0].

Note that this is only done in the argc == 0 case because some userspace
programs expect to find envp at exactly argv[argc]. The overlap of these
two misguided assumptions is believed to be zero.

[1] https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
[2] https://bugzilla.kernel.org/show_bug.cgi?id=8408
[3] https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
[4] https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0

Reported-by: Ariadne Conill <ariadne@dereferenced.org>
Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/binfmt_elf.c | 10 +++++++++-
 fs/exec.c       |  7 ++++++-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 605017eb9349..e456c48658ad 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -297,7 +297,8 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 	ei_index = elf_info - (elf_addr_t *)mm->saved_auxv;
 	sp = STACK_ADD(p, ei_index);
 
-	items = (argc + 1) + (envc + 1) + 1;
+	/* Make room for extra pointer when argc == 0. See below. */
+	items = (min(argc, 1) + 1) + (envc + 1) + 1;
 	bprm->p = STACK_ROUND(sp, items);
 
 	/* Point sp at the lowest address on the stack */
@@ -326,6 +327,13 @@ create_elf_tables(struct linux_binprm *bprm, const struct elfhdr *exec,
 
 	/* Populate list of argv pointers back to argv strings. */
 	p = mm->arg_end = mm->arg_start;
+	/*
+	 * Include an extra NULL pointer in argv when argc == 0 so
+	 * that argv[1] != envp[0] to help userspace programs from
+	 * mishandling argc == 0. See fs/exec.c bprm_stack_limits().
+	 */
+	if (argc == 0 && put_user(0, sp++))
+		return -EFAULT;
 	while (argc-- > 0) {
 		size_t len;
 		if (put_user((elf_addr_t)p, sp++))
diff --git a/fs/exec.c b/fs/exec.c
index 79f2c9483302..0b36384e55b1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -495,8 +495,13 @@ static int bprm_stack_limits(struct linux_binprm *bprm)
 	 * the stack. They aren't stored until much later when we can't
 	 * signal to the parent that the child has run out of stack space.
 	 * Instead, calculate it here so it's possible to fail gracefully.
+	 *
+	 * In the case of argc < 1, make sure there is a NULL pointer gap
+	 * between argv and envp to ensure confused userspace programs don't
+	 * start processing from argv[1], thinking argc can never be 0,
+	 * to block them from walking envp by accident. See fs/binfmt_elf.c.
 	 */
-	ptr_size = (bprm->argc + bprm->envc) * sizeof(void *);
+	ptr_size = (min(bprm->argc, 1) + bprm->envc) * sizeof(void *);
 	if (limit <= ptr_size)
 		return -E2BIG;
 	limit -= ptr_size;
-- 
2.30.2

