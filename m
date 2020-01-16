Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 842A713F004
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392616AbgAPR2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:28:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392612AbgAPR2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:28:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15A84246FB;
        Thu, 16 Jan 2020 17:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195716;
        bh=M67lEIo55FH6sTajIGnCevDurU/nFr3YKiBoOg5fC1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n7f5fqa5VQz4jOFmx8h20slZY2UDCOM6YncfP3yqdEZd25ACvYEUAOTzukgpLglqU
         OYERCBCQJWokyKUjZoF9i4MDuJwNvkbMOXasnRD5r5T9e6lpAWc/aMMryyX4GzNIel
         jy04mj2TKF77V4WnGyNr+AF6NM38Ye+YaF7Tcle0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paul Wise <pabs3@bonedaddy.net>, Jakub Wilk <jwilk@jwilk.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 260/371] coredump: split pipe command whitespace before expanding template
Date:   Thu, 16 Jan 2020 12:22:12 -0500
Message-Id: <20200116172403.18149-203-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Wise <pabs3@bonedaddy.net>

[ Upstream commit 315c69261dd3fa12dbc830d4fa00d1fad98d3b03 ]

Save the offsets of the start of each argument to avoid having to update
pointers to each argument after every corename krealloc and to avoid
having to duplicate the memory for the dump command.

Executable names containing spaces were previously being expanded from
%e or %E and then split in the middle of the filename.  This is
incorrect behaviour since an argument list can represent arguments with
spaces.

The splitting could lead to extra arguments being passed to the core
dump handler that it might have interpreted as options or ignored
completely.

Core dump handlers that are not aware of this Linux kernel issue will be
using %e or %E without considering that it may be split and so they will
be vulnerable to processes with spaces in their names breaking their
argument list.  If their internals are otherwise well written, such as
if they are written in shell but quote arguments, they will work better
after this change than before.  If they are not well written, then there
is a slight chance of breakage depending on the details of the code but
they will already be fairly broken by the split filenames.

Core dump handlers that are aware of this Linux kernel issue will be
placing %e or %E as the last item in their core_pattern and then
aggregating all of the remaining arguments into one, separated by
spaces.  Alternatively they will be obtaining the filename via other
methods.  Both of these will be compatible with the new arrangement.

A side effect from this change is that unknown template types (for
example %z) result in an empty argument to the dump handler instead of
the argument being dropped.  This is a desired change as:

It is easier for dump handlers to process empty arguments than dropped
ones, especially if they are written in shell or don't pass each
template item with a preceding command-line option in order to
differentiate between individual template types.  Most core_patterns in
the wild do not use options so they can confuse different template types
(especially numeric ones) if an earlier one gets dropped in old kernels.
If the kernel introduces a new template type and a core_pattern uses it,
the core dump handler might not expect that the argument can be dropped
in old kernels.

For example, this can result in security issues when %d is dropped in
old kernels.  This happened with the corekeeper package in Debian and
resulted in the interface between corekeeper and Linux having to be
rewritten to use command-line options to differentiate between template
types.

The core_pattern for most core dump handlers is written by the handler
author who would generally not insert unknown template types so this
change should be compatible with all the core dump handlers that exist.

Link: http://lkml.kernel.org/r/20190528051142.24939-1-pabs3@bonedaddy.net
Fixes: 74aadce98605 ("core_pattern: allow passing of arguments to user mode helper when core_pattern is a pipe")
Signed-off-by: Paul Wise <pabs3@bonedaddy.net>
Reported-by: Jakub Wilk <jwilk@jwilk.net> [https://bugs.debian.org/924398]
Reported-by: Paul Wise <pabs3@bonedaddy.net> [https://lore.kernel.org/linux-fsdevel/c8b7ecb8508895bf4adb62a748e2ea2c71854597.camel@bonedaddy.net/]
Suggested-by: Jakub Wilk <jwilk@jwilk.net>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/coredump.c | 44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 52c63d6c9143..0e5d2e447a71 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -7,6 +7,7 @@
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/swap.h>
+#include <linux/ctype.h>
 #include <linux/string.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
@@ -187,11 +188,13 @@ static int cn_print_exe_file(struct core_name *cn)
  * name into corename, which must have space for at least
  * CORENAME_MAX_SIZE bytes plus one byte for the zero terminator.
  */
-static int format_corename(struct core_name *cn, struct coredump_params *cprm)
+static int format_corename(struct core_name *cn, struct coredump_params *cprm,
+			   size_t **argv, int *argc)
 {
 	const struct cred *cred = current_cred();
 	const char *pat_ptr = core_pattern;
 	int ispipe = (*pat_ptr == '|');
+	bool was_space = false;
 	int pid_in_pattern = 0;
 	int err = 0;
 
@@ -201,12 +204,35 @@ static int format_corename(struct core_name *cn, struct coredump_params *cprm)
 		return -ENOMEM;
 	cn->corename[0] = '\0';
 
-	if (ispipe)
+	if (ispipe) {
+		int argvs = sizeof(core_pattern) / 2;
+		(*argv) = kmalloc_array(argvs, sizeof(**argv), GFP_KERNEL);
+		if (!(*argv))
+			return -ENOMEM;
+		(*argv)[(*argc)++] = 0;
 		++pat_ptr;
+	}
 
 	/* Repeat as long as we have more pattern to process and more output
 	   space */
 	while (*pat_ptr) {
+		/*
+		 * Split on spaces before doing template expansion so that
+		 * %e and %E don't get split if they have spaces in them
+		 */
+		if (ispipe) {
+			if (isspace(*pat_ptr)) {
+				was_space = true;
+				pat_ptr++;
+				continue;
+			} else if (was_space) {
+				was_space = false;
+				err = cn_printf(cn, "%c", '\0');
+				if (err)
+					return err;
+				(*argv)[(*argc)++] = cn->used;
+			}
+		}
 		if (*pat_ptr != '%') {
 			err = cn_printf(cn, "%c", *pat_ptr++);
 		} else {
@@ -546,6 +572,8 @@ void do_coredump(const siginfo_t *siginfo)
 	struct cred *cred;
 	int retval = 0;
 	int ispipe;
+	size_t *argv = NULL;
+	int argc = 0;
 	struct files_struct *displaced;
 	/* require nonrelative corefile path and be extra careful */
 	bool need_suid_safe = false;
@@ -592,9 +620,10 @@ void do_coredump(const siginfo_t *siginfo)
 
 	old_cred = override_creds(cred);
 
-	ispipe = format_corename(&cn, &cprm);
+	ispipe = format_corename(&cn, &cprm, &argv, &argc);
 
 	if (ispipe) {
+		int argi;
 		int dump_count;
 		char **helper_argv;
 		struct subprocess_info *sub_info;
@@ -637,12 +666,16 @@ void do_coredump(const siginfo_t *siginfo)
 			goto fail_dropcount;
 		}
 
-		helper_argv = argv_split(GFP_KERNEL, cn.corename, NULL);
+		helper_argv = kmalloc_array(argc + 1, sizeof(*helper_argv),
+					    GFP_KERNEL);
 		if (!helper_argv) {
 			printk(KERN_WARNING "%s failed to allocate memory\n",
 			       __func__);
 			goto fail_dropcount;
 		}
+		for (argi = 0; argi < argc; argi++)
+			helper_argv[argi] = cn.corename + argv[argi];
+		helper_argv[argi] = NULL;
 
 		retval = -ENOMEM;
 		sub_info = call_usermodehelper_setup(helper_argv[0],
@@ -652,7 +685,7 @@ void do_coredump(const siginfo_t *siginfo)
 			retval = call_usermodehelper_exec(sub_info,
 							  UMH_WAIT_EXEC);
 
-		argv_free(helper_argv);
+		kfree(helper_argv);
 		if (retval) {
 			printk(KERN_INFO "Core dump to |%s pipe failed\n",
 			       cn.corename);
@@ -771,6 +804,7 @@ void do_coredump(const siginfo_t *siginfo)
 	if (ispipe)
 		atomic_dec(&core_dump_count);
 fail_unlock:
+	kfree(argv);
 	kfree(cn.corename);
 	coredump_finish(mm, core_dumped);
 	revert_creds(old_cred);
-- 
2.20.1

