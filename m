Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8331022F121
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:30:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbgG0OVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731805AbgG0OVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:21:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F6312173E;
        Mon, 27 Jul 2020 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859714;
        bh=x1iHGR1Nyu/ytLSpApmQTR1QQy7zYGQSZKRX+Z63DBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lj55AR01ARhDnwBd6aP2Egi+RXCo4Lqn96vb3RcUO9EQRtzVWQ6WW+Uj7xc5H926t
         3KW+G8beg3y2ItV1ViSeirbAsID/84sSug8KecurQn8PBht/ROYOVk9FqNtX01hkfI
         wsPCTwx0a9CrLPWJYIfOasQvlT77XOcbjnz0r8Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Huang Guobin <huangguobin4@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 076/179] net: ag71xx: add missed clk_disable_unprepare in error path of probe
Date:   Mon, 27 Jul 2020 16:04:11 +0200
Message-Id: <20200727134936.384343052@linuxfoundation.org>
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

From: Huang Guobin <huangguobin4@huawei.com>

[ Upstream commit befc113c56a76ae7be3986034a0e476d3385e265 ]

The ag71xx_mdio_probe() forgets to call clk_disable_unprepare() when
of_reset_control_get_exclusive() failed. Add the missed call to fix it.

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/ag71xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 02b7705393ca7..37a1cf63d9f7b 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -556,7 +556,8 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
 	ag->mdio_reset = of_reset_control_get_exclusive(np, "mdio");
 	if (IS_ERR(ag->mdio_reset)) {
 		netif_err(ag, probe, ndev, "Failed to get reset mdio.\n");
-		return PTR_ERR(ag->mdio_reset);
+		err = PTR_ERR(ag->mdio_reset);
+		goto mdio_err_put_clk;
 	}
 
 	mii_bus->name = "ag71xx_mdio";
-- 
2.25.1



