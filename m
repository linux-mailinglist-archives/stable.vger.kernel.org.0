Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402336280A2
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbiKNNHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237850AbiKNNHh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:07:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3B82B25A
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:07:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 874CFB80EA5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E41C433D6;
        Mon, 14 Nov 2022 13:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431251;
        bh=0KeRaTa+fq4BAge2gyDK9j8Sf3oNLhKsKtAwZ5iRqKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nk0CExsvwmRhXyeEvRcyykZOjEEht272pB9KqIU3XmH6gkOPpLugZpkQIxj5TSm0k
         1xMmL3axK4CT9NTxQgmvXjrmcBlMQcQCUrGVZ4Ofcko81auYDy4K4wGn72LnembVkk
         Cae6cxWECIJvPF7xyMGMvkXx9b5Zkc/tVPEpu3Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Naoya Horiguchi <naoya.horiguchi@nec.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Liu Shixin <liushixin2@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Oscar Salvador <osalvador@suse.de>,
        Yang Shi <shy828301@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 156/190] arch/x86/mm/hugetlbpage.c: pud_huge() returns 0 when using 2-level paging
Date:   Mon, 14 Nov 2022 13:46:20 +0100
Message-Id: <20221114124505.638319398@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

commit 1fdbed657a4726639c4f17841fd2a0fb646c746e upstream.

The following bug is reported to be triggered when starting X on x86-32
system with i915:

  [  225.777375] kernel BUG at mm/memory.c:2664!
  [  225.777391] invalid opcode: 0000 [#1] PREEMPT SMP
  [  225.777405] CPU: 0 PID: 2402 Comm: Xorg Not tainted 6.1.0-rc3-bdg+ #86
  [  225.777415] Hardware name:  /8I865G775-G, BIOS F1 08/29/2006
  [  225.777421] EIP: __apply_to_page_range+0x24d/0x31c
  [  225.777437] Code: ff ff 8b 55 e8 8b 45 cc e8 0a 11 ec ff 89 d8 83 c4 28 5b 5e 5f 5d c3 81 7d e0 a0 ef 96 c1 74 ad 8b 45 d0 e8 2d 83 49 00 eb a3 <0f> 0b 25 00 f0 ff ff 81 eb 00 00 00 40 01 c3 8b 45 ec 8b 00 e8 76
  [  225.777446] EAX: 00000001 EBX: c53a3b58 ECX: b5c00000 EDX: c258aa00
  [  225.777454] ESI: b5c00000 EDI: b5900000 EBP: c4b0fdb4 ESP: c4b0fd80
  [  225.777462] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010202
  [  225.777470] CR0: 80050033 CR2: b5900000 CR3: 053a3000 CR4: 000006d0
  [  225.777479] Call Trace:
  [  225.777486]  ? i915_memcpy_init_early+0x63/0x63 [i915]
  [  225.777684]  apply_to_page_range+0x21/0x27
  [  225.777694]  ? i915_memcpy_init_early+0x63/0x63 [i915]
  [  225.777870]  remap_io_mapping+0x49/0x75 [i915]
  [  225.778046]  ? i915_memcpy_init_early+0x63/0x63 [i915]
  [  225.778220]  ? mutex_unlock+0xb/0xd
  [  225.778231]  ? i915_vma_pin_fence+0x6d/0xf7 [i915]
  [  225.778420]  vm_fault_gtt+0x2a9/0x8f1 [i915]
  [  225.778644]  ? lock_is_held_type+0x56/0xe7
  [  225.778655]  ? lock_is_held_type+0x7a/0xe7
  [  225.778663]  ? 0xc1000000
  [  225.778670]  __do_fault+0x21/0x6a
  [  225.778679]  handle_mm_fault+0x708/0xb21
  [  225.778686]  ? mt_find+0x21e/0x5ae
  [  225.778696]  exc_page_fault+0x185/0x705
  [  225.778704]  ? doublefault_shim+0x127/0x127
  [  225.778715]  handle_exception+0x130/0x130
  [  225.778723] EIP: 0xb700468a

Recently pud_huge() got aware of non-present entry by commit 3a194f3f8ad0
("mm/hugetlb: make pud_huge() and follow_huge_pud() aware of non-present
pud entry") to handle some special states of gigantic page.  However, it's
overlooked that pud_none() always returns false when running with 2-level
paging, and as a result pud_huge() can return true pointlessly.

Introduce "#if CONFIG_PGTABLE_LEVELS > 2" to pud_huge() to deal with this.

Link: https://lkml.kernel.org/r/20221107021010.2449306-1-naoya.horiguchi@linux.dev
Fixes: 3a194f3f8ad0 ("mm/hugetlb: make pud_huge() and follow_huge_pud() aware of non-present pud entry")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/hugetlbpage.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 6b3033845c6d..5804bbae4f01 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -37,8 +37,12 @@ int pmd_huge(pmd_t pmd)
  */
 int pud_huge(pud_t pud)
 {
+#if CONFIG_PGTABLE_LEVELS > 2
 	return !pud_none(pud) &&
 		(pud_val(pud) & (_PAGE_PRESENT|_PAGE_PSE)) != _PAGE_PRESENT;
+#else
+	return 0;
+#endif
 }
 
 #ifdef CONFIG_HUGETLB_PAGE
-- 
2.38.1



