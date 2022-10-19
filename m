Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51403603C39
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbiJSIo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbiJSIoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:44:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAFD89963;
        Wed, 19 Oct 2022 01:42:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 218B9617D1;
        Wed, 19 Oct 2022 08:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA44C433D6;
        Wed, 19 Oct 2022 08:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168844;
        bh=O5hT/gQYm6/LEbKSOMr4FejGgecjPZtk9ndOZq8vVHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8Ousj+FGM/GJehWCEF6xT6gDQ6tBG3Jy4FeuHYsQjv/kLYj7thFnDACw9xX01pNk
         CuAo2EKpqj3K5MXMI2xI0wQ0SviEcwIVMdGXSHsZrTrg/hMkpUuF/xr4/Gl6maWAa9
         2h4diY5Gp+Fmg8uJT66VS9qb0n7d3uqKx+jge4AA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.0 035/862] can: kvaser_usb_leaf: Fix TX queue out of sync after restart
Date:   Wed, 19 Oct 2022 10:22:02 +0200
Message-Id: <20221019083251.563976478@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

commit 455561fb618fde40558776b5b8435f9420f335db upstream.

The TX queue seems to be implicitly flushed by the hardware during
bus-off or bus-off recovery, but the driver does not reset the TX
bookkeeping.

Despite not resetting TX bookkeeping the driver still re-enables TX
queue unconditionally, leading to "cannot find free context" /
NETDEV_TX_BUSY errors if the TX queue was full at bus-off time.

Fix that by resetting TX bookkeeping on CAN restart.

Tested with 0bfd:0124 Kvaser Mini PCI Express 2xHS FW 4.18.778.

Cc: stable@vger.kernel.org
Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010150829.199676-4-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h      |    2 ++
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |    2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c |    2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -178,6 +178,8 @@ struct kvaser_usb_dev_cfg {
 extern const struct kvaser_usb_dev_ops kvaser_usb_hydra_dev_ops;
 extern const struct kvaser_usb_dev_ops kvaser_usb_leaf_dev_ops;
 
+void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv);
+
 int kvaser_usb_recv_cmd(const struct kvaser_usb *dev, void *cmd, int len,
 			int *actual_len);
 
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -477,7 +477,7 @@ static void kvaser_usb_reset_tx_urb_cont
 /* This method might sleep. Do not call it in the atomic context
  * of URB completions.
  */
-static void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv)
+void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv)
 {
 	usb_kill_anchored_urbs(&priv->tx_submitted);
 	kvaser_usb_reset_tx_urb_contexts(priv);
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1426,6 +1426,8 @@ static int kvaser_usb_leaf_set_mode(stru
 
 	switch (mode) {
 	case CAN_MODE_START:
+		kvaser_usb_unlink_tx_urbs(priv);
+
 		err = kvaser_usb_leaf_simple_cmd_async(priv, CMD_START_CHIP);
 		if (err)
 			return err;


