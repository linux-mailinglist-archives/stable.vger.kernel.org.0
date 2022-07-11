Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAE256FB47
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbiGKJ2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbiGKJ10 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:27:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DEC643F3;
        Mon, 11 Jul 2022 02:15:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C906AB80E87;
        Mon, 11 Jul 2022 09:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BDBC34115;
        Mon, 11 Jul 2022 09:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530938;
        bh=dEqsAoUirAyUGEREUy96KikMAHDexhgpijutbuTwZec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WfkfZwd9tejblT7l8z4vwCQvRujJpYMQkItumvpVMrY2NS8uBRv2GppTw17EYpXpF
         6X8nvhbkWI2pgK3TH2n25RgiF2OWLydIRFKhMT2S10jTO7jURSkifgRclaXkF0ncLk
         /dsfRs212GZccXEszEkZ1AfkW7w4enih7hRl9wN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Torin Cooper-Bennun <torin@maxiluxsystems.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.18 009/112] can: m_can: m_can_{read_fifo,echo_tx_event}(): shift timestamp to full 32 bits
Date:   Mon, 11 Jul 2022 11:06:09 +0200
Message-Id: <20220711090549.820201664@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 4c3333693f07313f5f0145a922f14a7d3c0f4f21 upstream.

In commit 1be37d3b0414 ("can: m_can: fix periph RX path: use
rx-offload to ensure skbs are sent from softirq context") the RX path
for peripheral devices was switched to RX-offload.

Received CAN frames are pushed to RX-offload together with a
timestamp. RX-offload is designed to handle overflows of the timestamp
correctly, if 32 bit timestamps are provided.

The timestamps of m_can core are only 16 bits wide. So this patch
shifts them to full 32 bit before passing them to RX-offload.

Link: https://lore.kernel.org/all/20220612211410.4081390-1-mkl@pengutronix.de
Fixes: 1be37d3b0414 ("can: m_can: fix periph RX path: use rx-offload to ensure skbs are sent from softirq context")
Cc: <stable@vger.kernel.org> # 5.13
Cc: Torin Cooper-Bennun <torin@maxiluxsystems.com>
Reviewed-by: Chandrasekar Ramakrishnan <rcsekar@samsung.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -532,7 +532,7 @@ static int m_can_read_fifo(struct net_de
 	/* acknowledge rx fifo 0 */
 	m_can_write(cdev, M_CAN_RXF0A, fgi);
 
-	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, fifo_header.dlc);
+	timestamp = FIELD_GET(RX_BUF_RXTS_MASK, fifo_header.dlc) << 16;
 
 	m_can_receive_skb(cdev, skb, timestamp);
 
@@ -1036,7 +1036,7 @@ static int m_can_echo_tx_event(struct ne
 		}
 
 		msg_mark = FIELD_GET(TX_EVENT_MM_MASK, txe);
-		timestamp = FIELD_GET(TX_EVENT_TXTS_MASK, txe);
+		timestamp = FIELD_GET(TX_EVENT_TXTS_MASK, txe) << 16;
 
 		/* ack txe element */
 		m_can_write(cdev, M_CAN_TXEFA, FIELD_PREP(TXEFA_EFAI_MASK,


