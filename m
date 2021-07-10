Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6CA23C3164
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234691AbhGJClQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235599AbhGJCji (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59730613F5;
        Sat, 10 Jul 2021 02:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884517;
        bh=RziDAp4BQsITzVInvhjMeZNe1otkpJ26f5BdXuv1mXc=;
        h=From:To:Cc:Subject:Date:From;
        b=CVxyO3JofkZrCZ3+yyDKX1z2itvaBp4K8nw8YpCP8kv3wTMNDhUn+TB3nXrsPyDxm
         F5syaJLMp8sUhHg8Fswtn/YXw08ZOW9BwhR7bFviwKoLlDyZ7d4v2+kVoGNH9CxuCi
         4ZrC+i3al/UMyjKt2+sN3mq0izJqv+HmeMy7ues24CrLIQ3AC6CUDyZX84Nblvo2hH
         kcdeRlXBGtzm9IzcOO5E3r/WrZ/wamaxSRjK5r5kALE/m56nADIsDCgmJUbIL5KbxI
         JZV0SjyHjdppsrnzubchv6bakEZ8gBwstPYGvoeF/+q7J4Y4LF33N04A4G+GitGNLf
         pM1Szk13eIb7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Sun <sherry.sun@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/33] tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero
Date:   Fri,  9 Jul 2021 22:34:43 -0400
Message-Id: <20210710023516.3172075-1-sashal@kernel.org>
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
index cebebdcd091c..3d5fe53988e5 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1998,6 +1998,9 @@ lpuart32_console_get_options(struct lpuart_port *sport, int *baud,
 
 	bd = lpuart32_read(&sport->port, UARTBAUD);
 	bd &= UARTBAUD_SBR_MASK;
+	if (!bd)
+		return;
+
 	sbr = bd;
 	uartclk = clk_get_rate(sport->clk);
 	/*
-- 
2.30.2

