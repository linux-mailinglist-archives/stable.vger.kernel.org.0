Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F163D3CE1FD
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349403AbhGSP0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348270AbhGSPYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:24:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8551161460;
        Mon, 19 Jul 2021 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710626;
        bh=N0b5EA01m6rix3zjJGI/CI/y5V9fr1n/JREdGLiscwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SgWpPTsJHC5bQNi4caq0BvAdZ2VIv5I4i/v6PnUCWg4uekjX4AInSNcA/RTSJXpVv
         xc59nQiRVvJ6L5EjgwOwsuMbMEKRS/Ma15+1KZAjBkgmgP0/JGQcRxEUfE/QyLj6pf
         YY1mpGkmWq04NNhpnxtatNttA0Vve3wf2mRiFvu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sherry Sun <sherry.sun@nxp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 048/351] tty: serial: fsl_lpuart: fix the potential risk of division or modulo by zero
Date:   Mon, 19 Jul 2021 16:49:54 +0200
Message-Id: <20210719144946.129079667@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 9c78e43e669d..4cad2ac00e9f 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2404,6 +2404,9 @@ lpuart32_console_get_options(struct lpuart_port *sport, int *baud,
 
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



