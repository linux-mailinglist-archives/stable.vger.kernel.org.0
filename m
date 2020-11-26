Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00752C5885
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 16:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390011AbgKZPwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 10:52:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:46766 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730181AbgKZPwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Nov 2020 10:52:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6E644ACD5;
        Thu, 26 Nov 2020 15:52:53 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 328B21E10D0; Thu, 26 Nov 2020 16:52:53 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     x86@kernel.org, Brian Gerst <brgerst@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] fanotify: Fix fanotify_mark() on 32-bit x86
Date:   Thu, 26 Nov 2020 16:52:46 +0100
Message-Id: <20201126155246.25961-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit converting syscalls taking 64-bit arguments to new scheme of compat
handlers omitted converting fanotify_mark(2) which then broke the
syscall for 32-bit x86 builds. Add missed conversion. It is somewhat
cumbersome since we need to keep the original compat handler for all the
other 32-bit archs.

CC: Brian Gerst <brgerst@gmail.com>
Suggested-by: Borislav Petkov <bp@suse.de>
Reported-by: Paweł Jasiak <pawel@jasiak.xyz>
Reported-and-tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: 121b32a58a3a ("x86/entry/32: Use IA32-specific wrappers for syscalls taking 64-bit arguments")
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 arch/x86/entry/syscalls/syscall_32.tbl | 2 +-
 fs/notify/fanotify/fanotify_user.c     | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

I plan to queue this fix into my tree next week. I'd be happy if someone with
x86 ABI knowledge checks whether I've got the patch right (especially various
config variants) because it was mostly a guesswork of me & Boris ;). Thanks!

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 0d0667a9fbd7..b2ec6ff88307 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -350,7 +350,7 @@
 336	i386	perf_event_open		sys_perf_event_open
 337	i386	recvmmsg		sys_recvmmsg_time32		compat_sys_recvmmsg_time32
 338	i386	fanotify_init		sys_fanotify_init
-339	i386	fanotify_mark		sys_fanotify_mark		compat_sys_fanotify_mark
+339	i386	fanotify_mark		sys_ia32_fanotify_mark
 340	i386	prlimit64		sys_prlimit64
 341	i386	name_to_handle_at	sys_name_to_handle_at
 342	i386	open_by_handle_at	sys_open_by_handle_at		compat_sys_open_by_handle_at
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 3e01d8f2ab90..ba38f0fec4d0 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1292,8 +1292,13 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
 	return do_fanotify_mark(fanotify_fd, flags, mask, dfd, pathname);
 }
 
-#ifdef CONFIG_COMPAT
+#if defined(CONFIG_COMPAT) || defined(CONFIG_X86_32) || \
+    defined(CONFIG_IA32_EMULATION)
+#if defined(CONFIG_X86_32) || defined(CONFIG_IA32_EMULATION)
+SYSCALL_DEFINE6(ia32_fanotify_mark,
+#elif CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE6(fanotify_mark,
+#endif
 				int, fanotify_fd, unsigned int, flags,
 				__u32, mask0, __u32, mask1, int, dfd,
 				const char  __user *, pathname)
-- 
2.16.4

