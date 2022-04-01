Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9004EECC1
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 14:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241369AbiDAME5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 08:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiDAME5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 08:04:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFB1269A7B
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 05:03:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B62C9B8245D
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 12:03:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FD1C340F2;
        Fri,  1 Apr 2022 12:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648814585;
        bh=ih4YxA3m33npL/FRxc2Fytu5K+DB5LHzpcsQ/KRSVS4=;
        h=Subject:To:Cc:From:Date:From;
        b=aEIn2/PzL7Mwzn2RopWOO079QrxzRWbFubREoi9NNeJVk2xA1dWiuz5W57QhWGcSS
         dqrHcbPYbhtHJ+ILd+WOq6nlbuZ9quwZh8dnDybU5a1++7yD0mdkeBLyp5he3r35Pr
         vvOs4TEV+kBHlnJJIjylUHdEQcmD1n6Hgq+s4WE4=
Subject: FAILED: patch "[PATCH] can: m_can: m_can_tx_handler(): fix use after free of skb" failed to apply to 4.14-stable tree
To:     mkl@pengutronix.de, hbh25y@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 01 Apr 2022 14:02:19 +0200
Message-ID: <164881453967163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e8e79c416aae1de224c0f1860f2e3350fa171f8 Mon Sep 17 00:00:00 2001
From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Thu, 17 Mar 2022 08:57:35 +0100
Subject: [PATCH] can: m_can: m_can_tx_handler(): fix use after free of skb

can_put_echo_skb() will clone skb then free the skb. Move the
can_put_echo_skb() for the m_can version 3.0.x directly before the
start of the xmit in hardware, similar to the 3.1.x branch.

Fixes: 80646733f11c ("can: m_can: update to support CAN FD features")
Link: https://lore.kernel.org/all/20220317081305.739554-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Reported-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 1a4b56f6fa8c..b3b5bc1c803b 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1637,8 +1637,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 		if (err)
 			goto out_fail;
 
-		can_put_echo_skb(skb, dev, 0, 0);
-
 		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
 			cccr = m_can_read(cdev, M_CAN_CCCR);
 			cccr &= ~CCCR_CMR_MASK;
@@ -1655,6 +1653,9 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 			m_can_write(cdev, M_CAN_CCCR, cccr);
 		}
 		m_can_write(cdev, M_CAN_TXBTIE, 0x1);
+
+		can_put_echo_skb(skb, dev, 0, 0);
+
 		m_can_write(cdev, M_CAN_TXBAR, 0x1);
 		/* End of xmit function for version 3.0.x */
 	} else {

