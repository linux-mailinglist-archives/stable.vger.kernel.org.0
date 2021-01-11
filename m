Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7528C2F141A
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732685AbhAKNRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:17:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732677AbhAKNRq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:17:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5660922C7E;
        Mon, 11 Jan 2021 13:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371024;
        bh=Icqj3NnDquF0UPI8M7/V2n9LlkLHdSpbKK/t5/0sNfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DeinzU2c66RDnkqgt19zPypHy7ZrlXJFzO5KLb0R5bTw7ZRqMtnmuHUQ104AIvUPG
         8GwM6n7CdqicfePJ9h0GrLhA6PqaW+jJF++YRwqEpZVEuJEsvqlDIkD9Z++ccs69VX
         FOYeuut9ftHFGjYNffbOc2ap1O7XQVCAdItUwre8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2fc0712f8f8b8b8fa0ef@syzkaller.appspotmail.com,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, stable@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 109/145] mm: make wait_on_page_writeback() wait for multiple pending writebacks
Date:   Mon, 11 Jan 2021 14:02:13 +0100
Message-Id: <20210111130053.764396270@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit c2407cf7d22d0c0d94cf20342b3b8f06f1d904e7 upstream.

Ever since commit 2a9127fcf229 ("mm: rewrite wait_on_page_bit_common()
logic") we've had some very occasional reports of BUG_ON(PageWriteback)
in write_cache_pages(), which we thought we already fixed in commit
073861ed77b6 ("mm: fix VM_BUG_ON(PageTail) and BUG_ON(PageWriteback)").

But syzbot just reported another one, even with that commit in place.

And it turns out that there's a simpler way to trigger the BUG_ON() than
the one Hugh found with page re-use.  It all boils down to the fact that
the page writeback is ostensibly serialized by the page lock, but that
isn't actually really true.

Yes, the people _setting_ writeback all do so under the page lock, but
the actual clearing of the bit - and waking up any waiters - happens
without any page lock.

This gives us this fairly simple race condition:

  CPU1 = end previous writeback
  CPU2 = start new writeback under page lock
  CPU3 = write_cache_pages()

  CPU1          CPU2            CPU3
  ----          ----            ----

  end_page_writeback()
    test_clear_page_writeback(page)
    ... delayed...

                lock_page();
                set_page_writeback()
                unlock_page()

                                lock_page()
                                wait_on_page_writeback();

    wake_up_page(page, PG_writeback);
    .. wakes up CPU3 ..

                                BUG_ON(PageWriteback(page));

where the BUG_ON() happens because we woke up the PG_writeback bit
becasue of the _previous_ writeback, but a new one had already been
started because the clearing of the bit wasn't actually atomic wrt the
actual wakeup or serialized by the page lock.

The reason this didn't use to happen was that the old logic in waiting
on a page bit would just loop if it ever saw the bit set again.

The nice proper fix would probably be to get rid of the whole "wait for
writeback to clear, and then set it" logic in the writeback path, and
replace it with an atomic "wait-to-set" (ie the same as we have for page
locking: we set the page lock bit with a single "lock_page()", not with
"wait for lock bit to clear and then set it").

However, out current model for writeback is that the waiting for the
writeback bit is done by the generic VFS code (ie write_cache_pages()),
but the actual setting of the writeback bit is done much later by the
filesystem ".writepages()" function.

IOW, to make the writeback bit have that same kind of "wait-to-set"
behavior as we have for page locking, we'd have to change our roughly
~50 different writeback functions.  Painful.

Instead, just make "wait_on_page_writeback()" loop on the very unlikely
situation that the PG_writeback bit is still set, basically re-instating
the old behavior.  This is very non-optimal in case of contention, but
since we only ever set the bit under the page lock, that situation is
controlled.

Reported-by: syzbot+2fc0712f8f8b8b8fa0ef@syzkaller.appspotmail.com
Fixes: 2a9127fcf229 ("mm: rewrite wait_on_page_bit_common() logic")
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2826,7 +2826,7 @@ EXPORT_SYMBOL(__test_set_page_writeback)
  */
 void wait_on_page_writeback(struct page *page)
 {
-	if (PageWriteback(page)) {
+	while (PageWriteback(page)) {
 		trace_wait_on_page_writeback(page, page_mapping(page));
 		wait_on_page_bit(page, PG_writeback);
 	}


