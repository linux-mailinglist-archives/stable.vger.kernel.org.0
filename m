Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2798E53CBF5
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 17:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245313AbiFCPEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 11:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbiFCPEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 11:04:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF97064D0
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 08:04:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08D19CE2382
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 15:04:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0958C385B8;
        Fri,  3 Jun 2022 15:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654268642;
        bh=Y/E2gtHEj96xC59fC20MIXJa7B4FI2pyzGqE2ch2Wls=;
        h=Subject:To:Cc:From:Date:From;
        b=1FqLk+hvdu2sBp4CZk3lYs9ud12NJMRCIVEUm8m9VXDjUc9gQNfc1Y+ODW7ze+Wvo
         y7YQHVQkDUeNOXZqvQfNRVZvduGpHs2XjEHw9Chbd93jPLVwZpJDPx6at/gEaS3tSH
         /0Sjd++xsvdFNVDlT2VGU5ATRrL/ZMlcJyusbUmk=
Subject: FAILED: patch "[PATCH] KVM: x86: Use __try_cmpxchg_user() to update guest PTE A/D" failed to apply to 5.10-stable tree
To:     seanjc@google.com, pbonzini@redhat.com, tadeusz.struk@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 03 Jun 2022 17:03:51 +0200
Message-ID: <165426863118590@kroah.com>
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f122dfe4476890d60b8c679128cd2259ec96a24c Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 2 Feb 2022 00:49:43 +0000
Subject: [PATCH] KVM: x86: Use __try_cmpxchg_user() to update guest PTE A/D
 bits

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

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 1dad8f3f2bb0..7d4377f1ef2a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -144,42 +144,6 @@ static bool FNAME(is_rsvd_bits_set)(struct kvm_mmu *mmu, u64 gpte, int level)
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
@@ -278,7 +242,7 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
 		if (unlikely(!walker->pte_writable[level - 1]))
 			continue;
 
-		ret = FNAME(cmpxchg_gpte)(vcpu, mmu, ptep_user, index, orig_pte, pte);
+		ret = __try_cmpxchg_user(ptep_user, &orig_pte, pte, fault);
 		if (ret)
 			return ret;
 

