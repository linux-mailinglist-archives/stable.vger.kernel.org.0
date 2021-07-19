Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5036A3CDF19
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345073AbhGSPHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346238AbhGSPFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:05:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD034601FD;
        Mon, 19 Jul 2021 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709562;
        bh=DWpobaDPfgHnuXOwwpkJpmQtmK/C8RWhGYIPMsqcv3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HSfcDNsQcdVaip75XocwT2jY0tcKQPPsDh4K3LetuSVKpQ1TQj8CD2cM54NW6/2Lg
         7uOfFlKdjM9s1M2Iu+K1uuDgZ1XkvyGC+ZXVC/B9GJ2txA5ypO/iBKv090ZVb/j1g2
         cSS9tzZK48I+bVqNRLrvv5FGvyvhp1l8LNyXoVRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/149] tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero
Date:   Mon, 19 Jul 2021 16:51:59 +0200
Message-Id: <20210719144904.076804878@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
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
index 6ad985e8dc65..b053345dfd1a 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2253,6 +2253,9 @@ lpuart32_console_get_options(struct lpuart_port *sport, int *baud,
 
 	bd = lpuart32_read(&sport->port, UARTBAUD);
 	bd &= UARTBAUD_SBR_MASK;
+	if (!bd)
+		return;
+
 	sbr = bd;
 	uartclk = lpuart_get_baud_clk_rate(sport);
 	/*
-- 
2.30.2



