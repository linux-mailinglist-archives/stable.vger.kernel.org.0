Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1BA666485B
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238899AbjAJSLO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238930AbjAJSKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6038715723
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:08:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09E66B81905
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:08:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 621C4C433F2;
        Tue, 10 Jan 2023 18:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374091;
        bh=/CFWjlEv1k5sF1WtWPeQYPJ2W/TyBqJHil37cYtaW3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0nzu3wNndz7IdbGNDe9eDWSrXnYxAHfwGOiS+Wo2/2uGl3GvAmT9lpAOvk0VZ9sGh
         4HzsR3z7qJfEZowfA3IY8KfrRCvxl08b3Amq5epMGR0lr0q582qpYl7Dov4RK3lP4Z
         +Do6aGx8reEmksnZnQ1VEW7WlT8tPqBEou0IOP68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Robin Cowley <robin.cowley@thehutgroup.com>,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.0 019/148] ice: xsk: do not use xdp_return_frame() on tx_buf->raw_buf
Date:   Tue, 10 Jan 2023 19:02:03 +0100
Message-Id: <20230110180017.811590778@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 53fc61be273a1e76dd5e356f91805dce00ff2d2c ]

Previously ice XDP xmit routine was changed in a way that it avoids
xdp_buff->xdp_frame conversion as it is simply not needed for handling
XDP_TX action and what is more it saves us CPU cycles. This routine is
re-used on ZC driver to handle XDP_TX action.

Although for XDP_TX on Rx ZC xdp_buff that comes from xsk_buff_pool is
converted to xdp_frame, xdp_frame itself is not stored inside
ice_tx_buf, we only store raw data pointer. Casting this pointer to
xdp_frame and calling against it xdp_return_frame in
ice_clean_xdp_tx_buf() results in undefined behavior.

To fix this, simply call page_frag_free() on tx_buf->raw_buf.
Later intention is to remove the buff->frame conversion in order to
simplify the codebase and improve XDP_TX performance on ZC.

Fixes: 126cdfe1007a ("ice: xsk: Improve AF_XDP ZC Tx and use batching API")
Reported-and-tested-by: Robin Cowley <robin.cowley@thehutgroup.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Piotr Raczynski <piotr.raczynski@.intel.com>
Link: https://lore.kernel.org/r/20221220175448.693999-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 056c904b83cc..79fa65d1cf20 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -772,7 +772,7 @@ int ice_clean_rx_irq_zc(struct ice_rx_ring *rx_ring, int budget)
 static void
 ice_clean_xdp_tx_buf(struct ice_tx_ring *xdp_ring, struct ice_tx_buf *tx_buf)
 {
-	xdp_return_frame((struct xdp_frame *)tx_buf->raw_buf);
+	page_frag_free(tx_buf->raw_buf);
 	xdp_ring->xdp_tx_active--;
 	dma_unmap_single(xdp_ring->dev, dma_unmap_addr(tx_buf, dma),
 			 dma_unmap_len(tx_buf, len), DMA_TO_DEVICE);
-- 
2.35.1



