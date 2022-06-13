Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2CB5492FD
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349997AbiFMLG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351885AbiFMLFL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:05:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CBDE7;
        Mon, 13 Jun 2022 03:34:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10AD4B80E93;
        Mon, 13 Jun 2022 10:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB20C34114;
        Mon, 13 Jun 2022 10:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116472;
        bh=x3KhVWC0ll/qL0hqYrVnjfMXp95Ww5ZMIt+AkkTdFUI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhQdUgDNf4vYE7E/m2Iz1JaohBrIFYG8db7LD/Inffk0TUtiYtOSRdE4weI47tf7s
         LdvN87roJjowIhGk0foBKLKeyqgKf6MxUcny30LPkkbBV7Yp4QWW4c6k2KurjUuaoN
         kJvMJfg0KlhDqR6PIWBT/JM8/RisJ/AAtOe/UjbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 187/218] drivers: tty: serial: Fix deadlock in sa1100_set_termios()
Date:   Mon, 13 Jun 2022 12:10:45 +0200
Message-Id: <20220613094926.286902618@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



