Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A761564A1EA
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbiLLNrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbiLLNql (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:46:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F4311829
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:46:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 12982CE0F7D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1E59C433D2;
        Mon, 12 Dec 2022 13:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852792;
        bh=+NGKycjcMmD0kRBGzEFEgVT8Bbz8POQ7HEBpkc10hpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sn/CX4qZuL1f4wBgFF42ajwRBJg4QTfL+FHT7YHgsskGYk5nqFMd+/nmczMFIZPXI
         ayWaNHKS8eaEn1C2R1XepyeEToBsx5rZ45dWBLda+/f0he0w88FRIYYhhgKHQbDVgB
         RLSfuz7qfIfxq/aLHjr/bxtkjp/7FhdAW30rowVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Richard Donkin <richard.donkin@corigine.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 115/157] nfp: correct desc type when header dma len is 4096
Date:   Mon, 12 Dec 2022 14:17:43 +0100
Message-Id: <20221212130939.472392119@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Yinjun Zhang <yinjun.zhang@corigine.com>

[ Upstream commit 5c306de8f787ab7df51f846e57ac79cd713537d5 ]

When there's only one buffer to dma and its length is 4096, then
only one data descriptor is needed to carry it according to current
descriptor definition. So the descriptor type should be `simple`
instead of `gather`, the latter requires more than one descriptor,
otherwise it'll be dropped by application firmware.

Fixes: c10d12e3dce8 ("nfp: add support for NFDK data path")
Fixes: d9d950490a0a ("nfp: nfdk: implement xdp tx path for NFDK")
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Reviewed-by: Richard Donkin <richard.donkin@corigine.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221202134646.311108-1-simon.horman@corigine.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index 2b427d8ccb2f..ccacb6ab6c39 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -282,7 +282,7 @@ netdev_tx_t nfp_nfdk_tx(struct sk_buff *skb, struct net_device *netdev)
 	dma_len = skb_headlen(skb);
 	if (skb_is_gso(skb))
 		type = NFDK_DESC_TX_TYPE_TSO;
-	else if (!nr_frags && dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	else if (!nr_frags && dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
@@ -927,7 +927,7 @@ nfp_nfdk_tx_xdp_buf(struct nfp_net_dp *dp, struct nfp_net_rx_ring *rx_ring,
 	dma_len = pkt_len;
 	dma_addr = rxbuf->dma_addr + dma_off;
 
-	if (dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	if (dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
@@ -1325,7 +1325,7 @@ nfp_nfdk_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 	txbuf = &tx_ring->ktxbufs[wr_idx];
 
 	dma_len = skb_headlen(skb);
-	if (dma_len < NFDK_TX_MAX_DATA_PER_HEAD)
+	if (dma_len <= NFDK_TX_MAX_DATA_PER_HEAD)
 		type = NFDK_DESC_TX_TYPE_SIMPLE;
 	else
 		type = NFDK_DESC_TX_TYPE_GATHER;
-- 
2.35.1



