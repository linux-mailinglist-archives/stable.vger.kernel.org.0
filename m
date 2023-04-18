Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F6F6E6372
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjDRMkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbjDRMkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:40:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A064813C31
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:40:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28A0763307
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CC8C433EF;
        Tue, 18 Apr 2023 12:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821637;
        bh=n58u0Tbsa25gml142dB+NUX9VNi3p/SJgdxipmZoWRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJrvuQKc44Kmzf/fKIJlIRalm0OAxyyKxD9By9HD7tf8mtyJlEUVZsezunHUZcU4U
         YJG2jcxhOnOzK8G8crOOyfWaBpv8g4iDLaRFsrtdLIpm/j5K+SVjNTk8ygM0ZabDj2
         H9aAkQ/DWOErxghPjKNwhYHVpM3L9pQiAjfSyLCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liang Chen <liangchen.linux@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/91] skbuff: Fix a race between coalescing and releasing SKBs
Date:   Tue, 18 Apr 2023 14:21:40 +0200
Message-Id: <20230418120306.837235565@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang Chen <liangchen.linux@gmail.com>

[ Upstream commit 0646dc31ca886693274df5749cd0c8c1eaaeb5ca ]

Commit 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment
recycling") allowed coalescing to proceed with non page pool page and page
pool page when @from is cloned, i.e.

to->pp_recycle    --> false
from->pp_recycle  --> true
skb_cloned(from)  --> true

However, it actually requires skb_cloned(@from) to hold true until
coalescing finishes in this situation. If the other cloned SKB is
released while the merging is in process, from_shinfo->nr_frags will be
set to 0 toward the end of the function, causing the increment of frag
page _refcount to be unexpectedly skipped resulting in inconsistent
reference counts. Later when SKB(@to) is released, it frees the page
directly even though the page pool page is still in use, leading to
use-after-free or double-free errors. So it should be prohibited.

The double-free error message below prompted us to investigate:
BUG: Bad page state in process swapper/1  pfn:0e0d1
page:00000000c6548b28 refcount:-1 mapcount:0 mapping:0000000000000000
index:0x2 pfn:0xe0d1
flags: 0xfffffc0000000(node=0|zone=1|lastcpupid=0x1fffff)
raw: 000fffffc0000000 0000000000000000 ffffffff00000101 0000000000000000
raw: 0000000000000002 0000000000000000 ffffffffffffffff 0000000000000000
page dumped because: nonzero _refcount

CPU: 1 PID: 0 Comm: swapper/1 Tainted: G            E      6.2.0+
Call Trace:
 <IRQ>
dump_stack_lvl+0x32/0x50
bad_page+0x69/0xf0
free_pcp_prepare+0x260/0x2f0
free_unref_page+0x20/0x1c0
skb_release_data+0x10b/0x1a0
napi_consume_skb+0x56/0x150
net_rx_action+0xf0/0x350
? __napi_schedule+0x79/0x90
__do_softirq+0xc8/0x2b1
__irq_exit_rcu+0xb9/0xf0
common_interrupt+0x82/0xa0
</IRQ>
<TASK>
asm_common_interrupt+0x22/0x40
RIP: 0010:default_idle+0xb/0x20

Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230413090353.14448-1-liangchen.linux@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 2d3f82b622366..46cc3a7632f79 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5397,18 +5397,18 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
-	/* In general, avoid mixing slab allocated and page_pool allocated
-	 * pages within the same SKB. However when @to is not pp_recycle and
-	 * @from is cloned, we can transition frag pages from page_pool to
-	 * reference counted.
-	 *
-	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
-	 * @from is cloned, in case the SKB is using page_pool fragment
+	/* In general, avoid mixing page_pool and non-page_pool allocated
+	 * pages within the same SKB. Additionally avoid dealing with clones
+	 * with page_pool pages, in case the SKB is using page_pool fragment
 	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
 	 * references for cloned SKBs at the moment that would result in
 	 * inconsistent reference counts.
+	 * In theory we could take full references if @from is cloned and
+	 * !@to->pp_recycle but its tricky (due to potential race with
+	 * the clone disappearing) and rare, so not worth dealing with.
 	 */
-	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
+	if (to->pp_recycle != from->pp_recycle ||
+	    (from->pp_recycle && skb_cloned(from)))
 		return false;
 
 	if (len <= skb_tailroom(to)) {
-- 
2.39.2



