Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6961CAEFC
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgEHNNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:13:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728736AbgEHMsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73E1D2145D;
        Fri,  8 May 2020 12:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942093;
        bh=+eu7PDIcnxjJ0UsZQxg1LtGjttTgz0EEIalbJfwifiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCDm0kSKDKLfL72MU33Yoqm7LOPUjTaTgAkD85o98JNAKDhY+6mDsP4Z5sBcNFdAZ
         JKOTLDaAtk5LWTTyIKXDdnJcAWC6rA77fk/PYA8iu3QYt5HttfxVxkwCkEsNhdtQPm
         j38tP/uNI7v3NTCFOP95knG0LXDaD6D711pgXtIA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Schichan <nschichan@freebox.fr>,
        Philipp Kirchhofer <philipp@familie-kirchhofer.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 294/312] net: mv643xx_eth: fix packet corruption with TSO and tiny unaligned packets.
Date:   Fri,  8 May 2020 14:34:45 +0200
Message-Id: <20200508123145.044031109@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Schichan <nschichan@freebox.fr>

commit 3b89624ab54b9dc2d92fc08ce2670e5f19ad8ec8 upstream.

The code in txq_put_data() would use txq->tx_curr_desc to index the
tso_hdrs/tso_hdrs_dma buffers, for less than 8 bytes unaligned
fragments, which is already moved to the next descriptor at the
beginning of the function.

If that fragment was the last of the the skb, the next skb would use
that same space to place the ip headers, overwritting that small
fragment data.

Fixes: 91986fd3d335 (net: mv643xx_eth: Ensure proper data alignment in TSO TX path)
Signed-off-by: Nicolas Schichan <nschichan@freebox.fr>
Reviewed-by: Philipp Kirchhofer <philipp@familie-kirchhofer.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/marvell/mv643xx_eth.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -762,10 +762,10 @@ txq_put_data_tso(struct net_device *dev,
 
 	if (length <= 8 && (uintptr_t)data & 0x7) {
 		/* Copy unaligned small data fragment to TSO header data area */
-		memcpy(txq->tso_hdrs + txq->tx_curr_desc * TSO_HEADER_SIZE,
+		memcpy(txq->tso_hdrs + tx_index * TSO_HEADER_SIZE,
 		       data, length);
 		desc->buf_ptr = txq->tso_hdrs_dma
-			+ txq->tx_curr_desc * TSO_HEADER_SIZE;
+			+ tx_index * TSO_HEADER_SIZE;
 	} else {
 		/* Alignment is okay, map buffer and hand off to hardware */
 		txq->tx_desc_mapping[tx_index] = DESC_DMA_MAP_SINGLE;


