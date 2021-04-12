Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B3A935C07F
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbhDLJOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240619AbhDLJKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4C7661393;
        Mon, 12 Apr 2021 09:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218355;
        bh=b6jP2esBCvWfvUUmVvrzymXsei9WXhVfRMlVzkY32mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7AV5egtTdWKnn/Ywq6dGDfEQoBw+00QMtL9wYMfpGR3cCTXzT7v7EHbr+b6DhnNS
         X+PeQhOv9Xjhr3Jqf+hqibX+yHyF14STce5OXgB0n09Xumne5jENB6l6FVfRRS858G
         T/+AZVhEiUdUzki+ZJXJTa2Uw3b7iXvsb/pTzoio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 131/210] gianfar: Handle error code at MAC address change
Date:   Mon, 12 Apr 2021 10:40:36 +0200
Message-Id: <20210412084020.381989292@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
index 4fab2ee5bbf5..e4d9c4c640e5 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -364,7 +364,11 @@ static void gfar_set_mac_for_addr(struct net_device *dev, int num,
 
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



