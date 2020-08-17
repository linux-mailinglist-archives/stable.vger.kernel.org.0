Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278C72473A3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388015AbgHQS6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387681AbgHQPtR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:49:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB81020855;
        Mon, 17 Aug 2020 15:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679357;
        bh=11TQG3Ov6Oau5HVpZcE9BPBg2ylugEwIixlNmsWPxMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlquORPRpdmunFGh3iyKYV6mwwh41dh7L75k7HqU5jfxyGw8C/Vt+w/rpJXVAjFKm
         XEOFSHHtQGJ+X6kN/Ax7sTQf6CNtsnFvfG6X9nLfGYtzCPkxNhxvwaL6Pgc0N8KM32
         iU3gdZQXFMvM4Jx89YA++0hZ/TeEd79JYTAJCU0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 156/393] dpaa2-eth: fix condition for number of buffer acquire retries
Date:   Mon, 17 Aug 2020 17:13:26 +0200
Message-Id: <20200817143827.183301761@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 0e5ad75b02d9341eb9ca22627247f9a02cc20d6f ]

We should keep retrying to acquire buffers through the software portals
as long as the function returns -EBUSY and the number of retries is
__below__ DPAA2_ETH_SWP_BUSY_RETRIES.

Fixes: ef17bd7cc0c8 ("dpaa2-eth: Avoid unbounded while loops")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index b7031f8562e04..665ec7269c603 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1054,7 +1054,7 @@ static void drain_bufs(struct dpaa2_eth_priv *priv, int count)
 					       buf_array, count);
 		if (ret < 0) {
 			if (ret == -EBUSY &&
-			    retries++ >= DPAA2_ETH_SWP_BUSY_RETRIES)
+			    retries++ < DPAA2_ETH_SWP_BUSY_RETRIES)
 				continue;
 			netdev_err(priv->net_dev, "dpaa2_io_service_acquire() failed\n");
 			return;
-- 
2.25.1



