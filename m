Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E273CDD95
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237688AbhGSO64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244572AbhGSO56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:57:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21308613CC;
        Mon, 19 Jul 2021 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708932;
        bh=U8AWqVS1ZKVUFzZYrSIhEgyNGHMirGXrQ1uT44A8i9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZYqJ6qe8jy9WGRJJgLv+TInpKxLlKaugUJ8AVqNHfxaFNiFd8Mk3kSJophXGZEZl
         rSLJf7PRX6KdyWFfdok5c2o8kFXNFgLa7OFe+Hm/7FrItOoNhzqWaYGisdba1t+MdA
         6KGgDzQOuCdPh1o4uMhvyBhboHxrJpVdbzabbcIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 144/421] net: ethernet: ezchip: fix error handling
Date:   Mon, 19 Jul 2021 16:49:15 +0200
Message-Id: <20210719144951.482224810@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 0de449d599594f5472e00267d651615c7f2c6c1d ]

As documented at drivers/base/platform.c for platform_get_irq:

 * Gets an IRQ for a platform device and prints an error message if finding the
 * IRQ fails. Device drivers should check the return value for errors so as to
 * not pass a negative integer value to the request_irq() APIs.

So, the driver should check that platform_get_irq() return value
is _negative_, not that it's equal to zero, because -ENXIO (return
value from request_irq() if irq was not found) will
pass this check and it leads to passing negative irq to request_irq()

Fixes: 0dd077093636 ("NET: Add ezchip ethernet driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ezchip/nps_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ezchip/nps_enet.c b/drivers/net/ethernet/ezchip/nps_enet.c
index fbadf08b7c5d..70ccbd11b9e7 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -623,7 +623,7 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 
 	/* Get IRQ number */
 	priv->irq = platform_get_irq(pdev, 0);
-	if (!priv->irq) {
+	if (priv->irq < 0) {
 		dev_err(dev, "failed to retrieve <irq Rx-Tx> value from device tree\n");
 		err = -ENODEV;
 		goto out_netdev;
-- 
2.30.2



