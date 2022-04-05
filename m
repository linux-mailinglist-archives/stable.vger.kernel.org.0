Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9609B4F2F8A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242104AbiDEIgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239409AbiDEIUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00553C7499;
        Tue,  5 Apr 2022 01:12:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C972B81B90;
        Tue,  5 Apr 2022 08:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D2FC385A1;
        Tue,  5 Apr 2022 08:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146363;
        bh=u/EL/0GYyY+HGzHuNDThbtmHquTrLCD0k3PSgXrKSiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUC6sB6auqiCI9GSSBE1qfGOPyPehJNFLfFr3j+cgMTAnctnP+j/B8e9IGq5ttMCw
         uuun7ylOP/Z3XhBbWRbcKD2IgQKVq2AaSFXeU5P+k/KGUnBkXn4Ck8AKJulhVJsSck
         KSmLddO/6ItPybXLELW0i8iqm+F7p8CE/7ipDFSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0737/1126] serial: 8250: Fix race condition in RTS-after-send handling
Date:   Tue,  5 Apr 2022 09:24:44 +0200
Message-Id: <20220405070429.221238083@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 973870ebff69..fd0339d22491 100644
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



