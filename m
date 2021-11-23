Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554BF45A850
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbhKWQku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239203AbhKWQkY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DC5C60FED;
        Tue, 23 Nov 2021 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685433;
        bh=6aBlo+VhM0KSJfoc/Myfd85tLk8bLxLk2dZbVu1I/54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dpfxv55l9mvucxliXPfhjUcP/R9/XnbgIV7C5hV1qVyVC68bTZ40OFZYaYXLorBZ1
         UiSIxqcqii4fLH0MtSZqkLJVxms6pgYuoqp1A5hEzKya6Tbmu/tbzIYBiOZNwL71qe
         GUGQl1tAby7GCOpmHIuxbRGMWN8q0Hl+PgVNab0oXdKiWLiHNOuloZeJMbRrvwb1WR
         cEuSw187D3WT7iRNqQ4SMw0w+1CbkxPbIJxMQDY59SpnWPxgBWf2IKdUNXgQ2jq1JK
         UWOX7kZsYneFlsT24zeuV+0vYuQybQaseB1J53ibxSjub85kPypFvpvPt7H5iGeGNm
         fKhgUjAKeHYrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        paulus@ozlabs.org, farosas@linux.ibm.com, bharata@linux.ibm.com,
        jgross@suse.com, ndesaulniers@google.com, clg@kaod.org,
        christophe.leroy@csgroup.eu, ravi.bangoria@linux.ibm.com,
        npiggin@gmail.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH MANUALSEL 5.4 3/4] KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date:   Tue, 23 Nov 2021 11:37:02 -0500
Message-Id: <20211123163706.289562-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163706.289562-1-sashal@kernel.org>
References: <20211123163706.289562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit b7915d55b1ac0e68a7586697fa2d06c018135c49 ]

It doesn't make sense to return the recommended maximum number of
vCPUs which exceeds the maximum possible number of vCPUs.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20211116163443.88707-4-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/powerpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 8dd4d2b83677b..7465be2d9ae3f 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -635,9 +635,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 * implementations just count online CPUs.
 		 */
 		if (hv_enabled)
-			r = num_present_cpus();
+			r = min_t(unsigned int, num_present_cpus(), KVM_MAX_VCPUS);
 		else
-			r = num_online_cpus();
+			r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
-- 
2.33.0

