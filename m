Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E019F579974
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbiGSMDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238021AbiGSMCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:02:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CED64B0F8;
        Tue, 19 Jul 2022 04:59:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0456661647;
        Tue, 19 Jul 2022 11:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C516FC341C6;
        Tue, 19 Jul 2022 11:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231944;
        bh=UcDZ58eCiejyh3LpsXs/Q/VB86xvoENvhAWfgMJHGLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TiFbUVY6gOc+UxsaF5gJiZwOFL/phgnpSav2iDVZugfDBOI+O/bF5XigyMQM48Ch0
         tTZFdU51FwqRr8gBR5s9tUF7Kz6wP2+nU83sQRXBFB6ozlyFq8AkpswkOEJdCxeH7V
         SyqVjpOoFskCnHaPcQ5BDnx0k9aIHlMPlhV02/Ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 43/43] can: m_can: m_can_tx_handler(): fix use after free of skb
Date:   Tue, 19 Jul 2022 13:54:14 +0200
Message-Id: <20220719114525.587310460@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 2e8e79c416aae1de224c0f1860f2e3350fa171f8 upstream.

can_put_echo_skb() will clone skb then free the skb. Move the
can_put_echo_skb() for the m_can version 3.0.x directly before the
start of the xmit in hardware, similar to the 3.1.x branch.

Fixes: 80646733f11c ("can: m_can: update to support CAN FD features")
Link: https://lore.kernel.org/all/20220317081305.739554-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Reported-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1420,8 +1420,6 @@ static netdev_tx_t m_can_start_xmit(stru
 					 M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
 
-		can_put_echo_skb(skb, dev, 0);
-
 		if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
 			cccr = m_can_read(priv, M_CAN_CCCR);
 			cccr &= ~(CCCR_CMR_MASK << CCCR_CMR_SHIFT);
@@ -1438,6 +1436,9 @@ static netdev_tx_t m_can_start_xmit(stru
 			m_can_write(priv, M_CAN_CCCR, cccr);
 		}
 		m_can_write(priv, M_CAN_TXBTIE, 0x1);
+
+		can_put_echo_skb(skb, dev, 0);
+
 		m_can_write(priv, M_CAN_TXBAR, 0x1);
 		/* End of xmit function for version 3.0.x */
 	} else {


