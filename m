Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C368643443
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbiLETno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:43:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234971AbiLETn3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:43:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B11D2A265
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:40:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16B75612EA
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:40:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228F7C433D6;
        Mon,  5 Dec 2022 19:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269256;
        bh=yFRaeCfxMVwVo2xlNiylzF7EomyknCO3jZdjXVzkwgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vyvH5xn3SxkYvkqzedUg8pW7PbdeWw20PCalkTPSSc44rvpKzT6w0lgnK8qOkyCwg
         VH3pmoicKdiSOVS68f0iAHmamigYbDHsmlOAyJ50CXwzG3uIRDCHU+kpv4RxY02lJl
         VuXSL498VmMy7wT6dNPDSBtfS53iMFWtcUlfCS0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kiszka <jan.kiszka@siemens.com>,
        Su Bao Cheng <baocheng.su@siemens.com>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Lukas Wunner <lukas@wunner.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/153] serial: 8250: 8250_omap: Avoid RS485 RTS glitch on ->set_termios()
Date:   Mon,  5 Dec 2022 20:09:45 +0100
Message-Id: <20221205190810.479916566@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 038ee49fef18710bedd38b531d173ccd746b2d8d ]

RS485-enabled UART ports on TI Sitara SoCs with active-low polarity
exhibit a Transmit Enable glitch on ->set_termios():

omap8250_restore_regs(), which is called from omap_8250_set_termios(),
sets the TCRTLR bit in the MCR register and clears all other bits,
including RTS.  If RTS uses active-low polarity, it is now asserted
for no reason.

The TCRTLR bit is subsequently cleared by writing up->mcr to the MCR
register.  That variable is always zero, so the RTS bit is still cleared
(incorrectly so if RTS is active-high).

(up->mcr is not, as one might think, a cache of the MCR register's
current value.  Rather, it only caches a single bit of that register,
the AFE bit.  And it only does so if the UART supports the AFE bit,
which OMAP does not.  For details see serial8250_do_set_termios() and
serial8250_do_set_mctrl().)

Finally at the end of omap8250_restore_regs(), the MCR register is
restored (and RTS deasserted) by a call to up->port.ops->set_mctrl()
(which equals serial8250_set_mctrl()) and serial8250_em485_stop_tx().

So there's an RTS glitch between setting TCRTLR and calling
serial8250_em485_stop_tx().  Avoid by using a read-modify-write
when setting TCRTLR.

While at it, drop a redundant initialization of up->mcr.  As explained
above, the variable isn't used by the driver and it is already
initialized to zero because it is part of the static struct
serial8250_ports[] declared in 8250_core.c.  (Static structs are
initialized to zero per section 6.7.8 nr. 10 of the C99 standard.)

Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Su Bao Cheng <baocheng.su@siemens.com>
Tested-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/6554b0241a2c7fd50f32576fdbafed96709e11e8.1664278942.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 3d6a159c87f4..928b35b87dcf 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -251,6 +251,7 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 {
 	struct omap8250_priv *priv = up->port.private_data;
 	struct uart_8250_dma	*dma = up->dma;
+	u8 mcr = serial8250_in_MCR(up);
 
 	if (dma && dma->tx_running) {
 		/*
@@ -267,7 +268,7 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 	serial_out(up, UART_EFR, UART_EFR_ECB);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
-	serial8250_out_MCR(up, UART_MCR_TCRTLR);
+	serial8250_out_MCR(up, mcr | UART_MCR_TCRTLR);
 	serial_out(up, UART_FCR, up->fcr);
 
 	omap8250_update_scr(up, priv);
@@ -283,7 +284,8 @@ static void omap8250_restore_regs(struct uart_8250_port *up)
 	serial_out(up, UART_LCR, 0);
 
 	/* drop TCR + TLR access, we setup XON/XOFF later */
-	serial8250_out_MCR(up, up->mcr);
+	serial8250_out_MCR(up, mcr);
+
 	serial_out(up, UART_IER, up->ier);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
@@ -594,7 +596,6 @@ static int omap_8250_startup(struct uart_port *port)
 
 	pm_runtime_get_sync(port->dev);
 
-	up->mcr = 0;
 	serial_out(up, UART_FCR, UART_FCR_CLEAR_RCVR | UART_FCR_CLEAR_XMIT);
 
 	serial_out(up, UART_LCR, UART_LCR_WLEN8);
-- 
2.35.1



