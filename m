Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E81C3C316D
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbhGJClV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235806AbhGJCjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2C8961419;
        Sat, 10 Jul 2021 02:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884566;
        bh=6IIqv45VZhMDWIeJ4VV/kuRvyK4QUeRR9GmrKQlpsBA=;
        h=From:To:Cc:Subject:Date:From;
        b=LFMhW7wZ9NCOuhd2sQ9HEsZaB2GXPuTo76Y4/2IRJAZtHLJILSU0Mh45ltYyP5GsA
         n4Ci7nQpVvwG0BDih4UNAQFczNrDefG7ncRla4cGYzbXf2Osz2mW2Osf5WDp267G0F
         +5fxq7c83rgOgZcJq+I2HKHWixMOTCAkxU8NCdxeSFWnnHMfRWZ1ySnFR87HCRuye2
         K1AKlf4bsA0lIdgSG43YraxJySnjEfE1kgIvz05gt7H1wvxhBqzotPmBnLbhDtZwEr
         H0OfgVxQeR+QAKgR0SIUZWKVn77PGow1hEjWWm8Ewe0RY32EIlNYG1qFbTR0ukC7Jo
         ASd8IiZyUkaaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Sun <sherry.sun@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/26] tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero
Date:   Fri,  9 Jul 2021 22:35:39 -0400
Message-Id: <20210710023604.3172486-1-sashal@kernel.org>
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
index 5b6093dc3ff2..a4c1797e30d7 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1766,6 +1766,9 @@ lpuart32_console_get_options(struct lpuart_port *sport, int *baud,
 
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

