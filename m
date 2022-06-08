Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAC6C543C60
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 21:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiFHTHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 15:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiFHTHB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 15:07:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAEC50037;
        Wed,  8 Jun 2022 12:04:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E10060C21;
        Wed,  8 Jun 2022 19:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E573C3411E;
        Wed,  8 Jun 2022 19:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654715091;
        bh=0lDBrCuZKSz8rWNkIdI4A7fJ98xuGVzlWVM5B1Nc7Tg=;
        h=Date:To:From:Subject:From;
        b=mgKi2J/DVewQeqRSqcBrjQWlYds/hQf2AQbGGy7WGxh5bIx2WSkaYMhxRW5imP/A0
         TElWevNk771iSUMP6tVUTxvP9rJ43xhZCV5KhZckKgm6GyvKpH79nmLKBakCTg/ZKZ
         OIGolJzQwTCW3PmNCGNx/OR0aMdewuAt0dsSB4Xk=
Date:   Wed, 08 Jun 2022 12:04:50 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, david@redhat.com, pizhenwei@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-dont-allow-to-unpoison-hw-corrupted-page.patch removed from -mm tree
Message-Id: <20220608190451.8E573C3411E@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/memory-failure: don't allow to unpoison hw corrupted page
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-dont-allow-to-unpoison-hw-corrupted-page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: zhenwei pi <pizhenwei@bytedance.com>
Subject: mm/memory-failure: don't allow to unpoison hw corrupted page
Date: Sat, 4 Jun 2022 18:32:29 +0800

Currently unpoison_memory(unsigned long pfn) is designed for soft
poison(hwpoison-inject) only.  Unpoisoning a hardware corrupted page puts
page back buddy only, this leads BUG during accessing on the corrupted
KPTE.

Do not allow to unpoison hardware corrupted page in unpoison_memory() to
avoid BUG like this:

 Unpoison: Software-unpoisoned page 0x61234
 BUG: unable to handle page fault for address: ffff888061234000
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 PGD 2c01067 P4D 2c01067 PUD 107267063 PMD 10382b063 PTE 800fffff9edcb062
 Oops: 0002 [#1] PREEMPT SMP NOPTI
 CPU: 4 PID: 26551 Comm: stress Kdump: loaded Tainted: G   M       OE     5.18.0.bm.1-amd64 #7
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996) ...
 RIP: 0010:clear_page_erms+0x7/0x10
 Code: ...
 RSP: 0000:ffffc90001107bc8 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: 0000000000000901 RCX: 0000000000001000
 RDX: ffffea0001848d00 RSI: ffffea0001848d40 RDI: ffff888061234000
 RBP: ffffea0001848d00 R08: 0000000000000901 R09: 0000000000001276
 R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000001
 R13: 0000000000000000 R14: 0000000000140dca R15: 0000000000000001
 FS:  00007fd8b2333740(0000) GS:ffff88813fd00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: ffff888061234000 CR3: 00000001023d2005 CR4: 0000000000770ee0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
  <TASK>
  prep_new_page+0x151/0x170
  get_page_from_freelist+0xca0/0xe20
  ? sysvec_apic_timer_interrupt+0xab/0xc0
  ? asm_sysvec_apic_timer_interrupt+0x1b/0x20
  __alloc_pages+0x17e/0x340
  __folio_alloc+0x17/0x40
  vma_alloc_folio+0x84/0x280
  __handle_mm_fault+0x8d4/0xeb0
  handle_mm_fault+0xd5/0x2a0
  do_user_addr_fault+0x1d0/0x680
  ? kvm_read_and_reset_apf_flags+0x3b/0x50
  exc_page_fault+0x78/0x170
  asm_exc_page_fault+0x27/0x30

Link: https://lkml.kernel.org/r/20220604103229.3378591-1-pizhenwei@bytedance.com
Fixes: 847ce401df392 ("HWPOISON: Add unpoisoning support")
Fixes: 17fae1294ad9d ("x86/{mce,mm}: Unmap the entire page if the whole page is affected and poisoned")
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-dont-allow-to-unpoison-hw-corrupted-page
+++ a/mm/memory-failure.c
@@ -2090,6 +2090,7 @@ int unpoison_memory(unsigned long pfn)
 {
 	struct page *page;
 	struct page *p;
+	pte_t *kpte;
 	int ret = -EBUSY;
 	int freeit = 0;
 	static DEFINE_RATELIMIT_STATE(unpoison_rs, DEFAULT_RATELIMIT_INTERVAL,
@@ -2101,6 +2102,13 @@ int unpoison_memory(unsigned long pfn)
 	p = pfn_to_page(pfn);
 	page = compound_head(p);
 
+	kpte = virt_to_kpte((unsigned long)page_to_virt(p));
+	if (kpte && !pte_present(*kpte)) {
+		unpoison_pr_info("Unpoison: Page was hardware poisoned %#lx\n",
+				 pfn, &unpoison_rs);
+		return -EPERM;
+	}
+
 	mutex_lock(&mf_mutex);
 
 	if (!PageHWPoison(p)) {
_

Patches currently in -mm which might be from pizhenwei@bytedance.com are


