Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8892E645C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391229AbgL1Nil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:38:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391211AbgL1Nij (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDC9F22472;
        Mon, 28 Dec 2020 13:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162678;
        bh=ZchJUxeM9kX9qvCkNrp2P9I+7X9g7U16EtoPx9lvG4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WVxP/gjpV60hCW86SjScrhKatRNQk+Qo5fBXOweiKE0hWwWKW7N2c2PI9G/sjUPy9
         pQOne8TbjnINzGZqGfPCAyCRtAVIDnaKNKTbyd5z9sB+vbMVyQoakCZNUntlLbXFEN
         SeofI8cTT/e4VbQrRNclkQR8RX+uhiGDDqFIr62I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Sandeep Penigalapati <sandeep.penigalapati@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Li RongQing <lirongqing@baidu.com>
Subject: [PATCH 5.4 034/453] ixgbe: avoid premature Rx buffer reuse
Date:   Mon, 28 Dec 2020 13:44:30 +0100
Message-Id: <20201228124938.905730498@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 5336bfcd2d701..f605540644035 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1947,7 +1947,8 @@ static inline bool ixgbe_page_is_reserved(struct page *page)
 	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
-static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer)
+static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer,
+				    int rx_buffer_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
@@ -1958,7 +1959,7 @@ static bool ixgbe_can_reuse_rx_page(struct ixgbe_rx_buffer *rx_buffer)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_ref_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buffer_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 	/* The last offset is a bit aggressive in that we assume the
@@ -2023,11 +2024,18 @@ static void ixgbe_add_rx_frag(struct ixgbe_ring *rx_ring,
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
 
@@ -2057,9 +2065,10 @@ static struct ixgbe_rx_buffer *ixgbe_get_rx_buffer(struct ixgbe_ring *rx_ring,
 
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
@@ -2295,6 +2304,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		union ixgbe_adv_rx_desc *rx_desc;
 		struct ixgbe_rx_buffer *rx_buffer;
 		struct sk_buff *skb;
+		int rx_buffer_pgcnt;
 		unsigned int size;
 
 		/* return some buffers to hardware, one at a time is too slow */
@@ -2314,7 +2324,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 		 */
 		dma_rmb();
 
-		rx_buffer = ixgbe_get_rx_buffer(rx_ring, rx_desc, &skb, size);
+		rx_buffer = ixgbe_get_rx_buffer(rx_ring, rx_desc, &skb, size, &rx_buffer_pgcnt);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -2356,7 +2366,7 @@ static int ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			break;
 		}
 
-		ixgbe_put_rx_buffer(rx_ring, rx_buffer, skb);
+		ixgbe_put_rx_buffer(rx_ring, rx_buffer, skb, rx_buffer_pgcnt);
 		cleaned_count++;
 
 		/* place incomplete frames back on ring for completion */
-- 
2.27.0



