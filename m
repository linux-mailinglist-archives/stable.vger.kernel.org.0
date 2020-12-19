Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1052DEF24
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgLSM7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:59:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728270AbgLSM7i (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:59:38 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Sverdlin <alexander.sverdlin@gmail.com>
Subject: [PATCH 5.9 45/49] serial: 8250_omap: Avoid FIFO corruption caused by MDR1 access
Date:   Sat, 19 Dec 2020 13:58:49 +0100
Message-Id: <20201219125346.872315993@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@gmail.com>

commit d96f04d347e4011977abdbb4da5d8f303ebd26f8 upstream.

It has been observed that once per 300-1300 port openings the first
transmitted byte is being corrupted on AM3352 ("v" written to FIFO appeared
as "e" on the wire). It only happened if single byte has been transmitted
right after port open, which means, DMA is not used for this transfer and
the corruption never happened afterwards.

Therefore I've carefully re-read the MDR1 errata (link below), which says
"when accessing the MDR1 registers that causes a dummy under-run condition
that will freeze the UART in IrDA transmission. In UART mode, this may
corrupt the transferred data". Strictly speaking,
omap_8250_mdr1_errataset() performs a read access and if the value is the
same as should be written, exits without errata-recommended FIFO reset.

A brief check of the serial_omap_mdr1_errataset() from the competing
omap-serial driver showed it has no read access of MDR1. After removing the
read access from omap_8250_mdr1_errataset() the data corruption never
happened any more.

Link: https://www.ti.com/lit/er/sprz360i/sprz360i.pdf
Fixes: 61929cf0169d ("tty: serial: Add 8250-core based omap driver")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@gmail.com>
Link: https://lore.kernel.org/r/20201210055257.1053028-1-alexander.sverdlin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250_omap.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -184,11 +184,6 @@ static void omap_8250_mdr1_errataset(str
 				     struct omap8250_priv *priv)
 {
 	u8 timeout = 255;
-	u8 old_mdr1;
-
-	old_mdr1 = serial_in(up, UART_OMAP_MDR1);
-	if (old_mdr1 == priv->mdr1)
-		return;
 
 	serial_out(up, UART_OMAP_MDR1, priv->mdr1);
 	udelay(2);


