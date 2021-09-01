Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DA43FD9AC
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 14:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244251AbhIAM20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:28:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244252AbhIAM2R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:28:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25BF76101B;
        Wed,  1 Sep 2021 12:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499240;
        bh=SBS0IT6RXhbnkmS5TylIa8QyPTtZyHJOArYJsNiJFuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BfPutSueH7lD769TCnNJ25G8K8UWkPDM/CqsNNzxZMJ/hPpVZUrYc82LgIHL+hSCx
         VssfnAvobtKwskPbTF5NfBc6KEyF5Ol1lSrRMcEHjl5BNbm6FyOik0U5UxOlpZppAm
         ZwrndfsOuiLhnd2oNUBWf+YKWCh5ygaGtQPzBno0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 15/16] KVM: x86/mmu: Treat NX as used (not reserved) for all !TDP shadow MMUs
Date:   Wed,  1 Sep 2021 14:26:41 +0200
Message-Id: <20210901122249.394226550@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122248.920548099@linuxfoundation.org>
References: <20210901122248.920548099@linuxfoundation.org>
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
@@ -3927,7 +3927,16 @@ static void reset_rsvds_bits_mask_ept(st
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
 
 	/*
 	 * Passing "true" to the last argument is okay; it adds a check


