Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0429411D9D
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbfEBPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728533AbfEBPb7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:31:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7466920C01;
        Thu,  2 May 2019 15:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811118;
        bh=Dv/lA4+6p+s0BaejKtvMlqfyZszd/eHGZ6o5sxIBGao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bTYzcGbxuyFSXW7E+uj6Me7hlI8SHQTN1jUhmIRH+ll5U3E99obfPRSDH4uMXH7ng
         6Dkx73icelymCwA5sfFFBvaxyBwm5s0LjwRgNi9ky8H0Nw+sa3wgJWcO1DZfDQTH4X
         HYlPJNr6oqn446+wEuSrRV/U2A/0+ZCCu7urL1S8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 082/101] KVM: nVMX: Do not inherit quadrant and invalid for the root shadow EPT
Date:   Thu,  2 May 2019 17:21:24 +0200
Message-Id: <20190502143345.354225167@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 552c69b1dc714854a5f4e27d37a43c6d797adf7d ]

Explicitly zero out quadrant and invalid instead of inheriting them from
the root_mmu.  Functionally, this patch is a nop as we (should) never
set quadrant for a direct mapped (EPT) root_mmu and nested EPT is only
allowed if EPT is used for L1, and the root_mmu will never be invalid at
this point.

Explicitly setting flags sets the stage for repurposing the legacy
paging bits in role, e.g. nxe, cr0_wp, and sm{a,e}p_andnot_wp, at which
point 'smm' would be the only flag to be inherited from root_mmu.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 arch/x86/kvm/mmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9ab33cab9486..acab95dcffb6 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4915,11 +4915,15 @@ static union kvm_mmu_role
 kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 				   bool execonly)
 {
-	union kvm_mmu_role role;
+	union kvm_mmu_role role = {0};
+	union kvm_mmu_page_role root_base = vcpu->arch.root_mmu.mmu_role.base;
 
-	/* Base role is inherited from root_mmu */
-	role.base.word = vcpu->arch.root_mmu.mmu_role.base.word;
-	role.ext = kvm_calc_mmu_role_ext(vcpu);
+	/* Legacy paging and SMM flags are inherited from root_mmu */
+	role.base.smm = root_base.smm;
+	role.base.nxe = root_base.nxe;
+	role.base.cr0_wp = root_base.cr0_wp;
+	role.base.smep_andnot_wp = root_base.smep_andnot_wp;
+	role.base.smap_andnot_wp = root_base.smap_andnot_wp;
 
 	role.base.level = PT64_ROOT_4LEVEL;
 	role.base.direct = false;
@@ -4927,6 +4931,7 @@ kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
 	role.base.guest_mode = true;
 	role.base.access = ACC_ALL;
 
+	role.ext = kvm_calc_mmu_role_ext(vcpu);
 	role.ext.execonly = execonly;
 
 	return role;
-- 
2.19.1



