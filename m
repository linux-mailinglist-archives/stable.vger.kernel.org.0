Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35242491DA3
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352077AbiARDih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351864AbiARDeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:34:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11E7C037029;
        Mon, 17 Jan 2022 19:09:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86127B811C4;
        Tue, 18 Jan 2022 03:09:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA5BC36AEF;
        Tue, 18 Jan 2022 03:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642475372;
        bh=mOa3viRnCiyugN9lsjwtjitWUVuvU+gNzpDpjLjWNzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGnKZIIFDJwwqsU80Zp6EhSzqeKxoOOh5mWmWM4/ekTaOiaO9UR/bx7At8NE+5U1n
         HHpTApGyM2tsuRC6u4BZp155eip8Da1PX4Z+iFGziYLWSeUluoXH2o82Kog2FRRDJj
         bPwzhpdzSFL5v8eKFA2LuwQhabA1y5gFRPHhiBXTOJnZpjc95cpZMOkYhgYzUVh7WP
         KlzijziV+yln+QL1IRjKn0CRXyrl/tMf/Mtb7zAlWJI9DtE/tnc7yZoTv9pxUEnsDN
         3OfrU/kic2nXeREYAgTVU87yv2LlfkWEOcu/kbfLtvcfQq4d9iIHOCORFPqsPczIef
         ClpucDrtbDJwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Wunner <lukas@wunner.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        jirislaby@kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 27/29] serial: pl010: Drop CR register reset on set_termios
Date:   Mon, 17 Jan 2022 22:08:20 -0500
Message-Id: <20220118030822.1955469-27-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118030822.1955469-1-sashal@kernel.org>
References: <20220118030822.1955469-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 08a0c6dff91c965e39905cf200d22db989203ccb ]

pl010_set_termios() briefly resets the CR register to zero.

Where does this register write come from?

The PL010 driver's IRQ handler ambauart_int() originally modified the CR
register without holding the port spinlock.  ambauart_set_termios() also
modified that register.  To prevent concurrent read-modify-writes by the
IRQ handler and to prevent transmission while changing baudrate,
ambauart_set_termios() had to disable interrupts.  That is achieved by
writing zero to the CR register.

However in 2004 the PL010 driver was amended to acquire the port
spinlock in the IRQ handler, obviating the need to disable interrupts in
->set_termios():
https://git.kernel.org/history/history/c/157c0342e591

That rendered the CR register write obsolete.  Drop it.

Cc: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/fcaff16e5b1abb4cc3da5a2879ac13f278b99ed0.1641128728.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/amba-pl010.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 5d41d5b92619a..7f4ba92739663 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -465,14 +465,11 @@ pl010_set_termios(struct uart_port *port, struct ktermios *termios,
 	if ((termios->c_cflag & CREAD) == 0)
 		uap->port.ignore_status_mask |= UART_DUMMY_RSR_RX;
 
-	/* first, disable everything */
 	old_cr = readb(uap->port.membase + UART010_CR) & ~UART010_CR_MSIE;
 
 	if (UART_ENABLE_MS(port, termios->c_cflag))
 		old_cr |= UART010_CR_MSIE;
 
-	writel(0, uap->port.membase + UART010_CR);
-
 	/* Set baud rate */
 	quot -= 1;
 	writel((quot & 0xf00) >> 8, uap->port.membase + UART010_LCRM);
-- 
2.34.1

