Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1A251F714
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 10:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237663AbiEIIqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 04:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbiEIIdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:33:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE901D572F
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:29:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACFEBB81065
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0341EC385AB;
        Mon,  9 May 2022 08:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652084919;
        bh=+5p6E+Cg7cuwEvORQj1R+7FVM0yo5qhIwcFfXpFYW54=;
        h=Subject:To:Cc:From:Date:From;
        b=AhNGDnTWdJO4IoyuVjJ9fvhpQCv23P0gQNbrmMYCp9yMMQF6ClwYao+sOeLpFHhO6
         Gxzqq2lnK/ObRljxUhUTTK+eZ33BYDHb7ozHhVL8ApHW01IY79w/orgE7NBgXiz5DL
         UQHke8yAPetgCd32WbytxVsaaDTYSkiuHulgCWVg=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Don't treat fully writable SPTEs as volatile" failed to apply to 4.19-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:28:25 +0200
Message-ID: <165208490542201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 706c9c55e5a32800605eb6a864ef6e1ca0c6c179 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Sat, 23 Apr 2022 03:47:41 +0000
Subject: [PATCH] KVM: x86/mmu: Don't treat fully writable SPTEs as volatile
 (modulo A/D)

Don't treat SPTEs that are truly writable, i.e. writable in hardware, as
being volatile (unless they're volatile for other reasons, e.g. A/D bits).
KVM _sets_ the WRITABLE bit out of mmu_lock, but never _clears_ the bit
out of mmu_lock, so if the WRITABLE bit is set, it cannot magically get
cleared just because the SPTE is MMU-writable.

Rename the wrapper of MMU-writable to be more literal, the previous name
of spte_can_locklessly_be_made_writable() is wrong and misleading.

Fixes: c7ba5b48cc8d ("KVM: MMU: fast path of handling guest page fault")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220423034752.1161007-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 64a2a7e2be90..48dcb6a782f4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -484,13 +484,15 @@ static bool spte_has_volatile_bits(u64 spte)
 	 * also, it can help us to get a stable is_writable_pte()
 	 * to ensure tlb flush is not missed.
 	 */
-	if (spte_can_locklessly_be_made_writable(spte) ||
-	    is_access_track_spte(spte))
+	if (!is_writable_pte(spte) && is_mmu_writable_spte(spte))
+		return true;
+
+	if (is_access_track_spte(spte))
 		return true;
 
 	if (spte_ad_enabled(spte)) {
-		if ((spte & shadow_accessed_mask) == 0 ||
-	    	    (is_writable_pte(spte) && (spte & shadow_dirty_mask) == 0))
+		if (!(spte & shadow_accessed_mask) ||
+		    (is_writable_pte(spte) && !(spte & shadow_dirty_mask)))
 			return true;
 	}
 
@@ -557,7 +559,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 	 * we always atomically update it, see the comments in
 	 * spte_has_volatile_bits().
 	 */
-	if (spte_can_locklessly_be_made_writable(old_spte) &&
+	if (is_mmu_writable_spte(old_spte) &&
 	      !is_writable_pte(new_spte))
 		flush = true;
 
@@ -1187,7 +1189,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	u64 spte = *sptep;
 
 	if (!is_writable_pte(spte) &&
-	      !(pt_protect && spte_can_locklessly_be_made_writable(spte)))
+	    !(pt_protect && is_mmu_writable_spte(spte)))
 		return false;
 
 	rmap_printk("spte %p %llx\n", sptep, *sptep);
@@ -3196,8 +3198,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * be removed in the fast path only if the SPTE was
 		 * write-protected for dirty-logging or access tracking.
 		 */
-		if (fault->write &&
-		    spte_can_locklessly_be_made_writable(spte)) {
+		if (fault->write && is_mmu_writable_spte(spte)) {
 			new_spte |= PT_WRITABLE_MASK;
 
 			/*
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index e4abeb5df1b1..c571784cb567 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -390,7 +390,7 @@ static inline void check_spte_writable_invariants(u64 spte)
 			  "kvm: Writable SPTE is not MMU-writable: %llx", spte);
 }
 
-static inline bool spte_can_locklessly_be_made_writable(u64 spte)
+static inline bool is_mmu_writable_spte(u64 spte)
 {
 	return spte & shadow_mmu_writable_mask;
 }

