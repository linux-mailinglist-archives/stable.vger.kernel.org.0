Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A015635679
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237574AbiKWJbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237694AbiKWJal (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:30:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFA1112C46
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:29:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 47F37CE0FC8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C0EC433D6;
        Wed, 23 Nov 2022 09:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195739;
        bh=7fg3JJI8ivCtwEiQGUPSN95Jq9Q5NyVi608o9N9iSBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hBeSfsKX6UZ/9Qb1n2jI9O1bCnexzh0TPvPKa7E8NGbXT5Qt36QU08H4Tx/wrlMlR
         VDtfFXAqw+eRqzvzRmLbOPp4g2bdSb3xYhebSi0CbqJyOut1FHNi33OSM0z0n7onaB
         Lz2hIaoS3mOe63LGwMG6d2tGYCwKrVgqWNF56fV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Shi <shy828301@gmail.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Hugh Dickins <hughd@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>
Subject: [PATCH 5.15 002/181] mm: hwpoison: handle non-anonymous THP correctly
Date:   Wed, 23 Nov 2022 09:49:25 +0100
Message-Id: <20221123084602.788986097@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Yang Shi <shy828301@gmail.com>

commit 4966455d9100236fd6dd72b0cd00818435fdb25d upstream.

Currently hwpoison doesn't handle non-anonymous THP, but since v4.8 THP
support for tmpfs and read-only file cache has been added.  They could
be offlined by split THP, just like anonymous THP.

Link: https://lkml.kernel.org/r/20211020210755.23964-7-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1440,14 +1440,11 @@ static int identify_page_state(unsigned
 static int try_to_split_thp_page(struct page *page, const char *msg)
 {
 	lock_page(page);
-	if (!PageAnon(page) || unlikely(split_huge_page(page))) {
+	if (unlikely(split_huge_page(page))) {
 		unsigned long pfn = page_to_pfn(page);
 
 		unlock_page(page);
-		if (!PageAnon(page))
-			pr_info("%s: %#lx: non anonymous thp\n", msg, pfn);
-		else
-			pr_info("%s: %#lx: thp split failed\n", msg, pfn);
+		pr_info("%s: %#lx: thp split failed\n", msg, pfn);
 		put_page(page);
 		return -EBUSY;
 	}


