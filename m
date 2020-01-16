Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6063513F798
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387444AbgAPQ5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:57:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387439AbgAPQ5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:57:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70EDD24681;
        Thu, 16 Jan 2020 16:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193829;
        bh=LHdU43H2Tr//VSt9UKxgsbBuqAgJVBpuTORBTKsdp9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6NjOXpz3bgeZ39SuGvh4B2YgOHXQSLCeaRBr04QGtSUTDnrdh+USRivJ0LQhJeDq
         BEDgk6HZedaQBB5XucWkD/MqOE2raslXe56MqCZrRAArdTqIWCGqkl/FF4+LCADyuI
         n+V1ep+KI028/ZIqfiexUvz69QfeGpfyx9tgXJRI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 086/671] clk: ti: fix refcount leak in ti_dt_clocks_register()
Date:   Thu, 16 Jan 2020 11:45:17 -0500
Message-Id: <20200116165502.8838-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 2274d8001fbb5e1942fbcab5ad2eb15553b09ed2 ]

The of_find_compatible_node() returns a node pointer with refcount
incremented, but there is the lack of use of the of_node_put() when
done. Add the missing of_node_put() to release the refcount.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Fixes: 5b385a45e001 ("clk: ti: add support for clkctrl aliases")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/clk.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ti/clk.c b/drivers/clk/ti/clk.c
index 27e0979b3158..0cc87c6ae91c 100644
--- a/drivers/clk/ti/clk.c
+++ b/drivers/clk/ti/clk.c
@@ -188,9 +188,13 @@ void __init ti_dt_clocks_register(struct ti_dt_clk oclks[])
 			clkdev_add(&c->lk);
 		} else {
 			if (num_args && !has_clkctrl_data) {
-				if (of_find_compatible_node(NULL, NULL,
-							    "ti,clkctrl")) {
+				struct device_node *np;
+
+				np = of_find_compatible_node(NULL, NULL,
+							     "ti,clkctrl");
+				if (np) {
 					has_clkctrl_data = true;
+					of_node_put(np);
 				} else {
 					clkctrl_nodes_missing = true;
 
-- 
2.20.1

