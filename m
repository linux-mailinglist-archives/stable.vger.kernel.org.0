Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DD3594932
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355270AbiHOXzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356509AbiHOXyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:54:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9478716101D;
        Mon, 15 Aug 2022 13:19:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE769B81136;
        Mon, 15 Aug 2022 20:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11103C433C1;
        Mon, 15 Aug 2022 20:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594755;
        bh=R6stR1XDXcR4UhrtoDaEKY1aUuGWKo8noBF9JPYHjng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lpNa2a109kjWAFX65GydCQJcstB6AeEz8YSVDOEo9Y5kyOkafFP3IdlFJRXKR6Zu/
         VxgUPwTGOz2YSLPeAZ05BsPKPv5wOTMNYavfJiu8z+jZi5Jyg4TfOCN0UTjDt1qOKT
         CnREGTsdUSo8pnAqLrjteL6K/LvdiaEmgCouoOlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0517/1157] can: rcar_can: do not report txerr and rxerr during bus-off
Date:   Mon, 15 Aug 2022 19:57:53 +0200
Message-Id: <20220815180500.384810585@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit a37b7245e831a641df360ca41db6a71c023d3746 ]

During bus off, the error count is greater than 255 and can not fit in
a u8.

Fixes: fd1159318e55 ("can: add Renesas R-Car CAN driver")
Link: https://lore.kernel.org/all/20220719143550.3681-3-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/rcar/rcar_can.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/rcar/rcar_can.c b/drivers/net/can/rcar/rcar_can.c
index d45762f1cf6b..24d7a71def6a 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -232,11 +232,8 @@ static void rcar_can_error(struct net_device *ndev)
 	if (eifr & (RCAR_CAN_EIFR_EWIF | RCAR_CAN_EIFR_EPIF)) {
 		txerr = readb(&priv->regs->tecr);
 		rxerr = readb(&priv->regs->recr);
-		if (skb) {
+		if (skb)
 			cf->can_id |= CAN_ERR_CRTL;
-			cf->data[6] = txerr;
-			cf->data[7] = rxerr;
-		}
 	}
 	if (eifr & RCAR_CAN_EIFR_BEIF) {
 		int rx_errors = 0, tx_errors = 0;
@@ -336,6 +333,9 @@ static void rcar_can_error(struct net_device *ndev)
 		can_bus_off(ndev);
 		if (skb)
 			cf->can_id |= CAN_ERR_BUSOFF;
+	} else if (skb) {
+		cf->data[6] = txerr;
+		cf->data[7] = rxerr;
 	}
 	if (eifr & RCAR_CAN_EIFR_ORIF) {
 		netdev_dbg(priv->ndev, "Receive overrun error interrupt\n");
-- 
2.35.1



