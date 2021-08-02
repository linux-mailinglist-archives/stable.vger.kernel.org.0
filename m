Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996753DD5CB
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 14:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbhHBMjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 08:39:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233622AbhHBMjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 08:39:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92BDF60FF2;
        Mon,  2 Aug 2021 12:38:55 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mAXDa-002Rjd-1Q; Mon, 02 Aug 2021 13:38:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: arm64: Unregister HYP sections from kmemleak in protected mode
Date:   Mon,  2 Aug 2021 13:38:30 +0100
Message-Id: <20210802123830.2195174-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210802123830.2195174-1-maz@kernel.org>
References: <20210802123830.2195174-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, qperret@google.com, will@kernel.org, catalin.marinas@arm.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Booting a KVM host in protected mode with kmemleak quickly results
in a pretty bad crash, as kmemleak doesn't know that the HYP sections
have been taken away. This is specially true for the BSS section,
which is part of the kernel BSS section and registered at boot time
by kmemleak itself.

Unregister the HYP part of the BSS before making that section
HYP-private. The rest of the HYP-specific data is obtained via
the page allocator or lives in other sections, none of which is
subjected to kmemleak.

Fixes: 90134ac9cabb ("KVM: arm64: Protect the .hyp sections from the host")
Reviewed-by: Quentin Perret <qperret@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: stable@vger.kernel.org # 5.13
---
 arch/arm64/kvm/arm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e9a2b8f27792..52242f32c4be 100644
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
@@ -1982,6 +1983,12 @@ static int finalize_hyp_mode(void)
 	if (ret)
 		return ret;
 
+	/*
+	 * Exclude HYP BSS from kmemleak so that it doesn't get peeked
+	 * at, which would end badly once the section is inaccessible.
+	 * None of other sections should ever be introspected.
+	 */
+	kmemleak_free_part(__hyp_bss_start, __hyp_bss_end - __hyp_bss_start);
 	ret = pkvm_mark_hyp_section(__hyp_bss);
 	if (ret)
 		return ret;
-- 
2.30.2

