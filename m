Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1935C594A3B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355393AbiHOX4D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356531AbiHOXyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:54:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094EE1617E4;
        Mon, 15 Aug 2022 13:19:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 825EEB81135;
        Mon, 15 Aug 2022 20:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB34FC433D7;
        Mon, 15 Aug 2022 20:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594768;
        bh=KjpTREGfDX1i7sYjb8h6LrLMdereyImHgHdSfSNAH0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0oTAkrJN0gzQtTI+6Via+2hKmw6TtwFsIO5r7PI7MaitD0KMijmb6djl1H69GP8Nx
         PhXGyzDYBhaEQQd94AOcnlme0LgzJZM21sQNHArTHUrmQD0rLDx32QaTbtbKl67Qr5
         XM9UwP4RtvbScYSQT88VzJEPuNP942qLtCCSp5CE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0521/1157] can: kvaser_usb_hydra: do not report txerr and rxerr during bus-off
Date:   Mon, 15 Aug 2022 19:57:57 +0200
Message-Id: <20220815180500.535214341@linuxfoundation.org>
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

[ Upstream commit 936e90595376e64b6247c72d3ea8b8b164b7ac96 ]

During bus off, the error count is greater than 255 and can not fit in
a u8.

Fixes: aec5fb2268b7 ("can: kvaser_usb: Add support for Kvaser USB hydra family")
Link: https://lore.kernel.org/all/20220719143550.3681-8-mailhol.vincent@wanadoo.fr
CC: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 5d70844ac030..404093468b2f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -917,8 +917,10 @@ static void kvaser_usb_hydra_update_state(struct kvaser_usb_net_priv *priv,
 	    new_state < CAN_STATE_BUS_OFF)
 		priv->can.can_stats.restarts++;
 
-	cf->data[6] = bec->txerr;
-	cf->data[7] = bec->rxerr;
+	if (new_state != CAN_STATE_BUS_OFF) {
+		cf->data[6] = bec->txerr;
+		cf->data[7] = bec->rxerr;
+	}
 
 	netif_rx(skb);
 }
@@ -1069,8 +1071,10 @@ kvaser_usb_hydra_error_frame(struct kvaser_usb_net_priv *priv,
 	shhwtstamps->hwtstamp = hwtstamp;
 
 	cf->can_id |= CAN_ERR_BUSERROR;
-	cf->data[6] = bec.txerr;
-	cf->data[7] = bec.rxerr;
+	if (new_state != CAN_STATE_BUS_OFF) {
+		cf->data[6] = bec.txerr;
+		cf->data[7] = bec.rxerr;
+	}
 
 	netif_rx(skb);
 
-- 
2.35.1



