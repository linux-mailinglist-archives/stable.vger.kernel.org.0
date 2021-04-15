Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FB0360D09
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhDOO4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:56:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234204AbhDOOzK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9363613EB;
        Thu, 15 Apr 2021 14:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498405;
        bh=f/2zWovTdWw1YiITnl0NVy6h6k/ftA0MY1bRphiYMCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVTDmtLxTBSV6JeYKbKBwsD4HXJtyYSn6G0EW0HK5BHgyUC6zpOkw0IFDwXsoUVeR
         F55ZUbXfyqdgOHzM8Awy7VhWLeLWJxW+GuKt49W6mcE0bljcF+d4KpqUfHuzvXZxyC
         L8pUfUbXeHcFtppKR7OkK5my9i/Vxq6Q7e7iuGeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 26/68] gianfar: Handle error code at MAC address change
Date:   Thu, 15 Apr 2021 16:47:07 +0200
Message-Id: <20210415144415.316808393@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144414.464797272@linuxfoundation.org>
References: <20210415144414.464797272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit bff5b62585123823842833ab20b1c0a7fa437f8c ]

Handle return error code of eth_mac_addr();

Fixes: 3d23a05c75c7 ("gianfar: Enable changing mac addr when if up")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/gianfar.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index b3b7b98eb32c..c89a5a80c9c8 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -485,7 +485,11 @@ static struct net_device_stats *gfar_get_stats(struct net_device *dev)
 
 static int gfar_set_mac_addr(struct net_device *dev, void *p)
 {
-	eth_mac_addr(dev, p);
+	int ret;
+
+	ret = eth_mac_addr(dev, p);
+	if (ret)
+		return ret;
 
 	gfar_set_mac_for_addr(dev, 0, dev->dev_addr);
 
-- 
2.30.2



