Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9824A53D0
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 01:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbiBAAJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 19:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiBAAJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 19:09:52 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6C5C06173E
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 16:09:52 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id 192so14311351pfz.3
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 16:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5qwLaEIOYlijwyduplYEjWelGWybvaxEnn7HYTpgP70=;
        b=mfBat4L77tKMTAhNSuJn3palyMkxYAKXtUo2345uF66a7Zve1Wh63z06waYxMc2JmJ
         pZjftdSTxVUeocBOulxZral26pOzB1DWdXI6lPmlB/a8tUT7xwF1mYM+qJ8fa7naBVXd
         X/mJpi59esp4KSFZZF7Je3D9jfUS7CyDLVq2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5qwLaEIOYlijwyduplYEjWelGWybvaxEnn7HYTpgP70=;
        b=syxSNzO3PePNp74X8Y9E2JI8eOjKRnIzbIHGp/N7QnMrGGRFYsKfUK6nPsKD853lKw
         eq9vPIpKAPU+e8XO6haSwgEoi7q0tJ71HxobQ7kTcU7IPoG8DANoqEL9M+GTJpATsFat
         2dG5jBw9BqQ+rNcyMudJzHqDu9tZhqMtw5gh8YU9bed7YwKcblC+piEGlJKVNBANMewF
         3f9O7LATdZXKakou2grkntKI/3AkDOuYeIo0XG6mFZ7U+/Z6RnjvhrSzsgHKWxVup7N9
         +mzUwutLvmQ0p60nW0VPIy15cLy7qPpx0JaqrBHIP7fv1/Oi8A/oG9GKpNjLjhxrbARh
         2eIQ==
X-Gm-Message-State: AOAM533A6KWLRcC7fWorsGBVwwTOPQogjnPSDI1SuEZ8cWEr0+Q2aXHL
        CN5Q+JEdRoqn5C7PNjA2bCXvCQ==
X-Google-Smtp-Source: ABdhPJxLkBuK1RGXLbnoqpApwiPt4eSLFw4uUzc1mr036KSTiU6DRnWMP5a/gRdhrOLhYs/aSMcDhQ==
X-Received: by 2002:a63:86c8:: with SMTP id x191mr18864852pgd.248.1643674191512;
        Mon, 31 Jan 2022 16:09:51 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c18sm2021208pfp.181.2022.01.31.16.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 16:09:51 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Ariadne Conill <ariadne@dereferenced.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Rich Felker <dalias@libc.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] exec: Force single empty string when argv is empty
Date:   Mon, 31 Jan 2022 16:09:47 -0800
Message-Id: <20220201000947.2453721-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4766; h=from:subject; bh=gaATF+4EbtmlAe3Nasp9+LtjYlIXpznex7XqhlI1JLg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBh+HpKpuM0Z7w1vc/DKue58FoVRYdahszqKEUikyKs LkopZsyJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYfh6SgAKCRCJcvTf3G3AJkQwD/ 9gaH8XIr+oEzkggBsQWnCKXTzVmALVe4Zgbuh4C1rNxscXB+aeb4/KQKr3K6vvJ2l/fkh70QW+Pn7u gIJ269Ql3ilTvYMn4HXVyAftwmN3ReDuZJeWNXj4y8gu7ACcVdP4DJh0sfA83KqkhOsgAf9y4DJ8iP OCGZIYAtkcZ+f/KxXM2BDfRb9ddLfwTJn9jHsMftdAK+Yn1zDj17kaeVxZ0W/d65OjCPd6tGgZ3s1c PlXZkeb4CHB7Oav2IKW6lx+21mDFSdm39f9LFCxm+vkzRsLN7rNIJXtdYnvmDgp3BiiEN59pAnk4LM b3tUHI2SsF2nwRpgeVXNUvPYyQvhSiEwC+oY7A16TzgvXU/bF78NmoWUa++albTJtNIeclGpUY63jE v/gCI2FvzFJ6AQBKO5k4pYdUY2/9xPW0b5P6lBvZJyiNFq29tSe1Hiug56G71uztL142LyKBpY1kLG MNpkEp5mybjnAWfXuO5CJNWOaqu3nWYwWqp+3C3AoJP1ftEZo4D4d8jYJLvL/1oyLriS3Y8T5p+LNE zjwsDh7xTQmmr/+sCcnGH3Elw7u2oOGxfZoP24E+ZhWsr4d3NzZ56dxWxYswOkMITolnGYZsne/Zj9 RHyBi5T2aGJ2C2EM0GgBZxw0rpfMuR5J/mTN8WYHLei3px/8432HbTf+5lkQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting[1] Ariadne Conill:

"In several other operating systems, it is a hard requirement that the
second argument to execve(2) be the name of a program, thus prohibiting
a scenario where argc < 1. POSIX 2017 also recommends this behaviour,
but it is not an explicit requirement[2]:

    The argument arg0 should point to a filename string that is
    associated with the process being started by one of the exec
    functions.
...
Interestingly, Michael Kerrisk opened an issue about this in 2008[3],
but there was no consensus to support fixing this issue then.
Hopefully now that CVE-2021-4034 shows practical exploitative use[4]
of this bug in a shellcode, we can reconsider.

This issue is being tracked in the KSPP issue tracker[5]."

While the initial code searches[6][7] turned up what appeared to be
mostly corner case tests, trying to that just reject argv == NULL
(or an immediately terminated pointer list) quickly started tripping[8]
existing userspace programs.

The next best approach is forcing a single empty string into argv and
adjusting argc to match. The number of programs depending on argc == 0
seems a smaller set than those calling execve with a NULL argv.

Account for the additional stack space in bprm_stack_limits(). Inject an
empty string when argc == 0 (and set argc = 1). Warn about the case so
userspace has some notice about the change:

    process './argc0' launched './argc0' with NULL argv: empty string added

Additionally WARN() and reject NULL argv usage for kernel threads.

[1] https://lore.kernel.org/lkml/20220127000724.15106-1-ariadne@dereferenced.org/
[2] https://pubs.opengroup.org/onlinepubs/9699919799/functions/exec.html
[3] https://bugzilla.kernel.org/show_bug.cgi?id=8408
[4] https://www.qualys.com/2022/01/25/cve-2021-4034/pwnkit.txt
[5] https://github.com/KSPP/linux/issues/176
[6] https://codesearch.debian.net/search?q=execve%5C+*%5C%28%5B%5E%2C%5D%2B%2C+*NULL&literal=0
[7] https://codesearch.debian.net/search?q=execlp%3F%5Cs*%5C%28%5B%5E%2C%5D%2B%2C%5Cs*NULL&literal=0
[8] https://lore.kernel.org/lkml/20220131144352.GE16385@xsang-OptiPlex-9020/

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
 fs/exec.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index 79f2c9483302..bbf3aadf7ce1 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -495,8 +495,14 @@ static int bprm_stack_limits(struct linux_binprm *bprm)
 	 * the stack. They aren't stored until much later when we can't
 	 * signal to the parent that the child has run out of stack space.
 	 * Instead, calculate it here so it's possible to fail gracefully.
+	 *
+	 * In the case of argc = 0, make sure there is space for adding a
+	 * empty string (which will bump argc to 1), to ensure confused
+	 * userspace programs don't start processing from argv[1], thinking
+	 * argc can never be 0, to keep them from walking envp by accident.
+	 * See do_execveat_common().
 	 */
-	ptr_size = (bprm->argc + bprm->envc) * sizeof(void *);
+	ptr_size = (min(bprm->argc, 1) + bprm->envc) * sizeof(void *);
 	if (limit <= ptr_size)
 		return -E2BIG;
 	limit -= ptr_size;
@@ -1897,6 +1903,9 @@ static int do_execveat_common(int fd, struct filename *filename,
 	}
 
 	retval = count(argv, MAX_ARG_STRINGS);
+	if (retval == 0)
+		pr_warn_once("process '%s' launched '%s' with NULL argv: empty string added\n",
+			     current->comm, bprm->filename);
 	if (retval < 0)
 		goto out_free;
 	bprm->argc = retval;
@@ -1923,6 +1932,19 @@ static int do_execveat_common(int fd, struct filename *filename,
 	if (retval < 0)
 		goto out_free;
 
+	/*
+	 * When argv is empty, add an empty string ("") as argv[0] to
+	 * ensure confused userspace programs that start processing
+	 * from argv[1] won't end up walking envp. See also
+	 * bprm_stack_limits().
+	 */
+	if (bprm->argc == 0) {
+		retval = copy_string_kernel("", bprm);
+		if (retval < 0)
+			goto out_free;
+		bprm->argc = 1;
+	}
+
 	retval = bprm_execve(bprm, fd, filename, flags);
 out_free:
 	free_bprm(bprm);
@@ -1951,6 +1973,8 @@ int kernel_execve(const char *kernel_filename,
 	}
 
 	retval = count_strings_kernel(argv);
+	if (WARN_ON_ONCE(retval == 0))
+		retval = -EINVAL;
 	if (retval < 0)
 		goto out_free;
 	bprm->argc = retval;
-- 
2.30.2

