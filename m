Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD37A51F6F4
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 10:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbiEIIq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 04:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237036AbiEIIdG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 04:33:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0631ED5B1
        for <stable@vger.kernel.org>; Mon,  9 May 2022 01:29:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E674B80FEA
        for <stable@vger.kernel.org>; Mon,  9 May 2022 08:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87432C385AB;
        Mon,  9 May 2022 08:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652084934;
        bh=q6Gcr42XAHuNoyozcxTnlRKFtsPj1mtSCtpKjQXNgd4=;
        h=Subject:To:Cc:From:Date:From;
        b=R49rrivTDxc0fMhY6HC8Au+tOKSeEnnytlJbYiTh1z6CoaKOElBhASCIr70AvuGW7
         r4+JfITdVNa1T5S+2Tge6bNFN3gqRmmNTeyrjkiBqEvNedS/NmazrZrkLg0VzM+2iV
         wwngr+O+xbxwUQt5AJJAVLg8H7zvEuxzr7aJBpd4=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Move shadow-present check out of" failed to apply to 5.15-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 10:28:51 +0200
Message-ID: <1652084931146228@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 54eb3ef56f36827aad90915df33387d4c2b5df5a Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Sat, 23 Apr 2022 03:47:42 +0000
Subject: [PATCH] KVM: x86/mmu: Move shadow-present check out of
 spte_has_volatile_bits()

Move the is_shadow_present_pte() check out of spte_has_volatile_bits()
and into its callers.  Well, caller, since only one of its two callers
doesn't already do the shadow-present check.

Opportunistically move the helper to spte.c/h so that it can be used by
the TDP MMU, which is also the primary motivation for the shadow-present
change.  Unlike the legacy MMU, the TDP MMU uses a single path for clear
leaf and non-leaf SPTEs, and to avoid unnecessary atomic updates, the TDP
MMU will need to check is_last_spte() prior to calling
spte_has_volatile_bits(), and calling is_last_spte() without first
calling is_shadow_present_spte() is at best odd, and at worst a violation
of KVM's loosely defines SPTE rules.

Note, mmu_spte_clear_track_bits() could likely skip the write entirely
for SPTEs that are not shadow-present.  Leave that cleanup for a future
patch to avoid introducing a functional change, and because the
shadow-present check can likely be moved further up the stack, e.g.
drop_large_spte() appears to be the only path that doesn't already
explicitly check for a shadow-present SPTE.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220423034752.1161007-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 48dcb6a782f4..311e4e1d7870 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -473,32 +473,6 @@ static u64 __get_spte_lockless(u64 *sptep)
 }
 #endif
 
-static bool spte_has_volatile_bits(u64 spte)
-{
-	if (!is_shadow_present_pte(spte))
-		return false;
-
-	/*
-	 * Always atomically update spte if it can be updated
-	 * out of mmu-lock, it can ensure dirty bit is not lost,
-	 * also, it can help us to get a stable is_writable_pte()
-	 * to ensure tlb flush is not missed.
-	 */
-	if (!is_writable_pte(spte) && is_mmu_writable_spte(spte))
-		return true;
-
-	if (is_access_track_spte(spte))
-		return true;
-
-	if (spte_ad_enabled(spte)) {
-		if (!(spte & shadow_accessed_mask) ||
-		    (is_writable_pte(spte) && !(spte & shadow_dirty_mask)))
-			return true;
-	}
-
-	return false;
-}
-
 /* Rules for using mmu_spte_set:
  * Set the sptep from nonpresent to present.
  * Note: the sptep being assigned *must* be either not present
@@ -593,7 +567,8 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
 	u64 old_spte = *sptep;
 	int level = sptep_to_sp(sptep)->role.level;
 
-	if (!spte_has_volatile_bits(old_spte))
+	if (!is_shadow_present_pte(old_spte) ||
+	    !spte_has_volatile_bits(old_spte))
 		__update_clear_spte_fast(sptep, 0ull);
 	else
 		old_spte = __update_clear_spte_slow(sptep, 0ull);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4739b53c9734..e5c0b6db6f2c 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -90,6 +90,34 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
 }
 
+/*
+ * Returns true if the SPTE has bits that may be set without holding mmu_lock.
+ * The caller is responsible for checking if the SPTE is shadow-present, and
+ * for determining whether or not the caller cares about non-leaf SPTEs.
+ */
+bool spte_has_volatile_bits(u64 spte)
+{
+	/*
+	 * Always atomically update spte if it can be updated
+	 * out of mmu-lock, it can ensure dirty bit is not lost,
+	 * also, it can help us to get a stable is_writable_pte()
+	 * to ensure tlb flush is not missed.
+	 */
+	if (!is_writable_pte(spte) && is_mmu_writable_spte(spte))
+		return true;
+
+	if (is_access_track_spte(spte))
+		return true;
+
+	if (spte_ad_enabled(spte)) {
+		if (!(spte & shadow_accessed_mask) ||
+		    (is_writable_pte(spte) && !(spte & shadow_dirty_mask)))
+			return true;
+	}
+
+	return false;
+}
+
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index c571784cb567..80ab0f5cff01 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -404,6 +404,8 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
+bool spte_has_volatile_bits(u64 spte);
+
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,

