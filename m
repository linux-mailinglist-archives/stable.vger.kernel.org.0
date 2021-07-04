Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CCE3BB147
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhGDXLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232414AbhGDXKS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BA5561416;
        Sun,  4 Jul 2021 23:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440062;
        bh=n0UOv8XGqRxE8ABKttXEeMPtQWNfPtRpL6ZYJXVh0uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aQHnYPSicyQc6W2yZkUGPX0VqnB/OuxQQKLmwH8neQmUYwY6+q5Ak/OxxPnsWN6Bg
         Lu2hbjpTz5D6smrXWtQu202NBQO6hdHmiuKVZ+lgdpfHCHPGMmgflSRpGFmCVSPKVk
         4uAbmCG0pCYgOobeAXJT39Yg9v2aFxUygrkT8qyuoUOx6HhhMMR4U0u7xc8/xLZrpE
         8lC7JFGv23WlDNc6FO5hd6vTanNQ6HrQzv2/Fino167jRHY9Eio6woH50PM+bT4N4o
         ZOFIN5R8Uo7dg/54tmKI+KgLC9QGWpYVeBAsiuc8MeFBuDgQHxm0+Ny+WMcbEN6rdJ
         nTr8R40+fnb7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Jinank Jain <jinankj@amazon.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.12 64/80] KVM: arm64: Restore PMU configuration on first run
Date:   Sun,  4 Jul 2021 19:06:00 -0400
Message-Id: <20210704230616.1489200-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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
index 858c2fcfc043..4e4356add46e 100644
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
index 7730b81aad6d..8455c5c30116 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -684,6 +684,10 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
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
index e32c6e139a09..e9699d10d2bd 100644
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

