Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0522F5E9F62
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiIZKZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbiIZKXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:23:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322424D25C;
        Mon, 26 Sep 2022 03:17:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9CE74B8091F;
        Mon, 26 Sep 2022 10:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF84CC433C1;
        Mon, 26 Sep 2022 10:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187432;
        bh=fAlZJ9xWNacVjByCeDTu4Kvh49DJCQi1wFo4hseHhVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r1TAwnJDzojEiU9wMBRy9dsMAXgIaODI5lH15bnCW6lTpVczTXEUYU83UR+mM1hYn
         WPmjOIy+kun54BrFcAp8t0MJ8ghuhNmBdm4FA8/z8/hMriRUR5/8qIy9hRLI9FydNq
         46k6KIMVhTJCSO0ypgNEO/PZJ0B1xDHgqCqVZcPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/40] can: gs_usb: gs_can_open(): fix race dev->can.state condition
Date:   Mon, 26 Sep 2022 12:12:00 +0200
Message-Id: <20220926100739.533466515@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100738.148626940@linuxfoundation.org>
References: <20220926100738.148626940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 5440428b3da65408dba0241985acb7a05258b85e ]

The dev->can.state is set to CAN_STATE_ERROR_ACTIVE, after the device
has been started. On busy networks the CAN controller might receive
CAN frame between and go into an error state before the dev->can.state
is assigned.

Assign dev->can.state before starting the controller to close the race
window.

Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Link: https://lore.kernel.org/all/20220920195216.232481-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 31c1dc0aa5cf..5e21486baa22 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -686,6 +686,7 @@ static int gs_can_open(struct net_device *netdev)
 		flags |= GS_CAN_MODE_TRIPLE_SAMPLE;
 
 	/* finally start device */
+	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 	dm->mode = cpu_to_le32(GS_CAN_MODE_START);
 	dm->flags = cpu_to_le32(flags);
 	rc = usb_control_msg(interface_to_usbdev(dev->iface),
@@ -702,13 +703,12 @@ static int gs_can_open(struct net_device *netdev)
 	if (rc < 0) {
 		netdev_err(netdev, "Couldn't start device (err=%d)\n", rc);
 		kfree(dm);
+		dev->can.state = CAN_STATE_STOPPED;
 		return rc;
 	}
 
 	kfree(dm);
 
-	dev->can.state = CAN_STATE_ERROR_ACTIVE;
-
 	parent->active_channels++;
 	if (!(dev->can.ctrlmode & CAN_CTRLMODE_LISTENONLY))
 		netif_start_queue(netdev);
-- 
2.35.1



