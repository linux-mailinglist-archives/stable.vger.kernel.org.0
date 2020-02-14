Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57DF215ED53
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392873AbgBNRdW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:33:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390427AbgBNQG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:06:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FAC422314;
        Fri, 14 Feb 2020 16:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696387;
        bh=RJz+RrkbU4lgmkToGa+2MO6GD3Qh7Gga30b3H8XRPnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZtykO0lZFsU7RMEqyEZXCH4CpX0wqZ1bhMnBbMQSPIaqsw2OVeo7rs1Q8Orm5pE8
         Dv7GTU1HufrO0ygDeYMbEZT9ky5Uv9r2NLhhx9Htq0awh81TLArMwLIN8Ep9RaOGfc
         JZknTJ/Jx0I8kjQUo9DOddee3GEIfx11oRA+qwbU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 213/459] clk: renesas: rcar-gen3: Allow changing the RPC[D2] clocks
Date:   Fri, 14 Feb 2020 10:57:43 -0500
Message-Id: <20200214160149.11681-213-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[ Upstream commit 0d67c0340a60829c5c1b7d09629d23bbd67696f3 ]

I was unable to get clk_set_rate() setting a lower RPC-IF clock frequency
and that issue boiled down to me not passing CLK_SET_RATE_PARENT flag to
clk_register_composite() when registering the RPC[D2] clocks...

Fixes: db4a0073cc82 ("clk: renesas: rcar-gen3: Add RPC clocks")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Link: https://lore.kernel.org/r/be27a344-d8bf-9e0c-8950-2d1b48498496@cogentembedded.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rcar-gen3-cpg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/rcar-gen3-cpg.c b/drivers/clk/renesas/rcar-gen3-cpg.c
index d25c8ba00a656..532626946b8d2 100644
--- a/drivers/clk/renesas/rcar-gen3-cpg.c
+++ b/drivers/clk/renesas/rcar-gen3-cpg.c
@@ -464,7 +464,8 @@ static struct clk * __init cpg_rpc_clk_register(const char *name,
 
 	clk = clk_register_composite(NULL, name, &parent_name, 1, NULL, NULL,
 				     &rpc->div.hw,  &clk_divider_ops,
-				     &rpc->gate.hw, &clk_gate_ops, 0);
+				     &rpc->gate.hw, &clk_gate_ops,
+				     CLK_SET_RATE_PARENT);
 	if (IS_ERR(clk)) {
 		kfree(rpc);
 		return clk;
@@ -500,7 +501,8 @@ static struct clk * __init cpg_rpcd2_clk_register(const char *name,
 
 	clk = clk_register_composite(NULL, name, &parent_name, 1, NULL, NULL,
 				     &rpcd2->fixed.hw, &clk_fixed_factor_ops,
-				     &rpcd2->gate.hw, &clk_gate_ops, 0);
+				     &rpcd2->gate.hw, &clk_gate_ops,
+				     CLK_SET_RATE_PARENT);
 	if (IS_ERR(clk))
 		kfree(rpcd2);
 
-- 
2.20.1

