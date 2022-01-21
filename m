Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10748496537
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 19:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382176AbiAUSmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 13:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiAUSmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 13:42:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4DCC06173B;
        Fri, 21 Jan 2022 10:42:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2DBC61B45;
        Fri, 21 Jan 2022 18:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF6DC340E1;
        Fri, 21 Jan 2022 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642790533;
        bh=pv2iyFT30rSVyRx5jMpbmdKHGSOmPxgdCT2YMK+DUmI=;
        h=From:To:Cc:Subject:Date:From;
        b=WV+AG3c8LTiS9L3CfICfHwyoWm5gJQ8lPR5Xy4BuJu1gOGlqbAm8/VL1ukbVeegU6
         +UXYzYO89F2Qx8qF6Vg+kRuGrYJnkLtXk1K9ErMcziB3pPNBKIJhNOLoB0ZKjlbedh
         pd3wn0qr4VxY/NVmJQe2bX/Iu0YdDNCmkIRCzyPpx1qigGufn+VwIroNCLgUg2Vxk/
         ZNpuwyAdA3a9K/qT7MKR4WbydzB5lJHIZRsfoDHS5kucJuo3msbV7f6iD4nBS5h0TT
         dwqutm/kuVsyDCtWbSbu/M9czAumNlrYzkGA2pCrAatjcV84KgLCFwq7oYxGlAR62A
         J80lKBQVVIhpQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nAyrS-001ySz-Li; Fri, 21 Jan 2022 18:42:10 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Fuad Tabba <tabba@google.com>, kernel-team@android.com,
        stable@vger.kernel.org
Subject: [PATCH] KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions on !VHE
Date:   Fri, 21 Jan 2022 18:42:07 +0000
Message-Id: <20220121184207.423426-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, will@kernel.org, qperret@google.com, tabba@google.com, kernel-team@android.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Injecting an exception into a guest with non-VHE is risky business.
Instead of writing in the shadow register for the switch code to
restore it, we override the CPU register instead. Which gets
overriden a few instructions later by said restore code.

The result is that although the guest correctly gets the exception,
it will return to the original context in some random state,
depending on what was there the first place... Boo.

Fix the issue by writing to the shadow register. The original code
is absolutely fine on VHE, as the state is already loaded, and writing
to the shadow register in that case would actually be a bug.

Fixes: bb666c472ca2 ("KVM: arm64: Inject AArch64 exceptions from HYP")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/exception.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 0418399e0a20..c5d009715402 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -38,7 +38,10 @@ static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 
 static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
 {
-	write_sysreg_el1(val, SYS_SPSR);
+	if (has_vhe())
+		write_sysreg_el1(val, SYS_SPSR);
+	else
+		__vcpu_sys_reg(vcpu, SPSR_EL1) = val;
 }
 
 static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
-- 
2.34.1

