Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C883C4D8A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242533AbhGLHNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:13:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240572AbhGLHDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:03:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D83C261167;
        Mon, 12 Jul 2021 07:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073258;
        bh=n0UOv8XGqRxE8ABKttXEeMPtQWNfPtRpL6ZYJXVh0uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHCmhGf0+Qt379oCxNSU6JhPHRGtIaX9ATMgxdTmF8N/rcvJsO/WqJjBL662nbqWG
         G65GMbJhvtKBbo1to8wcbMws7kN3kSGrPmZtuujgVUDw8goc3IRcHcuMpnRt3eakm0
         /bqg+RBwzJuErbvbK1eUyZRbbExGtaXH1koRQOVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jinank Jain <jinankj@amazon.de>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 181/700] KVM: arm64: Restore PMU configuration on first run
Date:   Mon, 12 Jul 2021 08:04:24 +0200
Message-Id: <20210712060952.200534438@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



