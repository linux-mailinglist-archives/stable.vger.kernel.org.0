Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D882512258
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 21:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbiD0TUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 15:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbiD0TTx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 15:19:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DA791563;
        Wed, 27 Apr 2022 12:14:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33E96619E1;
        Wed, 27 Apr 2022 19:14:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D506C385AA;
        Wed, 27 Apr 2022 19:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1651086866;
        bh=wK5s5NErBjAKg6T5TsoURBgP5kKXmle9rTlIl06jgLc=;
        h=Date:To:From:Subject:From;
        b=ogQKxma7CKFX0Mu0vepKLZVAMn44YvZU19yOUxzEUGRB935tY3kOo15ohpmGkRMMU
         81txuQ0Ms/b8Q2fqdLzt4lrcdAb2RU3EZyRAZpRfCOqmm8sn94MQQ+KBqvHGaQhlkV
         R8Yft4lYAZtd5hGtewg2V6l7QRq1xd2thGYnhiKs=
Date:   Wed, 27 Apr 2022 12:14:25 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        william.kucharski@oracle.com, stable@vger.kernel.org,
        linmiaohe@huawei.com, jhubbard@nvidia.com, jgg@nvidia.com,
        hch@infradead.org, naoya.horiguchi@nec.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hwpoison-use-pr_err-instead-of-dump_page-in-get_any_page.patch added to -mm tree
Message-Id: <20220427191426.8D506C385AA@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/hwpoison: use pr_err() instead of dump_page() in get_any_page()
has been added to the -mm tree.  Its filename is
     mm-hwpoison-use-pr_err-instead-of-dump_page-in-get_any_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-use-pr_err-instead-of-dump_page-in-get_any_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-use-pr_err-instead-of-dump_page-in-get_any_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hwpoison: use pr_err() instead of dump_page() in get_any_page()

The following VM_BUG_ON_FOLIO() is triggered when memory error event
happens on the (thp/folio) pages which are about to be freed:

  [ 1160.232771] page:00000000b36a8a0f refcount:1 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x16a000
  [ 1160.236916] page:00000000b36a8a0f refcount:0 mapcount:0 mapping:0000000000000000 index:0x1 pfn:0x16a000
  [ 1160.240684] flags: 0x57ffffc0800000(hwpoison|node=1|zone=2|lastcpupid=0x1fffff)
  [ 1160.243458] raw: 0057ffffc0800000 dead000000000100 dead000000000122 0000000000000000
  [ 1160.246268] raw: 0000000000000001 0000000000000000 00000000ffffffff 0000000000000000
  [ 1160.249197] page dumped because: VM_BUG_ON_FOLIO(!folio_test_large(folio))
  [ 1160.251815] ------------[ cut here ]------------
  [ 1160.253438] kernel BUG at include/linux/mm.h:788!
  [ 1160.256162] invalid opcode: 0000 [#1] PREEMPT SMP PTI
  [ 1160.258172] CPU: 2 PID: 115368 Comm: mceinj.sh Tainted: G            E     5.18.0-rc1-v5.18-rc1-220404-2353-005-g83111+ #3
  [ 1160.262049] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1.fc35 04/01/2014
  [ 1160.265103] RIP: 0010:dump_page.cold+0x27e/0x2bd
  [ 1160.266757] Code: fe ff ff 48 c7 c6 81 f1 5a 98 e9 4c fe ff ff 48 c7 c6 a1 95 59 98 e9 40 fe ff ff 48 c7 c6 50 bf 5a 98 48 89 ef e8 9d 04 6d ff <0f> 0b 41 f7 c4 ff 0f 00 00 0f 85 9f fd ff ff 49 8b 04 24 a9 00 00
  [ 1160.273180] RSP: 0018:ffffaa2c4d59fd18 EFLAGS: 00010292
  [ 1160.274969] RAX: 000000000000003e RBX: 0000000000000001 RCX: 0000000000000000
  [ 1160.277263] RDX: 0000000000000001 RSI: ffffffff985995a1 RDI: 00000000ffffffff
  [ 1160.279571] RBP: ffffdc9c45a80000 R08: 0000000000000000 R09: 00000000ffffdfff
  [ 1160.281794] R10: ffffaa2c4d59fb08 R11: ffffffff98940d08 R12: ffffdc9c45a80000
  [ 1160.283920] R13: ffffffff985b6f94 R14: 0000000000000000 R15: ffffdc9c45a80000
  [ 1160.286641] FS:  00007eff54ce1740(0000) GS:ffff99c67bd00000(0000) knlGS:0000000000000000
  [ 1160.289498] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [ 1160.291106] CR2: 00005628381a5f68 CR3: 0000000104712003 CR4: 0000000000170ee0
  [ 1160.293031] Call Trace:
  [ 1160.293724]  <TASK>
  [ 1160.294334]  get_hwpoison_page+0x47d/0x570
  [ 1160.295474]  memory_failure+0x106/0xaa0
  [ 1160.296474]  ? security_capable+0x36/0x50
  [ 1160.297524]  hard_offline_page_store+0x43/0x80
  [ 1160.298684]  kernfs_fop_write_iter+0x11c/0x1b0
  [ 1160.299829]  new_sync_write+0xf9/0x160
  [ 1160.300810]  vfs_write+0x209/0x290
  [ 1160.301835]  ksys_write+0x4f/0xc0
  [ 1160.302718]  do_syscall_64+0x3b/0x90
  [ 1160.303664]  entry_SYSCALL_64_after_hwframe+0x44/0xae
  [ 1160.304981] RIP: 0033:0x7eff54b018b7

As shown in the RIP address, this VM_BUG_ON in folio_entire_mapcount() is
called from dump_page("hwpoison: unhandlable page") in get_any_page().
The below explains the mechanism of the race:

  CPU 0                                       CPU 1

    memory_failure
      get_hwpoison_page
        get_any_page
          dump_page
            compound = PageCompound
                                                free_pages_prepare
                                                  page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP
            folio_entire_mapcount
              VM_BUG_ON_FOLIO(!folio_test_large(folio))

So replace dump_page() with safer one, pr_err().

Link: https://lkml.kernel.org/r/20220427053220.719866-1-naoya.horiguchi@linux.dev
Fixes: 74e8ee4708a8 ("mm: Turn head_compound_mapcount() into folio_entire_mapcount()")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-use-pr_err-instead-of-dump_page-in-get_any_page
+++ a/mm/memory-failure.c
@@ -1274,7 +1274,7 @@ try_again:
 	}
 out:
 	if (ret == -EIO)
-		dump_page(p, "hwpoison: unhandlable page");
+		pr_err("Memory failure: %#lx: unhandlable page.\n", page_to_pfn(p));
 
 	return ret;
 }
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-use-pr_err-instead-of-dump_page-in-get_any_page.patch
mm-hwpoison-put-page-in-already-hwpoisoned-case-with-mf_count_increased.patch
revert-mm-memory-failurec-fix-race-with-changing-page-compound-again.patch
mm-hugetlb-hwpoison-separate-branch-for-free-and-in-use-hugepage.patch

