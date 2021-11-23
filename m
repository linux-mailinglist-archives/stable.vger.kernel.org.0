Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2715E45A86B
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239271AbhKWQlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:41:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239086AbhKWQkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AB6460FBF;
        Tue, 23 Nov 2021 16:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685451;
        bh=dTY20x9C7ILrJLF2x3WFcgP0Fw/5b/QS5q+eMTnwQ/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUl2xQIHSLEE19HIJKYSrwwOLVA3JNA3U5diWaN16oMpj7OEMxop1W2oiO7NBD7hR
         3LMeqWHfzAf2xzpIlOyig2nvqO7Vr60tXWmGs2zEloBE/uM2CqDqzDhmqRkay1rc71
         Yab/VPIoFBvmDh5jFoQZDhdwZM9GD+55VGyI21ktDfbk7wlz1j4hoCvfxn7jAk6a+W
         BL3VjZab6iKX8IswYkRc+b7luxiNINqDFYcon1RtlB1cXsxCsOGw0vNK5x/wLHdAxe
         WlXYmTtOVTCU0VevPGpzW0UEE6YA/CUqu/IimwOASf4rMGjlKiH799XHgYiX15RXLh
         PmR0RHAj0uz6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        paulus@ozlabs.org, ravi.bangoria@linux.ibm.com,
        christophe.leroy@csgroup.eu, bharata@linux.ibm.com, clg@kaod.org,
        ndesaulniers@google.com, jgross@suse.com, npiggin@gmail.com,
        farosas@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH MANUALSEL 4.14 2/3] KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date:   Tue, 23 Nov 2021 11:37:23 -0500
Message-Id: <20211123163725.289694-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163725.289694-1-sashal@kernel.org>
References: <20211123163725.289694-1-sashal@kernel.org>
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
index af1f065dc9f37..d3832f1f17003 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -624,9 +624,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		 * implementations just count online CPUs.
 		 */
 		if (hv_enabled)
-			r = num_present_cpus();
+			r = min_t(unsigned int, num_present_cpus(), KVM_MAX_VCPUS);
 		else
-			r = num_online_cpus();
+			r = min_t(unsigned int, num_online_cpus(), KVM_MAX_VCPUS);
 		break;
 	case KVM_CAP_NR_MEMSLOTS:
 		r = KVM_USER_MEM_SLOTS;
-- 
2.33.0

