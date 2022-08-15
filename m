Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB05594AAF
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353237AbiHPAFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353426AbiHPAAY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:00:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB81895E58;
        Mon, 15 Aug 2022 13:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7EBA3B80EA8;
        Mon, 15 Aug 2022 20:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F67C433C1;
        Mon, 15 Aug 2022 20:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594890;
        bh=tmN+OwBTur08O8YyLpkAa7THQZ7tuRTsh9l8f/j7+RM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgTQvjSb2bBuZ2DGeLuwEk+LGA/e8N/T0LAKNdQYZbBPIIUbcSNOW1nRxeHjE6fWl
         NK9QayqFruUqGYeHcqRf/dwG/8e+eNM80xZNdcvzHUeCQ3poY8sLh1KRKFZYxupouQ
         b5R6PCzbnVGfh0UU1hPUYVcpqIAwvp+X7CuoViTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0592/1157] KVM: x86/mmu: Drop RWX=0 SPTEs during ept_sync_page()
Date:   Mon, 15 Aug 2022 19:59:08 +0200
Message-Id: <20220815180503.341253668@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index db80f7ccaa4e..1576e65b3b1f 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1053,7 +1053,14 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
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
index ba1be0159095..186fa97d4375 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -143,6 +143,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	bool wrprot = false;
 
+	WARN_ON_ONCE(!pte_access && !shadow_present_mask);
+
 	if (sp->role.ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED_MASK;
 	else if (kvm_mmu_page_ad_need_write_protect(sp))
-- 
2.35.1



