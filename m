Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E025729E7
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 01:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbiGLX1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 19:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiGLX1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 19:27:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA16A8505;
        Tue, 12 Jul 2022 16:27:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B55A9B81BF2;
        Tue, 12 Jul 2022 23:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC69AC3411C;
        Tue, 12 Jul 2022 23:27:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="IXCsfUZt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1657668466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aB9rTSoP5TcFMxIKv1dXr9wSKovU/IFkSimTlBSvEpw=;
        b=IXCsfUZt/FWBdscwWyhHZieu1Bq9xEAe37ehLp/YdGzacWZZP20PPDNnAejQ92Sv/KbW6n
        PZIxE4ZVOgU2mLjMbWdPYH126zvIOU2tqy/zovu/lB6NAsIi+sgpcElkH+WEaTQvWu5lYg
        rlodp1RlsA/oEzmabKyKBUSCy+jJ2AM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id af0bb318 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 12 Jul 2022 23:27:46 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        johannes@sipsolutions.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] um: seed rng using host OS rng
Date:   Wed, 13 Jul 2022 01:27:38 +0200
Message-Id: <20220712232738.77737-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/um/include/shared/os.h | 7 +++++++
 arch/um/kernel/um_arch.c    | 8 ++++++++
 arch/um/os-Linux/util.c     | 6 ++++++
 3 files changed, 21 insertions(+)

diff --git a/arch/um/include/shared/os.h b/arch/um/include/shared/os.h
index fafde1d5416e..79644dd88d58 100644
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
+#include <stddef.h>
+#endif
 
 #define CATCH_EINTR(expr) while ((errno = 0, ((expr) < 0)) && (errno == EINTR))
 
@@ -243,6 +249,7 @@ extern void stack_protections(unsigned long address);
 extern int raw(int fd);
 extern void setup_machinename(char *machine_out);
 extern void setup_hostinfo(char *buf, int len);
+extern ssize_t os_getrandom(void *buf, size_t len, unsigned int flags);
 extern void os_dump_core(void) __attribute__ ((noreturn));
 extern void um_early_printk(const char *s, unsigned int n);
 extern void os_fix_helper_signals(void);
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 0760e24f2eba..74f3efd96bd4 100644
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
diff --git a/arch/um/os-Linux/util.c b/arch/um/os-Linux/util.c
index 41297ec404bf..fc0f2a9dee5a 100644
--- a/arch/um/os-Linux/util.c
+++ b/arch/um/os-Linux/util.c
@@ -14,6 +14,7 @@
 #include <sys/wait.h>
 #include <sys/mman.h>
 #include <sys/utsname.h>
+#include <sys/random.h>
 #include <init.h>
 #include <os.h>
 
@@ -96,6 +97,11 @@ static inline void __attribute__ ((noreturn)) uml_abort(void)
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

