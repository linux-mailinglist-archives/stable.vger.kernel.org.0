Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF23D22F1ED
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbgG0Oft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:35:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730583AbgG0OOm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:14:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 002DE21744;
        Mon, 27 Jul 2020 14:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859281;
        bh=YKVuAkV0eYJPZqvXHyFJPRi0u2KKXdveNpN4N5vQAjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMBoOo3Mq8eQbWbC8JG/o8i734tW1XhWvGzeVzCFegYzT4o7xLxqpmXBH/QaYGlG5
         zPWRWcSUVhw8vw53Z4KqJZo09gefnPR/ajw4W5zYUnnmQxzUI83I1btH8Z88gHi7R1
         ppIr9z5LOnmaNfRvIx0vEYYYBNqAzrTnhCVXpuxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 048/138] net: smc91x: Fix possible memory leak in smc_drv_probe()
Date:   Mon, 27 Jul 2020 16:04:03 +0200
Message-Id: <20200727134927.757640108@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134925.228313570@linuxfoundation.org>
References: <20200727134925.228313570@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit bca9749b1aa23d964d3ab930938af66dbf887f15 ]

If try_toggle_control_gpio() failed in smc_drv_probe(), free_netdev(ndev)
should be called to free the ndev created earlier. Otherwise, a memleak
will occur.

Fixes: 7d2911c43815 ("net: smc91x: Fix gpios for device tree based booting")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/smsc/smc91x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc91x.c b/drivers/net/ethernet/smsc/smc91x.c
index 3a6761131f4c2..2248d26746124 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -2274,7 +2274,7 @@ static int smc_drv_probe(struct platform_device *pdev)
 		ret = try_toggle_control_gpio(&pdev->dev, &lp->power_gpio,
 					      "power", 0, 0, 100);
 		if (ret)
-			return ret;
+			goto out_free_netdev;
 
 		/*
 		 * Optional reset GPIO configured? Minimum 100 ns reset needed
@@ -2283,7 +2283,7 @@ static int smc_drv_probe(struct platform_device *pdev)
 		ret = try_toggle_control_gpio(&pdev->dev, &lp->reset_gpio,
 					      "reset", 0, 0, 100);
 		if (ret)
-			return ret;
+			goto out_free_netdev;
 
 		/*
 		 * Need to wait for optional EEPROM to load, max 750 us according
-- 
2.25.1



