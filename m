Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA5760B897
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbiJXTvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbiJXTv0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:51:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840157C1F5;
        Mon, 24 Oct 2022 11:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2C46B816AD;
        Mon, 24 Oct 2022 12:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A16C433D6;
        Mon, 24 Oct 2022 12:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614838;
        bh=9RgDa2xi1W+8STkDcV58pjNZP/j9rFjBUfcCyK1cHF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T46aL+u182J+Ajk+LHStY8HPkew0Zx3Cdshfgaua19Ld6XmquEARLx2Xcl9rTVY9G
         Q9wu9i38o1kwX75rTaxFOWbhuWTj43ZY+Mq+z74uzz3BRiIsbIezJdHn6/M8SX3HtG
         263d4ou7IaQ/SiHSpytq3NwhYgYijUixp97lg+Sc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 022/530] can: kvaser_usb: Fix use of uninitialized completion
Date:   Mon, 24 Oct 2022 13:26:06 +0200
Message-Id: <20221024113046.016827466@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

commit cd7f30e174d09a02ca2afa5ef093fb0f0352e0d8 upstream.

flush_comp is initialized when CMD_FLUSH_QUEUE is sent to the device and
completed when the device sends CMD_FLUSH_QUEUE_RESP.

This causes completion of uninitialized completion if the device sends
CMD_FLUSH_QUEUE_RESP before CMD_FLUSH_QUEUE is ever sent (e.g. as a
response to a flush by a previously bound driver, or a misbehaving
device).

Fix that by initializing flush_comp in kvaser_usb_init_one() like the
other completions.

This issue is only triggerable after RX URBs have been set up, i.e. the
interface has been opened at least once.

Cc: stable@vger.kernel.org
Fixes: aec5fb2268b7 ("can: kvaser_usb: Add support for Kvaser USB hydra family")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010150829.199676-3-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  |    1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -717,6 +717,7 @@ static int kvaser_usb_init_one(struct kv
 	init_usb_anchor(&priv->tx_submitted);
 	init_completion(&priv->start_comp);
 	init_completion(&priv->stop_comp);
+	init_completion(&priv->flush_comp);
 	priv->can.ctrlmode_supported = 0;
 
 	priv->dev = dev;
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1914,7 +1914,7 @@ static int kvaser_usb_hydra_flush_queue(
 {
 	int err;
 
-	init_completion(&priv->flush_comp);
+	reinit_completion(&priv->flush_comp);
 
 	err = kvaser_usb_hydra_send_simple_cmd(priv->dev, CMD_FLUSH_QUEUE,
 					       priv->channel);


