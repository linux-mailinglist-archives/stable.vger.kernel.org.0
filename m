Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BE73F645B
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238888AbhHXRDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238978AbhHXRBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:01:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C514461425;
        Tue, 24 Aug 2021 16:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824279;
        bh=HjxJKPBkmP9zosEOWuLj3wfAOQnWtvF1MXp2wTXoF3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXcPOABjRLcY/tcshhnHmSJTZosBgDHBWOQuf5FNhZtHgiA0rDl2TCUL7duseuJf0
         JS2NG75mN/8yFz6dhK32icqDuD+iD0FVOr00FRhacUtKy17zaPckAy5l9w+XntVO/D
         Za0HIc0mmS8f+mvJ5VhPtb+lOO0yqbQjesLCy9iDrxrM7wOsi1TyevrNXgB/YsYXJu
         Yn+6UzuF6UiJpXOLrYCa5eTh3nZmJQhtFc7VbM9KI2m/K1Y5ZPZMPCSz0rVaPMbJfg
         CUXS+FvCO8cFxEK3+jwmzAiyiN+PYus5ODrp4hZzIdKOyPDtqFIN3jgB2PKKY+FLWH
         8yp5gKRWLJ+hQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 114/127] powerpc/32s: Refactor update of user segment registers
Date:   Tue, 24 Aug 2021 12:55:54 -0400
Message-Id: <20210824165607.709387-115-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 91bb30822a2e1d7900f9f42e9e92647a9015f979 ]

KUEP implements the update of user segment registers.

Move it into mmu-hash.h in order to use it from other places.

And inline kuep_lock() and kuep_unlock(). Inlining kuep_lock() is
important for system_call_exception(), otherwise system_call_exception()
has to save into stack the system call parameters that are used just
after, and doing that takes more instructions than kuep_lock() itself.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/24591ca480d14a62ef910e38a5273d551262c4a2.1622708530.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/32/kup.h      | 21 +++++++++++
 arch/powerpc/include/asm/book3s/32/mmu-hash.h | 27 ++++++++++++++
 arch/powerpc/include/asm/kup.h                |  5 +--
 arch/powerpc/mm/book3s32/kuep.c               | 37 -------------------
 4 files changed, 49 insertions(+), 41 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/kup.h b/arch/powerpc/include/asm/book3s/32/kup.h
index 1670dfe9d4f1..5353ea68b912 100644
--- a/arch/powerpc/include/asm/book3s/32/kup.h
+++ b/arch/powerpc/include/asm/book3s/32/kup.h
@@ -7,6 +7,27 @@
 
 #ifndef __ASSEMBLY__
 
+static __always_inline bool kuep_is_disabled(void)
+{
+	return !IS_ENABLED(CONFIG_PPC_KUEP);
+}
+
+static inline void kuep_lock(void)
+{
+	if (kuep_is_disabled())
+		return;
+
+	update_user_segments(mfsr(0) | SR_NX);
+}
+
+static inline void kuep_unlock(void)
+{
+	if (kuep_is_disabled())
+		return;
+
+	update_user_segments(mfsr(0) & ~SR_NX);
+}
+
 #ifdef CONFIG_PPC_KUAP
 
 #include <linux/sched.h>
diff --git a/arch/powerpc/include/asm/book3s/32/mmu-hash.h b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
index b85f8e114a9c..cc0284bbac86 100644
--- a/arch/powerpc/include/asm/book3s/32/mmu-hash.h
+++ b/arch/powerpc/include/asm/book3s/32/mmu-hash.h
@@ -102,6 +102,33 @@ extern s32 patch__hash_page_B, patch__hash_page_C;
 extern s32 patch__flush_hash_A0, patch__flush_hash_A1, patch__flush_hash_A2;
 extern s32 patch__flush_hash_B;
 
+#include <asm/reg.h>
+#include <asm/task_size_32.h>
+
+#define UPDATE_TWO_USER_SEGMENTS(n) do {		\
+	if (TASK_SIZE > ((n) << 28))			\
+		mtsr(val1, (n) << 28);			\
+	if (TASK_SIZE > (((n) + 1) << 28))		\
+		mtsr(val2, ((n) + 1) << 28);		\
+	val1 = (val1 + 0x222) & 0xf0ffffff;		\
+	val2 = (val2 + 0x222) & 0xf0ffffff;		\
+} while (0)
+
+static __always_inline void update_user_segments(u32 val)
+{
+	int val1 = val;
+	int val2 = (val + 0x111) & 0xf0ffffff;
+
+	UPDATE_TWO_USER_SEGMENTS(0);
+	UPDATE_TWO_USER_SEGMENTS(2);
+	UPDATE_TWO_USER_SEGMENTS(4);
+	UPDATE_TWO_USER_SEGMENTS(6);
+	UPDATE_TWO_USER_SEGMENTS(8);
+	UPDATE_TWO_USER_SEGMENTS(10);
+	UPDATE_TWO_USER_SEGMENTS(12);
+	UPDATE_TWO_USER_SEGMENTS(14);
+}
+
 #endif /* !__ASSEMBLY__ */
 
 /* We happily ignore the smaller BATs on 601, we don't actually use
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index ec96232529ac..4b94d4293777 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -46,10 +46,7 @@ void setup_kuep(bool disabled);
 static inline void setup_kuep(bool disabled) { }
 #endif /* CONFIG_PPC_KUEP */
 
-#if defined(CONFIG_PPC_KUEP) && defined(CONFIG_PPC_BOOK3S_32)
-void kuep_lock(void);
-void kuep_unlock(void);
-#else
+#ifndef CONFIG_PPC_BOOK3S_32
 static inline void kuep_lock(void) { }
 static inline void kuep_unlock(void) { }
 #endif
diff --git a/arch/powerpc/mm/book3s32/kuep.c b/arch/powerpc/mm/book3s32/kuep.c
index 6eafe7b2b031..919595f47e25 100644
--- a/arch/powerpc/mm/book3s32/kuep.c
+++ b/arch/powerpc/mm/book3s32/kuep.c
@@ -1,43 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
 #include <asm/kup.h>
-#include <asm/reg.h>
-#include <asm/task_size_32.h>
-#include <asm/mmu.h>
-
-#define KUEP_UPDATE_TWO_USER_SEGMENTS(n) do {		\
-	if (TASK_SIZE > ((n) << 28))			\
-		mtsr(val1, (n) << 28);			\
-	if (TASK_SIZE > (((n) + 1) << 28))		\
-		mtsr(val2, ((n) + 1) << 28);		\
-	val1 = (val1 + 0x222) & 0xf0ffffff;		\
-	val2 = (val2 + 0x222) & 0xf0ffffff;		\
-} while (0)
-
-static __always_inline void kuep_update(u32 val)
-{
-	int val1 = val;
-	int val2 = (val + 0x111) & 0xf0ffffff;
-
-	KUEP_UPDATE_TWO_USER_SEGMENTS(0);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(2);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(4);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(6);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(8);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(10);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(12);
-	KUEP_UPDATE_TWO_USER_SEGMENTS(14);
-}
-
-void kuep_lock(void)
-{
-	kuep_update(mfsr(0) | SR_NX);
-}
-
-void kuep_unlock(void)
-{
-	kuep_update(mfsr(0) & ~SR_NX);
-}
 
 void __init setup_kuep(bool disabled)
 {
-- 
2.30.2

