Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86945328C16
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbhCASpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:45:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240502AbhCASjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 211356508F;
        Mon,  1 Mar 2021 17:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619916;
        bh=xl/RzlTfeoa9gNbStTQWMWCscnIf9VS68Kbwwf9cTas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iTNS8qgg4lFLQBF9LYscK9oe8xnDBVhWhHfI9VCRst1IIZu0MIEOwzgKZ/HOMxGgR
         unzlhj8zyTq8HFZnM8krZc888oDTGYUpSWVS/YAEbWWpIZrDHF6bHYbIPg8VCdjY+g
         AFzouaTnMtOHn/MsyUqarxSlv5kPf1jTdictNE1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas Stach <l.stach@pengutronix.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.10 620/663] kcmp: Support selection of SYS_kcmp without CHECKPOINT_RESTORE
Date:   Mon,  1 Mar 2021 17:14:28 +0100
Message-Id: <20210301161212.521569141@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit bfe3911a91047557eb0e620f95a370aee6a248c7 upstream.

Userspace has discovered the functionality offered by SYS_kcmp and has
started to depend upon it. In particular, Mesa uses SYS_kcmp for
os_same_file_description() in order to identify when two fd (e.g. device
or dmabuf) point to the same struct file. Since they depend on it for
core functionality, lift SYS_kcmp out of the non-default
CONFIG_CHECKPOINT_RESTORE into the selectable syscall category.

Rasmus Villemoes also pointed out that systemd uses SYS_kcmp to
deduplicate the per-service file descriptor store.

Note that some distributions such as Ubuntu are already enabling
CHECKPOINT_RESTORE in their configs and so, by extension, SYS_kcmp.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: stable@vger.kernel.org
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch> # DRM depends on kcmp
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk> # systemd uses kcmp
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20210205220012.1983-1-chris@chris-wilson.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/Kconfig                       |    3 +++
 fs/eventpoll.c                                |    4 ++--
 include/linux/eventpoll.h                     |    2 +-
 init/Kconfig                                  |   11 +++++++++++
 kernel/Makefile                               |    2 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c |    2 +-
 6 files changed, 19 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -15,6 +15,9 @@ menuconfig DRM
 	select I2C_ALGOBIT
 	select DMA_SHARED_BUFFER
 	select SYNC_FILE
+# gallium uses SYS_kcmp for os_same_file_description() to de-duplicate
+# device and dmabuf fd. Let's make sure that is available for our userspace.
+	select KCMP
 	help
 	  Kernel-level support for the Direct Rendering Infrastructure (DRI)
 	  introduced in XFree86 4.0. If you say Y here, you need to select
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1062,7 +1062,7 @@ static struct epitem *ep_find(struct eve
 	return epir;
 }
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#ifdef CONFIG_KCMP
 static struct epitem *ep_find_tfd(struct eventpoll *ep, int tfd, unsigned long toff)
 {
 	struct rb_node *rbp;
@@ -1104,7 +1104,7 @@ struct file *get_epoll_tfile_raw_ptr(str
 
 	return file_raw;
 }
-#endif /* CONFIG_CHECKPOINT_RESTORE */
+#endif /* CONFIG_KCMP */
 
 /**
  * Adds a new entry to the tail of the list in a lockless way, i.e.
--- a/include/linux/eventpoll.h
+++ b/include/linux/eventpoll.h
@@ -18,7 +18,7 @@ struct file;
 
 #ifdef CONFIG_EPOLL
 
-#ifdef CONFIG_CHECKPOINT_RESTORE
+#ifdef CONFIG_KCMP
 struct file *get_epoll_tfile_raw_ptr(struct file *file, int tfd, unsigned long toff);
 #endif
 
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1194,6 +1194,7 @@ endif # NAMESPACES
 config CHECKPOINT_RESTORE
 	bool "Checkpoint/restore support"
 	select PROC_CHILDREN
+	select KCMP
 	default n
 	help
 	  Enables additional kernel features in a sake of checkpoint/restore.
@@ -1737,6 +1738,16 @@ config ARCH_HAS_MEMBARRIER_CALLBACKS
 config ARCH_HAS_MEMBARRIER_SYNC_CORE
 	bool
 
+config KCMP
+	bool "Enable kcmp() system call" if EXPERT
+	help
+	  Enable the kernel resource comparison system call. It provides
+	  user-space with the ability to compare two processes to see if they
+	  share a common resource, such as a file descriptor or even virtual
+	  memory space.
+
+	  If unsure, say N.
+
 config RSEQ
 	bool "Enable rseq() system call" if EXPERT
 	default y
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -48,7 +48,7 @@ obj-y += livepatch/
 obj-y += dma/
 obj-y += entry/
 
-obj-$(CONFIG_CHECKPOINT_RESTORE) += kcmp.o
+obj-$(CONFIG_KCMP) += kcmp.o
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -315,7 +315,7 @@ TEST(kcmp)
 	ret = __filecmp(getpid(), getpid(), 1, 1);
 	EXPECT_EQ(ret, 0);
 	if (ret != 0 && errno == ENOSYS)
-		SKIP(return, "Kernel does not support kcmp() (missing CONFIG_CHECKPOINT_RESTORE?)");
+		SKIP(return, "Kernel does not support kcmp() (missing CONFIG_KCMP?)");
 }
 
 TEST(mode_strict_support)


