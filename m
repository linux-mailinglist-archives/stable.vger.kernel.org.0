Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E5845A877
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239335AbhKWQlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:41:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239410AbhKWQkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 886F960FD9;
        Tue, 23 Nov 2021 16:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685465;
        bh=x12KwXeaswcwwB/jKfFK1MB0NKmwL9y5uBux9iiPvlc=;
        h=From:To:Cc:Subject:Date:From;
        b=FtA9WJ/QsqrLB5rqp+I3pC2o6Ii1HD0w7j+dLmLX9b5ZG/MdEb0chUfgBoXj5CrWh
         Z6Z9qYTiVqvO7nPyksNt6PJ0uh+gKLj8BsmlTnJUDvXt6WkpKLSnBB41a9PxldY1wq
         8Vx24HnirMkR05cRiiMaKSZTwI6Eg7rfnHxzTfMDRN3O+KPMFE+vcqjOzM7Kdq/vsq
         oWQQwi0lQ6CcQ1yPKPvXwoxM0lID6o/UbDds9B6yYopZl1Qw9A0P3ksOwjLfAoyhMP
         FiE9bHi3Y0dr1OlcVgEJUMP6fDpqOJLD9k74Xyy5c4Skn2nUwbz/OmSiY9xE9ZpabC
         OZS3I+nfczzOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        paulus@ozlabs.org, david@gibson.dropbear.id.au,
        bharata@linux.ibm.com, clg@kaod.org, farosas@linux.ibm.com,
        jgross@suse.com, ndesaulniers@google.com,
        ravi.bangoria@linux.ibm.com, christophe.leroy@csgroup.eu,
        npiggin@gmail.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH MANUALSEL 4.4] KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date:   Tue, 23 Nov 2021 11:37:40 -0500
Message-Id: <20211123163742.290040-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
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
index a3b182dcb8236..823ca801b0507 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -555,9 +555,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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

