Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C62406BFE
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhIJMgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:53706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234055AbhIJMfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:35:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD77D61221;
        Fri, 10 Sep 2021 12:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277240;
        bh=Tffiqs3obAKlBqzPkwEMJ6xzyjDYXefTcDPZLUQYFnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMDvRh7TcSH3QetdgI2+T1VpJ4u7meqOz2ss+HoNBNN4rveObM3/w+/VD1eZyNb56
         TRd+AyyJpFJRcIVIlKhSVs/zdgHtgg9IH+6zws1Ko6Ro9IdqrTNgkdlqzhYe61Zetd
         7f6tB3k7a53SLA/eqZ+vFV84cx5O4L0HQxtXG1rY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 5.10 06/26] serial: 8250: 8250_omap: Fix unused variable warning
Date:   Fri, 10 Sep 2021 14:30:10 +0200
Message-Id: <20210910122916.470710157@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
References: <20210910122916.253646001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

commit 6f991850412963381017cfb0d691cbd4d6a551dc upstream.

With commit 439c7183e5b9 ("serial: 8250: 8250_omap: Disable RX interrupt after DMA enable"),
below warning is seen with W=1 and CONFIG_SERIAL_8250_DMA is disabled:

   drivers/tty/serial/8250/8250_omap.c:1199:42: warning: unused variable 'k3_soc_devices' [-Wunused-const-variable]

Fix this by moving the code using k3_soc_devices array to
omap_serial_fill_features_erratas() that handles other errata flags as
well.

Fixes: 439c7183e5b9 ("serial: 8250: 8250_omap: Disable RX interrupt after DMA enable")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Link: https://lore.kernel.org/r/20201111112653.2710-2-vigneshr@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -538,6 +538,11 @@ static void omap_8250_pm(struct uart_por
 static void omap_serial_fill_features_erratas(struct uart_8250_port *up,
 					      struct omap8250_priv *priv)
 {
+	const struct soc_device_attribute k3_soc_devices[] = {
+		{ .family = "AM65X",  },
+		{ .family = "J721E", .revision = "SR1.0" },
+		{ /* sentinel */ }
+	};
 	u32 mvr, scheme;
 	u16 revision, major, minor;
 
@@ -585,6 +590,14 @@ static void omap_serial_fill_features_er
 	default:
 		break;
 	}
+
+	/*
+	 * AM65x SR1.0, AM65x SR2.0 and J721e SR1.0 don't
+	 * don't have RHR_IT_DIS bit in IER2 register. So drop to flag
+	 * to enable errata workaround.
+	 */
+	if (soc_device_match(k3_soc_devices))
+		priv->habit &= ~UART_HAS_RHR_IT_DIS;
 }
 
 static void omap8250_uart_qos_work(struct work_struct *work)
@@ -1208,12 +1221,6 @@ static int omap8250_no_handle_irq(struct
 	return 0;
 }
 
-static const struct soc_device_attribute k3_soc_devices[] = {
-	{ .family = "AM65X",  },
-	{ .family = "J721E", .revision = "SR1.0" },
-	{ /* sentinel */ }
-};
-
 static struct omap8250_dma_params am654_dma = {
 	.rx_size = SZ_2K,
 	.rx_trigger = 1,
@@ -1419,13 +1426,6 @@ static int omap8250_probe(struct platfor
 			up.dma->rxconf.src_maxburst = RX_TRIGGER;
 			up.dma->txconf.dst_maxburst = TX_TRIGGER;
 		}
-
-		/*
-		 * AM65x SR1.0, AM65x SR2.0 and J721e SR1.0 don't
-		 * don't have RHR_IT_DIS bit in IER2 register
-		 */
-		if (soc_device_match(k3_soc_devices))
-			priv->habit &= ~UART_HAS_RHR_IT_DIS;
 	}
 #endif
 	ret = serial8250_register_8250_port(&up);


