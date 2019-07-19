Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A90D6DD9B
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387611AbfGSEJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387588AbfGSEJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:09:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E96962189D;
        Fri, 19 Jul 2019 04:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509371;
        bh=8pM3LpYVx8Rwf+jt79f50jH08ME8Hq8RHx9jHHJL83U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rto/5Xeqi7AZf0964MH5p3Z4ya6xywxPuiBgFNu43z6iEimlmqfj0QAs0MOHxLsO8
         1JzKT/NP2BsIb0yAVkB1Kup989rIw0corioa9hDxyTTBz9y3SYY/DOS1oA/2uV08Uk
         yg+/XJJ8OaHrJx2lHG8cVCGID+BoPDdr/V+BpJ5s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 059/101] serial: sh-sci: Terminate TX DMA during buffer flushing
Date:   Fri, 19 Jul 2019 00:06:50 -0400
Message-Id: <20190719040732.17285-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

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
index 040832635a64..71f12601e693 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1633,11 +1633,18 @@ static void sci_free_dma(struct uart_port *port)
 
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

