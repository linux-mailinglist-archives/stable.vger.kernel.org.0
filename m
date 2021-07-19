Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0B73CD7C6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242188AbhGSOS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242017AbhGSOSK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:18:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1F4F61164;
        Mon, 19 Jul 2021 14:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706730;
        bh=1lYLeTgNQJM2d5pmWy+rC3KLcs4gGOmYby3BAeXihoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5i2sQ8Q1KhOCOnlpjgfreIol/8fmoyDm3uJstJyZJj0o9xMwDp3n5APA5TEoS1/E
         Nm/Zj6htRD2QwsalmDfXBdfD4hO/yo79C9EKkpKhyPS0vtPxBVNifQQReOp0dlmmIx
         rCOXAevrNAGU/JsoRfNCSvu5LHBpE/Mvk18a/C0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 072/188] net: ethernet: ezchip: fix error handling
Date:   Mon, 19 Jul 2021 16:50:56 +0200
Message-Id: <20210719144929.793162859@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
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
index 73d2bc349b2f..2cb20d8e6bdf 100644
--- a/drivers/net/ethernet/ezchip/nps_enet.c
+++ b/drivers/net/ethernet/ezchip/nps_enet.c
@@ -586,7 +586,7 @@ static s32 nps_enet_probe(struct platform_device *pdev)
 
 	/* Get IRQ number */
 	priv->irq = platform_get_irq(pdev, 0);
-	if (!priv->irq) {
+	if (priv->irq < 0) {
 		dev_err(dev, "failed to retrieve <irq Rx-Tx> value from device tree\n");
 		err = -ENODEV;
 		goto out_netdev;
-- 
2.30.2



