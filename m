Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53C3230776
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 12:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbgG1KQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 06:16:23 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:42811 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728463AbgG1KQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jul 2020 06:16:23 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4BGCJ33CGdzMp4W;
        Tue, 28 Jul 2020 12:16:19 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4BGCHf5Pxyz2TRjk;
        Tue, 28 Jul 2020 12:15:58 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.116) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Tue, 28 Jul
 2020 12:08:44 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Mark Brown <broonie@kernel.org>
CC:     <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Christian Eggers" <ceggers@arri.de>, <stable@vger.kernel.org>
Subject: [PATCH] spi: spidev: Align buffers for DMA
Date:   Tue, 28 Jul 2020 12:08:32 +0200
Message-ID: <20200728100832.24788-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.116]
X-RMX-ID: 20200728-121558-4BGCHf5Pxyz2TRjk-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Simply copying all xfers from userspace into one bounce buffer causes
alignment problems if the SPI controller uses DMA.

Ensure that all transfer data blocks within the rx and tx bounce buffers
are aligned for DMA (according to ARCH_KMALLOC_MINALIGN).

Alignment may increase the usage of the bounce buffers. In some cases,
the buffers may need to be increased using the "bufsiz" module
parameter.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
---
 drivers/spi/spidev.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 59e07675ef86..455e99c4958e 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -224,6 +224,11 @@ static int spidev_message(struct spidev_data *spidev,
 	for (n = n_xfers, k_tmp = k_xfers, u_tmp = u_xfers;
 			n;
 			n--, k_tmp++, u_tmp++) {
+		/* Ensure that also following allocations from rx_buf/tx_buf will meet
+		 * DMA alignment requirements.
+		 */
+		unsigned int len_aligned = ALIGN(u_tmp->len, ARCH_KMALLOC_MINALIGN);
+
 		k_tmp->len = u_tmp->len;
 
 		total += k_tmp->len;
@@ -239,17 +244,17 @@ static int spidev_message(struct spidev_data *spidev,
 
 		if (u_tmp->rx_buf) {
 			/* this transfer needs space in RX bounce buffer */
-			rx_total += k_tmp->len;
+			rx_total += len_aligned;
 			if (rx_total > bufsiz) {
 				status = -EMSGSIZE;
 				goto done;
 			}
 			k_tmp->rx_buf = rx_buf;
-			rx_buf += k_tmp->len;
+			rx_buf += len_aligned;
 		}
 		if (u_tmp->tx_buf) {
 			/* this transfer needs space in TX bounce buffer */
-			tx_total += k_tmp->len;
+			tx_total += len_aligned;
 			if (tx_total > bufsiz) {
 				status = -EMSGSIZE;
 				goto done;
@@ -259,7 +264,7 @@ static int spidev_message(struct spidev_data *spidev,
 						(uintptr_t) u_tmp->tx_buf,
 					u_tmp->len))
 				goto done;
-			tx_buf += k_tmp->len;
+			tx_buf += len_aligned;
 		}
 
 		k_tmp->cs_change = !!u_tmp->cs_change;
@@ -293,16 +298,16 @@ static int spidev_message(struct spidev_data *spidev,
 		goto done;
 
 	/* copy any rx data out of bounce buffer */
-	rx_buf = spidev->rx_buffer;
-	for (n = n_xfers, u_tmp = u_xfers; n; n--, u_tmp++) {
+	for (n = n_xfers, k_tmp = k_xfers, u_tmp = u_xfers;
+			n;
+			n--, k_tmp++, u_tmp++) {
 		if (u_tmp->rx_buf) {
 			if (copy_to_user((u8 __user *)
-					(uintptr_t) u_tmp->rx_buf, rx_buf,
+					(uintptr_t) u_tmp->rx_buf, k_tmp->rx_buf,
 					u_tmp->len)) {
 				status = -EFAULT;
 				goto done;
 			}
-			rx_buf += u_tmp->len;
 		}
 	}
 	status = total;
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

