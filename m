Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E33A22F2C8
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbgG0OHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729240AbgG0OH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:07:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58D1920775;
        Mon, 27 Jul 2020 14:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858846;
        bh=XFO+m3iK7LtY6B1k/pVSY4bt5WEHisSrjpPfU8C8G2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KRwAdmBMn6PwuizklOyl0rMqaASScfVf0dhcKZdIsz2fpoF85tseWIV6qI8UGVtCk
         ViEAruzyWYeDyBMKqBJO8PdcItspikjX/gWe8cixoUfr6BlKti3JClcKCtTy88CMi5
         3YYjWAvJa6sE3iETRyp6cr3RCIP1r/eYKaetf50I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/64] net: smc91x: Fix possible memory leak in smc_drv_probe()
Date:   Mon, 27 Jul 2020 16:04:05 +0200
Message-Id: <20200727134912.446316264@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134911.020675249@linuxfoundation.org>
References: <20200727134911.020675249@linuxfoundation.org>
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
index 96ac0d3af6f5b..f570a37c68c23 100644
--- a/drivers/net/ethernet/smsc/smc91x.c
+++ b/drivers/net/ethernet/smsc/smc91x.c
@@ -2294,7 +2294,7 @@ static int smc_drv_probe(struct platform_device *pdev)
 		ret = try_toggle_control_gpio(&pdev->dev, &lp->power_gpio,
 					      "power", 0, 0, 100);
 		if (ret)
-			return ret;
+			goto out_free_netdev;
 
 		/*
 		 * Optional reset GPIO configured? Minimum 100 ns reset needed
@@ -2303,7 +2303,7 @@ static int smc_drv_probe(struct platform_device *pdev)
 		ret = try_toggle_control_gpio(&pdev->dev, &lp->reset_gpio,
 					      "reset", 0, 0, 100);
 		if (ret)
-			return ret;
+			goto out_free_netdev;
 
 		/*
 		 * Need to wait for optional EEPROM to load, max 750 us according
-- 
2.25.1



