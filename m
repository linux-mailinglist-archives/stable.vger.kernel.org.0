Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C69B2ABA36
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387496AbgKINQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:43892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731420AbgKINQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD80920663;
        Mon,  9 Nov 2020 13:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927806;
        bh=ZDoYYKu5gM7TPclSB+aTud55LXFMTwAiIIFgk4HNhVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFMCgdoLDtmIBvmDi55o332l2jygqvQ29vLNYSdzqOuKA1//QmZk66k/Jt4SACMiD
         QV6ON0SEyNT681eh3QD7KmtyhRfCpwWEwPyoqUQfWWYIo03gPDfPtapG1lMMmoUwR8
         Np4eOthkG8jOeDPxvCk8AZqLOAbV/Cpxb3vi6K30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 027/133] dpaa_eth: fix the RX headroom size alignment
Date:   Mon,  9 Nov 2020 13:54:49 +0100
Message-Id: <20201109125032.026547527@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Camelia Groza <camelia.groza@nxp.com>

[ Upstream commit 7834e494f42627769d3f965d5d203e9c6ddb8403 ]

The headroom reserved for received frames needs to be aligned to an
RX specific value. There is currently a discrepancy between the values
used in the Ethernet driver and the values passed to the FMan.
Coincidentally, the resulting aligned values are identical.

Fixes: 3c68b8fffb48 ("dpaa_eth: FMan erratum A050385 workaround")
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2845,7 +2845,8 @@ out_error:
 	return err;
 }
 
-static inline u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl)
+static u16 dpaa_get_headroom(struct dpaa_buffer_layout *bl,
+			     enum port_type port)
 {
 	u16 headroom;
 
@@ -2859,9 +2860,12 @@ static inline u16 dpaa_get_headroom(stru
 	 *
 	 * Also make sure the headroom is a multiple of data_align bytes
 	 */
-	headroom = (u16)(bl->priv_data_size + DPAA_HWA_SIZE);
+	headroom = (u16)(bl[port].priv_data_size + DPAA_HWA_SIZE);
 
-	return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
+	if (port == RX)
+		return ALIGN(headroom, DPAA_FD_RX_DATA_ALIGNMENT);
+	else
+		return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
 }
 
 static int dpaa_eth_probe(struct platform_device *pdev)
@@ -3029,8 +3033,8 @@ static int dpaa_eth_probe(struct platfor
 			goto free_dpaa_fqs;
 	}
 
-	priv->tx_headroom = dpaa_get_headroom(&priv->buf_layout[TX]);
-	priv->rx_headroom = dpaa_get_headroom(&priv->buf_layout[RX]);
+	priv->tx_headroom = dpaa_get_headroom(priv->buf_layout, TX);
+	priv->rx_headroom = dpaa_get_headroom(priv->buf_layout, RX);
 
 	/* All real interfaces need their ports initialized */
 	err = dpaa_eth_init_ports(mac_dev, dpaa_bp, &port_fqs,


