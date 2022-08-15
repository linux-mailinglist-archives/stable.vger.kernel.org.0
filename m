Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F60594F93
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiHPEaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiHPE35 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:29:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAA915B175;
        Mon, 15 Aug 2022 13:17:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2621B81135;
        Mon, 15 Aug 2022 20:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D489FC433C1;
        Mon, 15 Aug 2022 20:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594670;
        bh=Ck2+hCrQVgLQVzZ0ToyRALvKkwnPpjmXE+ci7kc4odo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAIWzghYXMOFjmlJotjh5t9xpcOQ5ZTKPSSuUHN3vCFIAYPGi1gM71fmvl+nlDbTK
         5+fzHydEEKc2/cFnxNxb8fz1lkbcB/x+038yCJqd7OF4rLE3uhNo0GyluevzhvAitJ
         gY5a015EUxcdBJ9SAYzRW+m7gTEaZ4xbocRncGFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0522/1157] can: kvaser_usb_leaf: do not report txerr and rxerr during bus-off
Date:   Mon, 15 Aug 2022 19:57:58 +0200
Message-Id: <20220815180500.564140469@linuxfoundation.org>
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

[ Upstream commit a57732084e06791d37ea1ea447cca46220737abd ]

During bus off, the error count is greater than 255 and can not fit in
a u8.

Fixes: 7259124eac7d1 ("can: kvaser_usb: Split driver into kvaser_usb_core.c and kvaser_usb_leaf.c")
Link: https://lore.kernel.org/all/20220719143550.3681-9-mailhol.vincent@wanadoo.fr
CC: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index cc809ecd1e62..f551fde16a70 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -853,8 +853,10 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 		break;
 	}
 
-	cf->data[6] = es->txerr;
-	cf->data[7] = es->rxerr;
+	if (new_state != CAN_STATE_BUS_OFF) {
+		cf->data[6] = es->txerr;
+		cf->data[7] = es->rxerr;
+	}
 
 	netif_rx(skb);
 }
-- 
2.35.1



