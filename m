Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79C359A109
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351899AbiHSQND (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352132AbiHSQLd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:11:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2BEF113DD5;
        Fri, 19 Aug 2022 08:57:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5773361789;
        Fri, 19 Aug 2022 15:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0ACC433D7;
        Fri, 19 Aug 2022 15:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924644;
        bh=LDc5v2TEHp05C8b2r86tDhiTfn3L0KsfkxXXLoe6Xp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwLv4UtPj0BEGBnvjSjVBoVG142XvFm1wzUwXFpZpgdgrIIvbhf4QlgyCVyQtqMEG
         +hR4Jyz8f2z/HijZzoLmGaVyknaFNklAS5ru1Q/8FWxqDwPqvjiVsRCs9Mbf+asOxl
         tCgndAhWkrCVRb1q7MJRSImXS69WvauAU+tgrAgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/545] can: rcar_can: do not report txerr and rxerr during bus-off
Date:   Fri, 19 Aug 2022 17:40:06 +0200
Message-Id: <20220819153839.918798025@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 3570a4de0085..134eda66f0dc 100644
--- a/drivers/net/can/rcar/rcar_can.c
+++ b/drivers/net/can/rcar/rcar_can.c
@@ -235,11 +235,8 @@ static void rcar_can_error(struct net_device *ndev)
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
@@ -339,6 +336,9 @@ static void rcar_can_error(struct net_device *ndev)
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



