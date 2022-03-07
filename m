Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184834CFABB
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbiCGKWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240024AbiCGKSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:18:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6104BCB0;
        Mon,  7 Mar 2022 01:57:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD76BB810B9;
        Mon,  7 Mar 2022 09:56:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3828C340F4;
        Mon,  7 Mar 2022 09:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646647012;
        bh=g57ENI8NMG7c24aILqIhKs7YngNbExCyU6rBDAMrUSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1snrsPNZqLH8GknPOQ+WQz6DWdDq2/ULgO09mAh/ioh+Zzg7bqH2STrat87l4lZo5
         gkVgU5o8ynx4PLeJOUFmrZ91OrZzhKu16X0Auhdal/1HA0PrCj6OQzCcBbXqdK4Foc
         rBs1w+HaKTi/tctVkkwG3VfiXTAIUZyOtsmS1URg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ong Boon Leong <boon.leong.ong@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 165/186] net: stmmac: perserve TX and RX coalesce value during XDP setup
Date:   Mon,  7 Mar 2022 10:20:03 +0100
Message-Id: <20220307091658.691008182@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

commit 61da6ac715700bcfeef50d187e15c6cc7c9d079b upstream.

When XDP program is loaded, it is desirable that the previous TX and RX
coalesce values are not re-inited to its default value. This prevents
unnecessary re-configurig the coalesce values that were working fine
before.

Fixes: ac746c8520d9 ("net: stmmac: enhance XDP ZC driver level switching performance")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
Link: https://lore.kernel.org/r/20211124114019.3949125-1-boon.leong.ong@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6596,6 +6596,9 @@ int stmmac_xdp_open(struct net_device *d
 		tx_q->tx_tail_addr = tx_q->dma_tx_phy;
 		stmmac_set_tx_tail_ptr(priv, priv->ioaddr,
 				       tx_q->tx_tail_addr, chan);
+
+		hrtimer_init(&tx_q->txtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		tx_q->txtimer.function = stmmac_tx_timer;
 	}
 
 	/* Enable the MAC Rx/Tx */
@@ -6604,8 +6607,6 @@ int stmmac_xdp_open(struct net_device *d
 	/* Start Rx & Tx DMA Channels */
 	stmmac_start_all_dma(priv);
 
-	stmmac_init_coalesce(priv);
-
 	ret = stmmac_request_irq(dev);
 	if (ret)
 		goto irq_error;


