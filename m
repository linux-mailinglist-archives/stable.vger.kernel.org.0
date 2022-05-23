Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B27531B0B
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241162AbiEWRcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241422AbiEWR0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD5F737BA;
        Mon, 23 May 2022 10:21:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FB3461175;
        Mon, 23 May 2022 17:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE1FC385A9;
        Mon, 23 May 2022 17:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326419;
        bh=PStYNHifrHb/iPNvuKCDmvAMKGKOKHMZKdb3MQjoiAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DF/GsC+sPClTQnaB+yqUckTlJpQfEesUMflToZyp1pHi+kip1yfa8ahUMpwtPwKZg
         P3pRQJC8wJWZtsvuPl4+YIkFSg1tBZG1M7DgGjKxYfeWmUbSr7yZUqy1L+oLsNjxa5
         fivWye/OVCJ6vCvxWEgfcH8OPmWEoe2ALCdtNph0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 052/132] KVM: x86/mmu: Update number of zapped pages even if page list is stable
Date:   Mon, 23 May 2022 19:04:21 +0200
Message-Id: <20220523165831.865928845@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit b28cb0cd2c5e80a8c0feb408a0e4b0dbb6d132c5 upstream.

When zapping obsolete pages, update the running count of zapped pages
regardless of whether or not the list has become unstable due to zapping
a shadow page with its own child shadow pages.  If the VM is backed by
mostly 4kb pages, KVM can zap an absurd number of SPTEs without bumping
the batch count and thus without yielding.  In the worst case scenario,
this can cause a soft lokcup.

 watchdog: BUG: soft lockup - CPU#12 stuck for 22s! [dirty_log_perf_:13020]
   RIP: 0010:workingset_activation+0x19/0x130
   mark_page_accessed+0x266/0x2e0
   kvm_set_pfn_accessed+0x31/0x40
   mmu_spte_clear_track_bits+0x136/0x1c0
   drop_spte+0x1a/0xc0
   mmu_page_zap_pte+0xef/0x120
   __kvm_mmu_prepare_zap_page+0x205/0x5e0
   kvm_mmu_zap_all_fast+0xd7/0x190
   kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
   kvm_page_track_flush_slot+0x5c/0x80
   kvm_arch_flush_shadow_memslot+0xe/0x10
   kvm_set_memslot+0x1a8/0x5d0
   __kvm_set_memory_region+0x337/0x590
   kvm_vm_ioctl+0xb08/0x1040

Fixes: fbb158cb88b6 ("KVM: x86/mmu: Revert "Revert "KVM: MMU: zap pages in batch""")
Reported-by: David Matlack <dmatlack@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220511145122.3133334-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu/mmu.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5590,6 +5590,7 @@ static void kvm_zap_obsolete_pages(struc
 {
 	struct kvm_mmu_page *sp, *node;
 	int nr_zapped, batch = 0;
+	bool unstable;
 
 restart:
 	list_for_each_entry_safe_reverse(sp, node,
@@ -5621,11 +5622,12 @@ restart:
 			goto restart;
 		}
 
-		if (__kvm_mmu_prepare_zap_page(kvm, sp,
-				&kvm->arch.zapped_obsolete_pages, &nr_zapped)) {
-			batch += nr_zapped;
+		unstable = __kvm_mmu_prepare_zap_page(kvm, sp,
+				&kvm->arch.zapped_obsolete_pages, &nr_zapped);
+		batch += nr_zapped;
+
+		if (unstable)
 			goto restart;
-		}
 	}
 
 	/*


