Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF2B3DA4B8
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237613AbhG2Nu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237680AbhG2NuY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:50:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E057D6023F;
        Thu, 29 Jul 2021 13:50:21 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m96QV-001nXB-Hw; Thu, 29 Jul 2021 14:50:20 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, Quentin Perret <qperret@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Unregister HYP sections from kmemleak in protected mode
Date:   Thu, 29 Jul 2021 14:50:16 +0100
Message-Id: <20210729135016.3037277-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com, qperret@google.com, catalin.marinas@arm.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Booting a KVM host in protected mode with kmemleak quickly results
in a pretty bad crash, as kmemleak doesn't know that the HYP sections
have been taken away.

Make the unregistration from kmemleak part of marking the sections
as HYP-private. The rest of the HYP-specific data is obtained via
the page allocator, which is not subjected to kmemleak.

Fixes: 90134ac9cabb ("KVM: arm64: Protect the .hyp sections from the host")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: stable@vger.kernel.org # 5.13
---
 arch/arm64/kvm/arm.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..23f12e602878 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -15,6 +15,7 @@
 #include <linux/fs.h>
 #include <linux/mman.h>
 #include <linux/sched.h>
+#include <linux/kmemleak.h>
 #include <linux/kvm.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
@@ -1960,8 +1961,12 @@ static inline int pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
 }
 
 #define pkvm_mark_hyp_section(__section)		\
+({							\
+	u64 sz = __section##_end - __section##_start;	\
+	kmemleak_free_part(__section##_start, sz);	\
 	pkvm_mark_hyp(__pa_symbol(__section##_start),	\
-			__pa_symbol(__section##_end))
+		      __pa_symbol(__section##_end));	\
+})
 
 static int finalize_hyp_mode(void)
 {
-- 
2.30.2

