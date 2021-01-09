Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB522F0337
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 20:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbhAITpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 14:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbhAITpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 14:45:35 -0500
X-Greylist: delayed 831 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 09 Jan 2021 11:44:54 PST
Received: from hall.aurel32.net (hall.aurel32.net [IPv6:2001:bc8:30d7:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF80C06179F;
        Sat,  9 Jan 2021 11:44:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
        ; s=202004.hall; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From:Content-Type:From:Reply-To:Subject:Content-ID:
        Content-Description:In-Reply-To:References:X-Debbugs-Cc;
        bh=Va69OFCaPzTyF2nCJ8Ej3Vk2ibZnYCpl6p6y3KC54nE=; b=uTEZa9USiLaUtdOnB5xFSUgzjI
        fyMrhzbjk1lpRHvsx0BjOpm123MNyU4F/GATAvdoqd8wL7yjFg/aoRbj0hVMCCs69y+wVFlR0GI1C
        FT39rr3m5a2dp2JafVwQAvrwm2b3gGngLI7VymQxISxs06WNPUX/ECJvDpv5L7gqtA7F1ULOIE+dt
        aQSyR6cxbWgpfq6p9KJYHP4rIucy2Xik5RBVo3mWJMNotLhcOWJ5o/nLZUyNHQYjzBoijhLI2qbYT
        /2Mx6VUqAO2WaLtuvnprMmGYNqmhlwoz25FZbneQbOJ6e5nKRp4qCjaDF83V1pUN4MGAF7Ejaozwp
        gGPVNvwA==;
Received: from [2a01:e35:2fdd:a4e1:fe91:fc89:bc43:b814] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <aurelien@aurel32.net>)
        id 1kyJws-00088b-5r; Sat, 09 Jan 2021 20:30:54 +0100
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.94)
        (envelope-from <aurelien@aurel32.net>)
        id 1kyJwp-0020S8-Pm; Sat, 09 Jan 2021 20:30:51 +0100
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     linux-kernel@vger.kernel.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>, stable@vger.kernel.org,
        YunQiang Su <syq@debian.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org (open list:MIPS)
Subject: [PATCH] MIPS: Support binutils configured with --enable-mips-fix-loongson3-llsc=yes
Date:   Sat,  9 Jan 2021 20:30:47 +0100
Message-Id: <20210109193048.478339-1-aurelien@aurel32.net>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From version 2.35, binutils can be configured with
--enable-mips-fix-loongson3-llsc=yes, which means it defaults to
-mfix-loongson3-llsc. This breaks labels which might then point at the
wrong instruction.

The workaround to explicitly pass -mno-fix-loongson3-llsc has been
added in Linux version 5.1, but is only enabled when building a Loongson
64 kernel. As vendors might use a common toolchain for building Loongson
and non-Loongson kernels, just move that workaround to
arch/mips/Makefile. At the same time update the comments to reflect the
current status.

Cc: stable@vger.kernel.org # 5.1+
Cc: YunQiang Su <syq@debian.org>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 arch/mips/Makefile            | 19 +++++++++++++++++++
 arch/mips/loongson64/Platform | 22 ----------------------
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/mips/Makefile b/arch/mips/Makefile
index cd4343edeb11..5ffdd67093bc 100644
--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -136,6 +136,25 @@ cflags-$(CONFIG_SB1XXX_CORELIS)	+= $(call cc-option,-mno-sched-prolog) \
 #
 cflags-y += -fno-stack-check
 
+# binutils from v2.35 when built with --enable-mips-fix-loongson3-llsc=yes,
+# supports an -mfix-loongson3-llsc flag which emits a sync prior to each ll
+# instruction to work around a CPU bug (see __SYNC_loongson3_war in asm/sync.h
+# for a description).
+#
+# We disable this in order to prevent the assembler meddling with the
+# instruction that labels refer to, ie. if we label an ll instruction:
+#
+# 1: ll v0, 0(a0)
+#
+# ...then with the assembler fix applied the label may actually point at a sync
+# instruction inserted by the assembler, and if we were using the label in an
+# exception table the table would no longer contain the address of the ll
+# instruction.
+#
+# Avoid this by explicitly disabling that assembler behaviour.
+#
+cflags-y += $(call as-option,-Wa$(comma)-mno-fix-loongson3-llsc,)
+
 #
 # CPU-dependent compiler/assembler options for optimization.
 #
diff --git a/arch/mips/loongson64/Platform b/arch/mips/loongson64/Platform
index ec42c5085905..e2354e128d9a 100644
--- a/arch/mips/loongson64/Platform
+++ b/arch/mips/loongson64/Platform
@@ -5,28 +5,6 @@
 
 cflags-$(CONFIG_CPU_LOONGSON64)	+= -Wa,--trap
 
-#
-# Some versions of binutils, not currently mainline as of 2019/02/04, support
-# an -mfix-loongson3-llsc flag which emits a sync prior to each ll instruction
-# to work around a CPU bug (see __SYNC_loongson3_war in asm/sync.h for a
-# description).
-#
-# We disable this in order to prevent the assembler meddling with the
-# instruction that labels refer to, ie. if we label an ll instruction:
-#
-# 1: ll v0, 0(a0)
-#
-# ...then with the assembler fix applied the label may actually point at a sync
-# instruction inserted by the assembler, and if we were using the label in an
-# exception table the table would no longer contain the address of the ll
-# instruction.
-#
-# Avoid this by explicitly disabling that assembler behaviour. If upstream
-# binutils does not merge support for the flag then we can revisit & remove
-# this later - for now it ensures vendor toolchains don't cause problems.
-#
-cflags-$(CONFIG_CPU_LOONGSON64)	+= $(call as-option,-Wa$(comma)-mno-fix-loongson3-llsc,)
-
 #
 # binutils from v2.25 on and gcc starting from v4.9.0 treat -march=loongson3a
 # as MIPS64 R2; older versions as just R1.  This leaves the possibility open
-- 
2.29.2

