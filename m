Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EF23CAA33
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243189AbhGOTM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243643AbhGOTJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:09:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19FC461402;
        Thu, 15 Jul 2021 19:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375970;
        bh=LexBJeL7GOk299JLac4Qe7GO0C5Z6j22bpkz07vVgj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2AJ0RHowfHZL2eOYxbvTa6DvbtZA1tX+raWQIAJPKJR8PFyZ0ia0l4Qdv3dhjQ+kw
         B8wQ7JjLv+zE6Oq1rK1YBmx6/c4poBawapOiUwPacsiEKepktLMGuXuEr74Mr+Xcco
         eVyFGJ2Lf6yiEY7eAvtF3zPXCqy0m8bWDvybPL+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 030/266] net: ethernet: ixp4xx: Fix return value check in ixp4xx_eth_probe()
Date:   Thu, 15 Jul 2021 20:36:25 +0200
Message-Id: <20210715182619.419359524@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 20e76d3d044d936998617f8acd7e77bebd9ca703 ]

In case of error, the function mdiobus_get_phy() returns NULL
pointer not ERR_PTR(). The IS_ERR() test in the return value
check should be replaced with NULL test.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index cb89323855d8..1ecceeb9700d 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1531,8 +1531,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 		phydev = of_phy_get_and_connect(ndev, np, ixp4xx_adjust_link);
 	} else {
 		phydev = mdiobus_get_phy(mdio_bus, plat->phy);
-		if (IS_ERR(phydev)) {
-			err = PTR_ERR(phydev);
+		if (!phydev) {
+			err = -ENODEV;
 			dev_err(dev, "could not connect phydev (%d)\n", err);
 			goto err_free_mem;
 		}
-- 
2.30.2



