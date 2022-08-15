Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82A995945ED
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350634AbiHOWTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347094AbiHOWPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:15:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E469A11FD03;
        Mon, 15 Aug 2022 12:39:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9938610A5;
        Mon, 15 Aug 2022 19:39:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B75C433C1;
        Mon, 15 Aug 2022 19:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592369;
        bh=qFEqlYR364zAMF8tGKZfx7jNJoYRaN3R5KeD+djXNmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAmpg39qHcQXTNGdzBQGBPDU7TOj85n6pZE3V1lN2PLIFfo1aiCY1zcQiOqlMl9IE
         Jz0h8ps5FnreLb3WF4RN797qHyEfOXO4O6NnXv/mXChg0NlYpxtAJF0nbB+TUeM4X+
         duuDZ0LPAkg6vzW+vEu9rgArNYckwz4+HQ9xYb7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.19 0100/1157] um: seed rng using host OS rng
Date:   Mon, 15 Aug 2022 19:50:56 +0200
Message-Id: <20220815180443.625365275@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
 
@@ -243,6 +249,7 @@ extern void stack_protections(unsigned l
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
@@ -406,6 +407,8 @@ int __init __weak read_initrd(void)
 
 void __init setup_arch(char **cmdline_p)
 {
+	u8 rng_seed[32];
+
 	stack_protections((unsigned long) &init_thread_info);
 	setup_physmem(uml_physmem, uml_reserved, physmem_size, highmem);
 	mem_total_pages(physmem_size, iomem_size, highmem);
@@ -416,6 +419,11 @@ void __init setup_arch(char **cmdline_p)
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


