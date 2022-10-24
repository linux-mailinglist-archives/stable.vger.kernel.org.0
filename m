Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E9D60A6A6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiJXMhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbiJXMfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:35:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7A2356E4;
        Mon, 24 Oct 2022 05:05:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8A8F612D4;
        Mon, 24 Oct 2022 12:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CE8C433C1;
        Mon, 24 Oct 2022 12:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613119;
        bh=BFat5BEfy41jcfjN1LQSScF9bLmYMpIuSmHtawi1W2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dn6lxCakEg6uASYIXyVpP/I6uq7CIElvHrQD6ODfRLKCnEklWrmQygSkIHo+VcKJZ
         Cfnu0xrSY0IVFZS3p2uo3xzeRIlFF9R7snHY0zKI1kIbIwiyAHbnmYjKFtOKmEvXP0
         E6ykY9wTmCaKn7Zsf4Znaazn82So4FmwCzLE8k30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 016/255] can: kvaser_usb: Fix use of uninitialized completion
Date:   Mon, 24 Oct 2022 13:28:46 +0200
Message-Id: <20221024113002.973471295@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
@@ -690,6 +690,7 @@ static int kvaser_usb_init_one(struct kv
 	init_usb_anchor(&priv->tx_submitted);
 	init_completion(&priv->start_comp);
 	init_completion(&priv->stop_comp);
+	init_completion(&priv->flush_comp);
 	priv->can.ctrlmode_supported = 0;
 
 	priv->dev = dev;
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1886,7 +1886,7 @@ static int kvaser_usb_hydra_flush_queue(
 {
 	int err;
 
-	init_completion(&priv->flush_comp);
+	reinit_completion(&priv->flush_comp);
 
 	err = kvaser_usb_hydra_send_simple_cmd(priv->dev, CMD_FLUSH_QUEUE,
 					       priv->channel);


