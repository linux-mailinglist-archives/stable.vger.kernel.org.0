Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB1B1A5A99
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgDKXoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbgDKXGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:06:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70FA721D6C;
        Sat, 11 Apr 2020 23:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646363;
        bh=thnLnMquqfXBw2CaUvUTvh3sLjdeFfrsERODMyLxxqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1JWTgCAWYiXxzzBqVgtctHNraL87WpEBSMm0WcC6ZOCTSrnVhx4kqaGPl/KidNl7t
         cEdSbn1NQIHUB22NuAuqWLkcUHC4srJuyDzW3G7b9Tr4iAUc7zuA2bOZn71ofefU3K
         lD3G3cYbyYkpvpqjC/TqxzcVSUcIVSWJRd/TLVQQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Dufour <ldufour@linux.ibm.com>,
        Bharata B Rao <bharata@linux.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Ram Pai <linuxram@us.ibnm.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Sasha Levin <sashal@kernel.org>, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.6 108/149] KVM: PPC: Book3S HV: Check caller of H_SVM_* Hcalls
Date:   Sat, 11 Apr 2020 19:03:05 -0400
Message-Id: <20200411230347.22371-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230347.22371-1-sashal@kernel.org>
References: <20200411230347.22371-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Dufour <ldufour@linux.ibm.com>

[ Upstream commit 8c47b6ff29e3d88484fe59d02f9db6de7e44e310 ]

The Hcall named H_SVM_* are reserved to the Ultravisor. However, nothing
prevent a malicious VM or SVM to call them. This could lead to weird result
and should be filtered out.

Checking the Secure bit of the calling MSR ensure that the call is coming
from either the Ultravisor or a SVM. But any system call made from a SVM
are going through the Ultravisor, and the Ultravisor should filter out
these malicious call. This way, only the Ultravisor is able to make such a
Hcall.

Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Laurent Dufour <ldufour@linux.ibm.com>
Reviewed-by: Ram Pai <linuxram@us.ibnm.com>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/book3s_hv.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 2cefd071b8483..698701b4a10dc 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1074,25 +1074,35 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
 					 kvmppc_get_gpr(vcpu, 6));
 		break;
 	case H_SVM_PAGE_IN:
-		ret = kvmppc_h_svm_page_in(vcpu->kvm,
-					   kvmppc_get_gpr(vcpu, 4),
-					   kvmppc_get_gpr(vcpu, 5),
-					   kvmppc_get_gpr(vcpu, 6));
+		ret = H_UNSUPPORTED;
+		if (kvmppc_get_srr1(vcpu) & MSR_S)
+			ret = kvmppc_h_svm_page_in(vcpu->kvm,
+						   kvmppc_get_gpr(vcpu, 4),
+						   kvmppc_get_gpr(vcpu, 5),
+						   kvmppc_get_gpr(vcpu, 6));
 		break;
 	case H_SVM_PAGE_OUT:
-		ret = kvmppc_h_svm_page_out(vcpu->kvm,
-					    kvmppc_get_gpr(vcpu, 4),
-					    kvmppc_get_gpr(vcpu, 5),
-					    kvmppc_get_gpr(vcpu, 6));
+		ret = H_UNSUPPORTED;
+		if (kvmppc_get_srr1(vcpu) & MSR_S)
+			ret = kvmppc_h_svm_page_out(vcpu->kvm,
+						    kvmppc_get_gpr(vcpu, 4),
+						    kvmppc_get_gpr(vcpu, 5),
+						    kvmppc_get_gpr(vcpu, 6));
 		break;
 	case H_SVM_INIT_START:
-		ret = kvmppc_h_svm_init_start(vcpu->kvm);
+		ret = H_UNSUPPORTED;
+		if (kvmppc_get_srr1(vcpu) & MSR_S)
+			ret = kvmppc_h_svm_init_start(vcpu->kvm);
 		break;
 	case H_SVM_INIT_DONE:
-		ret = kvmppc_h_svm_init_done(vcpu->kvm);
+		ret = H_UNSUPPORTED;
+		if (kvmppc_get_srr1(vcpu) & MSR_S)
+			ret = kvmppc_h_svm_init_done(vcpu->kvm);
 		break;
 	case H_SVM_INIT_ABORT:
-		ret = kvmppc_h_svm_init_abort(vcpu->kvm);
+		ret = H_UNSUPPORTED;
+		if (kvmppc_get_srr1(vcpu) & MSR_S)
+			ret = kvmppc_h_svm_init_abort(vcpu->kvm);
 		break;
 
 	default:
-- 
2.20.1

