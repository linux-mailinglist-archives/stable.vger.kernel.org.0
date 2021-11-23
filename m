Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BBD45A83F
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233089AbhKWQk1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:40:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:45348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237146AbhKWQkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Nov 2021 11:40:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 563A160F6E;
        Tue, 23 Nov 2021 16:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637685419;
        bh=0qoABYIWPz/i/2BXkoi4DDqKFFhFRhxnqrrJebmH65c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c04qlRVuZcye/IQAMovvRYlw8QVz23U58I8eSwpoAMcRxdOF4Gjz3EqIT5jgm3kx7
         7r5sUumuRDBr5H9qSXlrvkrreIcRHu5tTg+b5HgkLXp5mOrqmI0Lze/f38I83BQ35x
         oAQ8GW3Ywnl0KHS85dh4LbC13RqArlMF4y6P5FOu1yMwsY9dgWZ9mkFdMjGNHRxkED
         z1uWdCOd5ZaiouIepuWtU0QcbPKf+s3h96adzAozmAr1Sts21OoOfjKFDzqXpjh1iT
         H0f+I+AnWOUqeZqQXmK0PeBKfaSa0P7JcsBKUw1MZe0IDXFD2e20IeK35KE0HRvaqc
         K2sMnisaht+Pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        paulus@ozlabs.org, christophe.leroy@csgroup.eu, npiggin@gmail.com,
        farosas@linux.ibm.com, clg@kaod.org, bharata@linux.ibm.com,
        ravi.bangoria@linux.ibm.com, ndesaulniers@google.com,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH MANUALSEL 5.10 3/5] KVM: PPC: Cap KVM_CAP_NR_VCPUS by KVM_CAP_MAX_VCPUS
Date:   Tue, 23 Nov 2021 11:36:47 -0500
Message-Id: <20211123163652.289483-3-sashal@kernel.org>
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
index 543db9157f3b1..e0e8ec387970d 100644
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

