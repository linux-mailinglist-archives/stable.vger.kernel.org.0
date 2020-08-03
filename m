Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE09923A674
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgHCMsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:48:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbgHCMZA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:25:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C00F0204EC;
        Mon,  3 Aug 2020 12:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457499;
        bh=o7PvMwrlk3UBBoMW6c8XhdPCogoApdzwui/Lysd27AY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1SzhS1B+gIJMtkQKwAuFSFl2Wt1aE7iSPzvhqQ+wCcxn1/AeGl7cV4AWJKe2niYE
         nwaaaGZMkg/B8bI4e1/1zk6x0QJ2zzbtpG3wd9R4GQhionaHj5pwkMoGehDFYince+
         XmJR+J7Mh6raon37OIspdhRbQNMBqCHiyZ3tLT34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 089/120] net: gemini: Fix missing clk_disable_unprepare() in error path of gemini_ethernet_port_probe()
Date:   Mon,  3 Aug 2020 14:19:07 +0200
Message-Id: <20200803121907.196147278@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
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
index 5bff5c2be88b9..5359fb40578db 100644
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



