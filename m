Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EFF45A82D
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238907AbhKWQj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:39:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236460AbhKWQjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:39:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D137460F90;
        Tue, 23 Nov 2021 16:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685406;
        bh=IWxmDelPs4YPNvZmtOG1vhIrWVbFQf3oIx3Nqu6GuXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/EckTg233z04ojddeSp3epUda7ke6Wr9eobscXu2UvDKzpOr7HvM7Otmnam4uOqx
         oJ3k/K0UAGbhS1hqtEWMGpOdxHENgG/edKx79beoLHBynv1Jf3VqHFHbxUYCHO/Ny0
         N6lg4o7ezJe6m8LGyoipRkO4dS6ojMy+2vPFCi6QeiCA7AECTQO9skJf7YfKsnxH2E
         GlHQMecZfId/OYrbMpaGgRCd+PVdxhsDQUwvq0vSnxxqp4+iwkdVta7ewdhL1S7Pxe
         NVDDyhJPPZlSkK/8gg6wfR6QZbgcngkRm2FRDh4SVZxj5JG4L1rT8W+l5M5AtmTRVN
         UVAwlh67zqgVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        paulus@ozlabs.org, jgross@suse.com, bharata@linux.ibm.com,
        ravi.bangoria@linux.ibm.com, clg@kaod.org, npiggin@gmail.com,
        ndesaulniers@google.com, christophe.leroy@csgroup.eu,
        farosas@linux.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH MANUALSEL 5.15 6/8] KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date:   Tue, 23 Nov 2021 11:36:28 -0500
Message-Id: <20211123163630.289306-6-sashal@kernel.org>
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
index b4e6f70b97b94..8334563a46236 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -641,9 +641,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
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

