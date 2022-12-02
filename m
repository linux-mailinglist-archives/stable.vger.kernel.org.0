Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2286F63FE8A
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 04:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbiLBDMk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 22:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiLBDMk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 22:12:40 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CDF72BD6
        for <stable@vger.kernel.org>; Thu,  1 Dec 2022 19:12:36 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id f3so3343635pgc.2
        for <stable@vger.kernel.org>; Thu, 01 Dec 2022 19:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6gsWmPHkr8el1KNlBQqmlpzuhKO3cGSMvSxJ0VGQzxI=;
        b=V6b2NkaDqt+SLQQdwN5tQT/KUReDfH9HaKZT80YnWdouUkP4JQtx45p0QzSEJbTDF1
         mU/9zCZTanHao9c54YGGfisqjQXveXIIH3b/263ymxThrNTo+t9AvYrnT/ONvgq91szE
         4IE7m2vZHRb7WvQWi9GyA1dRKltZWF8mGkVUOCoGbx6/FNa8jLBPo25/VxV2yOq4qa6x
         xcZV4hQr1rUgphaY2NT6v0Kyxkq/kd+j9LodAf106NeY21uRZ0mrDU1wNsRdSsKuooKK
         Hf0W5U2rudE8tcvx9NEPq78IgW/PEkjAkWzH2ECPOf/H8tMcy6Pn+/KtsN4N9B/g8rFp
         YgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6gsWmPHkr8el1KNlBQqmlpzuhKO3cGSMvSxJ0VGQzxI=;
        b=2jzEBRK1A3Dm6Oi9CK9v/h/FndZAgbhlY+whRFClc/dnqWxqRQtIUCVeoPgw7XxGa9
         8DGDVwKOGuDoLmBOkwpc0nHmftjUVcQR38dn/hKIMpOkMp/CKZBgZfhwg9mTisBq9mXG
         1v+JuVNWaln0A5cZAgoXwyH1eA086gYy++jw1DmIn9N2jcx+FV0bD7bYPex0I61mfeTB
         ZTEe9CPH+iU6PGUoScu/D1oFOjRtzQOv6ZajlERpE63m+XWJ79lSrmq0SqBevm6PCqLj
         BYfA49am4IoTLWghU5ejpoBzmXMXrD3VjWRhLN5OfTdPjhOoF8pM+dVTgbfHAIKhgNdZ
         x3aw==
X-Gm-Message-State: ANoB5pkySriDBTTKSMUK57QHr1oClXqGViqG4DfRRy6I32gEAFMNMqIC
        krD0FQMkWe7knyw9g9ceiusZOIIHTfY=
X-Google-Smtp-Source: AA0mqf6U80NXEq4Vele2gDx61XMgwssWyqmmhCLW5KmNfg2SYbuFxE1fopgjII7JguukYbIHzDDm3Q==
X-Received: by 2002:a63:4246:0:b0:477:98cc:3d01 with SMTP id p67-20020a634246000000b0047798cc3d01mr40734205pga.505.1669950755199;
        Thu, 01 Dec 2022 19:12:35 -0800 (PST)
Received: from localhost (p122205-ipngn200703fukuokachu.fukuoka.ocn.ne.jp. [122.27.186.205])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090322c200b00188f8badbcdsm4401773plg.137.2022.12.01.19.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 19:12:34 -0800 (PST)
From:   Kazuki Takiguchi <takiguchi.kazuki171@gmail.com>
To:     stable@vger.kernel.org
Cc:     Kazuki Takiguchi <takiguchi.kazuki171@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15] KVM: x86/mmu: Fix race condition in direct_page_fault
Date:   Fri,  2 Dec 2022 12:08:46 +0900
Message-Id: <20221202030843.1777127-1-takiguchi.kazuki171@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 47b0c2e4c220f2251fd8dcfbb44479819c715e15 upstream.

make_mmu_pages_available() must be called with mmu_lock held for write.
However, if the TDP MMU is used, it will be called with mmu_lock held for
read.
This function does nothing unless shadow pages are used, so there is no
race unless nested TDP is used.
Since nested TDP uses shadow pages, old shadow pages may be zapped by this
function even when the TDP MMU is enabled.
Since shadow pages are never allocated by kvm_tdp_mmu_map(), a race
condition can be avoided by not calling make_mmu_pages_available() if the
TDP MMU is currently in use.

I encountered this when repeatedly starting and stopping nested VM.
It can be artificially caused by allocating a large number of nested TDP
SPTEs.

For example, the following BUG and general protection fault are caused in
the host kernel.

pte_list_remove: 00000000cd54fc10 many->many
------------[ cut here ]------------
kernel BUG at arch/x86/kvm/mmu/mmu.c:963!
invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:pte_list_remove.cold+0x16/0x48 [kvm]
Call Trace:
 <TASK>
 drop_spte+0xe0/0x180 [kvm]
 mmu_page_zap_pte+0x4f/0x140 [kvm]
 __kvm_mmu_prepare_zap_page+0x62/0x3e0 [kvm]
 kvm_mmu_zap_oldest_mmu_pages+0x7d/0xf0 [kvm]
 direct_page_fault+0x3cb/0x9b0 [kvm]
 kvm_tdp_page_fault+0x2c/0xa0 [kvm]
 kvm_mmu_page_fault+0x207/0x930 [kvm]
 npf_interception+0x47/0xb0 [kvm_amd]
 svm_invoke_exit_handler+0x13c/0x1a0 [kvm_amd]
 svm_handle_exit+0xfc/0x2c0 [kvm_amd]
 kvm_arch_vcpu_ioctl_run+0xa79/0x1780 [kvm]
 kvm_vcpu_ioctl+0x29b/0x6f0 [kvm]
 __x64_sys_ioctl+0x95/0xd0
 do_syscall_64+0x5c/0x90

general protection fault, probably for non-canonical address
0xdead000000000122: 0000 [#1] PREEMPT SMP NOPTI
RIP: 0010:kvm_mmu_commit_zap_page.part.0+0x4b/0xe0 [kvm]
Call Trace:
 <TASK>
 kvm_mmu_zap_oldest_mmu_pages+0xae/0xf0 [kvm]
 direct_page_fault+0x3cb/0x9b0 [kvm]
 kvm_tdp_page_fault+0x2c/0xa0 [kvm]
 kvm_mmu_page_fault+0x207/0x930 [kvm]
 npf_interception+0x47/0xb0 [kvm_amd]

CVE: CVE-2022-45869
Fixes: a2855afc7ee8 ("KVM: x86/mmu: Allow parallel page faults for the TDP MMU")
Signed-off-by: Kazuki Takiguchi <takiguchi.kazuki171@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ba1749a770eb..4724289c8a7f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2357,6 +2357,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
 {
 	bool list_unstable;
 
+	lockdep_assert_held_write(&kvm->mmu_lock);
 	trace_kvm_mmu_prepare_zap_page(sp);
 	++kvm->stat.mmu_shadow_zapped;
 	*nr_zapped = mmu_zap_unsync_children(kvm, sp, invalid_list);
@@ -4007,16 +4008,17 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	if (!is_noslot_pfn(pfn) && mmu_notifier_retry_hva(vcpu->kvm, mmu_seq, hva))
 		goto out_unlock;
-	r = make_mmu_pages_available(vcpu);
-	if (r)
-		goto out_unlock;
 
-	if (is_tdp_mmu_fault)
+	if (is_tdp_mmu_fault) {
 		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
 				    pfn, prefault);
-	else
+	} else {
+		r = make_mmu_pages_available(vcpu);
+		if (r)
+			goto out_unlock;
 		r = __direct_map(vcpu, gpa, error_code, map_writable, max_level, pfn,
 				 prefault, is_tdp);
+	}
 
 out_unlock:
 	if (is_tdp_mmu_fault)
-- 
2.34.1

