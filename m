Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39AC859DB86
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354022AbiHWK1M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354522AbiHWKZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:25:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0377C309;
        Tue, 23 Aug 2022 02:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBF3CB81C85;
        Tue, 23 Aug 2022 09:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 086BEC433C1;
        Tue, 23 Aug 2022 09:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245511;
        bh=GqRCdQk5gcrQtkUm0Jh9s9TsuaLzbGufsrzGeFlIiVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xt/CIyKP5s40uygA5pNyRcOkUWE76hwQnncrKTUwk1ll1F6WPmXv0OhYICCn5wPu5
         TQW7xolBcP7dFUd3lOw9mPmtPyhty2sHrSy53gK3m0Zqw8UF6GdgLuEB5+UrtLfg7q
         Jsfpe2IuV10H8KwizHTQb+E7f7iNSicvNdTApQxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 100/287] can: kvaser_usb_leaf: do not report txerr and rxerr during bus-off
Date:   Tue, 23 Aug 2022 10:24:29 +0200
Message-Id: <20220823080103.727574984@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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
index 0e0403dd0550..5e281249ad5f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -857,8 +857,10 @@ static void kvaser_usb_leaf_rx_error(const struct kvaser_usb *dev,
 		break;
 	}
 
-	cf->data[6] = es->txerr;
-	cf->data[7] = es->rxerr;
+	if (new_state != CAN_STATE_BUS_OFF) {
+		cf->data[6] = es->txerr;
+		cf->data[7] = es->rxerr;
+	}
 
 	stats->rx_packets++;
 	stats->rx_bytes += cf->can_dlc;
-- 
2.35.1



