Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A1A53CFBC
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244083AbiFCR4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346033AbiFCRzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:55:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989BB55497;
        Fri,  3 Jun 2022 10:53:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BDA4B823B0;
        Fri,  3 Jun 2022 17:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBCBC385A9;
        Fri,  3 Jun 2022 17:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278798;
        bh=lNOmLlFQuyuci5IwSKVo0uhTC3PXQ5cfKd6PwOA3j3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CyGjxtbKVM/PjMuPVVMytneSnuQCz7Kif70oBvbqTZHUTBo4dq/WaZD58Ybg2dyBi
         Peif68umGbveho6ydZJURm3JouDwV7Gf3swF/16bhMs4/yiOA4GxWSa8JBNxL0HFxK
         CQxDdG1wElUGiWMICc6DBC5eYRj2q+oysz4OMNsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tadeusz Struk <tadeusz.struk@linaro.org>,
        syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 31/75] KVM: x86: Use __try_cmpxchg_user() to update guest PTE A/D bits
Date:   Fri,  3 Jun 2022 19:43:15 +0200
Message-Id: <20220603173822.630027131@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sean Christopherson <seanjc@google.com>

commit f122dfe4476890d60b8c679128cd2259ec96a24c upstream.

Use the recently introduced __try_cmpxchg_user() to update guest PTE A/D
bits instead of mapping the PTE into kernel address space.  The VM_PFNMAP
path is broken as it assumes that vm_pgoff is the base pfn of the mapped
VMA range, which is conceptually wrong as vm_pgoff is the offset relative
to the file and has nothing to do with the pfn.  The horrific hack worked
for the original use case (backing guest memory with /dev/mem), but leads
to accessing "random" pfns for pretty much any other VM_PFNMAP case.

Fixes: bd53cb35a3e9 ("X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs")
Debugged-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Tested-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Reported-by: syzbot+6cde2282daa792c49ab8@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220202004945.2540433-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/paging_tmpl.h |   38 +-------------------------------------
 1 file changed, 1 insertion(+), 37 deletions(-)

--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -144,42 +144,6 @@ static bool FNAME(is_rsvd_bits_set)(stru
 	       FNAME(is_bad_mt_xwr)(&mmu->guest_rsvd_check, gpte);
 }
 
-static int FNAME(cmpxchg_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			       pt_element_t __user *ptep_user, unsigned index,
-			       pt_element_t orig_pte, pt_element_t new_pte)
-{
-	signed char r;
-
-	if (!user_access_begin(ptep_user, sizeof(pt_element_t)))
-		return -EFAULT;
-
-#ifdef CMPXCHG
-	asm volatile("1:" LOCK_PREFIX CMPXCHG " %[new], %[ptr]\n"
-		     "setnz %b[r]\n"
-		     "2:"
-		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %k[r])
-		     : [ptr] "+m" (*ptep_user),
-		       [old] "+a" (orig_pte),
-		       [r] "=q" (r)
-		     : [new] "r" (new_pte)
-		     : "memory");
-#else
-	asm volatile("1:" LOCK_PREFIX "cmpxchg8b %[ptr]\n"
-		     "setnz %b[r]\n"
-		     "2:"
-		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %k[r])
-		     : [ptr] "+m" (*ptep_user),
-		       [old] "+A" (orig_pte),
-		       [r] "=q" (r)
-		     : [new_lo] "b" ((u32)new_pte),
-		       [new_hi] "c" ((u32)(new_pte >> 32))
-		     : "memory");
-#endif
-
-	user_access_end();
-	return r;
-}
-
 static bool FNAME(prefetch_invalid_gpte)(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *sp, u64 *spte,
 				  u64 gpte)
@@ -278,7 +242,7 @@ static int FNAME(update_accessed_dirty_b
 		if (unlikely(!walker->pte_writable[level - 1]))
 			continue;
 
-		ret = FNAME(cmpxchg_gpte)(vcpu, mmu, ptep_user, index, orig_pte, pte);
+		ret = __try_cmpxchg_user(ptep_user, &orig_pte, pte, fault);
 		if (ret)
 			return ret;
 


