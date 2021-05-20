Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C6238A96C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239369AbhETLB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239618AbhETK76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 675C26191C;
        Thu, 20 May 2021 10:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504989;
        bh=AMAJjQ9ujnVW2iJvR7jMrwqJOFWID0e5DYKKQR9xvCQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q2oMMULWlr4hrpc79V9EPeSy8u40Pk4zic/+tBxUiTBtj+7cC6DrXQQO9QZBZxQbY
         4LSKA2XXzXMocyKAftGpNHj0JldUHKmLhEy/ZtGLcINQ27hrLzQfdEZ1jBYiIOAi7C
         JBZJnGJhytLHcQ3ok4hqlg90FzGJj17lR5ub/Vqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 172/240] net: stmmac: Set FIFO sizes for ipq806x
Date:   Thu, 20 May 2021 11:22:44 +0200
Message-Id: <20210520092114.427578636@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>

[ Upstream commit e127906b68b49ddb3ecba39ffa36a329c48197d3 ]

Commit eaf4fac47807 ("net: stmmac: Do not accept invalid MTU values")
started using the TX FIFO size to verify what counts as a valid MTU
request for the stmmac driver.  This is unset for the ipq806x variant.
Looking at older patches for this it seems the RX + TXs buffers can be
up to 8k, so set appropriately.

(I sent this as an RFC patch in June last year, but received no replies.
I've been running with this on my hardware (a MikroTik RB3011) since
then with larger MTUs to support both the internal qca8k switch and
VLANs with no problems. Without the patch it's impossible to set the
larger MTU required to support this.)

Signed-off-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
index 1924788d28da..f4ff43a1b5ba 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -363,6 +363,8 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 	plat_dat->bsp_priv = gmac;
 	plat_dat->fix_mac_speed = ipq806x_gmac_fix_mac_speed;
 	plat_dat->multicast_filter_bins = 0;
+	plat_dat->tx_fifo_size = 8192;
+	plat_dat->rx_fifo_size = 8192;
 
 	err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (err)
-- 
2.30.2



