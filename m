Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2542722F147
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731762AbgG0ObF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731660AbgG0OVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B00E2070B;
        Mon, 27 Jul 2020 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859664;
        bh=fWgkcWHZ5S4Hy6H2qIaWgZq9/peitARfUWaqCkpTLzQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=glilwNrpGiexzIpCjeDQcZQjbiyHEj6B6Ax2Tby5ekuFVnHAbDKtM0jzPr7as1ecR
         hTosoQOThCa6pfxRJWZOF0YukEnm/7kYDfgmW2ZyTzIWSIhw5SBujD4X8+ESWSA5Er
         Vc/Bg6C/y0Y8A0VnkKl9fSMDTw+oh+KhgZVtd/Js=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 050/179] dpaa2-eth: check fsl_mc_get_endpoint for IS_ERR_OR_NULL()
Date:   Mon, 27 Jul 2020 16:03:45 +0200
Message-Id: <20200727134935.105780439@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 841eb4012cef84820e5906527b31a854f42b0748 ]

The fsl_mc_get_endpoint() function can return an error or directly a
NULL pointer in case the peer device is not under the root DPRC
container. Treat this case also, otherwise it would lead to a NULL
pointer when trying to access the peer fsl_mc_device.

Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 569e06d2bab21..72fa9c4e058f7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -3383,7 +3383,7 @@ static int dpaa2_eth_connect_mac(struct dpaa2_eth_priv *priv)
 
 	dpni_dev = to_fsl_mc_device(priv->net_dev->dev.parent);
 	dpmac_dev = fsl_mc_get_endpoint(dpni_dev);
-	if (IS_ERR(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
+	if (IS_ERR_OR_NULL(dpmac_dev) || dpmac_dev->dev.type != &fsl_mc_bus_dpmac_type)
 		return 0;
 
 	if (dpaa2_mac_is_type_fixed(dpmac_dev, priv->mc_io))
-- 
2.25.1



