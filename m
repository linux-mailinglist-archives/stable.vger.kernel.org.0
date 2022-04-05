Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139704F29E8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353744AbiDEKJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345347AbiDEJW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:22:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A0F47AE4;
        Tue,  5 Apr 2022 02:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DEF161527;
        Tue,  5 Apr 2022 09:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCE4C385A0;
        Tue,  5 Apr 2022 09:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149837;
        bh=FwQBUKInjP4jnvxbqXA+7tsKrzdHs2KgsX0dQYJAh1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uBZX53MTpIwJ0bqRbcnr43MgQHs8bygVwgjJXLIK5sSb89rzi/Zq7nZGYHYEMHhuH
         7k5B3Ol+msfWkOwW9LfjJA2F6GMp0xVVjrTwmt4nUYHi8edTYhw1egAuBv0737DFrE
         /knp4++mCbQqedZyC2Wz/jGiNwYRjydc96GePiEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 0859/1017] KVM: x86/mmu: Move "invalid" check out of kvm_tdp_mmu_get_root()
Date:   Tue,  5 Apr 2022 09:29:32 +0200
Message-Id: <20220405070419.732710256@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 04dc4e6ce274fa729feda32aa957b27388a3870c upstream.

Move the check for an invalid root out of kvm_tdp_mmu_get_root() and into
the one place it actually matters, tdp_mmu_next_root(), as the other user
already has an implicit validity check.  A future bug fix will need to
get references to invalid roots to honor mmu_notifier requests; there's
no point in forcing what will be a common path to open code getting a
reference to a root.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20211215011557.399940-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c |   12 ++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h |    3 ---
 2 files changed, 10 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -121,9 +121,14 @@ static struct kvm_mmu_page *tdp_mmu_next
 		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
 						   typeof(*next_root), link);
 
-	while (next_root && !kvm_tdp_mmu_get_root(kvm, next_root))
+	while (next_root) {
+		if (!next_root->role.invalid &&
+		    kvm_tdp_mmu_get_root(kvm, next_root))
+			break;
+
 		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
 				&next_root->link, typeof(*next_root), link);
+	}
 
 	rcu_read_unlock();
 
@@ -200,7 +205,10 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(stru
 
 	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
 
-	/* Check for an existing root before allocating a new one. */
+	/*
+	 * Check for an existing root before allocating a new one.  Note, the
+	 * role check prevents consuming an invalid root.
+	 */
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word &&
 		    kvm_tdp_mmu_get_root(kvm, root))
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,9 +10,6 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(stru
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
 						     struct kvm_mmu_page *root)
 {
-	if (root->role.invalid)
-		return false;
-
 	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
 


