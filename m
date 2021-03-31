Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AC534C960
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhC2I3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233896AbhC2I1a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:27:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D2496197C;
        Mon, 29 Mar 2021 08:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006372;
        bh=sgr8tK8x+N4oQpocvskHvoLxipXGs5t+ArI37vnKWaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvWrObL2v36cQqprNGUiWJBO2zv/u48DqZ15u8SDi+SBb5I6mGsPXfqn71a3PZ+Z3
         0XhPJqEj7vsHC/tXGdycsLMl8C8yofolZ1Jsn2jsjViLtGaWvDRtHIF3h4/z3/J4fR
         9R8+iF/JXKjMOJCfS8/crqS+EKMO8EuaOlx3UVXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Vishakha Jambekar <vishakha.jambekar@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/221] igb: avoid premature Rx buffer reuse
Date:   Mon, 29 Mar 2021 09:58:33 +0200
Message-Id: <20210329075635.211881910@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 98dfb02aa22280bd8833836d1b00ab0488fa951f ]

Igb needs a similar fix as commit 75aab4e10ae6a ("i40e: avoid
premature Rx buffer reuse")

The page recycle code, incorrectly, relied on that a page fragment
could not be freed inside xdp_do_redirect(). This assumption leads to
that page fragments that are used by the stack/XDP redirect can be
reused and overwritten.

To avoid this, store the page count prior invoking xdp_do_redirect().

Longer explanation:

Intel NICs have a recycle mechanism. The main idea is that a page is
split into two parts. One part is owned by the driver, one part might
be owned by someone else, such as the stack.

t0: Page is allocated, and put on the Rx ring
              +---------------
used by NIC ->| upper buffer
(rx_buffer)   +---------------
              | lower buffer
              +---------------
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX

t1: Buffer is received, and passed to the stack (e.g.)
              +---------------
              | upper buff (skb)
              +---------------
used by NIC ->| lower buffer
(rx_buffer)   +---------------
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX - 1

t2: Buffer is received, and redirected
              +---------------
              | upper buff (skb)
              +---------------
used by NIC ->| lower buffer
(rx_buffer)   +---------------

Now, prior calling xdp_do_redirect():
  page count  == USHRT_MAX
  rx_buffer->pagecnt_bias == USHRT_MAX - 2

This means that buffer *cannot* be flipped/reused, because the skb is
still using it.

The problem arises when xdp_do_redirect() actually frees the
segment. Then we get:
  page count  == USHRT_MAX - 1
  rx_buffer->pagecnt_bias == USHRT_MAX - 2

>From a recycle perspective, the buffer can be flipped and reused,
which means that the skb data area is passed to the Rx HW ring!

To work around this, the page count is stored prior calling
xdp_do_redirect().

Fixes: 9cbc948b5a20 ("igb: add XDP support")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Tested-by: Vishakha Jambekar <vishakha.jambekar@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index ebe80ec6e437..fecfcfcf161c 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8232,7 +8232,8 @@ static inline bool igb_page_is_reserved(struct page *page)
 	return (page_to_nid(page) != numa_mem_id()) || page_is_pfmemalloc(page);
 }
 
-static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
+static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer,
+				  int rx_buf_pgcnt)
 {
 	unsigned int pagecnt_bias = rx_buffer->pagecnt_bias;
 	struct page *page = rx_buffer->page;
@@ -8243,7 +8244,7 @@ static bool igb_can_reuse_rx_page(struct igb_rx_buffer *rx_buffer)
 
 #if (PAGE_SIZE < 8192)
 	/* if we are only owner of page we can reuse it */
-	if (unlikely((page_ref_count(page) - pagecnt_bias) > 1))
+	if (unlikely((rx_buf_pgcnt - pagecnt_bias) > 1))
 		return false;
 #else
 #define IGB_LAST_OFFSET \
@@ -8633,11 +8634,17 @@ static unsigned int igb_rx_offset(struct igb_ring *rx_ring)
 }
 
 static struct igb_rx_buffer *igb_get_rx_buffer(struct igb_ring *rx_ring,
-					       const unsigned int size)
+					       const unsigned int size, int *rx_buf_pgcnt)
 {
 	struct igb_rx_buffer *rx_buffer;
 
 	rx_buffer = &rx_ring->rx_buffer_info[rx_ring->next_to_clean];
+	*rx_buf_pgcnt =
+#if (PAGE_SIZE < 8192)
+		page_count(rx_buffer->page);
+#else
+		0;
+#endif
 	prefetchw(rx_buffer->page);
 
 	/* we are reusing so sync this buffer for CPU use */
@@ -8653,9 +8660,9 @@ static struct igb_rx_buffer *igb_get_rx_buffer(struct igb_ring *rx_ring,
 }
 
 static void igb_put_rx_buffer(struct igb_ring *rx_ring,
-			      struct igb_rx_buffer *rx_buffer)
+			      struct igb_rx_buffer *rx_buffer, int rx_buf_pgcnt)
 {
-	if (igb_can_reuse_rx_page(rx_buffer)) {
+	if (igb_can_reuse_rx_page(rx_buffer, rx_buf_pgcnt)) {
 		/* hand second half of page back to the ring */
 		igb_reuse_rx_page(rx_ring, rx_buffer);
 	} else {
@@ -8682,6 +8689,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 	u16 cleaned_count = igb_desc_unused(rx_ring);
 	unsigned int xdp_xmit = 0;
 	struct xdp_buff xdp;
+	int rx_buf_pgcnt;
 
 	xdp.rxq = &rx_ring->xdp_rxq;
 
@@ -8712,7 +8720,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 		 */
 		dma_rmb();
 
-		rx_buffer = igb_get_rx_buffer(rx_ring, size);
+		rx_buffer = igb_get_rx_buffer(rx_ring, size, &rx_buf_pgcnt);
 
 		/* retrieve a buffer from the ring */
 		if (!skb) {
@@ -8755,7 +8763,7 @@ static int igb_clean_rx_irq(struct igb_q_vector *q_vector, const int budget)
 			break;
 		}
 
-		igb_put_rx_buffer(rx_ring, rx_buffer);
+		igb_put_rx_buffer(rx_ring, rx_buffer, rx_buf_pgcnt);
 		cleaned_count++;
 
 		/* fetch next buffer in frame if non-eop */
-- 
2.30.1



