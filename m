Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDB281D32
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730441AbfHENaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:30:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730365AbfHENU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:20:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D25522173B;
        Mon,  5 Aug 2019 13:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011256;
        bh=BFA5KkJp4vIV/V6KNLMZnNb7Da08HBmuiJBDgQVvN4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XRd9GTlZkJk2D+HOsvH/drL9DE0+QHDU1g6vGCgLYhtcOtvy/smX0gbt55404FwC
         omNIaZnNd48kIkf8t0hNh+T+gYd3T2RRTnOfEoVT3VyrW7ub/ai3xd4Dyel4+0z2Tp
         bvUw400K68pnGibqVyM78frHdSSAMIcLdeeTrzX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunyan Zhang <zhang.chunyan@linaro.org>,
        Baolin Wang <baolin.wang@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 024/131] clk: sprd: Add check for return value of sprd_clk_regmap_init()
Date:   Mon,  5 Aug 2019 15:01:51 +0200
Message-Id: <20190805124953.060478312@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c974c48deeb969c5e4250e4f06af91edd84b1f10 ]

sprd_clk_regmap_init() doesn't always return success, adding check
for its return value should make the code more strong.

Signed-off-by: Chunyan Zhang <zhang.chunyan@linaro.org>
Reviewed-by: Baolin Wang <baolin.wang@linaro.org>
[sboyd@kernel.org: Add a missing int ret]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sprd/sc9860-clk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/sprd/sc9860-clk.c b/drivers/clk/sprd/sc9860-clk.c
index 9980ab55271ba..f76305b4bc8df 100644
--- a/drivers/clk/sprd/sc9860-clk.c
+++ b/drivers/clk/sprd/sc9860-clk.c
@@ -2023,6 +2023,7 @@ static int sc9860_clk_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
 	const struct sprd_clk_desc *desc;
+	int ret;
 
 	match = of_match_node(sprd_sc9860_clk_ids, pdev->dev.of_node);
 	if (!match) {
@@ -2031,7 +2032,9 @@ static int sc9860_clk_probe(struct platform_device *pdev)
 	}
 
 	desc = match->data;
-	sprd_clk_regmap_init(pdev, desc);
+	ret = sprd_clk_regmap_init(pdev, desc);
+	if (ret)
+		return ret;
 
 	return sprd_clk_probe(&pdev->dev, desc->hw_clks);
 }
-- 
2.20.1



