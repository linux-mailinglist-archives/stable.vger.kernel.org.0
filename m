Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54A2417DD7
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 00:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232572AbhIXWoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 18:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhIXWoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 18:44:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8B1261019;
        Fri, 24 Sep 2021 22:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1632523401;
        bh=EvuUAlpzSYOcprBe/h8oX+QM5LFSXdkN/iEH877IZLQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=rQqDKBvc5cnaFSo5KzxDmskaGl6iBMXsjxz7PrSBZxRtfX8ojTjaz2i5Qu+pvQf29
         ntYHj3dx17OcGwhgiux9nvRzgAtTFQTunvZgG7YlLvY4rebWC2wC5BjM6ZDnGELOup
         VM3a/A4vS/C5HPuKPq7XiKiqTvugICZVGBN3JEU0=
Date:   Fri, 24 Sep 2021 15:43:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, shy828301@gmail.com, stable@vger.kernel.org,
        tony.luck@intel.com, torvalds@linux-foundation.org
Subject:  [patch 01/16] mm, hwpoison: add is_free_buddy_page() in
 HWPoisonHandlable()
Message-ID: <20210924224320.S3vgzdWHO%akpm@linux-foundation.org>
In-Reply-To: <20210924154257.1dbf6699ab8d88c0460f924f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: add is_free_buddy_page() in HWPoisonHandlable()

commit fcc00621d88b ("mm/hwpoison: retry with shake_page() for unhandlable
pages") changes the return value of __get_hwpoison_page() to retry for
transiently unhandlable cases.  However, __get_hwpoison_page() currently
fails to properly judge buddy pages as handlable, so hard/soft offline for
buddy pages always fail as "unhandlable page".  This is totally
regrettable.

So let's add is_free_buddy_page() in HWPoisonHandlable(), so that
__get_hwpoison_page() returns different return values between buddy
pages and unhandlable pages as intended.

Link: https://lkml.kernel.org/r/20210909004131.163221-1-naoya.horiguchi@linux.dev
Fixes: fcc00621d88b ("mm/hwpoison: retry with shake_page() for unhandlable pages")
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-hwpoison-add-is_free_buddy_page-in-hwpoisonhandlable
+++ a/mm/memory-failure.c
@@ -1126,7 +1126,7 @@ static int page_action(struct page_state
  */
 static inline bool HWPoisonHandlable(struct page *page)
 {
-	return PageLRU(page) || __PageMovable(page);
+	return PageLRU(page) || __PageMovable(page) || is_free_buddy_page(page);
 }
 
 static int __get_hwpoison_page(struct page *page)
_
