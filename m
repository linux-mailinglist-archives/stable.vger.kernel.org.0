Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C8159D8E9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241546AbiHWJmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351922AbiHWJkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:40:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF1479A48;
        Tue, 23 Aug 2022 01:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BEE60B81C66;
        Tue, 23 Aug 2022 08:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C65C433D6;
        Tue, 23 Aug 2022 08:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244068;
        bh=k6l0jTys9X4jNwGOb/WlS1JIPlY5G2K38bc4mbzN3tQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C59lMywTMRk5BYqFRUy/SxZOBojurhVJeTj8pwlBUIHCpMNDP5+JXiBSn59pssYM/
         RKhXPWej4wJNUyfTkMeswJQiojiOBpXZ1PGyXhgIcq3yJlMOEN3x2JRMITiglZl5Re
         TTbedqXAv0PdEQ0qaC9AO2c9GVcMuQ7C0/3ZK9uY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 081/229] can: sja1000: do not report txerr and rxerr during bus-off
Date:   Tue, 23 Aug 2022 10:24:02 +0200
Message-Id: <20220823080056.613928207@linuxfoundation.org>
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

[ Upstream commit 164d7cb2d5a30f1b3a5ab4fab1a27731fb1494a8 ]

During bus off, the error count is greater than 255 and can not fit in
a u8.

Fixes: 215db1856e83 ("can: sja1000: Consolidate and unify state change handling")
Link: https://lore.kernel.org/all/20220719143550.3681-4-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sja1000/sja1000.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 9f107798f904..e7327ceabb76 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -405,9 +405,6 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 	txerr = priv->read_reg(priv, SJA1000_TXERR);
 	rxerr = priv->read_reg(priv, SJA1000_RXERR);
 
-	cf->data[6] = txerr;
-	cf->data[7] = rxerr;
-
 	if (isrc & IRQ_DOI) {
 		/* data overrun interrupt */
 		netdev_dbg(dev, "data overrun interrupt\n");
@@ -429,6 +426,10 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 		else
 			state = CAN_STATE_ERROR_ACTIVE;
 	}
+	if (state != CAN_STATE_BUS_OFF) {
+		cf->data[6] = txerr;
+		cf->data[7] = rxerr;
+	}
 	if (isrc & IRQ_BEI) {
 		/* bus error interrupt */
 		priv->can.can_stats.bus_error++;
-- 
2.35.1



