Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0664F34E1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347574AbiDEJ1h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:27:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244147AbiDEIvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:51:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6C3D3AC0;
        Tue,  5 Apr 2022 01:40:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D605F614E5;
        Tue,  5 Apr 2022 08:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B60C385A1;
        Tue,  5 Apr 2022 08:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147977;
        bh=jdhV1ARZqjVBNBTFdsNBzGc69eetyP1wwgKMcVbjsh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyFVOjnENXWNE4FZBoHN7vpI0NYmN8hc3e8lhgYXABrZPZIWVisFC+CBNG10Hf0pg
         ZBiaZlgRue0gZeUtQt9HVjAnZ4hNgkpBDAO6/QuH/LclGBS/P/0c8k/33kYOZWjkLa
         i69WsvaZqOgPxxRVr8CuKmqvgtLqmcX62eFMJJck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.16 0183/1017] xtensa: define update_mmu_tlb function
Date:   Tue,  5 Apr 2022 09:18:16 +0200
Message-Id: <20220405070359.671343382@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

commit 1c4664faa38923330d478f046dc743a00c1e2dec upstream.

Before the commit f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault()
codepaths") there was a call to update_mmu_cache in alloc_set_pte that
used to invalidate TLB entry caching invalid PTE that caused a page
fault. That commit removed that call so now invalid TLB entry survives
causing repetitive page faults on the CPU that took the initial fault
until that TLB entry is occasionally evicted. This issue is spotted by
the xtensa TLB sanity checker.

Fix this issue by defining update_mmu_tlb function that flushes TLB entry
for the faulting address.

Cc: stable@vger.kernel.org # 5.12+
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/include/asm/pgtable.h |    4 ++++
 arch/xtensa/mm/tlb.c              |    6 ++++++
 2 files changed, 10 insertions(+)

--- a/arch/xtensa/include/asm/pgtable.h
+++ b/arch/xtensa/include/asm/pgtable.h
@@ -411,6 +411,10 @@ extern  void update_mmu_cache(struct vm_
 
 typedef pte_t *pte_addr_t;
 
+void update_mmu_tlb(struct vm_area_struct *vma,
+		    unsigned long address, pte_t *ptep);
+#define __HAVE_ARCH_UPDATE_MMU_TLB
+
 #endif /* !defined (__ASSEMBLY__) */
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
--- a/arch/xtensa/mm/tlb.c
+++ b/arch/xtensa/mm/tlb.c
@@ -162,6 +162,12 @@ void local_flush_tlb_kernel_range(unsign
 	}
 }
 
+void update_mmu_tlb(struct vm_area_struct *vma,
+		    unsigned long address, pte_t *ptep)
+{
+	local_flush_tlb_page(vma, address);
+}
+
 #ifdef CONFIG_DEBUG_TLB_SANITY
 
 static unsigned get_pte_for_vaddr(unsigned vaddr)


