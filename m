Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115D92062D
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 13:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbfEPLsE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 07:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfEPLj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 07:39:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7970320862;
        Thu, 16 May 2019 11:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006798;
        bh=CF5+kLRFNxDfWRKm3e7Wn+rgcDaHbU6jyhlCwi/ZtrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whVd+GPSv+oRmFk9phUWD1DSKTWXK+KEbZ5uLiHobr3sZzXtZ0EheIjJnT3JmTxMw
         iUyHpwLv2lpNqJ7Nb72dBr16EJGPWLtoqehizCqBAx4CI9+nKA1xW3Y9N+XNvuM3W9
         549e5BexC8S6mDrgP47J1yJz4dWkAQTCZ8O+/wbM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>, kvmarm@lists.cs.columbia.edu
Subject: [PATCH AUTOSEL 5.0 20/34] KVM: arm/arm64: Ensure vcpu target is unset on reset failure
Date:   Thu, 16 May 2019 07:39:17 -0400
Message-Id: <20190516113932.8348-20-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516113932.8348-1-sashal@kernel.org>
References: <20190516113932.8348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

[ Upstream commit 811328fc3222f7b55846de0cd0404339e2e1e6d7 ]

A failed KVM_ARM_VCPU_INIT should not set the vcpu target,
as the vcpu target is used by kvm_vcpu_initialized() to
determine if other vcpu ioctls may proceed. We need to set
the target before calling kvm_reset_vcpu(), but if that call
fails, we should then unset it and clear the feature bitmap
while we're at it.

Signed-off-by: Andrew Jones <drjones@redhat.com>
[maz: Simplified patch, completed commit message]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/arm/arm.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 9c486fad3f9f8..6202b4f718cea 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -949,7 +949,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 			       const struct kvm_vcpu_init *init)
 {
-	unsigned int i;
+	unsigned int i, ret;
 	int phys_target = kvm_target_cpu();
 
 	if (init->target != phys_target)
@@ -984,9 +984,14 @@ static int kvm_vcpu_set_target(struct kvm_vcpu *vcpu,
 	vcpu->arch.target = phys_target;
 
 	/* Now we know what it is, we can reset it. */
-	return kvm_reset_vcpu(vcpu);
-}
+	ret = kvm_reset_vcpu(vcpu);
+	if (ret) {
+		vcpu->arch.target = -1;
+		bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
+	}
 
+	return ret;
+}
 
 static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 					 struct kvm_vcpu_init *init)
-- 
2.20.1

