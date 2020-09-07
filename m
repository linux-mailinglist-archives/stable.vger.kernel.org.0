Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAE325FD58
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730149AbgIGPoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 11:44:05 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:50997 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730150AbgIGPil (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Sep 2020 11:38:41 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MJV9S-1jzqjP0Umm-00Jnof; Mon, 07 Sep 2020 17:38:07 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Christoph Hellwig <hch@lst.de>, Russell King <rmk@arm.linux.org.uk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>, kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@linaro.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org, Mikael Pettersson <mikpe@it.uu.se>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Russell King <linux@armlinux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] ARM: oabi-compat: add epoll_pwait handler
Date:   Mon,  7 Sep 2020 17:36:44 +0200
Message-Id: <20200907153701.2981205-4-arnd@arndb.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200907153701.2981205-1-arnd@arndb.de>
References: <20200907153701.2981205-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:mvJo34mtjWtAx5UFkxoUsY6BYLk5TxizfdfEI/T6x5LXUToj2Gs
 eq4jhvfQgCUKPTs9VI3GmZeo30Whz44Ox+rBSFU6/8DoOpbXTNq3BKOS7KvtD7vitnLMev4
 ZFISkwZY/310lkDvmmlXoZ8nLNeLLkmUhcFehyL7d6y1wwXDF0+lOSnnoh0frh3q4KA+91I
 Lb4TvMtrLPcnWR4BAJPaQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gCeswl9BfCM=:8DnlAUEq/JrLIRCAQnq+4c
 heUMcytFGL9tiFJ1xdsFSFtVUhbROAfIR6rz5QWmrlX/3jRXPCNlSpz54jhN+BO26VW+BgXX4
 sEajACaStSEJHDlxXlIftijP6E2P1WvTsh4QJpXE0NXaY7EqkQSJTN8eKqm95HRCAKs8JtXNn
 QIqYB2FoU8lTDlAmZceNhMALXWsqt1acoJMqa4SLBSLs/Oc0VIjw92LA4Y71Z5BRtV4QyX9Q9
 LK7V1PUXYbDpHBtekYajXnJb5MiV5Vr6g0xfZBzTZRgQqgbGskNa0zWu72ME8DN5I3yGd4NLk
 faAv2ObSfUAJO/SPcKKVSuca2j1J1Rt70kYxlAYxHhqE+RrHnfH4i1RP5rzkdI7D/OHmQnLAI
 Ohtt/1M7hr74cjMJHnkMB6mfI0viumKX3SZPeJwT1XAzTpJOYgYyd3DAhIx2hnzw+IKK/7P+5
 5OyThGF+d2nW42AyaJLWVvWHeQ4l9VmypwDGz1rH4GhoUH/OwhkzDgOWDDHvL//VYqg9oro2W
 PXL4keqq9nxuAolkORV0VIoZEeZIoIYRHKiLDXBkSEN9jo6ULRdgjtos9M23J7ieZ9jNoRbVk
 q54xAsqfU3vb6T5eX9rD6xUaYqcCoMrsqlv8lvRWAsRFBDy5YSuC5dschGvUASIVSTVr6pLEF
 w2qHMs4qdTq7B/85diKoKdCjBAr0L+wotV6N/fM+LfIMgGy+u/XAdCOQP/wk0UHjlazDk4p5j
 cfqs5phJHeJ50WwvwITuO9J38rpQLs8qdm5dPb1fu50nskyoGxHYfJNM6Pwd2Qu/GD8Eyo479
 M4npqU27DepXRo8YACxDghI5/x51i6lxG89ailOeiMPg84cUKupPvgidmWDMN9W+EPw++Jp
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The epoll_wait() syscall has a special version for OABI compat
mode to convert the arguments to the EABI structure layout
of the kernel. However, the later epoll_pwait() syscall was
added in arch/arm in linux-2.6.32 without this conversion.

Use the same kind of handler for both.

Fixes: 369842658a36 ("ARM: 5677/1: ARM support for TIF_RESTORE_SIGMASK/pselect6/ppoll/epoll_pwait")
Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/kernel/sys_oabi-compat.c | 35 ++++++++++++++++++++++++++++---
 arch/arm/tools/syscall.tbl        |  2 +-
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/sys_oabi-compat.c b/arch/arm/kernel/sys_oabi-compat.c
index 0203e545bbc8..2ce3e8c6ca91 100644
--- a/arch/arm/kernel/sys_oabi-compat.c
+++ b/arch/arm/kernel/sys_oabi-compat.c
@@ -264,9 +264,8 @@ asmlinkage long sys_oabi_epoll_ctl(int epfd, int op, int fd,
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
@@ -299,6 +298,36 @@ asmlinkage long sys_oabi_epoll_wait(int epfd,
 	return err ? -EFAULT : ret;
 }
 
+SYSCALL_DEFINE4(oabi_epoll_wait, int, epfd, struct oabi_epoll_event __user *, events,
+		int, maxevents, int, timeout)
+{
+	return do_oabi_epoll_wait(epfd, events, maxevents, timeout);
+}
+
+/*
+ * Implement the event wait interface for the eventpoll file. It is the kernel
+ * part of the user space epoll_pwait(2).
+ */
+SYSCALL_DEFINE6(oabi_epoll_pwait, int, epfd, struct oabi_epoll_event __user *, events,
+		int, maxevents, int, timeout, const sigset_t __user *, sigmask,
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
+
 struct oabi_sembuf {
 	unsigned short	sem_num;
 	short		sem_op;
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 171077cbf419..39a24bee7df8 100644
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
2.27.0

