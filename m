Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14EB983B5A
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfHFVek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727779AbfHFVej (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:34:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F6B121874;
        Tue,  6 Aug 2019 21:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127278;
        bh=3L+IQwvQDdqWZRQVsDruL1DOw6e+QLjGDZNG9Teckc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sma3zHcegCHyxkYKpAyo4F/W55axHJl/A9ZG/jkEWTxtKeFMxIUllkIMc498AvLb4
         7F/QBSIZWnJSPKnfKdr6/H8UUeWn/G+oq7WERynL3gcV4mhytjiJnvQ7xoAqgdhNyR
         NYJv7XawWSgD4OUddcdELgWv+pCGZcniad9xp/fs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julien Thierry <julien.thierry.kdev@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 40/59] arm64: Lower priority mask for GIC_PRIO_IRQON
Date:   Tue,  6 Aug 2019 17:33:00 -0400
Message-Id: <20190806213319.19203-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry.kdev@gmail.com>

[ Upstream commit 677379bc9139ac24b310a281fcb21a2f04288353 ]

On a system with two security states, if SCR_EL3.FIQ is cleared,
non-secure IRQ priorities get shifted to fit the secure view but
priority masks aren't.

On such system, it turns out that GIC_PRIO_IRQON masks the priority of
normal interrupts, which obviously ends up in a hang.

Increase GIC_PRIO_IRQON value (i.e. lower priority) to make sure
interrupts are not blocked by it.

Cc: Oleg Nesterov <oleg@redhat.com>
Fixes: bd82d4bd21880b7c ("arm64: Fix incorrect irqflag restore for priority masking")
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Julien Thierry <julien.thierry.kdev@gmail.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[will: fixed Fixes: tag]
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/arch_gicv3.h | 6 ++++++
 arch/arm64/include/asm/ptrace.h     | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index 79155a8cfe7c0..89e4c8b793490 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -155,6 +155,12 @@ static inline void gic_pmr_mask_irqs(void)
 	BUILD_BUG_ON(GICD_INT_DEF_PRI < (GIC_PRIO_IRQOFF |
 					 GIC_PRIO_PSR_I_SET));
 	BUILD_BUG_ON(GICD_INT_DEF_PRI >= GIC_PRIO_IRQON);
+	/*
+	 * Need to make sure IRQON allows IRQs when SCR_EL3.FIQ is cleared
+	 * and non-secure PMR accesses are not subject to the shifts that
+	 * are applied to IRQ priorities
+	 */
+	BUILD_BUG_ON((0x80 | (GICD_INT_DEF_PRI >> 1)) >= GIC_PRIO_IRQON);
 	gic_write_pmr(GIC_PRIO_IRQOFF);
 }
 
diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 81693244f58d6..701eaa7381876 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -30,7 +30,7 @@
  * in the  the priority mask, it indicates that PSR.I should be set and
  * interrupt disabling temporarily does not rely on IRQ priorities.
  */
-#define GIC_PRIO_IRQON			0xc0
+#define GIC_PRIO_IRQON			0xe0
 #define GIC_PRIO_IRQOFF			(GIC_PRIO_IRQON & ~0x80)
 #define GIC_PRIO_PSR_I_SET		(1 << 4)
 
-- 
2.20.1

