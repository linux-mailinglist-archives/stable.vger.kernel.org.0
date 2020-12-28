Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0402E3BB6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407362AbgL1Nxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:53:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407358AbgL1Nxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:53:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F9E720795;
        Mon, 28 Dec 2020 13:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163586;
        bh=YrJ4i2KC5zr1BIkxlB6HTidPdPmGeddL+Ux+poxKMOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nh+LWYzMyDIeUNZwazStmICAqPOxop04nGE2tzIh/qWytIv2geXDQf+8DMcd69GMk
         NVX+nSu2zXhGMK6Z4QZJm6ZprtHj0mIUWZpFDYeJy0u1M716Bfh6or56DNkPWen3P3
         ksJkipwU4+kDdVeHGiZxEv+ov6K361Y+UHAbIOOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 307/453] clk: s2mps11: Fix a resource leak in error handling paths in the probe function
Date:   Mon, 28 Dec 2020 13:49:03 +0100
Message-Id: <20201228124951.984776194@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d2d94fc567624f96187e8b52083795620f93e69f ]

Some resource should be released in the error handling path of the probe
function, as already done in the remove function.

The remove function was fixed in commit bf416bd45738 ("clk: s2mps11: Add
missing of_node_put and of_clk_del_provider")

Fixes: 7cc560dea415 ("clk: s2mps11: Add support for s2mps11")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20201212122818.86195-1-christophe.jaillet@wanadoo.fr
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-s2mps11.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/clk-s2mps11.c b/drivers/clk/clk-s2mps11.c
index 2ce370c804aae..f19994ce7ca15 100644
--- a/drivers/clk/clk-s2mps11.c
+++ b/drivers/clk/clk-s2mps11.c
@@ -195,6 +195,7 @@ static int s2mps11_clk_probe(struct platform_device *pdev)
 	return ret;
 
 err_reg:
+	of_node_put(s2mps11_clks[0].clk_np);
 	while (--i >= 0)
 		clkdev_drop(s2mps11_clks[i].lookup);
 
-- 
2.27.0



