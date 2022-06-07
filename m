Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4AD540EB8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354289AbiFGS4A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353374AbiFGSwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:52:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCA31C136;
        Tue,  7 Jun 2022 11:03:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19111B82340;
        Tue,  7 Jun 2022 18:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26B6C3411F;
        Tue,  7 Jun 2022 18:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654625010;
        bh=x3KhVWC0ll/qL0hqYrVnjfMXp95Ww5ZMIt+AkkTdFUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shNXiqTncmt1lcBuwgc0AJVlwleB6AdiGcpFq/twFLUc97N+JjsOnTRhX6JNsxx2u
         on6G5ObL6S5FvN/FRkSHu8nt9+FoKg9w+GY4h9opK0nvsaOh8Pi0B0fXrLDfRn4zfL
         /H6JWGVjyjHdeUM0LXzDOoMlEa9/uMQ7OC7vSZ3+APS8eGm3NQbcNLeQyV/2nbaO97
         txwZbjw7dDp0o/ShavBOj4NIaLv9NfmyTZGdnokcVJn9w6VJYE+FiisvJXwlVOzu1w
         2LpVefVI7Hh1e1ax9EjO9ly5Sh6I+7MMp9iRByiJP5jbKGA9hZu9rUlgcJjKVI3M6e
         wI5Yt9YAyQyMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 07/19] drivers: tty: serial: Fix deadlock in sa1100_set_termios()
Date:   Tue,  7 Jun 2022 14:03:02 -0400
Message-Id: <20220607180317.482354-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607180317.482354-1-sashal@kernel.org>
References: <20220607180317.482354-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 62b2caef400c1738b6d22f636c628d9f85cd4c4c ]

There is a deadlock in sa1100_set_termios(), which is shown
below:

   (Thread 1)              |      (Thread 2)
                           | sa1100_enable_ms()
sa1100_set_termios()       |  mod_timer()
 spin_lock_irqsave() //(1) |  (wait a time)
 ...                       | sa1100_timeout()
 del_timer_sync()          |  spin_lock_irqsave() //(2)
 (wait timer to stop)      |  ...

We hold sport->port.lock in position (1) of thread 1 and
use del_timer_sync() to wait timer to stop, but timer handler
also need sport->port.lock in position (2) of thread 2. As a result,
sa1100_set_termios() will block forever.

This patch moves del_timer_sync() before spin_lock_irqsave()
in order to prevent the deadlock.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Link: https://lore.kernel.org/r/20220417111626.7802-1-duoming@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sa1100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sa1100.c b/drivers/tty/serial/sa1100.c
index fd3d1329d48c..68eb1c9faa29 100644
--- a/drivers/tty/serial/sa1100.c
+++ b/drivers/tty/serial/sa1100.c
@@ -452,6 +452,8 @@ sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16); 
 	quot = uart_get_divisor(port, baud);
 
+	del_timer_sync(&sport->timer);
+
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	sport->port.read_status_mask &= UTSR0_TO_SM(UTSR0_TFS);
@@ -482,8 +484,6 @@ sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
 				UTSR1_TO_SM(UTSR1_ROR);
 	}
 
-	del_timer_sync(&sport->timer);
-
 	/*
 	 * Update the per-port timeout.
 	 */
-- 
2.35.1

