Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479306A09E2
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbjBWNKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234417AbjBWNKp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:10:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A89567BE
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:10:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D884B616F3
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A16C433EF;
        Thu, 23 Feb 2023 13:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157834;
        bh=fsNCZUsLTrQbOcSUJrp84g/07ePqWdcddwcfqHoDqgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7hLoMeSSlWUiYyCBY7TzRpSp+OYFzTeOfMEEa5O1KI+geR1yZMh6yxW4zdq2xtIz
         OuiOae03I+XB9miGwFcvxw7AUUbkMUYWUZV63yqcfEpsiGcxTYmGp4f3n2FmOZnCZv
         OPTd/DtwDy7+PFBDX4kLtmCLhnntqaK0CqFYx6oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/18] can: kvaser_usb: hydra: help gcc-13 to figure out cmd_len
Date:   Thu, 23 Feb 2023 14:06:55 +0100
Message-Id: <20230223130426.080997835@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130425.680784802@linuxfoundation.org>
References: <20230223130425.680784802@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit f006229135b7debf4037adb1eb93e358559593db ]

Debian's gcc-13 [1] throws the following error in
kvaser_usb_hydra_cmd_size():

[1] gcc version 13.0.0 20221214 (experimental) [master r13-4693-g512098a3316] (Debian 13-20221214-1)

| drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c:502:65: error:
| array subscript ‘struct kvaser_cmd_ext[0]’ is partly outside array
| bounds of ‘unsigned char[32]’ [-Werror=array-bounds=]
|   502 |                 ret = le16_to_cpu(((struct kvaser_cmd_ext *)cmd)->len);

kvaser_usb_hydra_cmd_size() returns the size of given command. It
depends on the command number (cmd->header.cmd_no). For extended
commands (cmd->header.cmd_no == CMD_EXTENDED) the above shown code is
executed.

Help gcc to recognize that this code path is not taken in all cases,
by calling kvaser_usb_hydra_cmd_size() directly after assigning the
command number.

Fixes: aec5fb2268b7 ("can: kvaser_usb: Add support for Kvaser USB hydra family")
Cc: Jimmy Assarsson <extja@kvaser.com>
Cc: Anssi Hannula <anssi.hannula@bitwise.fi>
Link: https://lore.kernel.org/all/20221219110104.1073881-1-mkl@pengutronix.de
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 33 ++++++++++++++-----
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 2764fdd7e84b3..233bbfeaa771e 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -518,6 +518,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 					    u8 cmd_no, int channel)
 {
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -525,6 +526,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = cmd_no;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	if (channel < 0) {
 		kvaser_usb_hydra_set_cmd_dest_he
 				(cmd, KVASER_USB_HYDRA_HE_ADDRESS_ILLEGAL);
@@ -541,7 +543,7 @@ static int kvaser_usb_hydra_send_simple_cmd(struct kvaser_usb *dev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -557,6 +559,7 @@ kvaser_usb_hydra_send_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 {
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_ATOMIC);
@@ -564,14 +567,14 @@ kvaser_usb_hydra_send_simple_cmd_async(struct kvaser_usb_net_priv *priv,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = cmd_no;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd_async(priv, cmd,
-					kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd_async(priv, cmd, cmd_len);
 	if (err)
 		kfree(cmd);
 
@@ -715,6 +718,7 @@ static int kvaser_usb_hydra_get_single_capability(struct kvaser_usb *dev,
 {
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	u32 value = 0;
 	u32 mask = 0;
 	u16 cap_cmd_res;
@@ -726,13 +730,14 @@ static int kvaser_usb_hydra_get_single_capability(struct kvaser_usb *dev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_CAPABILITIES_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	cmd->cap_req.cap_cmd = cpu_to_le16(cap_cmd_req);
 
 	kvaser_usb_hydra_set_cmd_dest_he(cmd, card_data->hydra.sysdbg_he);
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -1555,6 +1560,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_usb_net_hydra_priv *hydra = priv->sub_priv;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	if (!hydra)
@@ -1565,6 +1571,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_BUSPARAMS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
@@ -1574,7 +1581,7 @@ static int kvaser_usb_hydra_get_busparams(struct kvaser_usb_net_priv *priv,
 
 	reinit_completion(&priv->get_busparams_comp);
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		return err;
 
@@ -1601,6 +1608,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -1608,6 +1616,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	memcpy(&cmd->set_busparams_req.busparams_nominal, busparams,
 	       sizeof(cmd->set_busparams_req.busparams_nominal));
 
@@ -1616,7 +1625,7 @@ static int kvaser_usb_hydra_set_bittiming(const struct net_device *netdev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 
 	kfree(cmd);
 
@@ -1629,6 +1638,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 	struct kvaser_cmd *cmd;
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
 	struct kvaser_usb *dev = priv->dev;
+	size_t cmd_len;
 	int err;
 
 	cmd = kcalloc(1, sizeof(struct kvaser_cmd), GFP_KERNEL);
@@ -1636,6 +1646,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_BUSPARAMS_FD_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	memcpy(&cmd->set_busparams_req.busparams_data, busparams,
 	       sizeof(cmd->set_busparams_req.busparams_data));
 
@@ -1653,7 +1664,7 @@ static int kvaser_usb_hydra_set_data_bittiming(const struct net_device *netdev,
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 
 	kfree(cmd);
 
@@ -1781,6 +1792,7 @@ static int kvaser_usb_hydra_get_software_info(struct kvaser_usb *dev)
 static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 {
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 	u32 flags;
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
@@ -1790,6 +1802,7 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_GET_SOFTWARE_DETAILS_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	cmd->sw_detail_req.use_ext_cmd = 1;
 	kvaser_usb_hydra_set_cmd_dest_he
 				(cmd, KVASER_USB_HYDRA_HE_ADDRESS_ILLEGAL);
@@ -1797,7 +1810,7 @@ static int kvaser_usb_hydra_get_software_details(struct kvaser_usb *dev)
 	kvaser_usb_hydra_set_cmd_transid
 				(cmd, kvaser_usb_hydra_get_next_transid(dev));
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	if (err)
 		goto end;
 
@@ -1913,6 +1926,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 {
 	struct kvaser_usb *dev = priv->dev;
 	struct kvaser_cmd *cmd;
+	size_t cmd_len;
 	int err;
 
 	if ((priv->can.ctrlmode &
@@ -1928,6 +1942,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 		return -ENOMEM;
 
 	cmd->header.cmd_no = CMD_SET_DRIVERMODE_REQ;
+	cmd_len = kvaser_usb_hydra_cmd_size(cmd);
 	kvaser_usb_hydra_set_cmd_dest_he
 		(cmd, dev->card_data.hydra.channel_to_he[priv->channel]);
 	kvaser_usb_hydra_set_cmd_transid
@@ -1937,7 +1952,7 @@ static int kvaser_usb_hydra_set_opt_mode(const struct kvaser_usb_net_priv *priv)
 	else
 		cmd->set_ctrlmode.mode = KVASER_USB_HYDRA_CTRLMODE_NORMAL;
 
-	err = kvaser_usb_send_cmd(dev, cmd, kvaser_usb_hydra_cmd_size(cmd));
+	err = kvaser_usb_send_cmd(dev, cmd, cmd_len);
 	kfree(cmd);
 
 	return err;
-- 
2.39.0



