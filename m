Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4E11E2B8A
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403876AbgEZTGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403867AbgEZTGK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:06:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75E5A20776;
        Tue, 26 May 2020 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519968;
        bh=H3zYurp4vws08k5KeeuCCQoUZXnK6XFe5PA6kHN1Gm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1pkQgGh3cyaKGm99TzyjpviPVa13cHx3170afuQMpyeOmciUVU57Rzp9da1WDNk2
         ROm4wzUOPyJV7Dx3G1ry4unN5WPXKmS5nVxNoQ5y1xwgiBRpeuSK5dxI5ZAwhWFRES
         6jVfJqNRuds42JvArtB9EYMx7LKwA9uBhAyMZ8tc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Evan Green <evgreen@chromium.org>,
        Ryan Case <ryandcase@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 62/81] tty: serial: qcom_geni_serial: Fix wrap around of TX buffer
Date:   Tue, 26 May 2020 20:53:37 +0200
Message-Id: <20200526183933.937416893@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Kaehlcke <mka@chromium.org>

[ Upstream commit 3c66eb4ba18dd1cab0d1bde651cde6d8bdb47696 ]

Before commit a1fee899e5bed ("tty: serial: qcom_geni_serial: Fix
softlock") the size of TX transfers was limited to the TX FIFO size,
and wrap arounds of the UART circular buffer were split into two
transfers. With the commit wrap around are allowed within a transfer.
The TX FIFO of the geni serial port uses a word size of 4 bytes. In
case of a circular buffer wrap within a transfer the driver currently
may write an incomplete word to the FIFO, with some bytes containing
data from the circular buffer and others being zero. Since the
transfer isn't completed yet the zero bytes are sent as if they were
actual data.

Handle wrap arounds of the TX buffer properly and ensure that words
written to the TX FIFO always contain valid data (unless the transfer
is completed).

Fixes: a1fee899e5bed ("tty: serial: qcom_geni_serial: Fix softlock")
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Evan Green <evgreen@chromium.org>
Tested-by: Ryan Case <ryandcase@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/qcom_geni_serial.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/qcom_geni_serial.c b/drivers/tty/serial/qcom_geni_serial.c
index 4458419f053b..0d405cc58e72 100644
--- a/drivers/tty/serial/qcom_geni_serial.c
+++ b/drivers/tty/serial/qcom_geni_serial.c
@@ -705,7 +705,7 @@ static void qcom_geni_serial_handle_tx(struct uart_port *uport, bool done,
 	avail *= port->tx_bytes_pw;
 
 	tail = xmit->tail;
-	chunk = min3(avail, pending, (size_t)(UART_XMIT_SIZE - tail));
+	chunk = min(avail, pending);
 	if (!chunk)
 		goto out_write_wakeup;
 
@@ -727,19 +727,21 @@ static void qcom_geni_serial_handle_tx(struct uart_port *uport, bool done,
 
 		memset(buf, 0, ARRAY_SIZE(buf));
 		tx_bytes = min_t(size_t, remaining, port->tx_bytes_pw);
-		for (c = 0; c < tx_bytes ; c++)
-			buf[c] = xmit->buf[tail + c];
+
+		for (c = 0; c < tx_bytes ; c++) {
+			buf[c] = xmit->buf[tail++];
+			tail &= UART_XMIT_SIZE - 1;
+		}
 
 		iowrite32_rep(uport->membase + SE_GENI_TX_FIFOn, buf, 1);
 
 		i += tx_bytes;
-		tail += tx_bytes;
 		uport->icount.tx += tx_bytes;
 		remaining -= tx_bytes;
 		port->tx_remaining -= tx_bytes;
 	}
 
-	xmit->tail = tail & (UART_XMIT_SIZE - 1);
+	xmit->tail = tail;
 
 	/*
 	 * The tx fifo watermark is level triggered and latched. Though we had
-- 
2.25.1



