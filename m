Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA63D2A5701
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732951AbgKCVcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:32:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:59290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731977AbgKCU5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:57:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50D3522226;
        Tue,  3 Nov 2020 20:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437027;
        bh=O6U5wOOCN4ndNI4ZX6LMq38cihhcCpjkZYVwm+JUdRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cZvk+GR2Fj/nwU4bcDfKjKMQB/MJttzacjkn0kB1pTUSh+ArOajH2/VZdEybiwa7X
         WvGd1Q3lJKos3jYNJpYoJSCngI/2RbDhyahfm3HHzSMaPMl/Yifz6gBz1F/4Liwz/N
         wI4pxwPGNeigK2iYKrO7eHNn74N3DybY2Jvlhizw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/214] clk: ti: clockdomain: fix static checker warning
Date:   Tue,  3 Nov 2020 21:35:25 +0100
Message-Id: <20201103203257.589717041@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tero Kristo <t-kristo@ti.com>

[ Upstream commit b7a7943fe291b983b104bcbd2f16e8e896f56590 ]

Fix a memory leak induced by not calling clk_put after doing of_clk_get.

Reported-by: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Link: https://lore.kernel.org/r/20200907082600.454-3-t-kristo@ti.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clockdomain.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/ti/clockdomain.c b/drivers/clk/ti/clockdomain.c
index 423a99b9f10c7..8d0dea188a284 100644
--- a/drivers/clk/ti/clockdomain.c
+++ b/drivers/clk/ti/clockdomain.c
@@ -146,10 +146,12 @@ static void __init of_ti_clockdomain_setup(struct device_node *node)
 		if (!omap2_clk_is_hw_omap(clk_hw)) {
 			pr_warn("can't setup clkdm for basic clk %s\n",
 				__clk_get_name(clk));
+			clk_put(clk);
 			continue;
 		}
 		to_clk_hw_omap(clk_hw)->clkdm_name = clkdm_name;
 		omap2_init_clk_clkdm(clk_hw);
+		clk_put(clk);
 	}
 }
 
-- 
2.27.0



