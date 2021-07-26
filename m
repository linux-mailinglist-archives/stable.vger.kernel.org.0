Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25853D5B06
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 16:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbhGZNbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 09:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233498AbhGZNbY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 09:31:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59AD260F58;
        Mon, 26 Jul 2021 14:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627308713;
        bh=4CdKUxSFM8QMmxgntAsL2unQuopFIEx04zQkMcauFq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=enQgq7GLY8oTWf5BlXKKn6AjVLAVJnsRPZVU21Onq3wXO0rnr/YiJXje6wFvdVmcR
         648rl2EV1Vi7EaxRus7bgaIPs68p/cfVwQmhE8EgXM+bYHbtWu/iAoHJ7+PETztlmH
         PGC0oiUoQLt6+sTwu6cHHvHYHLX/caVJ7TcODIOpgzJgoKr40vkiWeaCh+Yt1ejKTf
         Yd33tdTZ+h+qXQqXIItpg7iHfpugtlc+pY7ZJ9EDoa4Go3fl1EQBwDvoLZMx9QNSxd
         faBmY6tzB4T1M1WqSfcSLwdbJtXmkFP2Y9aae0qLo/HIfxhWIVJvpYrAAO0MkF/gaD
         Zj+y4xj6fJtew==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Russell King <linux@armlinux.org.uk>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH v5 03/10] ARM: oabi-compat: add epoll_pwait handler
Date:   Mon, 26 Jul 2021 16:11:34 +0200
Message-Id: <20210726141141.2839385-4-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210726141141.2839385-1-arnd@kernel.org>
References: <20210726141141.2839385-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The epoll_wait() syscall has a special version for OABI compat
mode to convert the arguments to the EABI structure layout
of the kernel. However, the later epoll_pwait() syscall was
added in arch/arm in linux-2.6.32 without this conversion.

Use the same kind of handler for both.

Fixes: 369842658a36 ("ARM: 5677/1: ARM support for TIF_RESTORE_SIGMASK/pselect6/ppoll/epoll_pwait")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/kernel/sys_oabi-compat.c | 38 ++++++++++++++++++++++++++++---
 arch/arm/tools/syscall.tbl        |  2 +-
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 075a2e0ed2c1..443203fafb6b 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -265,9 +265,8 @@ asmlinkage long sys_oabi_epoll_ctl(int epfd, int op, int fd,
 	return do_epoll_ctl(epfd, op, fd, &kernel, false);
 }
 
-asmlinkage long sys_oabi_epoll_wait(int epfd,
-				    struct oabi_epoll_event __user *events,
-				    int maxevents, int timeout)
+static long do_oabi_epoll_wait(int epfd, struct oabi_epoll_event __user *events,
+			       int maxevents, int timeout)
 {
 	struct epoll_event *kbuf;
 	struct oabi_epoll_event e;
@@ -314,6 +313,39 @@ asmlinkage long sys_oabi_epoll_wait(int epfd,
 }
 #endif
 
+SYSCALL_DEFINE4(oabi_epoll_wait, int, epfd,
+		struct oabi_epoll_event __user *, events,
+		int, maxevents, int, timeout)
+{
+	return do_oabi_epoll_wait(epfd, events, maxevents, timeout);
+}
+
+/*
+ * Implement the event wait interface for the eventpoll file. It is the kernel
+ * part of the user space epoll_pwait(2).
+ */
+SYSCALL_DEFINE6(oabi_epoll_pwait, int, epfd,
+		struct oabi_epoll_event __user *, events, int, maxevents,
+		int, timeout, const sigset_t __user *, sigmask,
+		size_t, sigsetsize)
+{
+	int error;
+
+	/*
+	 * If the caller wants a certain signal mask to be set during the wait,
+	 * we apply it here.
+	 */
+	error = set_user_sigmask(sigmask, sigsetsize);
+	if (error)
+		return error;
+
+	error = do_oabi_epoll_wait(epfd, events, maxevents, timeout);
+	restore_saved_sigmask_unless(error == -EINTR);
+
+	return error;
+}
+#endif
+
 struct oabi_sembuf {
 	unsigned short	sem_num;
 	short		sem_op;
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index c5df1179fc5d..11d0b960b2c2 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -360,7 +360,7 @@
 343	common	vmsplice		sys_vmsplice
 344	common	move_pages		sys_move_pages
 345	common	getcpu			sys_getcpu
-346	common	epoll_pwait		sys_epoll_pwait
+346	common	epoll_pwait		sys_epoll_pwait		sys_oabi_epoll_pwait
 347	common	kexec_load		sys_kexec_load
 348	common	utimensat		sys_utimensat_time32
 349	common	signalfd		sys_signalfd
-- 
2.29.2

