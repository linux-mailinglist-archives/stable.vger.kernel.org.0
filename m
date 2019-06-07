Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40B1B39086
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbfFGPs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:48:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731854AbfFGPsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:48:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9088020840;
        Fri,  7 Jun 2019 15:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922531;
        bh=qsBYCJp0T9BTNFdojWwxp9gA8fp2Y3KEZMWRQhokJBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twolFrTcwe3XRwuvPYoWqy39Am+u1ABg6xmrS+RHaz6zgO/hnNyDPDd2+giSa9Eoz
         dOW1yS2oRmonHk/VSvs3CbpddaSWg/7tTni3WZ27l5cY92NsFfxKb0jg3Hn0ourgng
         fdYDrsPd/bTkhALkpJu+S/gXR/k1E6SKFoOlyvN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.1 46/85] tty: serial: msm_serial: Fix XON/XOFF
Date:   Fri,  7 Jun 2019 17:39:31 +0200
Message-Id: <20190607153854.732886196@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>

commit 61c0e37950b88bad590056286c1d766b1f167f4e upstream.

When the tty layer requests the uart to throttle, the current code
executing in msm_serial will trigger "Bad mode in Error Handler" and
generate an invalid stack frame in pstore before rebooting (that is if
pstore is indeed configured: otherwise the user shall just notice a
reboot with no further information dumped to the console).

This patch replaces the PIO byte accessor with the word accessor
already used in PIO mode.

Fixes: 68252424a7c7 ("tty: serial: msm: Support big-endian CPUs")
Cc: stable@vger.kernel.org
Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/msm_serial.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -860,6 +860,7 @@ static void msm_handle_tx(struct uart_po
 	struct circ_buf *xmit = &msm_port->uart.state->xmit;
 	struct msm_dma *dma = &msm_port->tx_dma;
 	unsigned int pio_count, dma_count, dma_min;
+	char buf[4] = { 0 };
 	void __iomem *tf;
 	int err = 0;
 
@@ -869,10 +870,12 @@ static void msm_handle_tx(struct uart_po
 		else
 			tf = port->membase + UART_TF;
 
+		buf[0] = port->x_char;
+
 		if (msm_port->is_uartdm)
 			msm_reset_dm_count(port, 1);
 
-		iowrite8_rep(tf, &port->x_char, 1);
+		iowrite32_rep(tf, buf, 1);
 		port->icount.tx++;
 		port->x_char = 0;
 		return;


