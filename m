Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662244CF6C8
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbiCGJnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240003AbiCGJkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:40:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5C76E298;
        Mon,  7 Mar 2022 01:36:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF1B3B810C2;
        Mon,  7 Mar 2022 09:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10875C340F3;
        Mon,  7 Mar 2022 09:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645781;
        bh=79BBtJCvrd7O12tzZuDbSN/2vkImyTVHbL+QeoTs2V8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t0Lgt0yKoww3hL5giEpKoVLlMnzqqxl/mOcmstb5ScZoxG36dmT8iMYfoBCmAz9gr
         6V7TWrCeejI4FpAegJ/MP1xByGoVJ2+R/TqFSqqtng4lHkXlXzk3NoP25LL5XO3jLt
         CJi1K+YGWsoSltF0Dswr6upAq0uVn9o+dWpi5VIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Caron <valentin.caron@foss.st.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/262] serial: stm32: prevent TDR register overwrite when sending x_char
Date:   Mon,  7 Mar 2022 10:16:17 +0100
Message-Id: <20220307091703.301925709@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Caron <valentin.caron@foss.st.com>

[ Upstream commit d3d079bde07e1b7deaeb57506dc0b86010121d17 ]

When sending x_char in stm32_usart_transmit_chars(), driver can overwrite
the value of TDR register by the value of x_char. If this happens, the
previous value that was present in TDR register will not be sent through
uart.

This code checks if the previous value in TDR register is sent before
writing the x_char value into register.

Fixes: 48a6092fb41f ("serial: stm32-usart: Add STM32 USART Driver")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Valentin Caron <valentin.caron@foss.st.com>
Link: https://lore.kernel.org/r/20220111164441.6178-2-valentin.caron@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/stm32-usart.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 200cd293d14d5..810a1b0b65203 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -421,10 +421,22 @@ static void stm32_usart_transmit_chars(struct uart_port *port)
 	struct stm32_port *stm32_port = to_stm32_port(port);
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	struct circ_buf *xmit = &port->state->xmit;
+	u32 isr;
+	int ret;
 
 	if (port->x_char) {
 		if (stm32_port->tx_dma_busy)
 			stm32_usart_clr_bits(port, ofs->cr3, USART_CR3_DMAT);
+
+		/* Check that TDR is empty before filling FIFO */
+		ret =
+		readl_relaxed_poll_timeout_atomic(port->membase + ofs->isr,
+						  isr,
+						  (isr & USART_SR_TXE),
+						  10, 1000);
+		if (ret)
+			dev_warn(port->dev, "1 character may be erased\n");
+
 		writel_relaxed(port->x_char, port->membase + ofs->tdr);
 		port->x_char = 0;
 		port->icount.tx++;
-- 
2.34.1



