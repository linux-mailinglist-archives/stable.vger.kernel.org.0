Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43B7341C7D
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhCSMVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:21:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231273AbhCSMUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:20:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E7A26146D;
        Fri, 19 Mar 2021 12:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156441;
        bh=3ob6B08D6cc1vZiJslOsSrCpp0UcvZFIHaFBC6mw9IU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2aM4TEAuIz+dtZm5TjFYt8QTzfE0tTfYZq9jmLczH09Sr+3ipaqus1ZkOcGNnwRp0
         inMvZ+Gv2F3J8TFCNzaqcagKL9cUXtKZFx9w+8Kd4wOZh1Klsrdx8URCodraVnm5k8
         VrjW2FU+kDW56ddCnw38V1AiorMA9Hr05Ojj2xeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 02/31] KVM: x86/mmu: Expand on the comment in kvm_vcpu_ad_need_write_protect()
Date:   Fri, 19 Mar 2021 13:18:56 +0100
Message-Id: <20210319121747.290778628@linuxfoundation.org>
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

[ Upstream commit 2855f98265dc579bd2becb79ce0156d08e0df813 ]

Expand the comment about need to use write-protection for nested EPT
when PML is enabled to clarify that the tagging is a nop when PML is
_not_ enabled.  Without the clarification, omitting the PML check looks
wrong at first^Wfifth glance.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210213005015.1651772-8-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu_internal.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index bfc6389edc28..8404145fb179 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -79,7 +79,10 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	 * When using the EPT page-modification log, the GPAs in the log
 	 * would come from L2 rather than L1.  Therefore, we need to rely
 	 * on write protection to record dirty pages.  This also bypasses
-	 * PML, since writes now result in a vmexit.
+	 * PML, since writes now result in a vmexit.  Note, this helper will
+	 * tag SPTEs as needing write-protection even if PML is disabled or
+	 * unsupported, but that's ok because the tag is consumed if and only
+	 * if PML is enabled.  Omit the PML check to save a few uops.
 	 */
 	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
 }
-- 
2.30.1



