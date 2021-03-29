Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDD234C975
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbhC2I3w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234239AbhC2I17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAB63619C2;
        Mon, 29 Mar 2021 08:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006419;
        bh=s2eDsaW1ro1iLhAOcNkNv9YFiR0Q4k8z1QIVXQWIZQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUDktKUQa39/Cww7MAnwxKxe3L4JITDBesRXCgJLD+iw7SZkGnVqcu4Uzw3eQD84Z
         C2m1Zwy5Uvc5IbEQGLr4l3CQAvQ0epqVLgm9P7YAkSnNtvd/EzTUct/bOb+FPXg/NL
         NGClUpaxoht2wdU0Tiyi/DBP9YjA0WcqE5B1Wqf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Feng Tang <feng.tang@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 005/254] powerpc/4xx: Fix build errors from mfdcr()
Date:   Mon, 29 Mar 2021 09:55:21 +0200
Message-Id: <20210329075633.318319732@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7141ccea8c94..a92059964579 100644
--- a/arch/powerpc/include/asm/dcr-native.h
+++ b/arch/powerpc/include/asm/dcr-native.h
@@ -53,8 +53,8 @@ static inline void mtdcrx(unsigned int reg, unsigned int val)
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
@@ -64,8 +64,8 @@ static inline void mtdcrx(unsigned int reg, unsigned int val)
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



