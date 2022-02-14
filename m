Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDFC4B498E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344546AbiBNKAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:00:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343842AbiBNJ72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:59:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8578C2C;
        Mon, 14 Feb 2022 01:46:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44F7361287;
        Mon, 14 Feb 2022 09:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4059C340E9;
        Mon, 14 Feb 2022 09:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832014;
        bh=KkVFtQgWDU8kC8bkFKYteuVKgn36OiBQyAW0ygsQ71w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wEsnRRzy2OozEIEZ4ObpMKh7oNqhKBbqiTmicFb8sbJv8Ptrdql3s9gjhKeF2RHL
         9jr/Q1ZGpnfmlBELnbNfeq2K+SELKyZI3XUEGsNSbbngomygVFSJsABs07G4rCOEsL
         O2noxFUagGHYvl1Wku8YQ+uPCKMqWyKEAImpckHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jisheng Zhang <jszhang@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/172] net: stmmac: reduce unnecessary wakeups from eee sw timer
Date:   Mon, 14 Feb 2022 10:25:10 +0100
Message-Id: <20220214092508.180040913@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit c74ead223deb88bdf18af8c772d7ca5a9b6c3c2b ]

Currently, on EEE capable platforms, if EEE SW timer is used, the SW
timer cause 1 wakeup/s even if the TX has successfully entered EEE.
Remove this unnecessary wakeup by only calling mod_timer() if we
haven't successfully entered EEE.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 161e65333ed94..e6af26b2dcb81 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -400,7 +400,7 @@ static void stmmac_lpi_entry_timer_config(struct stmmac_priv *priv, bool en)
  * Description: this function is to verify and enter in LPI mode in case of
  * EEE.
  */
-static void stmmac_enable_eee_mode(struct stmmac_priv *priv)
+static int stmmac_enable_eee_mode(struct stmmac_priv *priv)
 {
 	u32 tx_cnt = priv->plat->tx_queues_to_use;
 	u32 queue;
@@ -410,13 +410,14 @@ static void stmmac_enable_eee_mode(struct stmmac_priv *priv)
 		struct stmmac_tx_queue *tx_q = &priv->tx_queue[queue];
 
 		if (tx_q->dirty_tx != tx_q->cur_tx)
-			return; /* still unfinished work */
+			return -EBUSY; /* still unfinished work */
 	}
 
 	/* Check and enter in LPI mode */
 	if (!priv->tx_path_in_lpi_mode)
 		stmmac_set_eee_mode(priv, priv->hw,
 				priv->plat->en_tx_lpi_clockgating);
+	return 0;
 }
 
 /**
@@ -448,8 +449,8 @@ static void stmmac_eee_ctrl_timer(struct timer_list *t)
 {
 	struct stmmac_priv *priv = from_timer(priv, t, eee_ctrl_timer);
 
-	stmmac_enable_eee_mode(priv);
-	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
+	if (stmmac_enable_eee_mode(priv))
+		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
 }
 
 /**
@@ -2637,8 +2638,8 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 	if (priv->eee_enabled && !priv->tx_path_in_lpi_mode &&
 	    priv->eee_sw_timer_en) {
-		stmmac_enable_eee_mode(priv);
-		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
+		if (stmmac_enable_eee_mode(priv))
+			mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
 	}
 
 	/* We still have pending packets, let's call for a new scheduling */
-- 
2.34.1



