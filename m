Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03A6594124
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345012AbiHOV2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348075AbiHOV0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:26:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62F6E97D6;
        Mon, 15 Aug 2022 12:22:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 582FD60EF0;
        Mon, 15 Aug 2022 19:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 413EDC433D7;
        Mon, 15 Aug 2022 19:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591371;
        bh=vMvWEIEo1oW/bGTWgeRjKxE+hvtQgXM/3X8UYsmh7Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAgeCeBfc0rTFFYrh5ZG0GtzzYtyU3eQio6a4/SAzHZCBJhFwAnRfr3E6Bao58MKE
         B/cUWaIFXizkwebHCKbecZVJdzYoSnZfu8i7QxXu5cTICLQ8KZdrxDyhqeR6fGYqIP
         UOGbUZ/cWICvFvb6J1ikdcdWNpmqCXyB7z4sgc4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0558/1095] KVM: x86/mmu: Drop RWX=0 SPTEs during ept_sync_page()
Date:   Mon, 15 Aug 2022 19:59:17 +0200
Message-Id: <20220815180452.641750171@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 9fb3565743d58352f00964bf47213b88aff4bb82 ]

All of sync_page()'s existing checks filter out only !PRESENT gPTE,
because without execute-only, all upper levels are guaranteed to be at
least READABLE.  However, if EPT with execute-only support is in use by
L1, KVM can create an SPTE that is shadow-present but guest-inaccessible
(RWX=0) if the upper level combined permissions are R (or RW) and
the leaf EPTE is changed from R (or RW) to X.  Because the EPTE is
considered present when viewed in isolation, and no reserved bits are set,
FNAME(prefetch_invalid_gpte) will consider the GPTE valid, and cause a
not-present SPTE to be created.

The SPTE is "correct": the guest translation is inaccessible because
the combined protections of all levels yield RWX=0, and KVM will just
redirect any vmexits to the guest.  If EPT A/D bits are disabled, KVM
can mistake the SPTE for an access-tracked SPTE, but again such confusion
isn't fatal, as the "saved" protections are also RWX=0.  However,
creating a useless SPTE in general means that KVM messed up something,
even if this particular goof didn't manifest as a functional bug.
So, drop SPTEs whose new protections will yield a RWX=0 SPTE, and
add a WARN in make_spte() to detect creation of SPTEs that will
result in RWX=0 protections.

Fixes: d95c55687e11 ("kvm: mmu: track read permission explicitly for shadow EPT page tables")
Cc: David Matlack <dmatlack@google.com>
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220513195000.99371-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 9 ++++++++-
 arch/x86/kvm/mmu/spte.c        | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index beb3ce8d94eb..43f6a882615f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1044,7 +1044,14 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
 			continue;
 
-		if (gfn != sp->gfns[i]) {
+		/*
+		 * Drop the SPTE if the new protections would result in a RWX=0
+		 * SPTE or if the gfn is changing.  The RWX=0 case only affects
+		 * EPT with execute-only support, i.e. EPT without an effective
+		 * "present" bit, as all other paging modes will create a
+		 * read-only SPTE if pte_access is zero.
+		 */
+		if ((!pte_access && !shadow_present_mask) || gfn != sp->gfns[i]) {
 			drop_spte(vcpu->kvm, &sp->spt[i]);
 			flush = true;
 			continue;
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index e5c0b6db6f2c..8223a80802e7 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -128,6 +128,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	bool wrprot = false;
 
+	WARN_ON_ONCE(!pte_access && !shadow_present_mask);
+
 	if (sp->role.ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED_MASK;
 	else if (kvm_mmu_page_ad_need_write_protect(sp))
-- 
2.35.1



