Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB32811EFC
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfEBP0Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:26:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727694AbfEBP0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:26:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E39E721670;
        Thu,  2 May 2019 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810773;
        bh=g7pQ+qV9qjfPJPHbFyDA5wuEwJSJCE5Zp4tcHpf0DN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I1EheUvTVtRFft5XTvvk1JIpRTh+9wj7oSRdo+VkM5nB/K60/0rN/9DObMjkzrVb+
         rO5On9Tk5BMtgSHTOOokERY/lwkzw359/y+MCJmIOg+0o0JFpGnAVk7U6lm6AHdvU+
         mudnExxABkwgZb5i7Bi2R67fHigs7w0k3bjnmC0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Grall <julien.grall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 24/72] KVM: arm64: Reset the PMU in preemptible context
Date:   Thu,  2 May 2019 17:20:46 +0200
Message-Id: <20190502143335.312482735@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ebff0b0e3d3c862c16c487959db5e0d879632559 ]

We've become very cautious to now always reset the vcpu when nothing
is loaded on the physical CPU. To do so, we now disable preemption
and do a kvm_arch_vcpu_put() to make sure we have all the state
in memory (and that it won't be loaded behind out back).

This now causes issues with resetting the PMU, which calls into perf.
Perf itself uses mutexes, which clashes with the lack of preemption.
It is worth realizing that the PMU is fully emulated, and that
no PMU state is ever loaded on the physical CPU. This means we can
perfectly reset the PMU outside of the non-preemptible section.

Fixes: e761a927bc9a ("KVM: arm/arm64: Reset the VCPU without preemption and vcpu state loaded")
Reported-by: Julien Grall <julien.grall@arm.com>
Tested-by: Julien Grall <julien.grall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/arm64/kvm/reset.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 18b9a522a2b3..0688816f19e2 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -117,6 +117,9 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	int ret = -EINVAL;
 	bool loaded;
 
+	/* Reset PMU outside of the non-preemptible section */
+	kvm_pmu_vcpu_reset(vcpu);
+
 	preempt_disable();
 	loaded = (vcpu->cpu != -1);
 	if (loaded)
@@ -164,9 +167,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		vcpu->arch.reset_state.reset = false;
 	}
 
-	/* Reset PMU */
-	kvm_pmu_vcpu_reset(vcpu);
-
 	/* Default workaround setup is enabled (if supported) */
 	if (kvm_arm_have_ssbd() == KVM_SSBD_KERNEL)
 		vcpu->arch.workaround_flags |= VCPU_WORKAROUND_2_FLAG;
-- 
2.19.1



