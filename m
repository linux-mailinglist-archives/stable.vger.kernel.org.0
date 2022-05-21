Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF9452FD0B
	for <lists+stable@lfdr.de>; Sat, 21 May 2022 15:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbiEUN7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 May 2022 09:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239278AbiEUN7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 May 2022 09:59:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324F73EF1B
        for <stable@vger.kernel.org>; Sat, 21 May 2022 06:59:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E567EB803F3
        for <stable@vger.kernel.org>; Sat, 21 May 2022 13:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197B8C385A5;
        Sat, 21 May 2022 13:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653141546;
        bh=V2iRV8RCalZ4v6h6LLUokGqI+ISwzhCrgut9YEBsR/s=;
        h=Subject:To:Cc:From:Date:From;
        b=ykU+xahkDEj7xfuMY0Rpwohu4j6MBxxBpJDH47+ve9Crawr6Lv3Cg5HNiJRupV8Q9
         Tk2tEPQAiMBM+VOK9DJLxAzso6JGmAP7/CredwqpuJamRksGOdLqJkHALe6BDYgVJ3
         RxIE3vwtBqP2wHdxHVv8HD9f0e/+vViWYk3cEhvQ=
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID" failed to apply to 5.10-stable tree
To:     pbonzini@redhat.com, kangel@zju.edu.cn
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 21 May 2022 15:58:58 +0200
Message-ID: <165314153878227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

From 9f46c187e2e680ecd9de7983e4d081c3391acc76 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 20 May 2022 13:48:11 -0400
Subject: [PATCH] KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID

With shadow paging enabled, the INVPCID instruction results in a call
to kvm_mmu_invpcid_gva.  If INVPCID is executed with CR0.PG=0, the
invlpg callback is not set and the result is a NULL pointer dereference.
Fix it trivially by checking for mmu->invlpg before every call.

There are other possibilities:

- check for CR0.PG, because KVM (like all Intel processors after P5)
  flushes guest TLB on CR0.PG changes so that INVPCID/INVLPG are a
  nop with paging disabled

- check for EFER.LMA, because KVM syncs and flushes when switching
  MMU contexts outside of 64-bit mode

All of these are tricky, go for the simple solution.  This is CVE-2022-1789.

Reported-by: Yongkang Jia <kangel@zju.edu.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 56ebc4fb7f91..45e1573f8f1d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5470,14 +5470,16 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 	uint i;
 
 	if (pcid == kvm_get_active_pcid(vcpu)) {
-		mmu->invlpg(vcpu, gva, mmu->root.hpa);
+		if (mmu->invlpg)
+			mmu->invlpg(vcpu, gva, mmu->root.hpa);
 		tlb_flush = true;
 	}
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
 		if (VALID_PAGE(mmu->prev_roots[i].hpa) &&
 		    pcid == kvm_get_pcid(vcpu, mmu->prev_roots[i].pgd)) {
-			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
+			if (mmu->invlpg)
+				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
 			tlb_flush = true;
 		}
 	}

