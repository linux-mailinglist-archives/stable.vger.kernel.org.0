Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A90A48CE1D
	for <lists+stable@lfdr.de>; Wed, 12 Jan 2022 22:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiALV6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jan 2022 16:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbiALV6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jan 2022 16:58:06 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14F0C061748
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 13:58:05 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id n23-20020a17090a161700b001b3ea76b406so5631210pja.5
        for <stable@vger.kernel.org>; Wed, 12 Jan 2022 13:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VNRgzKinTZ6Id+a/e4H0nautSZpkIYv7hjrYs1XfT64=;
        b=mCqSVfcDyeteoVV0hlUcHnpifst39OqtdAuktf3D6EtMyNZiwLDMxU9mT8MZy+vp8u
         gfocjpGj3SIySqlC26aRuFqB1aB9xsC/X4dFndFeu6Bmk+Ts4qb/lvuB1TSzrkv72bID
         I/ppmcSIQK/eWBMll9pQkdTc13s8udqVln1hMaCNmXMtzKDI5iBWf28xzNrFhwMBvN0L
         wRfgxu/ed7toeE4OdO1odD0A4MbjuQQWQQUkEfUWEJkUEjhgobS8ZhpMus7yjwBeRPHk
         rQKdWMS6+KTUW+46q65lVPiFuujmgwYO2bT319YX4J2a3MnKDKXpsxAoPemfdKnoNsDE
         eKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VNRgzKinTZ6Id+a/e4H0nautSZpkIYv7hjrYs1XfT64=;
        b=v0qjaWxoeRY4qLgjBtDf8EbzB0e3SjQZmqLIdwAO4I4JT7JykdF3WU5FmnHf4gXJeZ
         4Qy3RJTyxKZjxj583HXOvhprxtGCoxQRUNvOoQIthjWGyFfMuBbewVlGk5kkfjb0xs1V
         EZo67nr49s48P9+Isam46t2jsOM44SxCZkErVb9Y8lnn9zvK3i3t1yZMC0X4O1tywUbd
         NaXhwwWRI8+PYFErlkX3ct6mJvXneSud2iWap/rBtCSQ0oIt7AdLjIWhz4Tm+f0R55po
         WprIX3ItgHpFO3d9ij/vdQZ8uIbsKv9Z6CoMqIu0uvqwWw37vAHfOXJK4BgqgYKGeqk/
         4N5w==
X-Gm-Message-State: AOAM533Iwhv1TamJI5ol0n7cwaw0E48sHmjFRkKr3HI/PcFO43ZDQu5s
        hxJzNlEWlZDyl0SpAEFP++Jp/ZOfgd7JUw==
X-Google-Smtp-Source: ABdhPJzszeGG0MKA9TcF8xXuazz86qUaOAZiONh0ibhkrIi9jecp+DR9GL/w7D79WatOv+rG6V1/eRKJnHiKJQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:9284:: with SMTP id
 n4mr1744837pjo.109.1642024685255; Wed, 12 Jan 2022 13:58:05 -0800 (PST)
Date:   Wed, 12 Jan 2022 21:58:00 +0000
In-Reply-To: <20220112215801.3502286-1-dmatlack@google.com>
Message-Id: <20220112215801.3502286-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20220112215801.3502286-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH 1/2] KVM: x86/mmu: Fix write-protection of PTs mapped by the
 TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the TDP MMU is write-protection GFNs for page table protection (as
opposed to for dirty logging, or due to the HVA not being writable), it
checks if the SPTE is already write-protected and if so skips modifying
the SPTE and the TLB flush.

This behavior is incorrect because the SPTE may be write-protected for
dirty logging. This implies that the SPTE could be locklessly be made
writable on the next write access, and that vCPUs could still be running
with writable SPTEs cached in their TLB.

Fix this by unconditionally setting the SPTE and only skipping the TLB
flush if the SPTE was already marked !MMU-writable or !Host-writable,
which guarantees the SPTE cannot be locklessly be made writable and no
vCPUs are running the writable SPTEs cached in their TLBs.

Technically it would be safe to skip setting the SPTE as well since:

  (a) If MMU-writable is set then Host-writable must be cleared
      and the only way to set Host-writable is to fault the SPTE
      back in entirely (at which point any unsynced shadow pages
      reachable by the new SPTE will be synced and MMU-writable can
      be safetly be set again).

  and

  (b) MMU-writable is never consulted on its own.

And in fact this is what the shadow MMU does when write-protecting guest
page tables. However setting the SPTE unconditionally is much easier to
reason about and does not require a huge comment explaining why it is safe.

Fixes: 46044f72c382 ("kvm: x86/mmu: Support write protection for nesting in tdp MMU")
Cc: stable@vger.kernel.org
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7b1bc816b7c3..462c6de9f944 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1423,14 +1423,16 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 /*
  * Removes write access on the last level SPTE mapping this GFN and unsets the
  * MMU-writable bit to ensure future writes continue to be intercepted.
- * Returns true if an SPTE was set and a TLB flush is needed.
+ *
+ * Returns true if a TLB flush is needed to ensure no CPU has a writable
+ * version of the SPTE in its TLB.
  */
 static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 			      gfn_t gfn, int min_level)
 {
 	struct tdp_iter iter;
 	u64 new_spte;
-	bool spte_set = false;
+	bool flush = false;
 
 	BUG_ON(min_level > KVM_MAX_HUGEPAGE_LEVEL);
 
@@ -1442,19 +1444,30 @@ static bool write_protect_gfn(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		if (!is_writable_pte(iter.old_spte))
-			break;
-
 		new_spte = iter.old_spte &
 			~(PT_WRITABLE_MASK | shadow_mmu_writable_mask);
 
 		tdp_mmu_set_spte(kvm, &iter, new_spte);
-		spte_set = true;
+
+		/*
+		 * The TLB flush can be skipped if the old SPTE cannot be
+		 * locklessly be made writable, which implies it is already
+		 * write-protected due to being !MMU-writable or !Host-writable.
+		 * This guarantees no CPU currently has a writable version of
+		 * this SPTE in its TLB.
+		 *
+		 * Otherwise the old SPTE was either not write-protected or was
+		 * write-protected but for dirty logging (which does not flush
+		 * TLBs before dropping the MMU lock), so a TLB flush is
+		 * required.
+		 */
+		if (spte_can_locklessly_be_made_writable(iter.old_spte))
+			flush = true;
 	}
 
 	rcu_read_unlock();
 
-	return spte_set;
+	return flush;
 }
 
 /*

base-commit: fea31d1690945e6dd6c3e89ec5591490857bc3d4
-- 
2.34.1.703.g22d0c6ccf7-goog

