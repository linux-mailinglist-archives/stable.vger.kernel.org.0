Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0685737C7D2
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbhELQCk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:02:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237823AbhELP40 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5343A61C1F;
        Wed, 12 May 2021 15:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833313;
        bh=NwwKEXoPlv+sAELIGDJSvIB9gGK5FXp1H0JLpLvCksg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FT9Wcm6ffe045E+hCUTyieEPOjYqa/T23oB1P7pNiMrwLk5K1dirYB0LEuGGnAC+z
         Re7+nzUHmENVATgdndRRj1e+IUFo9J4vsWi4EhzxBm6Q3glt3IJ0waFSuUdIMNQEcY
         M7Kslv2+4r1Y+OsXxAD4tjJeHE8rJ/oa0O5Syc8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.11 099/601] KVM: nSVM: Set the shadow root level to the TDP level for nested NPT
Date:   Wed, 12 May 2021 16:42:56 +0200
Message-Id: <20210512144831.094006360@linuxfoundation.org>
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

commit a3322d5cd87fef5ec0037fd1b14068a533f9a60f upstream.

Override the shadow root level in the MMU context when configuring
NPT for shadowing nested NPT.  The level is always tied to the TDP level
of the host, not whatever level the guest happens to be using.

Fixes: 096586fda522 ("KVM: nSVM: Correctly set the shadow NPT root level in its MMU role")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4630,12 +4630,17 @@ void kvm_init_shadow_npt_mmu(struct kvm_
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	union kvm_mmu_role new_role = kvm_calc_shadow_npt_root_page_role(vcpu);
 
-	context->shadow_root_level = new_role.base.level;
-
 	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base, false, false);
 
-	if (new_role.as_u64 != context->mmu_role.as_u64)
+	if (new_role.as_u64 != context->mmu_role.as_u64) {
 		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
+
+		/*
+		 * Override the level set by the common init helper, nested TDP
+		 * always uses the host's TDP configuration.
+		 */
+		context->shadow_root_level = new_role.base.level;
+	}
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 


