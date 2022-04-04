Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06994F1BDE
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357994AbiDDVTG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380173AbiDDTKb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 15:10:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD38BC7
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 12:08:33 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nbS40-0002n5-8z
        for stable@vger.kernel.org; Mon, 04 Apr 2022 21:08:32 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B6BEC5A42D
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 19:08:31 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 929C65A429;
        Mon,  4 Apr 2022 19:08:31 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3c14b167;
        Mon, 4 Apr 2022 19:08:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     linux-can@vger.kernel.org
Cc:     stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] can: m_can: m_can_tx_handler(): fix use after free of skb
Date:   Mon,  4 Apr 2022 21:08:30 +0200
Message-Id: <20220404190830.1241263-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2e8e79c416aae1de224c0f1860f2e3350fa171f8 upstream.

can_put_echo_skb() will clone skb then free the skb. Move the
can_put_echo_skb() for the m_can version 3.0.x directly before the
start of the xmit in hardware, similar to the 3.1.x branch.

Fixes: 80646733f11c ("can: m_can: update to support CAN FD features")
Link: https://lore.kernel.org/all/20220317081305.739554-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Reported-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Hello Greg, hello Sasha,

This is

| 2e8e79c416aa can: m_can: m_can_tx_handler(): fix use after free of skb

ported to v5.10.109.

regards,
Marc

 drivers/net/can/m_can/m_can.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 19a7e4adb933..52386460fe92 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1491,8 +1491,6 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 					 M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
 
-		can_put_echo_skb(skb, dev, 0);
-
 		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
 			cccr = m_can_read(cdev, M_CAN_CCCR);
 			cccr &= ~(CCCR_CMR_MASK << CCCR_CMR_SHIFT);
@@ -1509,6 +1507,9 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
 			m_can_write(cdev, M_CAN_CCCR, cccr);
 		}
 		m_can_write(cdev, M_CAN_TXBTIE, 0x1);
+
+		can_put_echo_skb(skb, dev, 0, 0);
+
 		m_can_write(cdev, M_CAN_TXBAR, 0x1);
 		/* End of xmit function for version 3.0.x */
 	} else {
-- 
2.35.1


