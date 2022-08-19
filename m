Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E655059A1DD
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351979AbiHSQO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351938AbiHSQNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:13:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6BA114A5C;
        Fri, 19 Aug 2022 08:57:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 558BBB82818;
        Fri, 19 Aug 2022 15:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A1FC433C1;
        Fri, 19 Aug 2022 15:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924660;
        bh=GqRCdQk5gcrQtkUm0Jh9s9TsuaLzbGufsrzGeFlIiVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsOBanzRaisG77t8rigqPFIjBVoJTfMuVQb6CFYUFV+P+AR036BwwWYyKryItx1vN
         9VmINeoTEYLQMxPorwjcLRsvuiQmaphr7p+WoccyXPmOX04W06vxauzNndeWNlNxg9
         pEKEKyJ5icfmsz7/wBJS6ilWIMHiMCuasl4uKPRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 241/545] can: kvaser_usb_leaf: do not report txerr and rxerr during bus-off
Date:   Fri, 19 Aug 2022 17:40:11 +0200
Message-Id: <20220819153840.145312989@linuxfoundation.org>
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



