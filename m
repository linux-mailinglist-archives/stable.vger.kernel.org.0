Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF556511DA4
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240882AbiD0P61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 11:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240794AbiD0P6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 11:58:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766B0737B1;
        Wed, 27 Apr 2022 08:54:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DB8161B0E;
        Wed, 27 Apr 2022 15:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4F49C385B2;
        Wed, 27 Apr 2022 15:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074873;
        bh=1Uup5LJ6XP8bOQ07lFkq/Wf9IwYm+naacOCcADdNm1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0xez6qk5XnSMVyrBLbBhTRPRxRQsVGZSuK0nq+oGSlHLV1b01RmZXyP4+VkRrqHt
         L9W6LvDTCCsftZeb/etHOyTqePA/s1roSveCHYrbsdigdQkEuwHkNkAAE3VINFeeVb
         tlUo9dwI4GySjsNKHMQMtqgegfcreCg1I7Onsu4orFpH89clRBzn+PD0rgKlnj9CEw
         5Cb0VBOOOcjRb7MuCmvpIqltC+DkkJQnWdFKhUKV49tFkBJU+N5fYYhSaEwliSJUJY
         3pDSDV73MG/maNQ3Zdu0+qgJE9HOsjKxjWNR845OEQyC8N9VG/6HN2Qe0CO7FF/LH+
         YfHJHy/PfmJhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 4/7] KVM: x86/mmu: do not allow readers to acquire references to invalid roots
Date:   Wed, 27 Apr 2022 11:54:24 -0400
Message-Id: <20220427155431.19458-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427155431.19458-1-sashal@kernel.org>
References: <20220427155431.19458-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 614f6970aa70242a3f8a8051b01244c029f77b2a ]

Remove the "shared" argument of for_each_tdp_mmu_root_yield_safe, thus ensuring
that readers do not ever acquire a reference to an invalid root.  After this
patch, all readers except kvm_tdp_mmu_zap_invalidated_roots() treat
refcount=0/valid, refcount=0/invalid and refcount=1/invalid in exactly the
same way.  kvm_tdp_mmu_zap_invalidated_roots() is different but it also
does not acquire a reference to the invalid root, and it cannot see
refcount=0/invalid because it is guaranteed to run after
kvm_tdp_mmu_invalidate_all_roots().

Opportunistically add a lockdep assertion to the yield-safe iterator.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 853780eb033b..7e854313ec3b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -155,14 +155,15 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 	for (_root = tdp_mmu_next_root(_kvm, NULL, _shared, _only_valid);	\
 	     _root;								\
 	     _root = tdp_mmu_next_root(_kvm, _root, _shared, _only_valid))	\
-		if (kvm_mmu_page_as_id(_root) != _as_id) {			\
+		if (kvm_lockdep_assert_mmu_lock_held(_kvm, _shared) &&		\
+		    kvm_mmu_page_as_id(_root) != _as_id) {			\
 		} else
 
 #define for_each_valid_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)	\
 	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, true)
 
-#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared)		\
-	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, _shared, false)
+#define for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id)			\
+	__for_each_tdp_mmu_root_yield_safe(_kvm, _root, _as_id, false, false)
 
 #define for_each_tdp_mmu_root(_kvm, _root, _as_id)				\
 	list_for_each_entry_rcu(_root, &_kvm->arch.tdp_mmu_roots, link,		\
@@ -828,7 +829,7 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 {
 	struct kvm_mmu_page *root;
 
-	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id, false)
+	for_each_tdp_mmu_root_yield_safe(kvm, root, as_id)
 		flush = zap_gfn_range(kvm, root, start, end, can_yield, flush,
 				      false);
 
-- 
2.35.1

