Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E7F23A4D9
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgHCMay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729114AbgHCMax (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:30:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 764232076B;
        Mon,  3 Aug 2020 12:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457852;
        bh=1XyuKvmwYbLPHPN4jsoUH2TOc7R4uC09XNDVY4IuVZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEtCJlkPYKrFxZI1mLO6nmRyvM9GbM+8gHlBWdHJfit6Y6DZf2dT6GQDMGCc5BMtp
         Yw1QucbmJzUaN1hzyE51k4VbdSXm+VTQwbmaYM8gvmhe4vECMLVRLl9/3MQSqNyZq7
         ymaL4jMwC86reHtu5Uk/Nd1lWi1dN1qWn8mSO668=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 66/90] net: gemini: Fix missing clk_disable_unprepare() in error path of gemini_ethernet_port_probe()
Date:   Mon,  3 Aug 2020 14:19:28 +0200
Message-Id: <20200803121900.814408872@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121857.546052424@linuxfoundation.org>
References: <20200803121857.546052424@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 85496a29224188051b6135eb38da8afd4c584765 ]

Fix the missing clk_disable_unprepare() before return
from gemini_ethernet_port_probe() in the error handling case.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 2814b96751b4f..01ae113f122a0 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -2445,6 +2445,7 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 	port->reset = devm_reset_control_get_exclusive(dev, NULL);
 	if (IS_ERR(port->reset)) {
 		dev_err(dev, "no reset\n");
+		clk_disable_unprepare(port->pclk);
 		return PTR_ERR(port->reset);
 	}
 	reset_control_reset(port->reset);
@@ -2500,8 +2501,10 @@ static int gemini_ethernet_port_probe(struct platform_device *pdev)
 					IRQF_SHARED,
 					port_names[port->id],
 					port);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(port->pclk);
 		return ret;
+	}
 
 	ret = register_netdev(netdev);
 	if (!ret) {
-- 
2.25.1



