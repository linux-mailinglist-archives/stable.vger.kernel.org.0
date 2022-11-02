Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C9561587B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbiKBCwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiKBCwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:52:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483D5220D3
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:52:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8125617CE
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB35C433B5;
        Wed,  2 Nov 2022 02:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357560;
        bh=xthj1xKzD/6hx4hSCARbjipAGWKIEkBELppOHk2izio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9zr/mpnc4i7fCf7H8455EtN2G6h9K1A5JZ+5bCP0P9WErutaESDwmMl9HGHUXX3G
         157I5S+33R0tIQuXLJt2q/bqQ/A7lqOZcmanNR2FZJN5Yqgx8M0HZ7NbA0Z1NG9/3H
         GZ3C7klG1EH8GmXa49FA4cjh8nAfin3kpw95qQkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 191/240] net: lan966x: Stop replacing tx dcbs and dcbs_buf when changing MTU
Date:   Wed,  2 Nov 2022 03:32:46 +0100
Message-Id: <20221102022115.713366413@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 4a4b6848d1e932b977e6a00cda393adf7e839ff8 ]

When a frame is sent using FDMA, the skb is mapped and then the mapped
address is given to an tx dcb that is different than the last used tx
dcb. Once the HW finish with this frame, it would generate an interrupt
and then the dcb can be reused and memory can be freed. For each dcb
there is an dcb buf that contains some meta-data(is used by PTP, is
it free). There is 1 to 1 relationship between dcb and dcb_buf.
The following issue was observed. That sometimes after changing the MTU
to allocate new tx dcbs and dcbs_buf, two frames were not
transmitted. The frames were not transmitted because when reloading the
tx dcbs, it was always presuming to use the first dcb but that was not
always happening. Because it could be that the last tx dcb used before
changing MTU was first dcb and then when it tried to get the next dcb it
would take dcb 1 instead of 0. Because it is supposed to take a
different dcb than the last used one. This can be fixed simply by
changing tx->last_in_use to -1 when the fdma is disabled to reload the
new dcb and dcbs_buff.
But there could be a different issue. For example, right after the frame
is sent, the MTU is changed. Now all the dcbs and dcbs_buf will be
cleared. And now get the interrupt from HW that it finished with the
frame. So when we try to clear the skb, it is not possible because we
lost all the dcbs_buf.
The solution here is to stop replacing the tx dcbs and dcbs_buf when
changing MTU because the TX doesn't care what is the MTU size, it is
only the RX that needs this information.

Fixes: 2ea1cbac267e ("net: lan966x: Update FDMA to change MTU.")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20221021090711.3749009-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/lan966x/lan966x_fdma.c | 24 +++----------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 51f8a0816377..69f741db25b1 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -309,6 +309,7 @@ static void lan966x_fdma_tx_disable(struct lan966x_tx *tx)
 		lan966x, FDMA_CH_DB_DISCARD);
 
 	tx->activated = false;
+	tx->last_in_use = -1;
 }
 
 static void lan966x_fdma_tx_reload(struct lan966x_tx *tx)
@@ -687,17 +688,14 @@ static int lan966x_qsys_sw_status(struct lan966x *lan966x)
 
 static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 {
-	void *rx_dcbs, *tx_dcbs, *tx_dcbs_buf;
-	dma_addr_t rx_dma, tx_dma;
+	dma_addr_t rx_dma;
+	void *rx_dcbs;
 	u32 size;
 	int err;
 
 	/* Store these for later to free them */
 	rx_dma = lan966x->rx.dma;
-	tx_dma = lan966x->tx.dma;
 	rx_dcbs = lan966x->rx.dcbs;
-	tx_dcbs = lan966x->tx.dcbs;
-	tx_dcbs_buf = lan966x->tx.dcbs_buf;
 
 	napi_synchronize(&lan966x->napi);
 	napi_disable(&lan966x->napi);
@@ -715,17 +713,6 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	size = ALIGN(size, PAGE_SIZE);
 	dma_free_coherent(lan966x->dev, size, rx_dcbs, rx_dma);
 
-	lan966x_fdma_tx_disable(&lan966x->tx);
-	err = lan966x_fdma_tx_alloc(&lan966x->tx);
-	if (err)
-		goto restore_tx;
-
-	size = sizeof(struct lan966x_tx_dcb) * FDMA_DCB_MAX;
-	size = ALIGN(size, PAGE_SIZE);
-	dma_free_coherent(lan966x->dev, size, tx_dcbs, tx_dma);
-
-	kfree(tx_dcbs_buf);
-
 	lan966x_fdma_wakeup_netdev(lan966x);
 	napi_enable(&lan966x->napi);
 
@@ -735,11 +722,6 @@ static int lan966x_fdma_reload(struct lan966x *lan966x, int new_mtu)
 	lan966x->rx.dcbs = rx_dcbs;
 	lan966x_fdma_rx_start(&lan966x->rx);
 
-restore_tx:
-	lan966x->tx.dma = tx_dma;
-	lan966x->tx.dcbs = tx_dcbs;
-	lan966x->tx.dcbs_buf = tx_dcbs_buf;
-
 	return err;
 }
 
-- 
2.35.1



