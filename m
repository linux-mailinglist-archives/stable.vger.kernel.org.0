Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762D33F645D
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238894AbhHXRDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:03:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238972AbhHXRBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:01:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E13AE6162E;
        Tue, 24 Aug 2021 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824278;
        bh=//m5Xx1PJYg81lK/6+bPnkcoz3fiIw0ZeFmsBx1Ligo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yk5oOTza7yHuymECGtL4iXaRgJqA3AtdeC6OMu35EnDEJPZL7y/mSXdXJXuY4jwgr
         +DRfYoRnBOtwdMYe9vzR7mTV/kn7kBOBaRX9k/6c+v9qrGIWukVyxJ/KF7X2YkiB35
         nCpQyrChWwAG249W3FCxqPokfP9mVpMri5TMJN3PMcGDUSD46avyEB7W26c0HOagdG
         qVrP/6n2Jok/Di3gDIymuP5MbSMXpb0p8lYSV4AsiKzh8BfSfTwABCIIzlqKUAA+SO
         HlK4ldPUPAXSkOY9SK+Colozb93ogTsg/VliJOXK06NKq5BpmLGsEAWdHSoXSbPWXo
         EKh3HMCZgh/AQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 113/127] powerpc/32s: Move setup_{kuep/kuap}() into {kuep/kuap}.c
Date:   Tue, 24 Aug 2021 12:55:53 -0400
Message-Id: <20210824165607.709387-114-sashal@kernel.org>
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

[ Upstream commit 91ec66719d4c5c0e7b4e32585b01881660d1bc53 ]

Avoids the #ifdef in mmu.c

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/0b7a13d414837e58264edc336b89c2fe9f35f9bc.1622708530.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s32/Makefile |  1 +
 arch/powerpc/mm/book3s32/kuap.c   | 11 +++++++++++
 arch/powerpc/mm/book3s32/kuep.c   |  8 ++++++++
 arch/powerpc/mm/book3s32/mmu.c    | 20 --------------------
 4 files changed, 20 insertions(+), 20 deletions(-)
 create mode 100644 arch/powerpc/mm/book3s32/kuap.c

diff --git a/arch/powerpc/mm/book3s32/Makefile b/arch/powerpc/mm/book3s32/Makefile
index 7f0c8a78ba0c..15f4773643d2 100644
--- a/arch/powerpc/mm/book3s32/Makefile
+++ b/arch/powerpc/mm/book3s32/Makefile
@@ -10,3 +10,4 @@ obj-y += mmu.o mmu_context.o
 obj-$(CONFIG_PPC_BOOK3S_603) += nohash_low.o
 obj-$(CONFIG_PPC_BOOK3S_604) += hash_low.o tlb.o
 obj-$(CONFIG_PPC_KUEP) += kuep.o
+obj-$(CONFIG_PPC_KUAP) += kuap.o
diff --git a/arch/powerpc/mm/book3s32/kuap.c b/arch/powerpc/mm/book3s32/kuap.c
new file mode 100644
index 000000000000..1df55392878e
--- /dev/null
+++ b/arch/powerpc/mm/book3s32/kuap.c
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <asm/kup.h>
+
+void __init setup_kuap(bool disabled)
+{
+	pr_info("Activating Kernel Userspace Access Protection\n");
+
+	if (disabled)
+		pr_warn("KUAP cannot be disabled yet on 6xx when compiled in\n");
+}
diff --git a/arch/powerpc/mm/book3s32/kuep.c b/arch/powerpc/mm/book3s32/kuep.c
index 8ed1b8634839..6eafe7b2b031 100644
--- a/arch/powerpc/mm/book3s32/kuep.c
+++ b/arch/powerpc/mm/book3s32/kuep.c
@@ -38,3 +38,11 @@ void kuep_unlock(void)
 {
 	kuep_update(mfsr(0) & ~SR_NX);
 }
+
+void __init setup_kuep(bool disabled)
+{
+	pr_info("Activating Kernel Userspace Execution Prevention\n");
+
+	if (disabled)
+		pr_warn("KUEP cannot be disabled yet on 6xx when compiled in\n");
+}
diff --git a/arch/powerpc/mm/book3s32/mmu.c b/arch/powerpc/mm/book3s32/mmu.c
index 159930351d9f..27061583a010 100644
--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -445,26 +445,6 @@ void __init print_system_hash_info(void)
 		pr_info("Hash_mask         = 0x%lx\n", Hash_mask);
 }
 
-#ifdef CONFIG_PPC_KUEP
-void __init setup_kuep(bool disabled)
-{
-	pr_info("Activating Kernel Userspace Execution Prevention\n");
-
-	if (disabled)
-		pr_warn("KUEP cannot be disabled yet on 6xx when compiled in\n");
-}
-#endif
-
-#ifdef CONFIG_PPC_KUAP
-void __init setup_kuap(bool disabled)
-{
-	pr_info("Activating Kernel Userspace Access Protection\n");
-
-	if (disabled)
-		pr_warn("KUAP cannot be disabled yet on 6xx when compiled in\n");
-}
-#endif
-
 void __init early_init_mmu(void)
 {
 }
-- 
2.30.2

