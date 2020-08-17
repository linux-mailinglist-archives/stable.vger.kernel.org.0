Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66794246A9B
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387434AbgHQPjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387424AbgHQPi6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:38:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D3CC208E4;
        Mon, 17 Aug 2020 15:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678735;
        bh=0t5POLBWNfw7QFM1DJCV/inOcg3oxp4uCilRlsw1hfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9nzOz5G2VVDm5WjPtyT69/61bNgjBaYzJBLzBMSiuPdtFWwV5YIgBQqvFKNEuzWo
         CRaz4RNdTRGTutcQncWEYicMa5mmaUFcWYMf4GcEz/K+A9eQrgr+//hqhELFhDXFWn
         hL2rb/J5C79G+vRFaPF5wcaPcqSDNCb64r45GNh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.8 436/464] spi: spidev: Align buffers for DMA
Date:   Mon, 17 Aug 2020 17:16:29 +0200
Message-Id: <20200817143854.663083713@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

commit aa9e862d7d5bcecd4dca9f39e8b684b93dd84ee7 upstream.

Simply copying all xfers from userspace into one bounce buffer causes
alignment problems if the SPI controller uses DMA.

Ensure that all transfer data blocks within the rx and tx bounce buffers
are aligned for DMA (according to ARCH_KMALLOC_MINALIGN).

Alignment may increase the usage of the bounce buffers. In some cases,
the buffers may need to be increased using the "bufsiz" module
parameter.

Signed-off-by: Christian Eggers <ceggers@arri.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200728100832.24788-1-ceggers@arri.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spidev.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -224,6 +224,11 @@ static int spidev_message(struct spidev_
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
@@ -239,17 +244,17 @@ static int spidev_message(struct spidev_
 
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
@@ -259,7 +264,7 @@ static int spidev_message(struct spidev_
 						(uintptr_t) u_tmp->tx_buf,
 					u_tmp->len))
 				goto done;
-			tx_buf += k_tmp->len;
+			tx_buf += len_aligned;
 		}
 
 		k_tmp->cs_change = !!u_tmp->cs_change;
@@ -293,16 +298,16 @@ static int spidev_message(struct spidev_
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


