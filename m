Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6A7357402
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 20:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhDGSNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 14:13:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:60366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229672AbhDGSNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 14:13:24 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A6B061139;
        Wed,  7 Apr 2021 18:13:14 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1lUCfw-0068VQ-0A; Wed, 07 Apr 2021 19:13:12 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Fully zero the vcpu state on reset
Date:   Wed,  7 Apr 2021 19:13:08 +0100
Message-Id: <20210407181308.2265808-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On vcpu reset, we expect all the registers to be brought back
to their initial state, which happens to be a bunch of zeroes.

However, some recent commit broke this, and is now leaving a bunch
of registers (such as a FP state) with whatever was left by the
guest. My bad.

Just zero the whole vcpu context on reset. It is more than we
strictly need, but at least we won't miss anything. This also
zeroes the __hyp_running_vcpu pointer, which is always NULL
for a vcpu anyway.

Cc: stable@vger.kernel.org
Fixes: e47c2055c68e ("KVM: arm64: Make struct kvm_regs userspace-only")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/reset.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index bd354cd45d28..ef1c49a1a3ad 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -240,8 +240,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		break;
 	}
 
-	/* Reset core registers */
-	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
+	/* Zero all registers */
+	memset(&vcpu->arch.ctxt, 0, sizeof(vcpu->arch.ctxt));
 	vcpu_gp_regs(vcpu)->pstate = pstate;
 
 	/* Reset system registers */
-- 
2.30.2

