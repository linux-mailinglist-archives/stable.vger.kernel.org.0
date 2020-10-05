Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0872283B2A
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbgJEPkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727660AbgJEP3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 625CF2074F;
        Mon,  5 Oct 2020 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911778;
        bh=ZQme0Sb5Y/n41RlYjxkPOpk4pvn9kOjdIlXsph5hS74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUhWVye0tXC/SY1Win9efMq+wz9hd4/d6nD/hQ73XTTuHKaqoT/NPnClUYrEnEk/c
         vtJV2aIug+rVSBA/WMOG5YjKLaSvRQsIkYJ19FABW2U45VrxrEJH/5Iyufx9jAiPjh
         tnXOOMaOgOJIatBvzgymmH1WZeey1UxlEd0S7QhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/57] phy: ti: am654: Fix a leak in serdes_am654_probe()
Date:   Mon,  5 Oct 2020 17:26:46 +0200
Message-Id: <20201005142111.452008304@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 850280156f6421a404f2351bee07a0e7bedfd4c6 ]

If devm_phy_create() fails then we need to call of_clk_del_provider(node)
to undo the call to of_clk_add_provider().

Fixes: 71e2f5c5c224 ("phy: ti: Add a new SERDES driver for TI's AM654x SoC")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200905124648.GA183976@mwanda
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/ti/phy-am654-serdes.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/ti/phy-am654-serdes.c b/drivers/phy/ti/phy-am654-serdes.c
index 88a047b9fa6fa..6ef12017ff4e8 100644
--- a/drivers/phy/ti/phy-am654-serdes.c
+++ b/drivers/phy/ti/phy-am654-serdes.c
@@ -625,8 +625,10 @@ static int serdes_am654_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 
 	phy = devm_phy_create(dev, NULL, &ops);
-	if (IS_ERR(phy))
-		return PTR_ERR(phy);
+	if (IS_ERR(phy)) {
+		ret = PTR_ERR(phy);
+		goto clk_err;
+	}
 
 	phy_set_drvdata(phy, am654_phy);
 	phy_provider = devm_of_phy_provider_register(dev, serdes_am654_xlate);
-- 
2.25.1



