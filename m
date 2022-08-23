Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E44159E01F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348015AbiHWLY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241158AbiHWLXG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:23:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCBB5E64D;
        Tue, 23 Aug 2022 02:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E5EFB81C86;
        Tue, 23 Aug 2022 09:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607F7C433D6;
        Tue, 23 Aug 2022 09:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246614;
        bh=VunSmMk6ohgZxQawrwkQqpADKI+MC2Xf+apOUCRcVf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2A2XD7VnWlp7U1p0VcQTwK67rVixzx4g1kZxASL8YpPtSxVKiLf/hLjE4fLzZrdB
         gOPIbGPKidYiRfP7DqV/49dt5UVkBZAlVCfCncKfCPGV8mAT+jzFtlmaI8WGPfNSrO
         O/Ra82BZzYAvy729lB9fUqkMWKjajnsl8semNfxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 135/389] can: sun4i_can: do not report txerr and rxerr during bus-off
Date:   Tue, 23 Aug 2022 10:23:33 +0200
Message-Id: <20220823080121.255592651@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

[ Upstream commit 0ac15a8f661b941519379831d09bfb12271b23ee ]

During bus off, the error count is greater than 255 and can not fit in
a u8.

Fixes: 0738eff14d81 ("can: Allwinner A10/A20 CAN Controller support - Kernel module")
Link: https://lore.kernel.org/all/20220719143550.3681-7-mailhol.vincent@wanadoo.fr
CC: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sun4i_can.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index f4cd88196404..c519b6f63b33 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -525,11 +525,6 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
 	rxerr = (errc >> 16) & 0xFF;
 	txerr = errc & 0xFF;
 
-	if (skb) {
-		cf->data[6] = txerr;
-		cf->data[7] = rxerr;
-	}
-
 	if (isrc & SUN4I_INT_DATA_OR) {
 		/* data overrun interrupt */
 		netdev_dbg(dev, "data overrun interrupt\n");
@@ -560,6 +555,10 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
 		else
 			state = CAN_STATE_ERROR_ACTIVE;
 	}
+	if (skb && state != CAN_STATE_BUS_OFF) {
+		cf->data[6] = txerr;
+		cf->data[7] = rxerr;
+	}
 	if (isrc & SUN4I_INT_BUS_ERR) {
 		/* bus error interrupt */
 		netdev_dbg(dev, "bus error interrupt\n");
-- 
2.35.1



