Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB206949A4
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbjBMPA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbjBMPA1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:00:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01EADBDD
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:00:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B027961161
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CECC4339B;
        Mon, 13 Feb 2023 14:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300396;
        bh=vkq/d11vp0t2z8M6ldoge9CimALDu5Qb1amyUjVxfCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+d7UgkFuUC2+FlOdU7NkX8hBQnJ5sOU6GjHTxG045EQ0rQASe32ytLpJV9zqZjUV
         iKpIGYmylEtDFTbWMy2Xil71Zp7qpQ8wZ3mpQeLzXdSoKXCsybqO6+N4DAv9Z6UKXO
         7EHQJnYYFcBRzak4xroLat0EmvD26mnqno0qB4zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
        Chunwei Chen <david.chen@nutanix.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 63/67] Fix page corruption caused by racy check in __free_pages
Date:   Mon, 13 Feb 2023 15:49:44 +0100
Message-Id: <20230213144735.393429059@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
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

From: David Chen <david.chen@nutanix.com>

commit 462a8e08e0e6287e5ce13187257edbf24213ed03 upstream.

When we upgraded our kernel, we started seeing some page corruption like
the following consistently:

  BUG: Bad page state in process ganesha.nfsd  pfn:1304ca
  page:0000000022261c55 refcount:0 mapcount:-128 mapping:0000000000000000 index:0x0 pfn:0x1304ca
  flags: 0x17ffffc0000000()
  raw: 0017ffffc0000000 ffff8a513ffd4c98 ffffeee24b35ec08 0000000000000000
  raw: 0000000000000000 0000000000000001 00000000ffffff7f 0000000000000000
  page dumped because: nonzero mapcount
  CPU: 0 PID: 15567 Comm: ganesha.nfsd Kdump: loaded Tainted: P    B      O      5.10.158-1.nutanix.20221209.el7.x86_64 #1
  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/05/2016
  Call Trace:
   dump_stack+0x74/0x96
   bad_page.cold+0x63/0x94
   check_new_page_bad+0x6d/0x80
   rmqueue+0x46e/0x970
   get_page_from_freelist+0xcb/0x3f0
   ? _cond_resched+0x19/0x40
   __alloc_pages_nodemask+0x164/0x300
   alloc_pages_current+0x87/0xf0
   skb_page_frag_refill+0x84/0x110
   ...

Sometimes, it would also show up as corruption in the free list pointer
and cause crashes.

After bisecting the issue, we found the issue started from commit
e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages"):

	if (put_page_testzero(page))
		free_the_page(page, order);
	else if (!PageHead(page))
		while (order-- > 0)
			free_the_page(page + (1 << order), order);

So the problem is the check PageHead is racy because at this point we
already dropped our reference to the page.  So even if we came in with
compound page, the page can already be freed and PageHead can return
false and we will end up freeing all the tail pages causing double free.

Fixes: e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages")
Link: https://lore.kernel.org/lkml/BYAPR02MB448855960A9656EEA81141FC94D99@BYAPR02MB4488.namprd02.prod.outlook.com/
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Chunwei Chen <david.chen@nutanix.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5490,9 +5490,12 @@ EXPORT_SYMBOL(get_zeroed_page);
  */
 void __free_pages(struct page *page, unsigned int order)
 {
+	/* get PageHead before we drop reference */
+	int head = PageHead(page);
+
 	if (put_page_testzero(page))
 		free_the_page(page, order);
-	else if (!PageHead(page))
+	else if (!head)
 		while (order-- > 0)
 			free_the_page(page + (1 << order), order);
 }


