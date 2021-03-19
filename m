Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A63341C80
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhCSMVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230464AbhCSMUo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B168164F65;
        Fri, 19 Mar 2021 12:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156444;
        bh=+4RG9UnQOAnxH+YGmJ+fg5x6tRkTfu7mIz+I7CiuxjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4461rsRO24QEGJDIzbFj/pjZw/i+1jHTcA/DqsLwtS2F4NbWris5zGd7IckAY7uU
         VBse4ZrWHOr831TTKw/QUdPn+FC78yBg3MIFd8Ulf/MKSHSbv77VNN2a+/g0XDzRD+
         xlZvTyrNV4dh2YSkusVJ1cWpasLYVqIAJUeAnRss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 03/31] KVM: x86/mmu: Set SPTE_AD_WRPROT_ONLY_MASK if and only if PML is enabled
Date:   Fri, 19 Mar 2021 13:18:57 +0100
Message-Id: <20210319121747.319793770@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121747.203523570@linuxfoundation.org>
References: <20210319121747.203523570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 44ac5958a6c1fd91ac8810fbb37194e377d78db5 ]

Check that PML is actually enabled before setting the mask to force a
SPTE to be write-protected.  The bits used for the !AD_ENABLED case are
in the upper half of the SPTE.  With 64-bit paging and EPT, these bits
are ignored, but with 32-bit PAE paging they are reserved.  Setting them
for L2 SPTEs without checking PML breaks NPT on 32-bit KVM.

Fixes: 1f4e5fc83a42 ("KVM: x86: fix nested guest live migration with PML")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210225204749.1512652-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu_internal.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 8404145fb179..cf101b73a360 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -76,15 +76,15 @@ static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
 static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * When using the EPT page-modification log, the GPAs in the log
-	 * would come from L2 rather than L1.  Therefore, we need to rely
-	 * on write protection to record dirty pages.  This also bypasses
-	 * PML, since writes now result in a vmexit.  Note, this helper will
-	 * tag SPTEs as needing write-protection even if PML is disabled or
-	 * unsupported, but that's ok because the tag is consumed if and only
-	 * if PML is enabled.  Omit the PML check to save a few uops.
+	 * When using the EPT page-modification log, the GPAs in the CPU dirty
+	 * log would come from L2 rather than L1.  Therefore, we need to rely
+	 * on write protection to record dirty pages, which bypasses PML, since
+	 * writes now result in a vmexit.  Note, the check on CPU dirty logging
+	 * being enabled is mandatory as the bits used to denote WP-only SPTEs
+	 * are reserved for NPT w/ PAE (32-bit KVM).
 	 */
-	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
+	return vcpu->arch.mmu == &vcpu->arch.guest_mmu &&
+	       kvm_x86_ops.cpu_dirty_log_size;
 }
 
 bool is_nx_huge_page_enabled(void);
-- 
2.30.1



