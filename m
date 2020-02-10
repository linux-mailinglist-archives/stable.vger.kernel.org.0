Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33118157B24
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgBJN1t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:27:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728398AbgBJMgc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:32 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24D052467C;
        Mon, 10 Feb 2020 12:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338190;
        bh=xSKy0VUYvuRtdZfsXdTP62/aEzxuc94wctJhZJ9qRQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CXHJwrQrZVomnwJy2hz9acvR8NE959TtGGt/06joTt72lOpNjl4EmN0mISRj/a1EI
         R79IVAT4HS48No37E42O9ua+Lx1Ou0m0gNl2umXqkB6QNFByNvSFiZ2EDU9Ij99ZCU
         xQe+Melqp4jbIGl2UgFqvJKf0SzbQPPKID92Ovco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harini Katakam <harini.katakam@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 174/195] net: macb: Limit maximum GEM TX length in TSO
Date:   Mon, 10 Feb 2020 04:33:52 -0800
Message-Id: <20200210122322.199856256@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harini Katakam <harini.katakam@xilinx.com>

[ Upstream commit f822e9c4ffa511a5c681cf866287d9383a3b6f1b ]

GEM_MAX_TX_LEN currently resolves to 0x3FF8 for any IP version supporting
TSO with full 14bits of length field in payload descriptor. But an IP
errata causes false amba_error (bit 6 of ISR) when length in payload
descriptors is specified above 16387. The error occurs because the DMA
falsely concludes that there is not enough space in SRAM for incoming
payload. These errors were observed continuously under stress of large
packets using iperf on a version where SRAM was 16K for each queue. This
errata will be documented shortly and affects all versions since TSO
functionality was added. Hence limit the max length to 0x3FC0 (rounded).

Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -66,7 +66,11 @@
 /* Max length of transmit frame must be a multiple of 8 bytes */
 #define MACB_TX_LEN_ALIGN	8
 #define MACB_MAX_TX_LEN		((unsigned int)((1 << MACB_TX_FRMLEN_SIZE) - 1) & ~((unsigned int)(MACB_TX_LEN_ALIGN - 1)))
-#define GEM_MAX_TX_LEN		((unsigned int)((1 << GEM_TX_FRMLEN_SIZE) - 1) & ~((unsigned int)(MACB_TX_LEN_ALIGN - 1)))
+/* Limit maximum TX length as per Cadence TSO errata. This is to avoid a
+ * false amba_error in TX path from the DMA assuming there is not enough
+ * space in the SRAM (16KB) even when there is.
+ */
+#define GEM_MAX_TX_LEN		(unsigned int)(0x3FC0)
 
 #define GEM_MTU_MIN_SIZE	ETH_MIN_MTU
 #define MACB_NETIF_LSO		NETIF_F_TSO


