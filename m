Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBEB4FD26A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346765AbiDLHLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350057AbiDLHJP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:09:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7AD49F96;
        Mon, 11 Apr 2022 23:49:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89DF3B81B51;
        Tue, 12 Apr 2022 06:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02D0C385A8;
        Tue, 12 Apr 2022 06:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746179;
        bh=DI2OLZuJYTJKh/eDk6ZeULcIY4vdi2GMVgMYgoJDwpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sJ886k7Df4QD0IVNAZHcBdGR88DZW9LrWn2TdQVPxDbuRcC7JxIxe/rBHtv8R/RbZ
         NFWoEo+Ph4gFlFPII7TJmFjHAfk3qyE+2Xv7G9E/5WAV1lUKL3siSIf4r7XCDT+F2P
         jVs8Me6aDSndnj0xbfZw5fH/RmiFXfRBeAFrpoYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Habets <habetsm.xilinx@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/277] net: sfc: fix using uninitialized xdp tx_queue
Date:   Tue, 12 Apr 2022 08:29:53 +0200
Message-Id: <20220412062947.534897741@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
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

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit fb5833d81e4333294add35d3ac7f7f52a7bf107f ]

In some cases, xdp tx_queue can get used before initialization.
1. interface up/down
2. ring buffer size change

When CPU cores are lower than maximum number of channels of sfc driver,
it creates new channels only for XDP.

When an interface is up or ring buffer size is changed, all channels
are initialized.
But xdp channels are always initialized later.
So, the below scenario is possible.
Packets are received to rx queue of normal channels and it is acted
XDP_TX and tx_queue of xdp channels get used.
But these tx_queues are not initialized yet.
If so, TX DMA or queue error occurs.

In order to avoid this problem.
1. initializes xdp tx_queues earlier than other rx_queue in
efx_start_channels().
2. checks whether tx_queue is initialized or not in efx_xdp_tx_buffers().

Splat looks like:
   sfc 0000:08:00.1 enp8s0f1np1: TX queue 10 spurious TX completion id 250
   sfc 0000:08:00.1 enp8s0f1np1: resetting (RECOVER_OR_ALL)
   sfc 0000:08:00.1 enp8s0f1np1: MC command 0x80 inlen 100 failed rc=-22
   (raw=22) arg=789
   sfc 0000:08:00.1 enp8s0f1np1: has been disabled

Fixes: f28100cb9c96 ("sfc: fix lack of XDP TX queues - error XDP TX failed (-22)")
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_channels.c | 2 +-
 drivers/net/ethernet/sfc/tx.c           | 3 +++
 drivers/net/ethernet/sfc/tx_common.c    | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 4753c0c5af10..1f8cfd806008 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -1123,7 +1123,7 @@ void efx_start_channels(struct efx_nic *efx)
 	struct efx_rx_queue *rx_queue;
 	struct efx_channel *channel;
 
-	efx_for_each_channel(channel, efx) {
+	efx_for_each_channel_rev(channel, efx) {
 		efx_for_each_channel_tx_queue(tx_queue, channel) {
 			efx_init_tx_queue(tx_queue);
 			atomic_inc(&efx->active_queues);
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index d16e031e95f4..6983799e1c05 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -443,6 +443,9 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
 	if (unlikely(!tx_queue))
 		return -EINVAL;
 
+	if (!tx_queue->initialised)
+		return -EINVAL;
+
 	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED)
 		HARD_TX_LOCK(efx->net_dev, tx_queue->core_txq, cpu);
 
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index d530cde2b864..9bc8281b7f5b 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -101,6 +101,8 @@ void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
 	netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
 		  "shutting down TX queue %d\n", tx_queue->queue);
 
+	tx_queue->initialised = false;
+
 	if (!tx_queue->buffer)
 		return;
 
-- 
2.35.1



