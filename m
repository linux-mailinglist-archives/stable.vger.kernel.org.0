Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBC23C2EBC
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhGJC2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233534AbhGJC1h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:27:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B5AB613E8;
        Sat, 10 Jul 2021 02:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883880;
        bh=Wqxmro3W+5ccL+hctX7Erm55wgwe6w9dc9oi77S6ap4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rjnQiVWj8yGm5OiaEbHz7BUrWUO9V1IeJdrTQC5QiLSOJar6qxb81JMb4U3i8z0hA
         83jts0Gje+NdLs561TPYj5xaPd0ZxFNliOe0PNSsppPUpT/Q8Q+xkRl02uJror+0NY
         KAnYrC//A32OlHrpYJ85h8/KWihnQtmngPfPBXtTvfx5/op0s9nDbSmXXRw9EwpYrp
         wzvRtHCnM6QwHFuotzHlCf6gVqbhq0tzX0tJGn/9Z8YZliDvGk4eoDm2rMKHsJiCe9
         V4Q0goP5SZXaFgisIfbc1PudK7C19GlD1qQUpEVQg9J7V7jy7WUyWZ5csKNieNdk9K
         ZhUKWvZV9WK0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Walle <michael@walle.cc>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/93] serial: fsl_lpuart: disable DMA for console and fix sysrq
Date:   Fri,  9 Jul 2021 22:23:03 -0400
Message-Id: <20210710022428.3169839-9-sashal@kernel.org>
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

From: Michael Walle <michael@walle.cc>

[ Upstream commit 8cac2f6eb8548245e6f8fb893fc7f2a714952654 ]

SYSRQ doesn't work with DMA. This is because there is no error
indication whether a symbol had a framing error or not. Actually,
this is not completely correct, there is a bit in the data register
which is set in this case, but we'd have to read change the DMA access
to 16 bit and we'd need to post process the data, thus make the DMA
pointless in the first place.

Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20210512141255.18277-10-michael@walle.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/fsl_lpuart.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 7aab87c92192..996e9aaa243e 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1581,6 +1581,9 @@ static void lpuart_tx_dma_startup(struct lpuart_port *sport)
 	u32 uartbaud;
 	int ret;
 
+	if (uart_console(&sport->port))
+		goto err;
+
 	if (!sport->dma_tx_chan)
 		goto err;
 
@@ -1610,6 +1613,9 @@ static void lpuart_rx_dma_startup(struct lpuart_port *sport)
 	int ret;
 	unsigned char cr3;
 
+	if (uart_console(&sport->port))
+		goto err;
+
 	if (!sport->dma_rx_chan)
 		goto err;
 
-- 
2.30.2

