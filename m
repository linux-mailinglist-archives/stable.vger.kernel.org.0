Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20E311B54A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732139AbfLKPT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:19:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732287AbfLKPT4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:19:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8073208C3;
        Wed, 11 Dec 2019 15:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077596;
        bh=JBPU3/vrUj+oKai8Q/oTSq69QE5XbAgQhbOd/sQgtcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mJqz2SS78OF5QxehRM2qE19nj7xk3z1i9WyYxdzM/DwrQRAoSK1xAC5I4OhGUv8NB
         D3ejOzufk2uhu8W1X+D1jX3sDs7+UdLhyf1Wa+IRu41AOW1ZtV2bY9lyaziJVsfPBM
         jbU0eU3Dp2ZYUvzD4NSDxtpcixUj8YsNGt+UBuHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Breno Leitao <leitao@debian.org>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/243] selftests/powerpc: Allocate base registers
Date:   Wed, 11 Dec 2019 16:04:19 +0100
Message-Id: <20191211150345.664023716@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 5249497a7bb6334fcc128588d6a7e1e21786515a ]

Some ptrace selftests are passing input operands using a constraint that
can allocate any register for the operand, and using these registers on
load/store operations.

If the register allocated by the compiler happens to be zero (r0), it might
cause an invalid memory address access, since load and store operations
consider the content of 0x0 address if the base register is r0, instead of
the content of the r0 register. For example:

	r1 := 0xdeadbeef
	r0 := 0xdeadbeef

	ld r2, 0(1) /* will load into r2 the content of r1 address */
	ld r2, 0(0) /* will load into r2 the content of 0x0 */

In order to avoid this possible problem, the inline assembly constraint
should be aware that these registers will be used as a base register, thus,
r0 should not be allocated.

Other than that, this patch removes inline assembly operands that are not
used by the tests.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/ptrace/ptrace-gpr.c        | 2 +-
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-gpr.c     | 4 ++--
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c | 2 +-
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c | 3 +--
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-spr.c     | 2 +-
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c     | 2 +-
 tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c     | 3 +--
 7 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-gpr.c b/tools/testing/selftests/powerpc/ptrace/ptrace-gpr.c
index 0b4ebcc2f485a..ca29fafeed5d9 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-gpr.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-gpr.c
@@ -31,7 +31,7 @@ void gpr(void)
 		ASM_LOAD_GPR_IMMED(gpr_1)
 		ASM_LOAD_FPR_SINGLE_PRECISION(flt_1)
 		:
-		: [gpr_1]"i"(GPR_1), [flt_1] "r" (&a)
+		: [gpr_1]"i"(GPR_1), [flt_1] "b" (&a)
 		: "memory", "r6", "r7", "r8", "r9", "r10",
 		"r11", "r12", "r13", "r14", "r15", "r16", "r17",
 		"r18", "r19", "r20", "r21", "r22", "r23", "r24",
diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-gpr.c b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-gpr.c
index 59206b96e98a5..a08a91594dbe5 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-gpr.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-gpr.c
@@ -59,8 +59,8 @@ trans:
 		"3: ;"
 		: [res] "=r" (result), [texasr] "=r" (texasr)
 		: [gpr_1]"i"(GPR_1), [gpr_2]"i"(GPR_2),
-		[sprn_texasr] "i" (SPRN_TEXASR), [flt_1] "r" (&a),
-		[flt_2] "r" (&b), [cptr1] "r" (&cptr[1])
+		[sprn_texasr] "i" (SPRN_TEXASR), [flt_1] "b" (&a),
+		[flt_2] "b" (&b), [cptr1] "b" (&cptr[1])
 		: "memory", "r7", "r8", "r9", "r10",
 		"r11", "r12", "r13", "r14", "r15", "r16",
 		"r17", "r18", "r19", "r20", "r21", "r22",
diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c
index b3c061dc95122..f471747462312 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-tar.c
@@ -72,7 +72,7 @@ trans:
 		"3: ;"
 
 		: [res] "=r" (result), [texasr] "=r" (texasr)
-		: [val] "r" (cptr[1]), [sprn_dscr]"i"(SPRN_DSCR),
+		: [sprn_dscr]"i"(SPRN_DSCR),
 		[sprn_tar]"i"(SPRN_TAR), [sprn_ppr]"i"(SPRN_PPR),
 		[sprn_texasr]"i"(SPRN_TEXASR), [tar_1]"i"(TAR_1),
 		[dscr_1]"i"(DSCR_1), [tar_2]"i"(TAR_2), [dscr_2]"i"(DSCR_2),
diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c
index 277dade1b382f..18a685bf6a097 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spd-vsx.c
@@ -77,8 +77,7 @@ trans:
 
 		"3: ;"
 		: [res] "=r" (result), [texasr] "=r" (texasr)
-		: [fp_load] "r" (fp_load), [fp_load_ckpt] "r" (fp_load_ckpt),
-		[sprn_texasr] "i"  (SPRN_TEXASR)
+		: [sprn_texasr] "i"  (SPRN_TEXASR)
 		: "memory", "r0", "r1", "r3", "r4",
 		"r7", "r8", "r9", "r10", "r11"
 		);
diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spr.c b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spr.c
index 51427a2465f69..ba04999254e38 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spr.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-spr.c
@@ -74,7 +74,7 @@ trans:
 
 		"3: ;"
 		: [tfhar] "=r" (tfhar), [res] "=r" (result),
-		[texasr] "=r" (texasr), [cptr1] "=r" (cptr1)
+		[texasr] "=r" (texasr), [cptr1] "=b" (cptr1)
 		: [sprn_texasr] "i"  (SPRN_TEXASR)
 		: "memory", "r0", "r8", "r31"
 		);
diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c
index 48b462f750230..f70023b25e6e8 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-tar.c
@@ -65,7 +65,7 @@ trans:
 		: [sprn_dscr]"i"(SPRN_DSCR), [sprn_tar]"i"(SPRN_TAR),
 		[sprn_ppr]"i"(SPRN_PPR), [sprn_texasr]"i"(SPRN_TEXASR),
 		[tar_1]"i"(TAR_1), [dscr_1]"i"(DSCR_1), [tar_2]"i"(TAR_2),
-		[dscr_2]"i"(DSCR_2), [cptr1] "r" (&cptr[1])
+		[dscr_2]"i"(DSCR_2), [cptr1] "b" (&cptr[1])
 		: "memory", "r0", "r1", "r3", "r4", "r5", "r6"
 		);
 
diff --git a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c
index 17c23cabac3ea..dfba800589776 100644
--- a/tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c
+++ b/tools/testing/selftests/powerpc/ptrace/ptrace-tm-vsx.c
@@ -65,8 +65,7 @@ trans:
 
 		"3: ;"
 		: [res] "=r" (result), [texasr] "=r" (texasr)
-		: [fp_load] "r" (fp_load), [fp_load_ckpt] "r" (fp_load_ckpt),
-		[sprn_texasr] "i"  (SPRN_TEXASR), [cptr1] "r" (&cptr[1])
+		: [sprn_texasr] "i"  (SPRN_TEXASR), [cptr1] "b" (&cptr[1])
 		: "memory", "r0", "r1", "r3", "r4",
 		"r7", "r8", "r9", "r10", "r11"
 		);
-- 
2.20.1



