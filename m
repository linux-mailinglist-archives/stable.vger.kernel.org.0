Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58C71E4577
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 16:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgE0OOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 10:14:52 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:47377 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728911AbgE0OOw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 10:14:52 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MPXxi-1jQ7At0vQY-00McXf; Wed, 27 May 2020 16:14:37 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        Alexios Zavras <alexios.zavras@intel.com>,
        Enrico Weigelt <info@metux.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] arm64: fix clang integrated assembler build
Date:   Wed, 27 May 2020 16:14:03 +0200
Message-Id: <20200527141435.1716510-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:7D97oLdlne2qL09g2jgGMc+fbgxIgsEVGqtW3VCiQSLFiFZYW+g
 fn2jFC8fox4CvFLOjk636cGCNApIdf+wHKZhqEFujfdqm2RA4gYBX6NwhZyD2COJG9mMmWc
 hZsygdfgYo/BJ0Kpgn67wE5vUFZRUdL6nV85teYEDlb3akqK8j5BG/d4Xix3+ngCzx8f8Fk
 QtdTh5UFRdMZ4v9ZxpTRA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:nopDGBtTCRY=:gmcT7aGMYwgi+osEwcoJQd
 M7Gi+selGs6VVEavYYgErF6uTZ6bBgfdli88sKgqNPoV0LvojDp5VmIyj+rdciv7gMGj0A7yG
 jsDiTtFH2SJfh7G9T0mVtBLKxjCxcwuRBA3IpHG0Ix0Mc69PlCAi/WhHLq+ulS4Lr2XGvHq+i
 eA+ZilQHHREFYpRTpuJ9UzLbt3crO7IIwk+rIZuIFadfFGdEIrYcveNcP/Mx8s+rISZu+U6fJ
 o966l0cWMOpV7uUKixyQJ0gMm+m68gva1gZofkGPUgIHSZaHr+APCqVB32JERs1Kxh694ljSD
 jfg4u9GwJhba3Gqq0v3ZuyVcZA+bjVgkmONZpObxYgc+EMWanX2BG0+mRqhOR2UsifUB3KzUm
 MAqbVfxh5u/+Yd/wIvs4YR0FaYOCZs2u7VqJhQk5GviOVbJwaxBNTBMUXaQQQVAIeu5e4+QGf
 t9Vunr7FO6GBeg8gS+jJWKY1gpNoyF7sf9FLmbvnzDd9Av8oCauSMuRkkhOgeObnSI++XiJEE
 qbNady/hj5hewA4LQ2EPTinkoYjYimoGhthiKhIWh7LA95VBplavcS1deQ7/kIXn+FDcxCQUK
 9t9W8JPchCM0Q5Cq67VWkxasU2WZJ6OeyGeGtFRh3pICiDj75iXYPhK5rWPROhou2rwiDod/a
 AF5XVDZ6xPZOQcB3bPuIi1NpFtZVahogUzIPTLa7zYcHQYAuYyREDxOL+m1+FuPwuatMfZU8Y
 DDCAknP3KxiYVzUCmkp/UY9UPUCIqRb43sIcaParqPIxnSOG348OK23sPnh9lbzh5HCA7ky13
 hySQO9Htd477w1nEt4Lp3Ht6poAUlCheVhQ1ndjIPxQg+Cl5WU=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

clang and gas seem to interpret the symbols in memmove.S and
memset.S differently, such that clang does not make them
'weak' as expected, which leads to a linker error, with both
ld.bfd and ld.lld:

ld.lld: error: duplicate symbol: memmove
>>> defined at common.c
>>>            kasan/common.o:(memmove) in archive mm/built-in.a
>>> defined at memmove.o:(__memmove) in archive arch/arm64/lib/lib.a

ld.lld: error: duplicate symbol: memset
>>> defined at common.c
>>>            kasan/common.o:(memset) in archive mm/built-in.a
>>> defined at memset.o:(__memset) in archive arch/arm64/lib/lib.a

Copy the exact way these are written in memcpy_64.S, which does
not have the same problem.

I don't know why this makes a difference, and it would be good
to have someone with a better understanding of assembler internals
review it.

It might be either a bug in the kernel or a bug in the assembler,
no idea which one. My patch makes it work with all versions of
clang and gcc, which is probably helpful even if it's a workaround
for a clang bug.

Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
---
 arch/arm64/lib/memcpy.S  | 3 +--
 arch/arm64/lib/memmove.S | 3 +--
 arch/arm64/lib/memset.S  | 3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/lib/memcpy.S b/arch/arm64/lib/memcpy.S
index e0bf83d556f2..dc8d2a216a6e 100644
--- a/arch/arm64/lib/memcpy.S
+++ b/arch/arm64/lib/memcpy.S
@@ -56,9 +56,8 @@
 	stp \reg1, \reg2, [\ptr], \val
 	.endm
 
-	.weak memcpy
 SYM_FUNC_START_ALIAS(__memcpy)
-SYM_FUNC_START_PI(memcpy)
+SYM_FUNC_START_WEAK_PI(memcpy)
 #include "copy_template.S"
 	ret
 SYM_FUNC_END_PI(memcpy)
diff --git a/arch/arm64/lib/memmove.S b/arch/arm64/lib/memmove.S
index 02cda2e33bde..1035dce4bdaf 100644
--- a/arch/arm64/lib/memmove.S
+++ b/arch/arm64/lib/memmove.S
@@ -45,9 +45,8 @@ C_h	.req	x12
 D_l	.req	x13
 D_h	.req	x14
 
-	.weak memmove
 SYM_FUNC_START_ALIAS(__memmove)
-SYM_FUNC_START_PI(memmove)
+SYM_FUNC_START_WEAK_PI(memmove)
 	cmp	dstin, src
 	b.lo	__memcpy
 	add	tmp1, src, count
diff --git a/arch/arm64/lib/memset.S b/arch/arm64/lib/memset.S
index 77c3c7ba0084..a9c1c9a01ea9 100644
--- a/arch/arm64/lib/memset.S
+++ b/arch/arm64/lib/memset.S
@@ -42,9 +42,8 @@ dst		.req	x8
 tmp3w		.req	w9
 tmp3		.req	x9
 
-	.weak memset
 SYM_FUNC_START_ALIAS(__memset)
-SYM_FUNC_START_PI(memset)
+SYM_FUNC_START_WEAK_PI(memset)
 	mov	dst, dstin	/* Preserve return value.  */
 	and	A_lw, val, #255
 	orr	A_lw, A_lw, A_lw, lsl #8
-- 
2.26.2

