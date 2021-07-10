Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CDD3C2EBA
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233684AbhGJC2P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233662AbhGJC1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33276613D1;
        Sat, 10 Jul 2021 02:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883879;
        bh=gLr8AGwzad/+lkLaGkCkTb6n2SoLCd488fNl48G1pGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQrpfU87OUQRJ3ad8U+RVs/A9z28PaR6hZuiWpz0XA4NCblxpZ6HJn2xy/kJ7z8Qp
         DHHrsft8EMtc8GzzjUrs+fsLis3tuvLgzLfbt4lkvmDitIayWdisf3fbsQNRrtteM4
         uf53keE4JjKDSSpWonJQGXIbFbfdWJSmVQdNckAvahFrIL2fIRIZquIVu3yx765/d/
         1bPIw27aa/XuVBMI7dwc3JI50wFZSu9Zhnx/PzdVKUbTJHHni52wCTObrDr8b/DvZF
         q4o9UBLCAFBBPBgx/XDunfZ1M2yYDUwTjVf7QzxJZVsIxi2ALJrMoC9CV1wLJPm4Bo
         p7e05TN3syHrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sherry Sun <sherry.sun@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 08/93] tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero
Date:   Fri,  9 Jul 2021 22:23:02 -0400
Message-Id: <20210710022428.3169839-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022428.3169839-1-sashal@kernel.org>
References: <20210710022428.3169839-1-sashal@kernel.org>
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
index bd047e1f9bea..7aab87c92192 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2414,6 +2414,9 @@ lpuart32_console_get_options(struct lpuart_port *sport, int *baud,
 
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

