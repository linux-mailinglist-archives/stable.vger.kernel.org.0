Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E3A45A845
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239107AbhKWQkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:40:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:45448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239086AbhKWQkM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 925F560F90;
        Tue, 23 Nov 2021 16:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685422;
        bh=ph8ObFbS8FOqN0/4yg+iMdjHcoQg5c5WDq4v+jpLOoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Flo0GOrE6WQx5Vuq80BoHrdHWeNNgVfMRrcsSik9BLffxNINWA9xPBRczZrtS2XEn
         OdOIhPk+HLeOAz6vGAi1zJaVyM3oS3WiKILvWJiG4tRhaKEjDj6lWwviopuBOJKIeg
         9ttXuc4DJtYQVleoBWEV9jfHO1Mk4KTZGvhTLI6FBOfGKJG3lKsTq2p4CQEowMQCcN
         fLDj11o6TqxrjaFCPB1o9Q+w08UU3s+hg/x+m29OjpKolt7G4kYC3LLuj7wV2mlfMV
         vGyVeT2c20DjLJfIig3k0L7DmV0/SInFO7RmeYN0Vg2Eb8Todz+DBN7tDN940oNiTz
         vXF684/NWumuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, catalin.marinas@arm.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH MANUALSEL 5.10 5/5] KVM: arm64: Cap KVM_CAP_NR_VCPUS by kvm_arm_default_max_vcpus()
Date:   Tue, 23 Nov 2021 11:36:49 -0500
Message-Id: <20211123163652.289483-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163652.289483-1-sashal@kernel.org>
References: <20211123163652.289483-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit f60a00d7295057cb4baea5a321501efc72794453 ]

Generally, it doesn't make sense to return the recommended maximum number
of vCPUs which exceeds the maximum possible number of vCPUs.

Note: ARM64 is special as the value returned by KVM_CAP_MAX_VCPUS differs
depending on whether it is a system-wide ioctl or a per-VM one. Previously,
KVM_CAP_NR_VCPUS didn't have this difference and it seems preferable to
keep the status quo. Cap KVM_CAP_NR_VCPUS by kvm_arm_default_max_vcpus()
which is what gets returned by system-wide KVM_CAP_MAX_VCPUS.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211116163443.88707-2-vkuznets@redhat.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 5bc978be80434..7737a10ba735f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -204,7 +204,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = 1;
 		break;
 	case KVM_CAP_NR_VCPUS:
-		r = num_online_cpus();
+		/*
+		 * ARM64 treats KVM_CAP_NR_CPUS differently from all other
+		 * architectures, as it does not always bound it to
+		 * KVM_CAP_MAX_VCPUS. It should not matter much because
+		 * this is just an advisory value.
+		 */
+		r = min_t(unsigned int, num_online_cpus(),
+			  kvm_arm_default_max_vcpus());
 		break;
 	case KVM_CAP_MAX_VCPUS:
 	case KVM_CAP_MAX_VCPU_ID:
-- 
2.33.0

