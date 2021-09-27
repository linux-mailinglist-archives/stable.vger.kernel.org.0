Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A6D419B5C
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbhI0RRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:17:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235711AbhI0RPi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:15:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73D6F6137D;
        Mon, 27 Sep 2021 17:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762672;
        bh=iUtyp+/r3ntGp3CauAKQdeetw2ecfDT+mt+3REUJ7qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NZzrgUBG6gVxbflHrJ2zB0E+P1k9/t1S/IrwAG37Y1hq/f74on1zKQn6zAJG9qjFG
         ITPn0eIE74ygf/Rr649k8ZQB9QczsM4pRlfB2p5tQrJQelkeeTW8UD+ox65SB61nU+
         /cByXBu6xWJJ4XtgdyFswSyHWaH3dx9bU5S0QdbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naoya Horiguchi <naoya.horiguchi@nec.com>,
        David Hildenbrand <david@redhat.com>,
        Yang Shi <shy828301@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.14 001/162] mm, hwpoison: add is_free_buddy_page() in HWPoisonHandlable()
Date:   Mon, 27 Sep 2021 19:00:47 +0200
Message-Id: <20210927170233.505942394@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>

commit acfa299a4a63a58e5e81a87cb16798f20d35f7d7 upstream.

Commit fcc00621d88b ("mm/hwpoison: retry with shake_page() for
unhandlable pages") changed the return value of __get_hwpoison_page() to
retry for transiently unhandlable cases.  However, __get_hwpoison_page()
currently fails to properly judge buddy pages as handlable, so hard/soft
offline for buddy pages always fail as "unhandlable page".  This is
totally regrettable.

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
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1127,7 +1127,7 @@ static int page_action(struct page_state
  */
 static inline bool HWPoisonHandlable(struct page *page)
 {
-	return PageLRU(page) || __PageMovable(page);
+	return PageLRU(page) || __PageMovable(page) || is_free_buddy_page(page);
 }
 
 static int __get_hwpoison_page(struct page *page)


