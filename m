Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3231F38332E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbhEQOzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:55:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236556AbhEQOwV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FB866198D;
        Mon, 17 May 2021 14:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261430;
        bh=kEnxKvRvXtsSjAMGQKobqwfi53MrIc8FrAhY6aWVDy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u9vVr8WYdEnjQrikn+RmXZJ+ZUp8iabv/9rvw3ZK312asU8/6vvpmCcVrh0+7aIiA
         PmV9/fzr0IGzkLpTxtPlqZ6hAibjDko2/NqCb3k7PjRWzsVutfbpqs/AwKdZe9HTd1
         bmapc2zk09QMH0mAjrFIwfhsKFOqQLi89AmZDK74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 019/289] net: stmmac: Set FIFO sizes for ipq806x
Date:   Mon, 17 May 2021 15:59:04 +0200
Message-Id: <20210517140305.826788332@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index bf3250e0e59c..749585fe6fc9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c
@@ -352,6 +352,8 @@ static int ipq806x_gmac_probe(struct platform_device *pdev)
 	plat_dat->bsp_priv = gmac;
 	plat_dat->fix_mac_speed = ipq806x_gmac_fix_mac_speed;
 	plat_dat->multicast_filter_bins = 0;
+	plat_dat->tx_fifo_size = 8192;
+	plat_dat->rx_fifo_size = 8192;
 
 	err = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (err)
-- 
2.30.2



