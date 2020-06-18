Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630E81FE679
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgFRCdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729347AbgFRBOi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6398D21D90;
        Thu, 18 Jun 2020 01:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442878;
        bh=ySCvOEhxd8UpgYwhmu3TXkszZl1O6dsa4nyS8gl6vYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgMO+u0mF4GiTgN6yjXZcDsqTSGQO8CbDzOtGyJ/aFu3LZaabM78p8dFy4nQD0JbG
         10XaQhkivkUzyR9QnZqBz3eifMtH6IiL7FAm8EmBlgUxIADxXjJ9Z48fEpxAnwvGCM
         0cU3S5ImDi7YGaVm+LBXHlD7hegdLTZs6hXQlDUQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.7 303/388] powerpc/64s/kuap: Add missing isync to KUAP restore paths
Date:   Wed, 17 Jun 2020 21:06:40 -0400
Message-Id: <20200618010805.600873-303-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit cb2b53cbffe3c388cd676b63f34e54ceb2643ae2 ]

Writing the AMR register is documented to require context
synchronizing operations before and after, for it to take effect as
expected. The KUAP restore at interrupt exit time deliberately avoids
the isync after the AMR update because it only needs to take effect
after the context synchronizing RFID that soon follows. Add a comment
for this.

The missing isync before the update doesn't have an obvious
justification, and seems it could theoretically allow a rogue user
access to leak past the AMR update. Add isyncs for these.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200429065654.1677541-3-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/64/kup-radix.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/book3s/64/kup-radix.h b/arch/powerpc/include/asm/book3s/64/kup-radix.h
index 3bcef989a35d..101d60f16d46 100644
--- a/arch/powerpc/include/asm/book3s/64/kup-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -16,7 +16,9 @@
 #ifdef CONFIG_PPC_KUAP
 	BEGIN_MMU_FTR_SECTION_NESTED(67)
 	ld	\gpr, STACK_REGS_KUAP(r1)
+	isync
 	mtspr	SPRN_AMR, \gpr
+	/* No isync required, see kuap_restore_amr() */
 	END_MMU_FTR_SECTION_NESTED_IFSET(MMU_FTR_RADIX_KUAP, 67)
 #endif
 .endm
@@ -62,8 +64,15 @@
 
 static inline void kuap_restore_amr(struct pt_regs *regs)
 {
-	if (mmu_has_feature(MMU_FTR_RADIX_KUAP))
+	if (mmu_has_feature(MMU_FTR_RADIX_KUAP)) {
+		isync();
 		mtspr(SPRN_AMR, regs->kuap);
+		/*
+		 * No isync required here because we are about to RFI back to
+		 * previous context before any user accesses would be made,
+		 * which is a CSI.
+		 */
+	}
 }
 
 static inline void kuap_check_amr(void)
-- 
2.25.1

