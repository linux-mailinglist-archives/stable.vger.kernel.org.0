Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFA14F3177
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242692AbiDEJh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbiDEJDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:03:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6585AE4F;
        Tue,  5 Apr 2022 01:55:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17721B81C19;
        Tue,  5 Apr 2022 08:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C42EC385A0;
        Tue,  5 Apr 2022 08:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148901;
        bh=lW0GnhFU2cI0e0ni70gC6pNauWpnvH3ZEvAeWn0F9os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhhNd1ocEhNEEAi81SdRtfcuUksAxyt9ERamRpI+ruSuwjH5/Ecs2RNz0CO5Lmph1
         +K1sPlQPjo4lelfk/Sk8CoOFNBr4rKHFASK+Tynb2ZCcH9m0vS2rB9/pkWWnoBYJHc
         74ttB+Dzb7PpcnsR8GQlJG9J/a9zKWGstL7k4mLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0523/1017] i40e: remove dead stores on XSK hotpath
Date:   Tue,  5 Apr 2022 09:23:56 +0200
Message-Id: <20220405070409.820437020@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Alexander Lobakin <alexandr.lobakin@intel.com>

[ Upstream commit 7e1b54d07751edcbf23c7211508abf5667b490ee ]

The 'if (ntu == rx_ring->count)' block in i40e_alloc_rx_buffers_zc()
was previously residing in the loop, but after introducing the
batched interface it is used only to wrap-around the NTU descriptor,
thus no more need to assign 'xdp'.

'cleaned_count' in i40e_clean_rx_irq_zc() was previously being
incremented in the loop, but after commit f12738b6ec06
("i40e: remove unnecessary cleaned_count updates") it gets
assigned only once after it, so the initialization can be dropped.

Fixes: 6aab0bb0c5cd ("i40e: Use the xsk batched rx allocation interface")
Fixes: f12738b6ec06 ("i40e: remove unnecessary cleaned_count updates")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 2553b130108d..0e8cf275e084 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -218,7 +218,6 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 	ntu += nb_buffs;
 	if (ntu == rx_ring->count) {
 		rx_desc = I40E_RX_DESC(rx_ring, 0);
-		xdp = i40e_rx_bi(rx_ring, 0);
 		ntu = 0;
 	}
 
@@ -328,11 +327,11 @@ static void i40e_handle_xdp_result_zc(struct i40e_ring *rx_ring,
 int i40e_clean_rx_irq_zc(struct i40e_ring *rx_ring, int budget)
 {
 	unsigned int total_rx_bytes = 0, total_rx_packets = 0;
-	u16 cleaned_count = I40E_DESC_UNUSED(rx_ring);
 	u16 next_to_clean = rx_ring->next_to_clean;
 	u16 count_mask = rx_ring->count - 1;
 	unsigned int xdp_res, xdp_xmit = 0;
 	bool failure = false;
+	u16 cleaned_count;
 
 	while (likely(total_rx_packets < (unsigned int)budget)) {
 		union i40e_rx_desc *rx_desc;
-- 
2.34.1



