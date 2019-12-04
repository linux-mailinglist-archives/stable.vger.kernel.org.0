Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F3D11348D
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbfLDSBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:01:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbfLDSBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:01:19 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D754F20659;
        Wed,  4 Dec 2019 18:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482479;
        bh=ZUnfTmRLi56Tq78wLA2fmqZ3fr7i1G1cs1DURUgtK90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQy9qooHzBD8kHHFPK78dsSB7BOz+5gMGMi4rcZTmt0bIbVOyiNFN2ST4nEfH6tXD
         HxVty8CPVrw2qqhTaHBZ7j467+g1AcpQNKK8sK+aMwIzkR1eq6H4FLKlgVqURUQS2y
         0kkotCzcqEoEq3s36lt9K4idPMsdqhNSBfqIbMK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 013/209] net: fec: add missed clk_disable_unprepare in remove
Date:   Wed,  4 Dec 2019 18:53:45 +0100
Message-Id: <20191204175322.476887640@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

[ Upstream commit c43eab3eddb4c6742ac20138659a9b701822b274 ]

This driver forgets to disable and unprepare clks when remove.
Add calls to clk_disable_unprepare to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 0ae6532b02e09..0237221059bfd 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3574,6 +3574,8 @@ fec_drv_remove(struct platform_device *pdev)
 		regulator_disable(fep->reg_phy);
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+	clk_disable_unprepare(fep->clk_ahb);
+	clk_disable_unprepare(fep->clk_ipg);
 	if (of_phy_is_fixed_link(np))
 		of_phy_deregister_fixed_link(np);
 	of_node_put(fep->phy_node);
-- 
2.20.1



