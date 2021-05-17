Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF9B3835EB
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243516AbhEQP0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243682AbhEQPYL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:24:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8122661C9A;
        Mon, 17 May 2021 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262136;
        bh=D6fmC4gZpD8AbyvGF5N25mGb+CJw0maURT2579qM7zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DjOzEt6gxdqWYZ89bihmbaC1rzkLJ6cMs7NusqArH+K6sa7xHBMMqnJGigdHBhs7V
         MiI8OFH/R7jqn7QgNtm/sx3IgXa17m27eoMHejKXzrIiATkt8i5GPRCUyta4yfjHFz
         jtx29VMKNQ5ytzhx6pyOSM9lssv9bhWwSJmE/n2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 224/329] i40e: fix broken XDP support
Date:   Mon, 17 May 2021 16:02:15 +0200
Message-Id: <20210517140309.698128290@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit ae4393dfd472b194c90d75d2123105fb5ed59b04 ]

Commit 12738ac4754e ("i40e: Fix sparse errors in i40e_txrx.c") broke
XDP support in the i40e driver. That commit was fixing a sparse error
in the code by introducing a new variable xdp_res instead of
overloading this into the skb pointer. The problem is that the code
later uses the skb pointer in if statements and these where not
extended to also test for the new xdp_res variable. Fix this by adding
the correct tests for xdp_res in these places.

The skb pointer was used to store the result of the XDP program by
overloading the results in the error pointer
ERR_PTR(-result). Therefore, the allocation failure test that used to
only test for !skb now need to be extended to also consider !xdp_res.

i40e_cleanup_headers() had a check that based on the skb value being
an error pointer, i.e. a result from the XDP program != XDP_PASS, and
if so start to process a new packet immediately, instead of populating
skb fields and sending the skb to the stack. This check is not needed
anymore, since we have added an explicit test for xdp_res being set
and if so just do continue to pick the next packet from the NIC.

Fixes: 12738ac4754e ("i40e: Fix sparse errors in i40e_txrx.c")
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 92ce835bc79e..c779512f44f4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1821,10 +1821,6 @@ static bool i40e_cleanup_headers(struct i40e_ring *rx_ring, struct sk_buff *skb,
 				 union i40e_rx_desc *rx_desc)
 
 {
-	/* XDP packets use error pointer so abort at this point */
-	if (IS_ERR(skb))
-		return true;
-
 	/* ERR_MASK will only have valid bits if EOP set, and
 	 * what we are doing here is actually checking
 	 * I40E_RX_DESC_ERROR_RXE_SHIFT, since it is the zeroth bit in
@@ -2437,7 +2433,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 		}
 
 		/* exit if we failed to retrieve a buffer */
-		if (!skb) {
+		if (!xdp_res && !skb) {
 			rx_ring->rx_stats.alloc_buff_failed++;
 			rx_buffer->pagecnt_bias++;
 			break;
@@ -2449,7 +2445,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget)
 		if (i40e_is_non_eop(rx_ring, rx_desc, skb))
 			continue;
 
-		if (i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
+		if (xdp_res || i40e_cleanup_headers(rx_ring, skb, rx_desc)) {
 			skb = NULL;
 			continue;
 		}
-- 
2.30.2



