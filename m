Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E538432F340
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 19:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCESxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 13:53:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:58224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhCESxC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 13:53:02 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C71D260200;
        Fri,  5 Mar 2021 18:53:01 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lIFZM-00HYFA-3M; Fri, 05 Mar 2021 18:53:00 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Howard Zhang <Howard.Zhang@arm.com>,
        Jia He <justin.he@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/8] KVM: arm64: Avoid corrupting vCPU context register in guest exit
Date:   Fri,  5 Mar 2021 18:52:48 +0000
Message-Id: <20210305185254.3730990-3-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210305185254.3730990-1-maz@kernel.org>
References: <87eegtzbch.wl-maz@kernel.org>
 <20210305185254.3730990-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com, andre.przywara@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, Howard.Zhang@arm.com, justin.he@arm.com, mark.rutland@arm.com, qperret@google.com, shameerali.kolothum.thodi@huawei.com, suzuki.poulose@arm.com, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, kernel-team@android.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

Commit 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest
context") tracks the currently running vCPU, clearing the pointer to
NULL on exit from a guest.

Unfortunately, the use of 'set_loaded_vcpu' clobbers x1 to point at the
kvm_hyp_ctxt instead of the vCPU context, causing the subsequent RAS
code to go off into the weeds when it saves the DISR assuming that the
CPU context is embedded in a struct vCPU.

Leave x1 alone and use x3 as a temporary register instead when clearing
the vCPU on the guest exit path.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Andrew Scull <ascull@google.com>
Cc: <stable@vger.kernel.org>
Fixes: 7db21530479f ("KVM: arm64: Restore hyp when panicking in guest context")
Suggested-by: Quentin Perret <qperret@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210226181211.14542-1-will@kernel.org
---
 arch/arm64/kvm/hyp/entry.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index b0afad7a99c6..0c66a1d408fd 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -146,7 +146,7 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// Now restore the hyp regs
 	restore_callee_saved_regs x2
 
-	set_loaded_vcpu xzr, x1, x2
+	set_loaded_vcpu xzr, x2, x3
 
 alternative_if ARM64_HAS_RAS_EXTN
 	// If we have the RAS extensions we can consume a pending error
-- 
2.29.2

