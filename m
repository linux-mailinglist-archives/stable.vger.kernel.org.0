Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B42337CA94
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241819AbhELQay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240796AbhELQZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:25:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D071361CA8;
        Wed, 12 May 2021 15:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834508;
        bh=+e+9fGb0i1UGO5xQP05niRXF8z6Ux1OdOf8kpsudtWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FydfX2zFFC+wXK4mWKlUA0Gfa/K4lCy4pHngmcHVhrGTAPuBboXm2+c3FSWf+5s8c
         7ei32lQVPA1/3NBNgHa/PLtcyI/W03OVloBJmpv53YBqb7ngpxQnL9GggPwWFLryrN
         Hfvu9INRZJUyjYNiqrFirBPL6fyqDzUZljPr+B5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 573/601] KVM: SVM: Disable SEV/SEV-ES if NPT is disabled
Date:   Wed, 12 May 2021 16:50:50 +0200
Message-Id: <20210512144846.717365824@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit fa13680f5668cff05302a2f4753c49334a83a064 ]

Disable SEV and SEV-ES if NPT is disabled.  While the APM doesn't clearly
state that NPT is mandatory, it's alluded to by:

  The guest page tables, managed by the guest, may mark data memory pages
  as either private or shared, thus allowing selected pages to be shared
  outside the guest.

And practically speaking, shadow paging can't work since KVM can't read
the guest's page tables.

Fixes: e9df09428996 ("KVM: SVM: Add sev module_param")
Cc: Brijesh Singh <brijesh.singh@amd.com
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422021125.3417167-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/svm.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 99592e03658b..15a69500819d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -980,7 +980,16 @@ static __init int svm_hardware_setup(void)
 		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
 	}
 
-	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
+	if (!boot_cpu_has(X86_FEATURE_NPT))
+		npt_enabled = false;
+
+	if (npt_enabled && !npt)
+		npt_enabled = false;
+
+	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
+	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
+
+	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev && npt_enabled) {
 		sev_hardware_setup();
 	} else {
 		sev = false;
@@ -995,15 +1004,6 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
-	if (!boot_cpu_has(X86_FEATURE_NPT))
-		npt_enabled = false;
-
-	if (npt_enabled && !npt)
-		npt_enabled = false;
-
-	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
-	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
-
 	if (nrips) {
 		if (!boot_cpu_has(X86_FEATURE_NRIPS))
 			nrips = false;
-- 
2.30.2



