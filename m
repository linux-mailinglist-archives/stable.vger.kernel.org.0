Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D1B2AB8C4
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 13:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgKIM4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 07:56:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:51338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbgKIM4k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:56:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C73C2207BC;
        Mon,  9 Nov 2020 12:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926598;
        bh=I+GBIy0LMNM4F141vlraS2DQHCDphetxIi030RoZr0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBzkxg1iO6mzmgQQQhjBJiJEHUonJb4lWz2q9rOyKIIVtFyi4mA+3KkVrtIF8jPCe
         +lYo8w3MSepcjkpWPHhH1Xsgt3I0clMvpWijkTm2rkTV7h3ZnOylwIHmnlA6Zn/CSj
         /8T6yvH/xqjVMVd4LfjX/ryMcVkUvk9tRr4txovs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        Tero Kristo <t-kristo@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 25/86] clk: ti: clockdomain: fix static checker warning
Date:   Mon,  9 Nov 2020 13:54:32 +0100
Message-Id: <20201109125022.071242181@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
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
index b9bc3b8df659d..4fde9767392e3 100644
--- a/drivers/clk/ti/clockdomain.c
+++ b/drivers/clk/ti/clockdomain.c
@@ -124,10 +124,12 @@ static void __init of_ti_clockdomain_setup(struct device_node *node)
 		if (clk_hw_get_flags(clk_hw) & CLK_IS_BASIC) {
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



