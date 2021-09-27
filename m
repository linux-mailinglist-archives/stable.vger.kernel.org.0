Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF469419BBE
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbhI0RVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:21:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236043AbhI0RTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:19:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E61666134F;
        Mon, 27 Sep 2021 17:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762782;
        bh=OqdgJlHVsssfnQqqHpKrNqiku44QOGpoNOBJS8fWfhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QI1u2dMaeh5GYL8OR/oPHeZjF+NHRrzYBg72KpNwgQaljRj7Mkk4rt3YUagb5CVHw
         AqWHie5tKs6P8FSOvn4hYFPookaVYvmRvRj4n4VyFKyMlFgSV/r6uXnWIT8eRihbO5
         YUoDTRVqu0ibiR/5N2u4gIYN53FKBmT8JGNxELfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 048/162] afs: Fix page leak
Date:   Mon, 27 Sep 2021 19:01:34 +0200
Message-Id: <20210927170235.164647293@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 581b2027af0018944ba301d68e7af45c6d1128b5 ]

There's a loop in afs_extend_writeback() that adds extra pages to a write
we want to make to improve the efficiency of the writeback by making it
larger.  This loop stops, however, if we hit a page we can't write back
from immediately, but it doesn't get rid of the page ref we speculatively
acquired.

This was caused by the removal of the cleanup loop when the code switched
from using find_get_pages_contig() to xarray scanning as the latter only
gets a single page at a time, not a batch.

Fix this by putting the page on a ref on an early break from the loop.
Unfortunately, we can't just add that page to the pagevec we're employing
as we'll go through that and add those pages to the RPC call.

This was found by the generic/074 test.  It leaks ~4GiB of RAM each time it
is run - which can be observed with "top".

Fixes: e87b03f5830e ("afs: Prepare for use of THPs")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-and-tested-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/163111666635.283156.177701903478910460.stgit@warthog.procyon.org.uk/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/write.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index c0534697268e..66b235266893 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -471,13 +471,18 @@ static void afs_extend_writeback(struct address_space *mapping,
 			}
 
 			/* Has the page moved or been split? */
-			if (unlikely(page != xas_reload(&xas)))
+			if (unlikely(page != xas_reload(&xas))) {
+				put_page(page);
 				break;
+			}
 
-			if (!trylock_page(page))
+			if (!trylock_page(page)) {
+				put_page(page);
 				break;
+			}
 			if (!PageDirty(page) || PageWriteback(page)) {
 				unlock_page(page);
+				put_page(page);
 				break;
 			}
 
@@ -487,6 +492,7 @@ static void afs_extend_writeback(struct address_space *mapping,
 			t = afs_page_dirty_to(page, priv);
 			if (f != 0 && !new_content) {
 				unlock_page(page);
+				put_page(page);
 				break;
 			}
 
-- 
2.33.0



