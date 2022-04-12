Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115D34FD3D2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345017AbiDLIAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357674AbiDLHkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:40:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B186C377F7;
        Tue, 12 Apr 2022 00:16:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C4E4B81B60;
        Tue, 12 Apr 2022 07:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DF7C385A5;
        Tue, 12 Apr 2022 07:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747789;
        bh=S3iPb50ZkG9ZYTuIpZz9Lju61ChJj1zOrSTTXOulzhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FkwGwBlc3p4geMtZ10zyomHEati4ek/+/NPXkEVAtttWq6uKbicFM22XGB2nFE5OI
         W17KRRoqIbufVIW99VLktEh0fwUK+Zj/DUyNI3L7u67wAliB5QQRxhIl6oayIPMAkb
         Eob+AoipuUOVw3W5NM5ScSNtI7Cx4nD4y1EH6dF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yunsheng Lin <linyunsheng@huawei.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 207/343] skbuff: fix coalescing for page_pool fragment recycling
Date:   Tue, 12 Apr 2022 08:30:25 +0200
Message-Id: <20220412062957.324693567@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

[ Upstream commit 1effe8ca4e34c34cdd9318436a4232dcb582ebf4 ]

Fix a use-after-free when using page_pool with page fragments. We
encountered this problem during normal RX in the hns3 driver:

(1) Initially we have three descriptors in the RX queue. The first one
    allocates PAGE1 through page_pool, and the other two allocate one
    half of PAGE2 each. Page references look like this:

                RX_BD1 _______ PAGE1
                RX_BD2 _______ PAGE2
                RX_BD3 _________/

(2) Handle RX on the first descriptor. Allocate SKB1, eventually added
    to the receive queue by tcp_queue_rcv().

(3) Handle RX on the second descriptor. Allocate SKB2 and pass it to
    netif_receive_skb():

    netif_receive_skb(SKB2)
      ip_rcv(SKB2)
        SKB3 = skb_clone(SKB2)

    SKB2 and SKB3 share a reference to PAGE2 through
    skb_shinfo()->dataref. The other ref to PAGE2 is still held by
    RX_BD3:

                      SKB2 ---+- PAGE2
                      SKB3 __/   /
                RX_BD3 _________/

 (3b) Now while handling TCP, coalesce SKB3 with SKB1:

      tcp_v4_rcv(SKB3)
        tcp_try_coalesce(to=SKB1, from=SKB3)    // succeeds
        kfree_skb_partial(SKB3)
          skb_release_data(SKB3)                // drops one dataref

                      SKB1 _____ PAGE1
                           \____
                      SKB2 _____ PAGE2
                                 /
                RX_BD3 _________/

    In skb_try_coalesce(), __skb_frag_ref() takes a page reference to
    PAGE2, where it should instead have increased the page_pool frag
    reference, pp_frag_count. Without coalescing, when releasing both
    SKB2 and SKB3, a single reference to PAGE2 would be dropped. Now
    when releasing SKB1 and SKB2, two references to PAGE2 will be
    dropped, resulting in underflow.

 (3c) Drop SKB2:

      af_packet_rcv(SKB2)
        consume_skb(SKB2)
          skb_release_data(SKB2)                // drops second dataref
            page_pool_return_skb_page(PAGE2)    // drops one pp_frag_count

                      SKB1 _____ PAGE1
                           \____
                                 PAGE2
                                 /
                RX_BD3 _________/

(4) Userspace calls recvmsg()
    Copies SKB1 and releases it. Since SKB3 was coalesced with SKB1, we
    release the SKB3 page as well:

    tcp_eat_recv_skb(SKB1)
      skb_release_data(SKB1)
        page_pool_return_skb_page(PAGE1)
        page_pool_return_skb_page(PAGE2)        // drops second pp_frag_count

(5) PAGE2 is freed, but the third RX descriptor was still using it!
    In our case this causes IOMMU faults, but it would silently corrupt
    memory if the IOMMU was disabled.

Change the logic that checks whether pp_recycle SKBs can be coalesced.
We still reject differing pp_recycle between 'from' and 'to' SKBs, but
in order to avoid the situation described above, we also reject
coalescing when both 'from' and 'to' are pp_recycled and 'from' is
cloned.

The new logic allows coalescing a cloned pp_recycle SKB into a page
refcounted one, because in this case the release (4) will drop the right
reference, the one taken by skb_try_coalesce().

Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")
Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a8a2fb745274..180fa6a26ad4 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5275,11 +5275,18 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
-	/* The page pool signature of struct page will eventually figure out
-	 * which pages can be recycled or not but for now let's prohibit slab
-	 * allocated and page_pool allocated SKBs from being coalesced.
+	/* In general, avoid mixing slab allocated and page_pool allocated
+	 * pages within the same SKB. However when @to is not pp_recycle and
+	 * @from is cloned, we can transition frag pages from page_pool to
+	 * reference counted.
+	 *
+	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
+	 * @from is cloned, in case the SKB is using page_pool fragment
+	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
+	 * references for cloned SKBs at the moment that would result in
+	 * inconsistent reference counts.
 	 */
-	if (to->pp_recycle != from->pp_recycle)
+	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
 		return false;
 
 	if (len <= skb_tailroom(to)) {
-- 
2.35.1



