Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59A24F018E
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239818AbiDBMpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 08:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233007AbiDBMpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 08:45:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5893DDEC
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:43:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31C18B80159
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92475C3410F;
        Sat,  2 Apr 2022 12:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648903391;
        bh=5UKbOXYrs9m/EI0huSJu4WRCngn0rZSZvBjB6BpGvgg=;
        h=Subject:To:Cc:From:Date:From;
        b=ZZa7cVAaM9gNT+oexi2h5qtxS+tp7XTTa4PMfv9CxkVgpbsE3Cii7OLjbSBDMbCav
         DArBdCL3ViKDsFmZZRCeNoTzvshMnFzH0uacHvW39/GHxeLgR5UuozKRnsm0bQ/oBR
         D9D08ruzWOij2NU/7AiQV9sTLIZhtwlQLwqIUoDM=
Subject: FAILED: patch "[PATCH] exec: Force single empty string when argv is empty" failed to apply to 4.19-stable tree
To:     keescook@chromium.org, ariadne@dereferenced.org,
        brauner@kernel.org, dalias@libc.org, ebiederm@xmission.com,
        luto@kernel.org, mtk.manpages@gmail.com, viro@zeniv.linux.org.uk,
        willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:43:04 +0200
Message-ID: <16489033844956@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dcd46d897adb70d63e025f175a00a89797d31a43 Mon Sep 17 00:00:00 2001
From: Kees Cook <keescook@chromium.org>
Date: Mon, 31 Jan 2022 16:09:47 -0800
Subject: [PATCH] exec: Force single empty string when argv is empty

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
Acked-by: Christian Brauner <brauner@kernel.org>
Acked-by: Ariadne Conill <ariadne@dereferenced.org>
Acked-by: Andy Lutomirski <luto@kernel.org>
Link: https://lore.kernel.org/r/20220201000947.2453721-1-keescook@chromium.org

diff --git a/fs/exec.c b/fs/exec.c
index 79f2c9483302..40b1008fb0f7 100644
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
+	ptr_size = (max(bprm->argc, 1) + bprm->envc) * sizeof(void *);
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

