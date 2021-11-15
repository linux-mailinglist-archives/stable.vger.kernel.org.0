Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36EDF451336
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347929AbhKOTs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:48:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245462AbhKOTUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9342C63549;
        Mon, 15 Nov 2021 18:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001317;
        bh=1cmpWzElpAcSuokBDCLpqxv1y2vfsyAWaOAEgIl/9ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bahdGBpzJIbLW6GnqMLLQKVyL39QJODXx2NCyE//7MfJC7zIHreZvssgNDCi4p0Pd
         +MHQhEfkySYCrRjjePyeMdJd32eo85QRrcNii/EGQ92wZrKXHsmb3sBfnxCGsPBALN
         ypVNLEP+f/sQGeIwq5kSWWKAzH4IoY4riA2DN+A8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 127/917] can: mcp251xfd: mcp251xfd_irq(): add missing can_rx_offload_threaded_irq_finish() in case of bus off
Date:   Mon, 15 Nov 2021 17:53:42 +0100
Message-Id: <20211115165433.063458753@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 691204bd66b34ba982e19988e6eba9f6321dfe6c upstream.

The function can_rx_offload_threaded_irq_finish() is needed to trigger
the NAPI thread to deliver read CAN frames to the networking stack.

This patch adds the missing call to can_rx_offload_threaded_irq_finish()
in case of a bus off, before leaving the interrupt handler to avoid
packet starvation.

Link: https://lore.kernel.org/all/20211106201526.44292-1-mkl@pengutronix.de
Fixes: 30bfec4fec59 ("can: rx-offload: can_rx_offload_threaded_irq_finish(): add new function to be called from threaded interrupt")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2290,8 +2290,10 @@ static irqreturn_t mcp251xfd_irq(int irq
 			 * check will fail, too. So leave IRQ handler
 			 * directly.
 			 */
-			if (priv->can.state == CAN_STATE_BUS_OFF)
+			if (priv->can.state == CAN_STATE_BUS_OFF) {
+				can_rx_offload_threaded_irq_finish(&priv->offload);
 				return IRQ_HANDLED;
+			}
 		}
 
 		handled = IRQ_HANDLED;


