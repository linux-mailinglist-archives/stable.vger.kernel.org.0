Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DA745A833
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238999AbhKWQkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238246AbhKWQj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:39:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E04C60F5D;
        Tue, 23 Nov 2021 16:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685409;
        bh=plK5J/t7M/GlW86iF1TJCxPLnyKdb3OQjKr63ahMX9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gL+JfqMn4zmSYTLx2l+OXc+j6OKAqMORXivtQvMguOjH7gWVn7AklM7Sa3jVHaVxT
         Ju4PJp7tl280dwFY/Rpj5Ij4XImwQ+rOt7onZ6rUaiEsu2sqQ6gxTZIl+EkBqAwtAE
         RX/EFRUzIzdf29cldJIcYM7j9VBulAmH1RlAr1l0Mv0eov4JiOBD/EXdiJhb6B1B0S
         M3x7lEdmwsip5gXgKoJaWsut1KIuIaCRoX7xlgB71iL0jKw0QOxS2Vl6nntwXStLhc
         Mx9Axbg9USK/tBnuZkQSIKPOWO/rkG7GEpDoZk9fdlLp4SzF6mihaQgftQnI+Eg+JR
         AoFu+LNY6lX9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, catalin.marinas@arm.com,
        will@kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Subject: [PATCH MANUALSEL 5.15 8/8] KVM: arm64: Cap KVM_CAP_NR_VCPUS by kvm_arm_default_max_vcpus()
Date:   Tue, 23 Nov 2021 11:36:30 -0500
Message-Id: <20211123163630.289306-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163630.289306-1-sashal@kernel.org>
References: <20211123163630.289306-1-sashal@kernel.org>
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
index 9b328bb05596a..1ed82b6d5e8db 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -223,7 +223,14 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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

