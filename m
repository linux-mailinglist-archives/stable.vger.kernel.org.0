Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1FE579A65
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238783AbiGSMPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239386AbiGSMOg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:14:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B408D4C612;
        Tue, 19 Jul 2022 05:05:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25A28B817AF;
        Tue, 19 Jul 2022 12:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF84C341C6;
        Tue, 19 Jul 2022 12:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232267;
        bh=d+m4VWCUSsO3Sudpaqtn3IQBPQ5PF/wGQxEV8XVqCJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zmPb+I4t0PFR9w4a0DlMugZcp9WuLhzyAf+fhoa6T7sPV73oLew3nz8fBoCnXXHKj
         2AEABLVxJdAUFG5mTGaGm9/0cNCErYpof73h+5ybv6xTKTOwZ/cTJFny4aeMKjSOT2
         mrA+CtR365POk2S8YnhimwlVa6QIuaYgZVkZY8ww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.4 71/71] can: m_can: m_can_tx_handler(): fix use after free of skb
Date:   Tue, 19 Jul 2022 13:54:34 +0200
Message-Id: <20220719114559.610828192@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
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
@@ -1443,8 +1443,6 @@ static netdev_tx_t m_can_tx_handler(stru
 					 M_CAN_FIFO_DATA(i / 4),
 					 *(u32 *)(cf->data + i));
 
-		can_put_echo_skb(skb, dev, 0);
-
 		if (cdev->can.ctrlmode & CAN_CTRLMODE_FD) {
 			cccr = m_can_read(cdev, M_CAN_CCCR);
 			cccr &= ~(CCCR_CMR_MASK << CCCR_CMR_SHIFT);
@@ -1461,6 +1459,9 @@ static netdev_tx_t m_can_tx_handler(stru
 			m_can_write(cdev, M_CAN_CCCR, cccr);
 		}
 		m_can_write(cdev, M_CAN_TXBTIE, 0x1);
+
+		can_put_echo_skb(skb, dev, 0);
+
 		m_can_write(cdev, M_CAN_TXBAR, 0x1);
 		/* End of xmit function for version 3.0.x */
 	} else {


