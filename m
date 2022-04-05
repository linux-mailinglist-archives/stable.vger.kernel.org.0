Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBD94F2FB8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350279AbiDEJ5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238747AbiDEJQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC392D1CED;
        Tue,  5 Apr 2022 02:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D454B81A22;
        Tue,  5 Apr 2022 09:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F1EC385A0;
        Tue,  5 Apr 2022 09:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149308;
        bh=nHD0pg0JPdDBQlubw4lET+r6B3XXrvHryuZbDJCYbcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRu8R2S5m9o8Lap9wGsgH0GjpbT83S8H0v4SgFeclbSf7cLx5+4eGdEe9e7f9C92G
         oX8JruHOsX+tWzuUGflaWMwukwtd06l0j+RZ7jAmGTqp6OBaa5xvJ6gnHYWRSM9JzP
         Ie5blp7kR+WcwN4dDyOGo5k9PWx/3smAYE7sUfBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0668/1017] serial: 8250: Fix race condition in RTS-after-send handling
Date:   Tue,  5 Apr 2022 09:26:21 +0200
Message-Id: <20220405070414.110149314@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit dedab69fd650ea74710b2e626e63fd35584ef773 ]

Set em485->active_timer = NULL isn't always enough to take out the stop
timer. While there is a check that it acts in the right state (i.e.
waiting for RTS-after-send to pass after sending some chars) but the
following might happen:

 - CPU1: some chars send, shifter becomes empty, stop tx timer armed
 - CPU0: more chars send before RTS-after-send expired
 - CPU0: shifter empty irq, port lock taken
 - CPU1: tx timer triggers, waits for port lock
 - CPU0: em485->active_timer = &em485->stop_tx_timer, hrtimer_start(),
   releases lock()
 - CPU1: get lock, see em485->active_timer == &em485->stop_tx_timer,
   tear down RTS too early

This fix bases on research done by Steffen Trumtrar.

Fixes: b86f86e8e7c5 ("serial: 8250: fix potential deadlock in rs485-mode")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20220215160236.344236-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index b34e84695c8c..344fbe7426f6 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -1623,6 +1623,18 @@ static inline void start_tx_rs485(struct uart_port *port)
 	struct uart_8250_port *up = up_to_u8250p(port);
 	struct uart_8250_em485 *em485 = up->em485;
 
+	/*
+	 * While serial8250_em485_handle_stop_tx() is a noop if
+	 * em485->active_timer != &em485->stop_tx_timer, it might happen that
+	 * the timer is still armed and triggers only after the current bunch of
+	 * chars is send and em485->active_timer == &em485->stop_tx_timer again.
+	 * So cancel the timer. There is still a theoretical race condition if
+	 * the timer is already running and only comes around to check for
+	 * em485->active_timer when &em485->stop_tx_timer is armed again.
+	 */
+	if (em485->active_timer == &em485->stop_tx_timer)
+		hrtimer_try_to_cancel(&em485->stop_tx_timer);
+
 	em485->active_timer = NULL;
 
 	if (em485->tx_stopped) {
-- 
2.34.1



