Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7127F3CE
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392013AbfHBJwM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:52:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392178AbfHBJwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:52:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4D3A206A2;
        Fri,  2 Aug 2019 09:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739528;
        bh=gW37YEBveilWs83XAvaMJxFdidorjLSE2sOGwO0txh4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZvnv5mgyU2yjxXPuAJRdvQB+pxQabIZhi8FP/OQk69xMxSuQWXpjziMcr1KrTUPJ
         COhWsgN85naueBbuf0VXo0hlBNoChyj1UkjrsvwXkuwRmrnjUtstsGjK9wQLx6gPQY
         5GPvL1CGCkdWwbY0wQylXT3bhNCLzk7sJVJXaOA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 187/223] serial: sh-sci: Terminate TX DMA during buffer flushing
Date:   Fri,  2 Aug 2019 11:36:52 +0200
Message-Id: <20190802092249.613450130@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 775b7ffd7d6d5db320d99b0a485c51e04dfcf9f1 ]

While the .flush_buffer() callback clears sci_port.tx_dma_len since
commit 1cf4a7efdc71cab8 ("serial: sh-sci: Fix race condition causing
garbage during shutdown"), it does not terminate a transmit DMA
operation that may be in progress.

Fix this by terminating any pending DMA operations, and resetting the
corresponding cookie.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Tested-by: Eugeniu Rosca <erosca@de.adit-jv.com>

Link: https://lore.kernel.org/r/20190624123540.20629-3-geert+renesas@glider.be
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sh-sci.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index bcb997935c5e..8ec8b3bbaf25 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1538,11 +1538,18 @@ static void sci_free_dma(struct uart_port *port)
 
 static void sci_flush_buffer(struct uart_port *port)
 {
+	struct sci_port *s = to_sci_port(port);
+
 	/*
 	 * In uart_flush_buffer(), the xmit circular buffer has just been
-	 * cleared, so we have to reset tx_dma_len accordingly.
+	 * cleared, so we have to reset tx_dma_len accordingly, and stop any
+	 * pending transfers
 	 */
-	to_sci_port(port)->tx_dma_len = 0;
+	s->tx_dma_len = 0;
+	if (s->chan_tx) {
+		dmaengine_terminate_async(s->chan_tx);
+		s->cookie_tx = -EINVAL;
+	}
 }
 #else /* !CONFIG_SERIAL_SH_SCI_DMA */
 static inline void sci_request_dma(struct uart_port *port)
-- 
2.20.1



