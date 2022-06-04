Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1F053D837
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 20:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239923AbiFDS4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 14:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239717AbiFDS4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 14:56:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7978B4F47B;
        Sat,  4 Jun 2022 11:56:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F23F2B803F4;
        Sat,  4 Jun 2022 18:56:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95743C385B8;
        Sat,  4 Jun 2022 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654368997;
        bh=mVkKB5vr27GjXwNnkwRE61qgB0Z2AlvC/b553xv51hM=;
        h=Date:To:From:Subject:From;
        b=szCXQIyDWuwxafuAYM2LlqvI17AILC84tT/inYK4lz1xmGZrsKmMHEwwo6znQ2cfk
         htq9/B09vft71DDe/n1aT6WejOMwNLfCkl8XucsheDcn60wQK0cQymhQUFb77aYP4P
         DDjUvuskMR5na/sr6FB9rGs1iLJV03FsQRFfHTtc=
Date:   Sat, 04 Jun 2022 11:56:36 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        naoya.horiguchi@nec.com, pizhenwei@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-dont-allow-to-unpoison-hw-corrupted-page.patch added to mm-hotfixes-unstable branch
Message-Id: <20220604185637.95743C385B8@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/memory-failure: don't allow to unpoison hw corrupted page
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-dont-allow-to-unpoison-hw-corrupted-page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-dont-allow-to-unpoison-hw-corrupted-page.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
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

mm-memory-failure-dont-allow-to-unpoison-hw-corrupted-page.patch

