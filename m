Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46565EA34E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233574AbiIZLYW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbiIZLXE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:23:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5C7FDF66;
        Mon, 26 Sep 2022 03:39:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8540E604F5;
        Mon, 26 Sep 2022 10:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D6CC433C1;
        Mon, 26 Sep 2022 10:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188738;
        bh=NexvLtw/DG7sNlXCxEGCln2wY+hg4N3/kbn2/5Wj/O0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pi+VS+V51PvgKdNK5TBU0WGpd4E5IPTVQcdJRv9BMFHriTJ7NDv3bNwXMoeqDe3P6
         5jaVrZvWWOOJ97/Q8UApZoQ4n5Kx+hRr52xbZaxwFmWnPm5hta5iyi43Zocs86I/IZ
         LMxYvWRen+LnGWgk380TCdFyvyOBUfuG0Tf9zcB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/148] can: gs_usb: gs_can_open(): fix race dev->can.state condition
Date:   Mon, 26 Sep 2022 12:12:19 +0200
Message-Id: <20220926100800.054839168@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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
index e26b3d6f5b48..5a43e542b302 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -680,6 +680,7 @@ static int gs_can_open(struct net_device *netdev)
 		flags |= GS_CAN_MODE_TRIPLE_SAMPLE;
 
 	/* finally start device */
+	dev->can.state = CAN_STATE_ERROR_ACTIVE;
 	dm->mode = cpu_to_le32(GS_CAN_MODE_START);
 	dm->flags = cpu_to_le32(flags);
 	rc = usb_control_msg(interface_to_usbdev(dev->iface),
@@ -696,13 +697,12 @@ static int gs_can_open(struct net_device *netdev)
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



