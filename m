Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BB359D7D0
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242509AbiHWJmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352010AbiHWJks (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:40:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B49BE7961A;
        Tue, 23 Aug 2022 01:41:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65F0EB81C5C;
        Tue, 23 Aug 2022 08:40:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5700C433D6;
        Tue, 23 Aug 2022 08:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244053;
        bh=DWD3GZq6j5zEbQtORBVne/OcWKHdw1NZa8O3C6p2FYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z67WTOw1lM1FhrsKn4/dicyMlgPWi9yQQqGXkwGZodtQrE8MC9CPNtVbkkaGg3vYx
         gxf8XuS/ZluEi+XCJ6hlW1mXGrLs5FfWgWI5Hu6Pxe09rDet+Qbt3Yu03bn0m902DY
         pHmzgSvrSU7i7u9s0yxHcvKUzPwcw3jEV9NOFSD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 079/229] can: pch_can: do not report txerr and rxerr during bus-off
Date:   Tue, 23 Aug 2022 10:24:00 +0200
Message-Id: <20220823080056.547384526@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

[ Upstream commit 3a5c7e4611ddcf0ef37a3a17296b964d986161a6 ]

During bus off, the error count is greater than 255 and can not fit in
a u8.

Fixes: 0c78ab76a05c ("pch_can: Add setting TEC/REC statistics processing")
Link: https://lore.kernel.org/all/20220719143550.3681-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/pch_can.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/pch_can.c b/drivers/net/can/pch_can.c
index ced11ea89269..3e1d71c70b0d 100644
--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -507,6 +507,9 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 		cf->can_id |= CAN_ERR_BUSOFF;
 		priv->can.can_stats.bus_off++;
 		can_bus_off(ndev);
+	} else {
+		cf->data[6] = errc & PCH_TEC;
+		cf->data[7] = (errc & PCH_REC) >> 8;
 	}
 
 	errc = ioread32(&priv->regs->errc);
@@ -567,9 +570,6 @@ static void pch_can_error(struct net_device *ndev, u32 status)
 		break;
 	}
 
-	cf->data[6] = errc & PCH_TEC;
-	cf->data[7] = (errc & PCH_REC) >> 8;
-
 	priv->can.state = state;
 	netif_receive_skb(skb);
 
-- 
2.35.1



