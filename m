Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A466A59A4B8
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353711AbiHSQnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353488AbiHSQmC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:42:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734FD10EEFF;
        Fri, 19 Aug 2022 09:10:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4F97B8281C;
        Fri, 19 Aug 2022 16:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F36C433C1;
        Fri, 19 Aug 2022 16:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925446;
        bh=Hr1ggMLVtXJBbIebHN67aOz1NiVb5WE3aiOVLw7QZoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f9ApyBbFBlmThgIfkviqAk11ENtWN1GHISJub4qnur8pA2iGaKeSvgSMlyfaf006t
         dImC7xIGQ3lE6/nPnVvTSBA7ER+ourOOkg7OPndTCmI4naIoWn7x+4QTrG6oPIBKgn
         CvYVJ1et3uEcFSxJTC75IDOvT2sUX1idI1H478xY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 493/545] um: seed rng using host OS rng
Date:   Fri, 19 Aug 2022 17:44:23 +0200
Message-Id: <20220819153851.517323685@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

[ Upstream commit 0b9ba6135d7f18b82f3d8bebb55ded725ba88e0e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/asm/archrandom.h | 30 ++++++++++++++++++++++++++++++
 arch/um/include/shared/os.h      |  7 +++++++
 arch/um/kernel/um_arch.c         |  8 ++++++++
 arch/um/os-Linux/util.c          |  6 ++++++
 4 files changed, 51 insertions(+)
 create mode 100644 arch/um/include/asm/archrandom.h

diff --git a/arch/um/include/asm/archrandom.h b/arch/um/include/asm/archrandom.h
new file mode 100644
index 000000000000..2f24cb96391d
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
diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index 2f31d44d892e..a339938b85a0 100644
--- a/arch/um/include/shared/os.h
+++ b/arch/um/include/shared/os.h
@@ -12,6 +12,12 @@
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
 
@@ -248,6 +254,7 @@ extern void stack_protections(unsigned long address);
 extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
+extern ssize_t os_getrandom(void *buf, size_t len, unsigned int flags);
 extern void os_dump_core(void) __attribute__ ((noreturn));
 extern void um_early_printk(const char *s, unsigned int n);
 extern void os_fix_helper_signals(void);
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 52e2e2a3e4ae..ecef61f9aadf 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -14,6 +14,7 @@
 #include <linux/sched/task.h>
 #include <linux/kmsg_dump.h>
 #include <linux/suspend.h>
+#include <linux/random.h>
 
 #include <asm/processor.h>
 #include <asm/sections.h>
@@ -342,6 +343,8 @@ int __init __weak read_initrd(void)
 
 void __init setup_arch(char **cmdline_p)
 {
+	u8 rng_seed[32];
+
 	stack_protections((unsigned long) &init_thread_info);
 	setup_physmem(uml_physmem, uml_reserved, physmem_size, highmem);
 	mem_total_pages(physmem_size, iomem_size, highmem);
@@ -351,6 +354,11 @@ void __init setup_arch(char **cmdline_p)
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
diff --git a/arch/um/os-Linux/util.c b/arch/um/os-Linux/util.c
index 07327425d06e..fab664203f30 100644
--- a/arch/um/os-Linux/util.c
+++ b/arch/um/os-Linux/util.c
@@ -13,6 +13,7 @@
 #include <sys/wait.h>
 #include <sys/mman.h>
 #include <sys/utsname.h>
+#include <sys/random.h>
 #include <init.h>
 #include <os.h>
 
@@ -95,6 +96,11 @@ static inline void __attribute__ ((noreturn)) uml_abort(void)
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
-- 
2.35.1



