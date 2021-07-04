Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B46B3BB0A5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhGDXJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231183AbhGDXIa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9312C613E5;
        Sun,  4 Jul 2021 23:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439953;
        bh=k4A9U8XSbpXM50WX2bk9eqfV52wvOpVIiCKt8c8gujg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cl1I3TZ+YCF35Hj97tff50OR/Mk/k0GPy7geJPMbSRSbDkhSz27sXrsjKV+KIHIjn
         XWf1455SC5Wy16O395mmQfArVKQ6y3kd5WIrhPgCHa1+zml2pMtIVvhXpQoKrKSpYK
         J4MZgZBLBjWaOlTvOhf/XliSYkmtjgpH7jRoHNz7FAWaDzl8N+ekkhi7LAy2ypArtT
         0wIcQG3qvs9Hsbj8Q7UVBLH4z9QBgVQE2r4gnr0XvHbo+XNE7LdKO+82bGKOcvZv8Q
         Nh8osPu9xEWL/9IBf3lbcFCSryeMBxYgL8GQ15DnTAuwhTZmCok/JMrk5KBkCVAPbF
         84xu36m3Nejfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Jinank Jain <jinankj@amazon.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.13 68/85] KVM: arm64: Restore PMU configuration on first run
Date:   Sun,  4 Jul 2021 19:04:03 -0400
Message-Id: <20210704230420.1488358-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit d0c94c49792cf780cbfefe29f81bb8c3b73bc76b ]

Restoring a guest with an active virtual PMU results in no perf
counters being instanciated on the host side. Not quite what
you'd expect from a restore.

In order to fix this, force a writeback of PMCR_EL0 on the first
run of a vcpu (using a new request so that it happens once the
vcpu has been loaded). This will in turn create all the host-side
counters that were missing.

Reported-by: Jinank Jain <jinankj@amazon.de>
Tested-by: Jinank Jain <jinankj@amazon.de>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/87wnrbylxv.wl-maz@kernel.org
Link: https://lore.kernel.org/r/b53dfcf9bbc4db7f96154b1cd5188d72b9766358.camel@amazon.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 4 ++++
 arch/arm64/kvm/pmu-emul.c         | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cd7d5c8c4bc..6336b4309114 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -46,6 +46,7 @@
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
+#define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e720148232a0..facf4d41d32a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -689,6 +689,10 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			vgic_v4_load(vcpu);
 			preempt_enable();
 		}
+
+		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
+			kvm_pmu_handle_pmcr(vcpu,
+					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 	}
 }
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index fd167d4f4215..a0bbb7111f57 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -850,6 +850,9 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		   return -EINVAL;
 	}
 
+	/* One-off reload of the PMU on first run */
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
 	return 0;
 }
 
-- 
2.30.2

