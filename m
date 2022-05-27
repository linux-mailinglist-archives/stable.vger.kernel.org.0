Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C302F535CAC
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 11:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350402AbiE0JBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 05:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350531AbiE0JAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 05:00:03 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AA2106566;
        Fri, 27 May 2022 01:56:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DE5C2CE23C9;
        Fri, 27 May 2022 08:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4357C385B8;
        Fri, 27 May 2022 08:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653641767;
        bh=2wSHEEurpZQC1OfwEv0aR4844pcEFDJ9Ix5fkH0x0Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cw8mwaa6Uw3nztn6usLdRkjkBJh7jiECjQo8p/vJKjIUX0+FdUZeLxsqJS5VnbFLA
         uUJ0bAwNGBvNoC5vhIGvyUFlkz3tJyQMYhXKkYspsylnOAAXOm/VaJJcbXe/Zp4Vbq
         IdNqFo99wZHLRY4CvoK3EBN6tdeGSFXDx9MhxWJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongkang Jia <kangel@zju.edu.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH 5.10 004/163] KVM: x86/mmu: fix NULL pointer dereference on guest INVPCID
Date:   Fri, 27 May 2022 10:48:04 +0200
Message-Id: <20220527084828.810813962@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 9f46c187e2e680ecd9de7983e4d081c3391acc76 upstream.

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
[fix conflict due to missing b9e5603c2a3accbadfec570ac501a54431a6bdba]
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5178,14 +5178,16 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu
 	uint i;
 
 	if (pcid == kvm_get_active_pcid(vcpu)) {
-		mmu->invlpg(vcpu, gva, mmu->root_hpa);
+		if (mmu->invlpg)
+			mmu->invlpg(vcpu, gva, mmu->root_hpa);
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


