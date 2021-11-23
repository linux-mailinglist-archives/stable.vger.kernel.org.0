Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FCC45A875
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:38:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhKWQl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:41:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239185AbhKWQks (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74B5D60FD7;
        Tue, 23 Nov 2021 16:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685459;
        bh=w3cT2oslgU+kwGW3oLI24vq8edURSGT6hX1m6elGhAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfAy9L5oVvTm8JQGTmTqJ6J31Ub+ywd/NOaIXP48DRCpVYohokdWreaet+hYwWOj8
         VCgrtCxLJwNnuUu/jfiosgA9F3CnIE9GmKFG6DDZh7oerrd+h7VeEYlmoLYFJeUCrz
         nYn1bZiDRHI6pdO1Z5VApQf/X4PliInqTWsNIdf8VZFSMvbxuxH7iBegFD9qJ9OUQm
         5loyjIlsz5WuAGOwWTReXKwS8AcfdE/ZidP7Z0mmta3jLSWx2oK12nOllnx8m3SkYr
         S8y737d4+r49jrgea/+UuxW7KomRGj32sE4Hu4yVRavEqcyLv3uy27LQy5CU8hZn5r
         s7hkzKslwNcVQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        paulus@ozlabs.org, christophe.leroy@csgroup.eu,
        farosas@linux.ibm.com, bharata@linux.ibm.com, jgross@suse.com,
        clg@kaod.org, ravi.bangoria@linux.ibm.com, npiggin@gmail.com,
        ndesaulniers@google.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH MANUALSEL 4.9 2/2] KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date:   Tue, 23 Nov 2021 11:37:33 -0500
Message-Id: <20211123163733.289925-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211123163733.289925-1-sashal@kernel.org>
References: <20211123163733.289925-1-sashal@kernel.org>
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
index fc0df0f6fe881..596c7612bbbff 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -582,9 +582,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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

