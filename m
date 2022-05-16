Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AF0528FBE
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244421AbiEPUFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348929AbiEPT7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240E23ED3C;
        Mon, 16 May 2022 12:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3F6660ABE;
        Mon, 16 May 2022 19:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD18C34100;
        Mon, 16 May 2022 19:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730779;
        bh=YbsiaqMe5yBZdvF9hnBlQ3vhxcQzkb8TxDMCiVQAXOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDvEPLuekxmK/feHs64LIcsLPPcPGM3Q/mdJXYWYpzsEhCaVQlBxEeWlBIxyk9Bay
         SA/aAnE0oeTwlO5IbegXBmoVfVoTcyiFkVwz5lJMKXCXLamg+eRJxtboepVv5m26w+
         CJqLUb/a0bCSRJ85lYYl0zjipsoj+yt1zYCjOKVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naoya Horiguchi <naoya.horiguchi@nec.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        William Kucharski <william.kucharski@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 098/102] mm/hwpoison: use pr_err() instead of dump_page() in get_any_page()
Date:   Mon, 16 May 2022 21:37:12 +0200
Message-Id: <20220516193626.814874017@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

commit 1825b93b626e99eb9a0f9f50342c7b2fa201b387 upstream.

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
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1217,7 +1217,7 @@ try_again:
 	}
 out:
 	if (ret == -EIO)
-		dump_page(p, "hwpoison: unhandlable page");
+		pr_err("Memory failure: %#lx: unhandlable page.\n", page_to_pfn(p));
 
 	return ret;
 }


