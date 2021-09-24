Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768E5417427
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344849AbhIXNDR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:03:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345431AbhIXNBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8FA3861269;
        Fri, 24 Sep 2021 12:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488052;
        bh=KWGTorvk9vSsJ6GBOeej2BLeMw45GFlJy5WHEo2IMHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xPRnld5okXsTpqxJkaVplwma4xcsQWbNrJO9uYhiUwoqFuqXm2Rz4wEw9jlkueT9B
         oaSakONY50gAx+LcqppeJi5VV7psMvTiqR3Md6SGadcO1WESTBu+uWZyg1ZwlrQXuK
         A5qoHxJyH+ikAB1fXWJrTh0h8mmM/iHf5Cf0tRX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Bruno Goncalves <bgoncalv@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 037/100] init: move usermodehelper_enable() to populate_rootfs()
Date:   Fri, 24 Sep 2021 14:43:46 +0200
Message-Id: <20210924124342.703209208@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

[ Upstream commit b234ed6d629420827e2839c8c8935be85a0867fd ]

Currently, usermodehelper is enabled right before PID1 starts going
through the initcalls. However, any call of a usermodehelper from a
pure_, core_, postcore_, arch_, subsys_ or fs_ initcall is futile, as
there is no filesystem contents yet.

Up until commit e7cb072eb988 ("init/initramfs.c: do unpacking
asynchronously"), such calls, whether via some request_module(), a
legacy uevent "/sbin/hotplug" notification or something else, would
just fail silently with (presumably) -ENOENT from
kernel_execve(). However, that commit introduced the
wait_for_initramfs() synchronization hook which must be called from
the usermodehelper exec path right before the kernel_execve, in order
that request_module() et al done from *after* rootfs_initcall()
time (i.e. device_ and late_ initcalls) would continue to find a
populated initramfs as they used to.

Any call of wait_for_initramfs() done before the unpacking has been
scheduled (i.e. before rootfs_initcall time) must just return
immediately [and let the caller find an empty file system] in order
not to deadlock the machine. I mistakenly thought, and my limited
testing confirmed, that there were no such calls, so I added a
pr_warn_once() in wait_for_initramfs(). It turns out that one can
indeed hit request_module() as well as kobject_uevent_env() during
those early init calls, leading to a user-visible warning in the
kernel log emitted consistently for certain configurations.

We could just remove the pr_warn_once(), but I think it's better to
postpone enabling the usermodehelper framework until there is at least
some chance of finding the executable. That is also a little more
efficient in that a lot of work done in umh.c will be elided. However,
it does change the error seen by those early callers from -ENOENT to
-EBUSY, so there is a risk of a regression if any caller care about
the exact error value.

Link: https://lkml.kernel.org/r/20210728134638.329060-1-linux@rasmusvillemoes.dk
Fixes: e7cb072eb988 ("init/initramfs.c: do unpacking asynchronously")
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reported-by: Bruno Goncalves <bgoncalv@redhat.com>
Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/initramfs.c   | 2 ++
 init/main.c        | 1 -
 init/noinitramfs.c | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index af27abc59643..a842c0544745 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -15,6 +15,7 @@
 #include <linux/mm.h>
 #include <linux/namei.h>
 #include <linux/init_syscalls.h>
+#include <linux/umh.h>
 
 static ssize_t __init xwrite(struct file *file, const char *p, size_t count,
 		loff_t *pos)
@@ -727,6 +728,7 @@ static int __init populate_rootfs(void)
 {
 	initramfs_cookie = async_schedule_domain(do_populate_rootfs, NULL,
 						 &initramfs_domain);
+	usermodehelper_enable();
 	if (!initramfs_async)
 		wait_for_initramfs();
 	return 0;
diff --git a/init/main.c b/init/main.c
index 8d97aba78c3a..90733a916791 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1392,7 +1392,6 @@ static void __init do_basic_setup(void)
 	driver_init();
 	init_irq_proc();
 	do_ctors();
-	usermodehelper_enable();
 	do_initcalls();
 }
 
diff --git a/init/noinitramfs.c b/init/noinitramfs.c
index 3d62b07f3bb9..d1d26b93d25c 100644
--- a/init/noinitramfs.c
+++ b/init/noinitramfs.c
@@ -10,6 +10,7 @@
 #include <linux/kdev_t.h>
 #include <linux/syscalls.h>
 #include <linux/init_syscalls.h>
+#include <linux/umh.h>
 
 /*
  * Create a simple rootfs that is similar to the default initramfs
@@ -18,6 +19,7 @@ static int __init default_rootfs(void)
 {
 	int err;
 
+	usermodehelper_enable();
 	err = init_mkdir("/dev", 0755);
 	if (err < 0)
 		goto out;
-- 
2.33.0



