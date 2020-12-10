Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810452D5383
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 07:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732949AbgLJGBA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 01:01:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731841AbgLJGBA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 01:01:00 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953ADC0613CF;
        Wed,  9 Dec 2020 22:00:19 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id l9so4136416wrt.13;
        Wed, 09 Dec 2020 22:00:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XZ0GzFkMnql2mZ9ucABMri0aPX93XDgGP0zi1s6RhwA=;
        b=lpPQkdebMIuW2w/cNOMG3wQQ6LBxUIp+8A+fz23QJ6YBfQHmYd2Q6TFsEzkd65Bz2Q
         nnmjvPjeS+4gbIrHSjWnyZY7eigeX6MXbFvOHu9iqxzTfso5Xn4Ex20eiBA1DOc7Dqg1
         gajDdftMTG6qbWO0ufCTvhUF7BOCqbI/Y9fc+bD3jzdCux81kf+U8V/S9SD+MsqxMfMn
         P+KQhlhvWVTuXidYsGa2+Ghj1y15ukXr6DAbF+glgtNRLH2wLJZGbY9DftaZGhgcZZlW
         W8VN8+Zp2vbP95uhZ1etegd9qAn7liSoWUXEfjb44h6WVNpPFg4jj52djNRPlRFWy4z0
         wDnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XZ0GzFkMnql2mZ9ucABMri0aPX93XDgGP0zi1s6RhwA=;
        b=dyArKJHorjqCp0RbMDPAJBu0OA0Tk/+pdO3Lmq4XwjESnqA+K4D9eAVNCch1AdLpfz
         Rf6HR2boX27Gx5fErEC6T9mxDMPNzN708tHxU2cWfx4j/2OZBPsGU4Raer3vcfixjLH0
         t7RZGvh/F+f2Gpf3uAPmfacWivPMuWQfN+aXNxivGNMWmUsbEpegfp/GSjc8doTYePoZ
         cxbST9YyqwFFpQelunUds9zYMN6x8w+EmS58WoPj0bPwWA0SVDrIfhyMxLJnso+dLDbc
         PnDxm8+GRIaYv491G1YFil5c5BKPav/Tq3fSCdVgYo58Y7rcfU4Ttu1RKt1tDyPMJBmr
         btgg==
X-Gm-Message-State: AOAM533TvHeO04ermift8cJCucVCppjEqQ+1fbtfs1uGN0VGYI92nfvC
        wHntKB9j/+YF/ntD6Y7EVvFWvPjfxfep9g==
X-Google-Smtp-Source: ABdhPJxIZm4jacRkxlweAry7ldEyr9Cs5Uph++CwJyZaxVGgzBK88btGmFHUxJq7aphOK+x0WV2vZQ==
X-Received: by 2002:adf:916e:: with SMTP id j101mr6237868wrj.55.1607580018016;
        Wed, 09 Dec 2020 22:00:18 -0800 (PST)
Received: from giga-mm.localdomain ([195.245.17.255])
        by smtp.gmail.com with ESMTPSA id q15sm7443906wrw.75.2020.12.09.22.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 22:00:17 -0800 (PST)
From:   Alexander Sverdlin <alexander.sverdlin@gmail.com>
To:     linux-serial@vger.kernel.org
Cc:     Alexander Sverdlin <alexander.sverdlin@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] serial: 8250_omap: Avoid FIFO corruption caused by MDR1 access
Date:   Thu, 10 Dec 2020 06:52:57 +0100
Message-Id: <20201210055257.1053028-1-alexander.sverdlin@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/tty/serial/8250/8250_omap.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index 562087df7d33..0cc6d35a0815 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -184,11 +184,6 @@ static void omap_8250_mdr1_errataset(struct uart_8250_port *up,
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
-- 
2.29.2

