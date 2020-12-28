Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E412E395C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388327AbgL1NWo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:22:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388320AbgL1NWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:22:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3BF4207C9;
        Mon, 28 Dec 2020 13:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161746;
        bh=Hx+uRCefzJN6KKyGC2UDODJX1x8RkQ9wEXlhqDRDedM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1A28JSYugtvTPUuupBpu+B5LFCHAcPr+hXCfRKiFuSbhQQDwQq4UNE3a2f/2XXyW9
         /5Wj7X41kT9TWlxJB76slmORkgQjtLUv218MvsFcDXpKz7lFbpdK8Db8pfKioRKkYk
         mRHLv2bRF2e+hk7Ht/mtPh1Zamnzdm02HGrA0Am8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Li RongQing <lirongqing@baidu.com>
Subject: [PATCH 4.19 068/346] ixgbe: avoid premature Rx buffer reuse
Date:   Mon, 28 Dec 2020 13:46:27 +0100
Message-Id: <20201228124923.086677040@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit a06316dc87bdc000f7f39a315476957af2ba0f05 ]

The page recycle code, incorrectly, relied on that a page fragment
could not be freed inside xdp_do_redirect(). This assumption leads to
that page fragments that are used by the stack/XDP redirect can be
reused and overwritten.

To avoid this, store the page count prior invoking xdp_do_redirect().

Fixes: 6453073987ba ("ixgbe: add initial support for xdp redirect")
Reported-and-analyzed-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: Sandeep Penigalapati <sandeep.penigalapati@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 +++++++++++++------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 4243ff4ec4b1d..faee77fa08044 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1943,7 +1943,8 @@ static inline bool ixgbe_page_is_reserved(struct page *page)
 	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
-static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer)
+static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer,
+				    int rx_buffer_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
@@ -1954,7 +1955,7 @@ static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_ref_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 	/* The last offset is a bit aggressive in that we assume the
@@ -2019,11 +2020,18 @@ static void ixgbe_add_rx_frag(struct ixgbe_ring *rx_ring,
 static struct ixgbe_rx_buffer *ixgbe_get_rx_buffer(struct ixgbe_ring *rx_ring,
 						   union ixgbe_adv_rx_desc *rx_desc,
 						   struct sk_buff **skb,
-						   const unsigned int size)
+						   const unsigned int size,
+						   int *rx_buffer_pgcnt)
 {
 	struct ixgbe_rx_buffer *rx_buffer;
 
 	rx_buffer = &rx_ring->rx_buffer_info[rx_ring->next_to_clean];
+	*rx_buffer_pgcnt =
+#if (PAGE_SIZE < 8192)
+		page_count(rx_buffer->page);
+#else
+		0;
+#endif
 	prefetchw(rx_buffer->page);
 	*skb = rx_buffer->skb;
 
@@ -2053,9 +2061,10 @@ static struct ixgbe_rx_buffer *ixgbe_get_rx_buffer(struct ixgbe_ring *rx_ring,
 
 static void ixgbe_put_rx_buffer(struct ixgbe_ring *rx_ring,
 				struct ixgbe_rx_buffer *rx_buffer,
-				struct sk_buff *skb)
+				struct sk_buff *skb,
+				int rx_buffer_pgcnt)
 {
-	if (ixgbe_can_reuse_rx_page(rx_buffer)) {
+	if (ixgbe_can_reuse_rx_page(rx_buffer, rx_buffer_pgcnt)) {
 		/* hand second half of page back to the ring */
 		ixgbe_reuse_rx_page(rx_ring, rx_buffer);
 	} else {
@@ -2299,6 +2308,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		union ixgbe_adv_rx_desc *rx_desc;
 		struct ixgbe_rx_buffer *rx_buffer;
 		struct sk_buff *skb;
+		int rx_buffer_pgcnt;
 		unsigned int size;
 
 		/* return some buffers to hardware, one at a time is too slow */
@@ -2318,7 +2328,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		 */
 		dma_rmb();
 
-		rx_buffer = ixgbe_get_rx_buffer(rx_ring, rx_desc, &skb, size);
+		rx_buffer = ixgbe_get_rx_buffer(rx_ring, rx_desc, &skb, size, &rx_buffer_pgcnt);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -2360,7 +2370,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			break;
 		}
 
-		ixgbe_put_rx_buffer(rx_ring, rx_buffer, skb);
+		ixgbe_put_rx_buffer(rx_ring, rx_buffer, skb, rx_buffer_pgcnt);
 		cleaned_count++;
 
 		/* place incomplete frames back on ring for completion */
-- 
2.27.0



