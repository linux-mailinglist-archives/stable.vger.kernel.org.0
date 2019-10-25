Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8BEDE530D
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731710AbfJYSG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:06:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46584 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731309AbfJYSFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0008OF-KG; Fri, 25 Oct 2019 19:05:35 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xu-0001hn-TI; Fri, 25 Oct 2019 19:05:34 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Christophe Leroy" <christophe.leroy@c-s.fr>
Date:   Fri, 25 Oct 2019 19:03:05 +0100
Message-ID: <lsq.1572026582.61489952@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 04/47] tty: serial: cpm_uart - fix init when SMC is
 relocated
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 06aaa3d066db87e8478522d910285141d44b1e58 upstream.

SMC relocation can also be activated earlier by the bootloader,
so the driver's behaviour cannot rely on selected kernel config.

When the SMC is relocated, CPM_CR_INIT_TRX cannot be used.

But the only thing CPM_CR_INIT_TRX does is to clear the
rstate and tstate registers, so this can be done manually,
even when SMC is not relocated.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Fixes: 9ab921201444 ("cpm_uart: fix non-console port startup bug")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/tty/serial/cpm_uart/cpm_uart_core.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -420,7 +420,16 @@ static int cpm_uart_startup(struct uart_
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
@@ -871,16 +880,14 @@ static void cpm_uart_init_smc(struct uar
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
@@ -894,8 +901,6 @@ static void cpm_uart_init_smc(struct uar
 	out_be16(&up->smc_brkec, 0);
 	out_be16(&up->smc_brkcr, 1);
 
-	cpm_line_cr_cmd(pinfo, CPM_CR_INIT_TRX);
-
 	/* Set UART mode, 8 bit, no parity, one stop.
 	 * Enable receive and transmit.
 	 */

