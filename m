Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A0B3C31B9
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbhGJCnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:33892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235242AbhGJCnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:43:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B30AA613EB;
        Sat, 10 Jul 2021 02:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884754;
        bh=OrOvRXnJHcLvOozj6dKL+qNTjYI/AkkXuge1iissLIE=;
        h=From:To:Cc:Subject:Date:From;
        b=gLEgU1BijsTZbQjKJGptrRrZPCdNPPIyjvr8H6YdQ27JZMa/RlBfQKDLa0b7uXO7O
         h2wYU59Bm8MhmNk5+B1GFSne6GUZbV1p11u5VV3NkIHiRwlDevIZoxzX2Z50/Kq+o4
         b7Q+n+q3MbkLLqxLiVIp8pqgsIHvyFXezJK3BG+droG6UsIEU9bVZhbM20yp2V5SX9
         oBH70YqKsD862+YW34TTcBEJ5r0fz33lYAjnYT0emxddor43nH5Etkudz2T9+jRkmZ
         46RljngMtpo9NuEr+k5iOroW+9FSooHVXbSY5VK/0Dngas0mUPPLIkaQvKYrjwW4TJ
         WhApQyVsWNVNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Sun <sherry.sun@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/23] tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero
Date:   Fri,  9 Jul 2021 22:38:50 -0400
Message-Id: <20210710023912.3172972-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sherry Sun <sherry.sun@nxp.com>

[ Upstream commit fcb10ee27fb91b25b68d7745db9817ecea9f1038 ]

We should be very careful about the register values that will be used
for division or modulo operations, althrough the possibility that the
UARTBAUD register value is zero is very low, but we had better to deal
with the "bad data" of hardware in advance to avoid division or modulo
by zero leading to undefined kernel behavior.

Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://lore.kernel.org/r/20210427021226.27468-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 1544a7cc76ff..1319f3dd5b70 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1681,6 +1681,9 @@ lpuart32_console_get_options(struct lpuart_port *sport, int *baud,
 
 	bd = lpuart32_read(sport->port.membase + UARTBAUD);
 	bd &= UARTBAUD_SBR_MASK;
+	if (!bd)
+		return;
+
 	sbr = bd;
 	uartclk = clk_get_rate(sport->clk);
 	/*
-- 
2.30.2

