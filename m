Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C25B59353B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240181AbiHOSVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240525AbiHOSUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:20:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5372C649;
        Mon, 15 Aug 2022 11:16:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 470CD612A8;
        Mon, 15 Aug 2022 18:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0E6C433D7;
        Mon, 15 Aug 2022 18:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587403;
        bh=yeoemor4Uw73NOtS6LeNA/ED035gV3a0eFSZ4fQXmWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SodHEgrPNzSsMgDyLGPqUeRA23ATUSu5nOeGnK0aU0a3c/qB+fKuMHlqSEgeY5Dvf
         N62X7/8YcS/PMbdpyOysTz/7fZ6OIdBhs3DxeLWr6sJKTVFaAMgzeu8xCRdvrEAjSs
         thqmLRDj+AHuLKBWmqy364D7IuHtqXQI/Bf5WlTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.15 075/779] um: seed rng using host OS rng
Date:   Mon, 15 Aug 2022 19:55:19 +0200
Message-Id: <20220815180340.499355405@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 0b9ba6135d7f18b82f3d8bebb55ded725ba88e0e upstream.

UML generally does not provide access to special CPU instructions like
RDRAND, and execution tends to be rather deterministic, with no real
hardware interrupts, making good randomness really very hard, if not
all together impossible. Not only is this a security eyebrow raiser, but
it's also quite annoying when trying to do various pieces of UML-based
automation that takes a long time to boot, if ever.

Fix this by trivially calling getrandom() in the host and using that
seed as "bootloader randomness", which initializes the rng immediately
at UML boot.

The old behavior can be restored the same way as on any other arch, by
way of CONFIG_TRUST_BOOTLOADER_RANDOMNESS=n or
random.trust_bootloader=0. So seen from that perspective, this just
makes UML act like other archs, which is positive in its own right.

Additionally, wire up arch_get_random_{int,long}() in the same way, so
that reseeds can also make use of the host RNG, controllable by
CONFIG_TRUST_CPU_RANDOMNESS and random.trust_cpu, per usual.

Cc: stable@vger.kernel.org
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/um/include/asm/archrandom.h |   30 ++++++++++++++++++++++++++++++
 arch/um/include/shared/os.h      |    7 +++++++
 arch/um/kernel/um_arch.c         |    8 ++++++++
 arch/um/os-Linux/util.c          |    6 ++++++
 4 files changed, 51 insertions(+)
 create mode 100644 arch/um/include/asm/archrandom.h

--- /dev/null
+++ b/arch/um/include/asm/archrandom.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_UM_ARCHRANDOM_H__
+#define __ASM_UM_ARCHRANDOM_H__
+
+#include <linux/types.h>
+
+/* This is from <os.h>, but better not to #include that in a global header here. */
+ssize_t os_getrandom(void *buf, size_t len, unsigned int flags);
+
+static inline bool __must_check arch_get_random_long(unsigned long *v)
+{
+	return os_getrandom(v, sizeof(*v), 0) == sizeof(*v);
+}
+
+static inline bool __must_check arch_get_random_int(unsigned int *v)
+{
+	return os_getrandom(v, sizeof(*v), 0) == sizeof(*v);
+}
+
+static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
+{
+	return false;
+}
+
+static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
+{
+	return false;
+}
+
+#endif
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -11,6 +11,12 @@
 #include <irq_user.h>
 #include <longjmp.h>
 #include <mm_id.h>
+/* This is to get size_t */
+#ifndef __UM_HOST__
+#include <linux/types.h>
+#else
+#include <sys/types.h>
+#endif
 
 #define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
 
@@ -252,6 +258,7 @@ extern void stack_protections(unsigned l
 extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
+extern ssize_t os_getrandom(void *buf, size_t len, unsigned int flags);
 extern void os_dump_core(void) __attribute__ ((noreturn));
 extern void um_early_printk(const char *s, unsigned int n);
 extern void os_fix_helper_signals(void);
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -16,6 +16,7 @@
 #include <linux/sched/task.h>
 #include <linux/kmsg_dump.h>
 #include <linux/suspend.h>
+#include <linux/random.h>
 
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
@@ -404,6 +405,8 @@ int __init __weak read_initrd(void)
 
 void __init setup_arch(char **cmdline_p)
 {
+	u8 rng_seed[32];
+
 	stack_protections((unsigned long) &init_thread_info);
 	setup_physmem(uml_physmem, uml_reserved, physmem_size, highmem);
 	mem_total_pages(physmem_size, iomem_size, highmem);
@@ -413,6 +416,11 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 	setup_hostinfo(host_info, sizeof host_info);
+
+	if (os_getrandom(rng_seed, sizeof(rng_seed), 0) == sizeof(rng_seed)) {
+		add_bootloader_randomness(rng_seed, sizeof(rng_seed));
+		memzero_explicit(rng_seed, sizeof(rng_seed));
+	}
 }
 
 void __init check_bugs(void)
--- a/arch/um/os-Linux/util.c
+++ b/arch/um/os-Linux/util.c
@@ -14,6 +14,7 @@
 #include <sys/wait.h>
 #include <sys/mman.h>
 #include <sys/utsname.h>
+#include <sys/random.h>
 #include <init.h>
 #include <os.h>
 
@@ -96,6 +97,11 @@ static inline void __attribute__ ((noret
 			exit(127);
 }
 
+ssize_t os_getrandom(void *buf, size_t len, unsigned int flags)
+{
+	return getrandom(buf, len, flags);
+}
+
 /*
  * UML helper threads must not handle SIGWINCH/INT/TERM
  */


