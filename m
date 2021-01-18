Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE632FA2C0
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390567AbhAROSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:18:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:39924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390568AbhARLpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B27A230FB;
        Mon, 18 Jan 2021 11:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970274;
        bh=0uvvG1ERfvBLzRrpVkVpMhhn5ozcI2Z00UpayjdTPV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cd5nY8w6gPPgJr6iG+iHQzsfmdlort7/9qIrt1EzVO4k1bYu/LtmeKHe3SGtix7dG
         Ftzy80BCZHiaYEYPFa7LjVa+tKWepouIdrqZrfXo59Io6OUuw75IksXlIglOr8VUd/
         jaqFVPHN5pIB1Dn6ifcTC5s7QWmGH6hd/QUsUasY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Peter Xu <peterx@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Martin Raiber <martin@urbackup.org>
Subject: [PATCH 5.10 111/152] mm: dont put pinned pages into the swap cache
Date:   Mon, 18 Jan 2021 12:34:46 +0100
Message-Id: <20210118113358.050858954@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit feb889fb40fafc6933339cf1cca8f770126819fb ]

So technically there is nothing wrong with adding a pinned page to the
swap cache, but the pinning obviously means that the page can't actually
be free'd right now anyway, so it's a bit pointless.

However, the real problem is not with it being a bit pointless: the real
issue is that after we've added it to the swap cache, we'll try to unmap
the page.  That will succeed, because the code in mm/rmap.c doesn't know
or care about pinned pages.

Even the unmapping isn't fatal per se, since the page will stay around
in memory due to the pinning, and we do hold the connection to it using
the swap cache.  But when we then touch it next and take a page fault,
the logic in do_swap_page() will map it back into the process as a
possibly read-only page, and we'll then break the page association on
the next COW fault.

Honestly, this issue could have been fixed in any of those other places:
(a) we could refuse to unmap a pinned page (which makes conceptual
sense), or (b) we could make sure to re-map a pinned page writably in
do_swap_page(), or (c) we could just make do_wp_page() not COW the
pinned page (which was what we historically did before that "mm:
do_wp_page() simplification" commit).

But while all of them are equally valid models for breaking this chain,
not putting pinned pages into the swap cache in the first place is the
simplest one by far.

It's also the safest one: the reason why do_wp_page() was changed in the
first place was that getting the "can I re-use this page" wrong is so
fraught with errors.  If you do it wrong, you end up with an incorrectly
shared page.

As a result, using "page_maybe_dma_pinned()" in either do_wp_page() or
do_swap_page() would be a serious bug since it is only a (very good)
heuristic.  Re-using the page requires a hard black-and-white rule with
no room for ambiguity.

In contrast, saying "this page is very likely dma pinned, so let's not
add it to the swap cache and try to unmap it" is an obviously safe thing
to do, and if the heuristic might very rarely be a false positive, no
harm is done.

Fixes: 09854ba94c6a ("mm: do_wp_page() simplification")
Reported-and-tested-by: Martin Raiber <martin@urbackup.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmscan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1240,6 +1240,8 @@ static unsigned int shrink_page_list(str
 			if (!PageSwapCache(page)) {
 				if (!(sc->gfp_mask & __GFP_IO))
 					goto keep_locked;
+				if (page_maybe_dma_pinned(page))
+					goto keep_locked;
 				if (PageTransHuge(page)) {
 					/* cannot split THP, skip it */
 					if (!can_split_huge_page(page, NULL))


