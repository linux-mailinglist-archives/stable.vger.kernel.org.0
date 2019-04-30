Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1046F6DB
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbfD3Lwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:52:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731361AbfD3LvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:51:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 504362054F;
        Tue, 30 Apr 2019 11:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625079;
        bh=OdYzluc1D8RkQFvapLx5SNZPZ7XFPmP5OcuUtZr9ZEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOk/Yf7l7iPUV3L2N3K6NAL+H1o4F3Kl/dT7Lb/5vfQCeJSu+Qxq8vbCB4yrFe2JU
         VQ06Ti1Pvjmnc8ZTdTQu2otQ1/Z7Tlofmb2ZEP3vrbm1YanHWmb0l9rP705ie3KtjQ
         Es4Nj8bM6tAeJXnM2VcmkkSSsvSERvEsuyiETiR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 82/89] net: socionext: replace napi_alloc_frag with the netdev variant on init
Date:   Tue, 30 Apr 2019 13:39:13 +0200
Message-Id: <20190430113613.629688800@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

[ Upstream commit ffbf9870dcf1342592a1a26f4cf70bda39046134 ]

The netdev variant is usable on any context since it disables interrupts.
The napi variant of the call should only be used within softirq context.
Replace napi_alloc_frag on driver init with the correct netdev_alloc_frag
call

Changes since v1:
- Adjusted commit message

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Acked-by: Jassi Brar <jaswinder.singh@linaro.org>
Fixes: 4acb20b46214 ("net: socionext: different approach on DMA")
Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/socionext/netsec.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -673,7 +673,8 @@ static void netsec_process_tx(struct net
 }
 
 static void *netsec_alloc_rx_data(struct netsec_priv *priv,
-				  dma_addr_t *dma_handle, u16 *desc_len)
+				  dma_addr_t *dma_handle, u16 *desc_len,
+				  bool napi)
 {
 	size_t total_len = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	size_t payload_len = NETSEC_RX_BUF_SZ;
@@ -682,7 +683,7 @@ static void *netsec_alloc_rx_data(struct
 
 	total_len += SKB_DATA_ALIGN(payload_len + NETSEC_SKB_PAD);
 
-	buf = napi_alloc_frag(total_len);
+	buf = napi ? napi_alloc_frag(total_len) : netdev_alloc_frag(total_len);
 	if (!buf)
 		return NULL;
 
@@ -765,7 +766,8 @@ static int netsec_process_rx(struct nets
 		/* allocate a fresh buffer and map it to the hardware.
 		 * This will eventually replace the old buffer in the hardware
 		 */
-		buf_addr = netsec_alloc_rx_data(priv, &dma_handle, &desc_len);
+		buf_addr = netsec_alloc_rx_data(priv, &dma_handle, &desc_len,
+						true);
 		if (unlikely(!buf_addr))
 			break;
 
@@ -1069,7 +1071,8 @@ static int netsec_setup_rx_dring(struct
 		void *buf;
 		u16 len;
 
-		buf = netsec_alloc_rx_data(priv, &dma_handle, &len);
+		buf = netsec_alloc_rx_data(priv, &dma_handle, &len,
+					   false);
 		if (!buf) {
 			netsec_uninit_pkt_dring(priv, NETSEC_RING_RX);
 			goto err_out;


