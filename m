Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62285657842
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbiL1OtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:49:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbiL1Os5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:48:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C016ABC3A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:48:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1D9AB81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A7DC433A0;
        Wed, 28 Dec 2022 14:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238919;
        bh=bUEfMPz+NclXwWRFuMRgP+UzFHRve/BkJfTpNcLpsnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvML4HcVXawKn59ddC4zCF9yzuE/24aHqwbfyyv8ThvW6uDGfGDQQMV7ayGg1cCZe
         xqaryVNcI/YiN+BXOHkM/iAkpKMm+hhvyUTG591xmiBYQwcapy0sExxijJZ4CTbYTK
         EPW9TKzldq4U9s/3+HoBBNBNYYelyHzxMZtLYDTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Geffon <bgeffon@google.com>,
        Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/731] pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP
Date:   Wed, 28 Dec 2022 15:32:47 +0100
Message-Id: <20221228144258.293363002@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit e6b842741b4f39007215fd7e545cb55aa3d358a2 ]

An oops can be induced by running 'cat /proc/kcore > /dev/null' on
devices using pstore with the ram backend because kmap_atomic() assumes
lowmem pages are accessible with __va().

 Unable to handle kernel paging request at virtual address ffffff807ff2b000
 Mem abort info:
 ESR = 0x96000006
 EC = 0x25: DABT (current EL), IL = 32 bits
 SET = 0, FnV = 0
 EA = 0, S1PTW = 0
 FSC = 0x06: level 2 translation fault
 Data abort info:
 ISV = 0, ISS = 0x00000006
 CM = 0, WnR = 0
 swapper pgtable: 4k pages, 39-bit VAs, pgdp=0000000081d87000
 [ffffff807ff2b000] pgd=180000017fe18003, p4d=180000017fe18003, pud=180000017fe18003, pmd=0000000000000000
 Internal error: Oops: 96000006 [#1] PREEMPT SMP
 Modules linked in: dm_integrity
 CPU: 7 PID: 21179 Comm: perf Not tainted 5.15.67-10882-ge4eb2eb988cd #1 baa443fb8e8477896a370b31a821eb2009f9bfba
 Hardware name: Google Lazor (rev3 - 8) (DT)
 pstate: a0400009 (NzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
 pc : __memcpy+0x110/0x260
 lr : vread+0x194/0x294
 sp : ffffffc013ee39d0
 x29: ffffffc013ee39f0 x28: 0000000000001000 x27: ffffff807ff2b000
 x26: 0000000000001000 x25: ffffffc0085a2000 x24: ffffff802d4b3000
 x23: ffffff80f8a60000 x22: ffffff802d4b3000 x21: ffffffc0085a2000
 x20: ffffff8080b7bc68 x19: 0000000000001000 x18: 0000000000000000
 x17: 0000000000000000 x16: 0000000000000000 x15: ffffffd3073f2e60
 x14: ffffffffad588000 x13: 0000000000000000 x12: 0000000000000001
 x11: 00000000000001a2 x10: 00680000fff2bf0b x9 : 03fffffff807ff2b
 x8 : 0000000000000001 x7 : 0000000000000000 x6 : 0000000000000000
 x5 : ffffff802d4b4000 x4 : ffffff807ff2c000 x3 : ffffffc013ee3a78
 x2 : 0000000000001000 x1 : ffffff807ff2b000 x0 : ffffff802d4b3000
 Call trace:
 __memcpy+0x110/0x260
 read_kcore+0x584/0x778
 proc_reg_read+0xb4/0xe4

During early boot, memblock reserves the pages for the ramoops reserved
memory node in DT that would otherwise be part of the direct lowmem
mapping. Pstore's ram backend reuses those reserved pages to change the
memory type (writeback or non-cached) by passing the pages to vmap()
(see pfn_to_page() usage in persistent_ram_vmap() for more details) with
specific flags. When read_kcore() starts iterating over the vmalloc
region, it runs over the virtual address that vmap() returned for
ramoops. In aligned_vread() the virtual address is passed to
vmalloc_to_page() which returns the page struct for the reserved lowmem
area. That lowmem page is passed to kmap_atomic(), which effectively
calls page_to_virt() that assumes a lowmem page struct must be directly
accessible with __va() and friends. These pages are mapped via vmap()
though, and the lowmem mapping was never made, so accessing them via the
lowmem virtual address oopses like above.

Let's side-step this problem by passing VM_IOREMAP to vmap(). This will
tell vread() to not include the ramoops region in the kcore. Instead the
area will look like a bunch of zeros. The alternative is to teach kmap()
about vmalloc areas that intersect with lowmem. Presumably such a change
isn't a one-liner, and there isn't much interest in inspecting the
ramoops region in kcore files anyway, so the most expedient route is
taken for now.

Cc: Brian Geffon <bgeffon@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 404a6043385d ("staging: android: persistent_ram: handle reserving and mapping memory")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221205233136.3420802-1-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/pstore/ram_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index fe5305028c6e..155c7010b1f8 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -439,7 +439,11 @@ static void *persistent_ram_vmap(phys_addr_t start, size_t size,
 		phys_addr_t addr = page_start + i * PAGE_SIZE;
 		pages[i] = pfn_to_page(addr >> PAGE_SHIFT);
 	}
-	vaddr = vmap(pages, page_count, VM_MAP, prot);
+	/*
+	 * VM_IOREMAP used here to bypass this region during vread()
+	 * and kmap_atomic() (i.e. kcore) to avoid __va() failures.
+	 */
+	vaddr = vmap(pages, page_count, VM_MAP | VM_IOREMAP, prot);
 	kfree(pages);
 
 	/*
-- 
2.35.1



