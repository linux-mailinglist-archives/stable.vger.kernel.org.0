Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 441F61FE695
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbgFRBO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:14:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729306AbgFRBOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70B6221D7B;
        Thu, 18 Jun 2020 01:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442860;
        bh=4119TfJh7HOmQEmTcbn7FL6rRL/Yia1MnYpYqTvsjbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+sgS5CZBC137IMf7BZfUXsoqLcBQX8N6OBBbrhIO5WX+iaf2yDU3lrp+QE+5fRL5
         ZSsZhszA/F0ObWRgMAEDKMTl3thOxqMe3Pp03l7zswhs0hJQUNj+0XZKpHkLVLwB7B
         UlcXZv4J1SvE3WlZ+LhdzDeFZPQuF/6pA/v76Vns=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Dufour <ldufour@linux.ibm.com>, Greg Kurz <groug@kaod.org>,
        Ram Pai <linuxram@us.ibm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.7 289/388] KVM: PPC: Book3S HV: Relax check on H_SVM_INIT_ABORT
Date:   Wed, 17 Jun 2020 21:06:26 -0400
Message-Id: <20200618010805.600873-289-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

[ Upstream commit e3326ae3d59e443a379367c6936941d6ab55d316 ]

The commit 8c47b6ff29e3 ("KVM: PPC: Book3S HV: Check caller of H_SVM_*
Hcalls") added checks of secure bit of SRR1 to filter out the Hcall
reserved to the Ultravisor.

However, the Hcall H_SVM_INIT_ABORT is made by the Ultravisor passing the
context of the VM calling UV_ESM. This allows the Hypervisor to return to
the guest without going through the Ultravisor. Thus the Secure bit of SRR1
is not set in that particular case.

In the case a regular VM is calling H_SVM_INIT_ABORT, this hcall will be
filtered out in kvmppc_h_svm_init_abort() because kvm->arch.secure_guest is
not set in that case.

Fixes: 8c47b6ff29e3 ("KVM: PPC: Book3S HV: Check caller of H_SVM_* Hcalls")
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Ram Pai <linuxram@us.ibm.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 93493f0cbfe8..ee581cde4878 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1099,9 +1099,14 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 			ret = kvmppc_h_svm_init_done(vcpu->kvm);
 		break;
 	case H_SVM_INIT_ABORT:
-		ret = H_UNSUPPORTED;
-		if (kvmppc_get_srr1(vcpu) & MSR_S)
-			ret = kvmppc_h_svm_init_abort(vcpu->kvm);
+		/*
+		 * Even if that call is made by the Ultravisor, the SSR1 value
+		 * is the guest context one, with the secure bit clear as it has
+		 * not yet been secured. So we can't check it here.
+		 * Instead the kvm->arch.secure_guest flag is checked inside
+		 * kvmppc_h_svm_init_abort().
+		 */
+		ret = kvmppc_h_svm_init_abort(vcpu->kvm);
 		break;
 
 	default:
-- 
2.25.1

