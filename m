Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948B2328A3C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239554AbhCASNm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:13:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239378AbhCASIg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 702D46523E;
        Mon,  1 Mar 2021 17:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619579;
        bh=8tTmOVdS1/PkhguOWQ0gRjVoSUMEQ+s3z+eGgd/9ks8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8P14yAwzLcNlyOAw9YkTkceNkf8qtuJBwDnNcKiV3D3pfJ7kYk2KNz80FWFNK14o
         lYYBjuLpyJEZL+teZ+8tRtNVCXIfgICdquqTKuqcdHeN9F6m0zNA1h7R/gPIDPjjmF
         /7TZWczZ63AuPXrMoDsKsjPbL2o9PcnGYFxHHO9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YunQiang Su <syq@debian.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 506/663] MIPS: Support binutils configured with --enable-mips-fix-loongson3-llsc=yes
Date:   Mon,  1 Mar 2021 17:12:34 +0100
Message-Id: <20210301161206.877659270@linuxfoundation.org>
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

From: Aurelien Jarno <aurelien@aurel32.net>

commit 5373ae67c3aad1ab306cc722b5a80b831eb4d4d1 upstream.

>From version 2.35, binutils can be configured with
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
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/Makefile            |   19 +++++++++++++++++++
 arch/mips/loongson64/Platform |   22 ----------------------
 2 files changed, 19 insertions(+), 22 deletions(-)

--- a/arch/mips/Makefile
+++ b/arch/mips/Makefile
@@ -136,6 +136,25 @@ cflags-$(CONFIG_SB1XXX_CORELIS)	+= $(cal
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
--- a/arch/mips/loongson64/Platform
+++ b/arch/mips/loongson64/Platform
@@ -6,28 +6,6 @@
 cflags-$(CONFIG_CPU_LOONGSON64)	+= -Wa,--trap
 
 #
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
-#
 # binutils from v2.25 on and gcc starting from v4.9.0 treat -march=loongson3a
 # as MIPS64 R2; older versions as just R1.  This leaves the possibility open
 # that GCC might generate R2 code for -march=loongson3a which then is rejected


