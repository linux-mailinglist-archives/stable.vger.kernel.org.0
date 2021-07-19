Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD83E3CE464
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347681AbhGSPnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347856AbhGSPjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:39:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEC9061376;
        Mon, 19 Jul 2021 16:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711564;
        bh=fgELw4BBaHIhFYgclLDgscrvOIComfJ0rvQaEzi085M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpiT2eVyDv5S1SoQBce7F2a7DAOvPQZQLibtCcBK1KGc4h7x7rfXr/hq8MKi9FsUJ
         Npe5yI2jSSA/OgE+nuwM/hId0yibUQCBIAO5/A2ypoiO7rE12ZdED3+UXsUOS+ggAB
         Uzeykxn4h+mILn7WcTvL1I4ArPShoaIF91nLLZ5s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 042/292] serial: fsl_lpuart: disable DMA for console and fix sysrq
Date:   Mon, 19 Jul 2021 16:51:44 +0200
Message-Id: <20210719144943.897721619@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4cad2ac00e9f..0d7ea144a4a6 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1571,6 +1571,9 @@ static void lpuart_tx_dma_startup(struct lpuart_port *sport)
 	u32 uartbaud;
 	int ret;
 
+	if (uart_console(&sport->port))
+		goto err;
+
 	if (!sport->dma_tx_chan)
 		goto err;
 
@@ -1600,6 +1603,9 @@ static void lpuart_rx_dma_startup(struct lpuart_port *sport)
 	int ret;
 	unsigned char cr3;
 
+	if (uart_console(&sport->port))
+		goto err;
+
 	if (!sport->dma_rx_chan)
 		goto err;
 
-- 
2.30.2



