Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82A03FDA1A
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244288AbhIAMaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:30:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244468AbhIAM3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:29:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9242B6109E;
        Wed,  1 Sep 2021 12:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499320;
        bh=GxZ8YOeuQq8dvU+abvnKdwLfoOchbYJeeVD8qaiTVoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=plVVwJApCi09YwZZcFDlBTq5ZAIuzPKNvTUQomFaF9Wy5ZcrBxiEA42eXp45Kc/uV
         aEGXCx5ZXPAHyyIz7Brollns7mE7JtHdI6ZvcsXj6iyIO9O1yNFB9p1fW43OAKaN5Z
         FBKs3HIc0xY5b8mDbHRJh1/SLCfSCLWm4ssxSR24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 21/23] KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP shadow MMUs
Date:   Wed,  1 Sep 2021 14:27:06 +0200
Message-Id: <20210901122250.465576312@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122249.786673285@linuxfoundation.org>
References: <20210901122249.786673285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 112022bdb5bc372e00e6e43cb88ee38ea67b97bd upstream

Mark NX as being used for all non-nested shadow MMUs, as KVM will set the
NX bit for huge SPTEs if the iTLB mutli-hit mitigation is enabled.
Checking the mitigation itself is not sufficient as it can be toggled on
at any time and KVM doesn't reset MMU contexts when that happens.  KVM
could reset the contexts, but that would require purging all SPTEs in all
MMUs, for no real benefit.  And, KVM already forces EFER.NX=1 when TDP is
disabled (for WP=0, SMEP=1, NX=0), so technically NX is never reserved
for shadow MMUs.

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622175739.3610207-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[sudip: use old path and adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4326,7 +4326,16 @@ static void reset_rsvds_bits_mask_ept(st
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 {
-	bool uses_nx = context->nx || context->base_role.smep_andnot_wp;
+	/*
+	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
+	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
+	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
+	 * The iTLB multi-hit workaround can be toggled at any time, so assume
+	 * NX can be used by any non-nested shadow MMU to avoid having to reset
+	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
+	 */
+	bool uses_nx = context->nx || !tdp_enabled ||
+		context->base_role.smep_andnot_wp;
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
 


