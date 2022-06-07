Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553D9540A12
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351448AbiFGSSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351936AbiFGSQs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3191836B;
        Tue,  7 Jun 2022 10:50:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC561B82340;
        Tue,  7 Jun 2022 17:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F88C34115;
        Tue,  7 Jun 2022 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624208;
        bh=FW/I7BVkoeE8In3t2dtd44ke8+0eARmdPhzZXUroxaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOOYsZzUBG5Pgh87JkDbxxVXkKTUrVe31FngsvunXOBKYrKWDWToPIeoov7bnoagK
         JWjbks8ki+zi0Zb/AfIgGXP2vtzuSUqbho1pfJZUABl/nm7hzxxWY9O+vkeVlJH/PZ
         oIPIrQAGsVV7eaHKR3QIp6BPLUGZWWsZqJQpyukBA1FIdfxCYjfSpHPLFF/ynyv/JR
         eP4CuyaUUHpOonz67q9+QNUqugydsCygnGaOq8utsXf2amVJV3gs+xIjlBSd3Z8KO1
         ffm8C0fF3IrdseN+IV/b7Ulhg7gCvuavJRT+rDhFh4T6MlreTHILgPoXoHWqVsf4uN
         jmLgTmXWSPoTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, jirislaby@kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 14/68] drivers: tty: serial: Fix deadlock in sa1100_set_termios()
Date:   Tue,  7 Jun 2022 13:47:40 -0400
Message-Id: <20220607174846.477972-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
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
index 5fe6cccfc1ae..e64e42a19d1a 100644
--- a/drivers/tty/serial/sa1100.c
+++ b/drivers/tty/serial/sa1100.c
@@ -446,6 +446,8 @@ sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16); 
 	quot = uart_get_divisor(port, baud);
 
+	del_timer_sync(&sport->timer);
+
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	sport->port.read_status_mask &= UTSR0_TO_SM(UTSR0_TFS);
@@ -476,8 +478,6 @@ sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
 				UTSR1_TO_SM(UTSR1_ROR);
 	}
 
-	del_timer_sync(&sport->timer);
-
 	/*
 	 * Update the per-port timeout.
 	 */
-- 
2.35.1

