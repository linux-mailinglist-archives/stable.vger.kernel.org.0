Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7EB59406E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbiHOVMR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343972AbiHOVLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:11:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF142564CB;
        Mon, 15 Aug 2022 12:19:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C8A2B81123;
        Mon, 15 Aug 2022 19:19:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAA7C433C1;
        Mon, 15 Aug 2022 19:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591155;
        bh=mOJiTfYXXghttqqDx/jhCa0gwW/IhXfWePwJX7Lm2Ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ryusZDU+c6p2Qksc5GqJSBJyNva3+podBcUZi15esiWD3uKNTOdN8LfxlirrDzN55
         hbJUt/+mDp5NwVBe/G8gPMxfhpKMpdUJdLnk+5kEjMwxRyG83Yz5Pc5ljpezETqJYk
         iNtOq+o627YSVELPY+xQyROtsYsPEwAK1gs2aiWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0489/1095] can: sun4i_can: do not report txerr and rxerr during bus-off
Date:   Mon, 15 Aug 2022 19:58:08 +0200
Message-Id: <20220815180449.768645301@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 25d6d81ab4f4..f3ad585e766f 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -538,11 +538,6 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
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
@@ -573,6 +568,10 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
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



