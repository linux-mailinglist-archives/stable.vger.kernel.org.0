Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7866DD54
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733223AbfGSELV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:11:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733220AbfGSELU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:11:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08DC521872;
        Fri, 19 Jul 2019 04:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509479;
        bh=bE/o6eAqU6qX/EAT/Xurvd6Cx5OVld2x7NE5cyW1lOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMKmvvVYew3QMsEWHNMmQ7A7cHeXV74TxYZEagejUo7NLYCSwdew1CEss5j8S22lT
         L6Wf5t1EJWLBkUO/XHGFF1OqZYYda6Ue/okAKC1TGO2f4bbX8ILt2W/kp3VlLM5wve
         NQUIF2q+6IhNY4SQufHyp0pExp/Bcnn+pZkUe+9s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@c-s.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/60] tty: serial: cpm_uart - fix init when SMC is relocated
Date:   Fri, 19 Jul 2019 00:10:14 -0400
Message-Id: <20190719041109.18262-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719041109.18262-1-sashal@kernel.org>
References: <20190719041109.18262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 06aaa3d066db87e8478522d910285141d44b1e58 ]

SMC relocation can also be activated earlier by the bootloader,
so the driver's behaviour cannot rely on selected kernel config.

When the SMC is relocated, CPM_CR_INIT_TRX cannot be used.

But the only thing CPM_CR_INIT_TRX does is to clear the
rstate and tstate registers, so this can be done manually,
even when SMC is not relocated.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 9ab921201444 ("cpm_uart: fix non-console port startup bug")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/cpm_uart/cpm_uart_core.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index 8b2b694334ec..8f5a5a16cb3b 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -421,7 +421,16 @@ static int cpm_uart_startup(struct uart_port *port)
 			clrbits16(&pinfo->sccp->scc_sccm, UART_SCCM_RX);
 		}
 		cpm_uart_initbd(pinfo);
-		cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
+		if (IS_SMC(pinfo)) {
+			out_be32(&pinfo->smcup->smc_rstate, 0);
+			out_be32(&pinfo->smcup->smc_tstate, 0);
+			out_be16(&pinfo->smcup->smc_rbptr,
+				 in_be16(&pinfo->smcup->smc_rbase));
+			out_be16(&pinfo->smcup->smc_tbptr,
+				 in_be16(&pinfo->smcup->smc_tbase));
+		} else {
+			cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
+		}
 	}
 	/* Install interrupt handler. */
 	retval = request_irq(port->irq, cpm_uart_int, 0, "cpm_uart", port);
@@ -875,16 +884,14 @@ static void cpm_uart_init_smc(struct uart_cpm_port *pinfo)
 	         (u8 __iomem *)pinfo->tx_bd_base - DPRAM_BASE);
 
 /*
- *  In case SMC1 is being relocated...
+ *  In case SMC is being relocated...
  */
-#if defined (CONFIG_I2C_SPI_SMC1_UCODE_PATCH)
 	out_be16(&up->smc_rbptr, in_be16(&pinfo->smcup->smc_rbase));
 	out_be16(&up->smc_tbptr, in_be16(&pinfo->smcup->smc_tbase));
 	out_be32(&up->smc_rstate, 0);
 	out_be32(&up->smc_tstate, 0);
 	out_be16(&up->smc_brkcr, 1);              /* number of break chars */
 	out_be16(&up->smc_brkec, 0);
-#endif
 
 	/* Set up the uart parameters in the
 	 * parameter ram.
@@ -898,8 +905,6 @@ static void cpm_uart_init_smc(struct uart_cpm_port *pinfo)
 	out_be16(&up->smc_brkec, 0);
 	out_be16(&up->smc_brkcr, 1);
 
-	cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
-
 	/* Set UART mode, 8 bit, no parity, one stop.
 	 * Enable receive and transmit.
 	 */
-- 
2.20.1

