Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F12F724F98B
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgHXJqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 05:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:33288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728905AbgHXImC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:42:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA5DE2074D;
        Mon, 24 Aug 2020 08:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258522;
        bh=v0EkP+p2M3ReO2oddBs9lqatZyv+GgA96CSxfCFZfos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v89BaR6b4pTZd3nKZCfGiuhG4uePMx/NfZBMcgXYC9gZ7XJzLTq004E9v34+iMgMR
         jAIlDGEWWmytArrkZoxnPLJ3S6tt1T3BIpBk8eB1xlEy8hka39XJ/jixELccKJSQIC
         1Yh+tVMUXow715wCwriV7U10b3P2F8korSn89W0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 076/124] net: fec: correct the error path for regulator disable in probe
Date:   Mon, 24 Aug 2020 10:30:10 +0200
Message-Id: <20200824082413.147234350@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082409.368269240@linuxfoundation.org>
References: <20200824082409.368269240@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

[ Upstream commit c6165cf0dbb82ded90163dce3ac183fc7a913dc4 ]

Correct the error path for regulator disable.

Fixes: 9269e5560b26 ("net: fec: add phy-reset-gpios PROBE_DEFER check")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index bf73bc9bf35b9..76abafd099e22 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3719,11 +3719,11 @@ fec_probe(struct platform_device *pdev)
 failed_irq:
 failed_init:
 	fec_ptp_stop(pdev);
-	if (fep->reg_phy)
-		regulator_disable(fep->reg_phy);
 failed_reset:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	if (fep->reg_phy)
+		regulator_disable(fep->reg_phy);
 failed_regulator:
 	clk_disable_unprepare(fep->clk_ahb);
 failed_clk_ahb:
-- 
2.25.1



