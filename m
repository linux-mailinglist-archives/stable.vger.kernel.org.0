Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082F74FD65D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352331AbiDLHXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354060AbiDLHQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C019348882;
        Mon, 11 Apr 2022 23:58:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0588B615A4;
        Tue, 12 Apr 2022 06:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A942C385A6;
        Tue, 12 Apr 2022 06:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746685;
        bh=b/+qkuaKqcpsC6aEEb3D76mekCKpkMRju0VRn4DhoMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=noOiP1r+jyXdrKoi9DWVBdssEHrq7rYCmfgsowbYZNY9h5wIGSEVkTRO5EJSUUqNv
         GNxkfyXNr4K+N0zRjf4GnOMr7rodHCK3gmlWWqTvH8wcIlcd40a7+BZQul2XU+tMQv
         du0kdHDFc+JUwGG21XJXkHSeu+IU70kxn7Uv+q4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 094/285] can: etas_es58x: es58x_fd_rx_event_msg(): initialize rx_event_msg before calling es58x_check_msg_len()
Date:   Tue, 12 Apr 2022 08:29:11 +0200
Message-Id: <20220412062946.376907108@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
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

[ Upstream commit 7a8cd7c0ee823a1cc893ab3feaa23e4b602bfb9a ]

Function es58x_fd_rx_event() invokes the es58x_check_msg_len() macro:

| 	ret = es58x_check_msg_len(es58x_dev->dev, *rx_event_msg, msg_len);

While doing so, it dereferences an uninitialized
variable: *rx_event_msg.

This is actually harmless because es58x_check_msg_len() only uses
preprocessor macros (sizeof() and __stringify()) on
*rx_event_msg. c.f. [1].

Nonetheless, this pattern is confusing so the lines are reordered to
make sure that rx_event_msg is correctly initialized.

This patch also fixes a false positive warning reported by cppcheck:

| cppcheck possible warnings: (new ones prefixed by >>, may not be real problems)
|
|    In file included from drivers/net/can/usb/etas_es58x/es58x_fd.c:
| >> drivers/net/can/usb/etas_es58x/es58x_fd.c:174:8: warning: Uninitialized variable: rx_event_msg [uninitvar]
|     ret = es58x_check_msg_len(es58x_dev->dev, *rx_event_msg, msg_len);
|           ^

[1] https://elixir.bootlin.com/linux/v5.16/source/drivers/net/can/usb/etas_es58x/es58x_core.h#L467

Link: https://lore.kernel.org/all/20220306101302.708783-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/etas_es58x/es58x_fd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
index 4f0cae29f4d8..b71d1530638b 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -171,12 +171,11 @@ static int es58x_fd_rx_event_msg(struct net_device *netdev,
 	const struct es58x_fd_rx_event_msg *rx_event_msg;
 	int ret;
 
+	rx_event_msg = &es58x_fd_urb_cmd->rx_event_msg;
 	ret = es58x_check_msg_len(es58x_dev->dev, *rx_event_msg, msg_len);
 	if (ret)
 		return ret;
 
-	rx_event_msg = &es58x_fd_urb_cmd->rx_event_msg;
-
 	return es58x_rx_err_msg(netdev, rx_event_msg->error_code,
 				rx_event_msg->event_code,
 				get_unaligned_le64(&rx_event_msg->timestamp));
-- 
2.35.1



