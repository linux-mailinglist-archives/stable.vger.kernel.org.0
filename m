Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C576537CEBD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238971AbhELRGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242530AbhELQuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76AF361E8F;
        Wed, 12 May 2021 16:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836192;
        bh=zVo2qWTUfNmChk0Lfx8n9Al/jsit1Inq1Mfk6wA8Nw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMw3E4lZ/RpMdxqXwGInaUWIQTdSUVSG4f8oKcJXho8/ieVR8qpEHTjVyRgHM6Ki4
         P4yGn0lfCcBXoKGOtYhtKdnRO+VHG5ER/nZoGtfaj48BlTeFXLOSLyycmtXEdQLfV1
         k5TzUWAbsDtDvXt9/zxRL4HOmm/lJbWYnvdnyik8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 648/677] KVM: SVM: Disable SEV/SEV-ES if NPT is disabled
Date:   Wed, 12 May 2021 16:51:34 +0200
Message-Id: <20210512144858.891777378@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
 arch/x86/kvm/svm/svm.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d5620361eae7..309725151313 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -968,21 +968,6 @@ static __init int svm_hardware_setup(void)
 		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
 	}
 
-	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev) {
-		sev_hardware_setup();
-	} else {
-		sev = false;
-		sev_es = false;
-	}
-
-	svm_adjust_mmio_mask();
-
-	for_each_possible_cpu(cpu) {
-		r = svm_cpu_init(cpu);
-		if (r)
-			goto err;
-	}
-
 	/*
 	 * KVM's MMU doesn't support using 2-level paging for itself, and thus
 	 * NPT isn't supported if the host is using 2-level paging since host
@@ -997,6 +982,21 @@ static __init int svm_hardware_setup(void)
 	kvm_configure_mmu(npt_enabled, get_max_npt_level(), PG_LEVEL_1G);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
+	if (IS_ENABLED(CONFIG_KVM_AMD_SEV) && sev && npt_enabled) {
+		sev_hardware_setup();
+	} else {
+		sev = false;
+		sev_es = false;
+	}
+
+	svm_adjust_mmio_mask();
+
+	for_each_possible_cpu(cpu) {
+		r = svm_cpu_init(cpu);
+		if (r)
+			goto err;
+	}
+
 	if (nrips) {
 		if (!boot_cpu_has(X86_FEATURE_NRIPS))
 			nrips = false;
-- 
2.30.2



