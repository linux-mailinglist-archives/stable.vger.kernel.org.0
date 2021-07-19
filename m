Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF153CDE68
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344029AbhGSPDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:03:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245702AbhGSPAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:00:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0D9660238;
        Mon, 19 Jul 2021 15:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709291;
        bh=jubVaQRlhNSmiN+XmTt572cEjRXXkVgH+Bp7bvrT6Vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ne5x1uPgQ9PSIqYXNHBnIpzyRO8fhFWpEtDGKXpB+mq9URRojd8wVPUhpf5FjFv0C
         IdFy9hdjtOjcgsLGGAiWKlGUwm4MW9W18gRy4jIn0p6zrtvrzdA6W9hTSKOheqydT5
         JZt1qIvj02dcTydXl6zKwNYBTGlT99316teQb1eA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 323/421] tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero
Date:   Mon, 19 Jul 2021 16:52:14 +0200
Message-Id: <20210719144957.503921919@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4b9f42269477..deb9d4fa9cb0 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1992,6 +1992,9 @@ lpuart32_console_get_options(struct lpuart_port *sport, int *baud,
 
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



