Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7E3412482
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352917AbhITSfj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380082AbhITSc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0874961425;
        Mon, 20 Sep 2021 17:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158869;
        bh=68THdfiFeOKS8g83uwolAWRGbPZ1OGzwp8L7fbCTySo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCYbdHKKzOCrYmVx+on0uKTpgVOoVGQZQL7IpOij9BKuhRHMlwQlvgquAKh7rt4XW
         u9e+eEuIwMeEaon+GK1q3ra5KEjrGn2wny8hWeDNzD7fiPSes8XXCTVkPBUgD4I6sh
         jiWYYbAMtX9BOB9swwghVhAm+6xt8b6J471V0CTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/122] KVM: arm64: Fix read-side race on updates to vcpu reset state
Date:   Mon, 20 Sep 2021 18:44:24 +0200
Message-Id: <20210920163918.802009584@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163915.757887582@linuxfoundation.org>
References: <20210920163915.757887582@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Upton <oupton@google.com>

[ Upstream commit 6654f9dfcb88fea3b9affc180dc3c04333d0f306 ]

KVM correctly serializes writes to a vCPU's reset state, however since
we do not take the KVM lock on the read side it is entirely possible to
read state from two different reset requests.

Cure the race for now by taking the KVM lock when reading the
reset_state structure.

Fixes: 358b28f09f0a ("arm/arm64: KVM: Allow a VCPU to fully reset itself")
Signed-off-by: Oliver Upton <oupton@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210818202133.1106786-2-oupton@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/reset.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 6058a80ec9ec..204c62debf06 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -263,10 +263,16 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
  */
 int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_reset_state reset_state;
 	int ret;
 	bool loaded;
 	u32 pstate;
 
+	mutex_lock(&vcpu->kvm->lock);
+	reset_state = vcpu->arch.reset_state;
+	WRITE_ONCE(vcpu->arch.reset_state.reset, false);
+	mutex_unlock(&vcpu->kvm->lock);
+
 	/* Reset PMU outside of the non-preemptible section */
 	kvm_pmu_vcpu_reset(vcpu);
 
@@ -325,8 +331,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	 * Additional reset state handling that PSCI may have imposed on us.
 	 * Must be done after all the sys_reg reset.
 	 */
-	if (vcpu->arch.reset_state.reset) {
-		unsigned long target_pc = vcpu->arch.reset_state.pc;
+	if (reset_state.reset) {
+		unsigned long target_pc = reset_state.pc;
 
 		/* Gracefully handle Thumb2 entry point */
 		if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
@@ -335,13 +341,11 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		}
 
 		/* Propagate caller endianness */
-		if (vcpu->arch.reset_state.be)
+		if (reset_state.be)
 			kvm_vcpu_set_be(vcpu);
 
 		*vcpu_pc(vcpu) = target_pc;
-		vcpu_set_reg(vcpu, 0, vcpu->arch.reset_state.r0);
-
-		vcpu->arch.reset_state.reset = false;
+		vcpu_set_reg(vcpu, 0, reset_state.r0);
 	}
 
 	/* Reset timer */
-- 
2.30.2



