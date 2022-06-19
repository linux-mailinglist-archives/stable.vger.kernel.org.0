Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF14D550B68
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 17:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiFSPLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 11:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiFSPLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 11:11:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7F3AE53;
        Sun, 19 Jun 2022 08:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=HEdDzWGE0/UHZ2jiI+06ZjvEQpyio5BCGMu+xcj8GF0=; b=sZmaruFh2/gF/L/HuQXhGK6qZb
        eTdqebfkQ7+xES9EIjJjUsRQ52aTC7z4Y4sZtIWXSUFhBfZ01esJ1pdMxtGgxPhdUKxQGTNJ1/TVN
        gL1525wV6ogGepJWkseXjFu3pBixV56lh1VRFx94jSN7Y32FQwrARLA0Rn0u8Z3fZ77zbHJeIJBeh
        OFPCrvTO+HA4Qth8rF7ewBPjeI5uHbaYh6MxARGxO2MOEyY2iFyPK0kRWD4dhYUy/8Q3heargL3Z0
        qCVn7BDm/o3v0koG61EZFrqWTBtXIh61XPKfbsUWMc7LKaCUgpyJtvABSQ2q0E6gMrtplQz5oratY
        cG//Gk2g==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o2waZ-004QOs-5Y; Sun, 19 Jun 2022 15:11:47 +0000
From:   "Matthew Wilcox (Oracle)" <willy@infradead.org>
To:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 2/3] filemap: Handle sibling entries in filemap_get_read_batch()
Date:   Sun, 19 Jun 2022 16:11:42 +0100
Message-Id: <20220619151143.1054746-3-willy@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220619151143.1054746-1-willy@infradead.org>
References: <20220619151143.1054746-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a read races with an invalidation followed by another read, it is
possible for a folio to be replaced with a higher-order folio.  If that
happens, we'll see a sibling entry for the new folio in the next iteration
of the loop.  This manifests as a NULL pointer dereference while holding
the RCU read lock.

Handle this by simply returning.  The next call will find the new folio
and handle it correctly.  The other ways of handling this rare race are
more complex and it's just not worth it.

Reported-by: Dave Chinner <david@fromorbit.com>
Reported-by: Brian Foster <bfoster@redhat.com>
Debugged-by: Brian Foster <bfoster@redhat.com>
Tested-by: Brian Foster <bfoster@redhat.com>
Fixes: cbd59c48ae2b ("mm/filemap: use head pages in generic_file_buffered_read")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 577068868449..ffdfbc8b0e3c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2385,6 +2385,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
 			continue;
 		if (xas.xa_index > max || xa_is_value(folio))
 			break;
+		if (xa_is_sibling(folio))
+			break;
 		if (!folio_try_get_rcu(folio))
 			goto retry;
 
-- 
2.35.1

