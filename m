Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC78F328F3D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242052AbhCATsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:48:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:51202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236932AbhCATgm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:36:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F469650C4;
        Mon,  1 Mar 2021 17:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620611;
        bh=z48XpFlYBWyux+J2/a5onXBUtrHRr7RYVt6Yo8P6K/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HxXu0RHe7KU7wsffKdi6jQF6Rs2nuKocJ3hmuaBPu6Rc61SPO+nbS5RK4E83+oSyR
         2vOk2qMbI/SVYGa1OvpsiJe/ThjeKUII0Z4HdTOTQk/UrCn+bywdlrQuQFRpF4VG+m
         0ZwO6IY+36v4d8SWarVq6FPNlxChFUqNBMQPCr00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 216/775] MIPS: Compare __SYNC_loongson3_war against 0
Date:   Mon,  1 Mar 2021 17:06:24 +0100
Message-Id: <20210301161212.295955210@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 8790ccf8daf1a8c53b6cb8ce0c9a109274bd3fa8 ]

When building with clang when CONFIG_CPU_LOONGSON3_WORKAROUNDS is
enabled:

 In file included from lib/errseq.c:4:
 In file included from ./include/linux/atomic.h:7:
 ./arch/mips/include/asm/atomic.h:52:1: warning: converting the result of
 '<<' to a boolean always evaluates to true
 [-Wtautological-constant-compare]
 ATOMIC_OPS(atomic64, s64)
 ^
 ./arch/mips/include/asm/atomic.h:40:9: note: expanded from macro
 'ATOMIC_OPS'
         return cmpxchg(&v->counter, o, n);
                ^
 ./arch/mips/include/asm/cmpxchg.h:194:7: note: expanded from macro
 'cmpxchg'
         if (!__SYNC_loongson3_war)
              ^
 ./arch/mips/include/asm/sync.h:147:34: note: expanded from macro
 '__SYNC_loongson3_war'
 # define __SYNC_loongson3_war   (1 << 31)
                                    ^

While it is not wrong that the result of this shift is always true in a
boolean context, it is not a problem here. Regardless, the warning is
really noisy so rather than making the shift a boolean implicitly, use
it in an equality comparison so the shift is used as an integer value.

Fixes: 4d1dbfe6cbec ("MIPS: atomic: Emit Loongson3 sync workarounds within asm")
Fixes: a91f2a1dba44 ("MIPS: cmpxchg: Omit redundant barriers for Loongson3")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/atomic.h  | 2 +-
 arch/mips/include/asm/cmpxchg.h | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index f904084fcb1fd..27ad767915390 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -248,7 +248,7 @@ static __inline__ int pfx##_sub_if_positive(type i, pfx##_t * v)	\
 	 * bltz that can branch	to code outside of the LL/SC loop. As	\
 	 * such, we don't need to emit another barrier here.		\
 	 */								\
-	if (!__SYNC_loongson3_war)					\
+	if (__SYNC_loongson3_war == 0)					\
 		smp_mb__after_atomic();					\
 									\
 	return result;							\
diff --git a/arch/mips/include/asm/cmpxchg.h b/arch/mips/include/asm/cmpxchg.h
index 5b0b3a6777ea5..ed8f3f3c4304a 100644
--- a/arch/mips/include/asm/cmpxchg.h
+++ b/arch/mips/include/asm/cmpxchg.h
@@ -99,7 +99,7 @@ unsigned long __xchg(volatile void *ptr, unsigned long x, int size)
 	 * contains a completion barrier prior to the LL, so we don't	\
 	 * need to emit an extra one here.				\
 	 */								\
-	if (!__SYNC_loongson3_war)					\
+	if (__SYNC_loongson3_war == 0)					\
 		smp_mb__before_llsc();					\
 									\
 	__res = (__typeof__(*(ptr)))					\
@@ -191,7 +191,7 @@ unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 	 * contains a completion barrier prior to the LL, so we don't	\
 	 * need to emit an extra one here.				\
 	 */								\
-	if (!__SYNC_loongson3_war)					\
+	if (__SYNC_loongson3_war == 0)					\
 		smp_mb__before_llsc();					\
 									\
 	__res = cmpxchg_local((ptr), (old), (new));			\
@@ -201,7 +201,7 @@ unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
 	 * contains a completion barrier after the SC, so we don't	\
 	 * need to emit an extra one here.				\
 	 */								\
-	if (!__SYNC_loongson3_war)					\
+	if (__SYNC_loongson3_war == 0)					\
 		smp_llsc_mb();						\
 									\
 	__res;								\
-- 
2.27.0



