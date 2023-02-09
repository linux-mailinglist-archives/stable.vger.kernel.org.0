Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0399D6912E6
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 23:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjBIWBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 17:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBIWBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 17:01:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04A2656A3;
        Thu,  9 Feb 2023 14:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E01761B89;
        Thu,  9 Feb 2023 22:01:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8116C433EF;
        Thu,  9 Feb 2023 22:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675980071;
        bh=MEM5Eq+Cc129af3iSNYKlayCiQ6m6MiCeukgCgHocAg=;
        h=Date:To:From:Subject:From;
        b=u3lAqb2Fd+/O7K1sg24Lux2FI8mT0Va9HLX4/u/SxCFH4J4xLCk53cIv10/7ZshQR
         N4hwVvRD4WNVcFG8pI0u+9KJ5viznPlFQKQ71oMZWlRmI32antcHgB9rvUm6Ttay17
         m8Yc36hOyS7Cm2dtSrBkUM31LTp8oZmxwJ2jDSqY=
Date:   Thu, 09 Feb 2023 14:01:11 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, david.chen@nutanix.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fix-page-corruption-caused-by-racy-check-in-__free_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20230209220111.D8116C433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix page corruption caused by racy check in __free_pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fix-page-corruption-caused-by-racy-check-in-__free_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fix-page-corruption-caused-by-racy-check-in-__free_pages.patch

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
From: David Chen <david.chen@nutanix.com>
Subject: mm/page_alloc.c: fix page corruption caused by racy check in __free_pages
Date: Thu, 9 Feb 2023 17:48:28 +0000

When we upgraded our kernel, we started seeing some page corruption like
the following consistently:

 BUG: Bad page state in process ganesha.nfsd  pfn:1304ca
 page:0000000022261c55 refcount:0 mapcount:-128 mapping:0000000000000000 in=
dex:0x0 pfn:0x1304ca
 flags: 0x17ffffc0000000()
 raw: 0017ffffc0000000 ffff8a513ffd4c98 ffffeee24b35ec08 0000000000000000
 raw: 0000000000000000 0000000000000001 00000000ffffff7f 0000000000000000
 page dumped because: nonzero mapcount
 CPU: 0 PID: 15567 Comm: ganesha.nfsd Kdump: loaded Tainted: P    B      O =
     5.10.158-1.nutanix.20221209.el7.x86_64 #1
 Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Referenc=
e Platform, BIOS 6.00 04/05/2016
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

Sometimes, it would also show up as corruption in the free list pointer and
cause crashes.

After bisecting the issue, we found the issue started from e320d3012d25:

	if (put_page_testzero(page))
		free_the_page(page, order);
	else if (!PageHead(page))
		while (order-- > 0)
			free_the_page(page + (1 << order), order);

So the problem is the check PageHead is racy because at this point we
already dropped our reference to the page.  So even if we came in with
compound page, the page can already be freed and PageHead can return false
and we will end up freeing all the tail pages causing double free.

Link: https://lkml.kernel.org/r/Message-ID:
Fixes: e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages")
Signed-off-by: Chunwei Chen <david.chen@nutanix.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~fix-page-corruption-caused-by-racy-check-in-__free_pages
+++ a/mm/page_alloc.c
@@ -5631,9 +5631,12 @@ EXPORT_SYMBOL(get_zeroed_page);
  */
 void __free_pages(struct page *page, unsigned int order)
 {
+	/* get PageHead before we drop reference */
+	int head =3D PageHead(page);
+
 	if (put_page_testzero(page))
 		free_the_page(page, order);
-	else if (!PageHead(page))
+	else if (!head)
 		while (order-- > 0)
 			free_the_page(page + (1 << order), order);
 }
_

Patches currently in -mm which might be from david.chen@nutanix.com are

fix-page-corruption-caused-by-racy-check-in-__free_pages.patch

