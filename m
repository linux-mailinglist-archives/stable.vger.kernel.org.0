Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4490133E46B
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhCQA7t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:59:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232254AbhCQA7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51E5164FB9;
        Wed, 17 Mar 2021 00:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942733;
        bh=2mwziOYKT3pRWQtNG0ZVuTpdkoBbG0Y6HR+EIoH3K70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GSNrtIbppG6CP/BMgl1RjaO8/0atE9ZDYk1KMKaKNJH1ZK+JVi8MMFvHPXAyUfCE0
         P85a+10aFYb+X08rWiBkxfcvbhgOw+ougCOeSyAiRf+KLDUOZ71I4CUc90N5cokAAn
         HDTyCCOmUikZsNqYlu0/g7b7tus0jNe5ZGY/PJ+1B3KGaSqDdmbjIEuSHwe5EYPfL3
         60mHQLJODsHcZ9Jo1cTTpIEQGRYPdGeS+CCdIoLEW47+pgnMxEHS4QmJ/sPi6ICKeu
         k0of32XgXCYjsvisiWlnLmJFgPRn1zqhmc8CqRh/dH4I0noMxwOXBCUVADrAaPfzIP
         8Qt1iDMInnHQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        kernel test robot <lkp@intel.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Feng Tang <feng.tang@intel.com>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 02/23] powerpc/4xx: Fix build errors from mfdcr()
Date:   Tue, 16 Mar 2021 20:58:28 -0400
Message-Id: <20210317005850.726479-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005850.726479-1-sashal@kernel.org>
References: <20210317005850.726479-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit eead089311f4d935ab5d1d8fbb0c42ad44699ada ]

lkp reported a build error in fsp2.o:

  CC      arch/powerpc/platforms/44x/fsp2.o
  {standard input}:577: Error: unsupported relocation against base

Which comes from:

  pr_err("GESR0: 0x%08x\n", mfdcr(base + PLB4OPB_GESR0));

Where our mfdcr() macro is stringifying "base + PLB4OPB_GESR0", and
passing that to the assembler, which obviously doesn't work.

The mfdcr() macro already checks that the argument is constant using
__builtin_constant_p(), and if not calls the out-of-line version of
mfdcr(). But in this case GCC is smart enough to notice that "base +
PLB4OPB_GESR0" will be constant, even though it's not something we can
immediately stringify into a register number.

Segher pointed out that passing the register number to the inline asm
as a constant would be better, and in fact it fixes the build error,
presumably because it gives GCC a chance to resolve the value.

While we're at it, change mtdcr() similarly.

Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Segher Boessenkool <segher@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Feng Tang <feng.tang@intel.com>
Link: https://lore.kernel.org/r/20210218123058.748882-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/dcr-native.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/dcr-native.h b/arch/powerpc/include/asm/dcr-native.h
index 151dff555f50..9d9e323f5e9b 100644
--- a/arch/powerpc/include/asm/dcr-native.h
+++ b/arch/powerpc/include/asm/dcr-native.h
@@ -66,8 +66,8 @@ static inline void mtdcrx(unsigned int reg, unsigned int val)
 #define mfdcr(rn)						\
 	({unsigned int rval;					\
 	if (__builtin_constant_p(rn) && rn < 1024)		\
-		asm volatile("mfdcr %0," __stringify(rn)	\
-		              : "=r" (rval));			\
+		asm volatile("mfdcr %0, %1" : "=r" (rval)	\
+			      : "n" (rn));			\
 	else if (likely(cpu_has_feature(CPU_FTR_INDEXED_DCR)))	\
 		rval = mfdcrx(rn);				\
 	else							\
@@ -77,8 +77,8 @@ static inline void mtdcrx(unsigned int reg, unsigned int val)
 #define mtdcr(rn, v)						\
 do {								\
 	if (__builtin_constant_p(rn) && rn < 1024)		\
-		asm volatile("mtdcr " __stringify(rn) ",%0"	\
-			      : : "r" (v)); 			\
+		asm volatile("mtdcr %0, %1"			\
+			      : : "n" (rn), "r" (v));		\
 	else if (likely(cpu_has_feature(CPU_FTR_INDEXED_DCR)))	\
 		mtdcrx(rn, v);					\
 	else							\
-- 
2.30.1

