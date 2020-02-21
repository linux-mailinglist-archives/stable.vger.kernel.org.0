Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6595716780D
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbgBUIpq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:45:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:47886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728680AbgBUHuu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:50:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2FCF20801;
        Fri, 21 Feb 2020 07:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271449;
        bh=rVvA20sfcoYyNmfXyFcd9GfCkMVmQpc8fvd+zdtoQew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdunyDA33V2sJDiUxEH+WjeATsJUN3my3UB8yp/C5XZn2zDvm4pD0QnqsBcV1lblm
         rAAIKqoGiNX59T2yqlSmYgEmhwutL16j4GoCM042cES33me/BAqrfIewuMzHycH9va
         p9CgKmj7NOPFQGES12qh2KOr06joXfyvhH4SL2Tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 171/399] clk: renesas: rcar-gen3: Allow changing the RPC[D2] clocks
Date:   Fri, 21 Feb 2020 08:38:16 +0100
Message-Id: <20200221072419.274033711@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
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
index c97b647db9b68..488f8b3980c55 100644
--- a/drivers/clk/renesas/rcar-gen3-cpg.c
+++ b/drivers/clk/renesas/rcar-gen3-cpg.c
@@ -470,7 +470,8 @@ static struct clk * __init cpg_rpc_clk_register(const char *name,
 
 	clk = clk_register_composite(NULL, name, &parent_name, 1, NULL, NULL,
 				     &rpc->div.hw,  &clk_divider_ops,
-				     &rpc->gate.hw, &clk_gate_ops, 0);
+				     &rpc->gate.hw, &clk_gate_ops,
+				     CLK_SET_RATE_PARENT);
 	if (IS_ERR(clk)) {
 		kfree(rpc);
 		return clk;
@@ -506,7 +507,8 @@ static struct clk * __init cpg_rpcd2_clk_register(const char *name,
 
 	clk = clk_register_composite(NULL, name, &parent_name, 1, NULL, NULL,
 				     &rpcd2->fixed.hw, &clk_fixed_factor_ops,
-				     &rpcd2->gate.hw, &clk_gate_ops, 0);
+				     &rpcd2->gate.hw, &clk_gate_ops,
+				     CLK_SET_RATE_PARENT);
 	if (IS_ERR(clk))
 		kfree(rpcd2);
 
-- 
2.20.1



