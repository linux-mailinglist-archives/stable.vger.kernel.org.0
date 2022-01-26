Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D529349D11D
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 18:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbiAZRrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 12:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243976AbiAZRrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 12:47:53 -0500
X-Greylist: delayed 1960 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 26 Jan 2022 09:47:52 PST
Received: from hall.aurel32.net (hall.aurel32.net [IPv6:2001:bc8:30d7:100::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22ABC06161C
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 09:47:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=aurel32.net
        ; s=202004.hall; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:
        Subject:Cc:To:From:Content-Type:From:Reply-To:Subject:Content-ID:
        Content-Description:In-Reply-To:References:X-Debbugs-Cc;
        bh=JcMDygQ3jwximp20F0L2sMP6dOWvpxTtwX9dpTRf13o=; b=FgHcbTeJt+uvUQR6oh7qwpxdYX
        1mpfNXVC0gmKsHHP2B1yg368NoThRObuLXqxuTsbPF4W+OKfIMecSSYu/RJYBBk2TzT8ibhWgybsA
        NsKhDbpRmmL7KvxDQ7A7qlOfeGEKTdp0X0JNyGswv3KgbWdbLDl0P7xzzfj2aRCcG3dYYGtn59DDV
        c7WxPdrkOJWgoFEkyfqNdxgh2GC6W9vg00PNC6MCfjCdMDjDcT9rbGg7HyOA7g7DnebDsi4vr6JGn
        sqmPBPmpRrEa2twe0/A+fUU4UuXWAOyeKrT1IZDSLk5Bm00r7aSRLg48AI1OWKfK1HkNWZiX1Kqw7
        fThuM5Hg==;
Received: from [2a01:e34:ec5d:a741:8a4c:7c4e:dc4c:1787] (helo=ohm.rr44.fr)
        by hall.aurel32.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <aurelien@aurel32.net>)
        id 1nClsx-00Gm2K-NS; Wed, 26 Jan 2022 18:15:07 +0100
Received: from aurel32 by ohm.rr44.fr with local (Exim 4.95)
        (envelope-from <aurelien@aurel32.net>)
        id 1nClsx-005cI1-6x;
        Wed, 26 Jan 2022 18:15:07 +0100
From:   Aurelien Jarno <aurelien@aurel32.net>
To:     linux-kernel@vger.kernel.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>, stable@vger.kernel.org,
        Kito Cheng <kito.cheng@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-riscv@lists.infradead.org (open list:RISC-V ARCHITECTURE)
Subject: [PATCH] riscv: fix build with binutils 2.38
Date:   Wed, 26 Jan 2022 18:14:42 +0100
Message-Id: <20220126171442.1338740-1-aurelien@aurel32.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From version 2.38, binutils default to ISA spec version 20191213. This
means that the csr read/write (csrr*/csrw*) instructions and fence.i
instruction has separated from the `I` extension, become two standalone
extensions: Zicsr and Zifencei. As the kernel uses those instruction,
this causes the following build failure:

  CC      arch/riscv/kernel/vdso/vgettimeofday.o
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h: Assembler messages:
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'
  <<BUILDDIR>>/arch/riscv/include/asm/vdso/gettimeofday.h:71: Error: unrecognized opcode `csrr a5,0xc01'

The fix is to specify those extensions explicitely in -march. However as
older binutils version do not support this, we first need to detect
that.

Cc: stable@vger.kernel.org # 4.15+
Cc: Kito Cheng <kito.cheng@gmail.com>
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
---
 arch/riscv/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 8a107ed18b0d..7d81102cffd4 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -50,6 +50,12 @@ riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
 riscv-march-$(CONFIG_ARCH_RV64I)	:= rv64ima
 riscv-march-$(CONFIG_FPU)		:= $(riscv-march-y)fd
 riscv-march-$(CONFIG_RISCV_ISA_C)	:= $(riscv-march-y)c
+
+# Newer binutils versions default to ISA spec version 20191213 which moves some
+# instructions from the I extension to the Zicsr and Zifencei extensions.
+toolchain-need-zicsr-zifencei := $(call cc-option-yn, -march=$(riscv-march-y)_zicsr_zifencei)
+riscv-march-$(toolchain-need-zicsr-zifencei) := $(riscv-march-y)_zicsr_zifencei
+
 KBUILD_CFLAGS += -march=$(subst fd,,$(riscv-march-y))
 KBUILD_AFLAGS += -march=$(riscv-march-y)
 
-- 
2.34.1

