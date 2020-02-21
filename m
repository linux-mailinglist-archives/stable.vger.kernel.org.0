Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848CE1672E5
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732075AbgBUIHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:07:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730248AbgBUIHf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:07:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72BC724676;
        Fri, 21 Feb 2020 08:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272454;
        bh=RJz+RrkbU4lgmkToGa+2MO6GD3Qh7Gga30b3H8XRPnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nROOSvkSPcIATPVbhpDl8ET699sy96QfErjd8KX+ndazgw0koBaNINeupf7CXQ9hp
         6Q1F4KzY9oLk5zgCPS+6tNFjcEbQYDzvXzlzPY01wFwz7fPB6+TWOim+/gdza6Uydc
         +OJT6FDVTi991mvU0n9sRXLDLL33jU1AqMa9NTBg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/344] clk: renesas: rcar-gen3: Allow changing the RPC[D2] clocks
Date:   Fri, 21 Feb 2020 08:39:09 +0100
Message-Id: <20200221072402.406447525@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



