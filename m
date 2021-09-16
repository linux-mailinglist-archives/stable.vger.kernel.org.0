Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD86D40E59B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244183AbhIPRNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348881AbhIPRLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5169A613A9;
        Thu, 16 Sep 2021 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810265;
        bh=zJhYzoABb5BbEKbkrkFnagJCsOz1csIUNBbgmhs5j+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbTTGpr3NXIISljZeDqOUG6KFezvcKF26d1+lQYGPZ3YuTUm7Cg0hVS8Kw/lPa0G5
         xKghPlDmWYj/9zEYjxKY3OWd7AICUZEhv+XbwgwjpEFSiildRC1tTiEY8YWAQwmJne
         Ndx5EwQ1vlQi/8TuxuJa7Li0VgIbf6ojl7f4OvaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 077/432] clk: renesas: rzg2l: Fix off-by-one check in rzg2l_cpg_clk_src_twocell_get()
Date:   Thu, 16 Sep 2021 17:57:06 +0200
Message-Id: <20210916155813.393546570@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 1606e81543f80fc3b1912957cf6d8fa62e40b8e5 ]

Fix clock index out of range check for module clocks in
rzg2l_cpg_clk_src_twocell_get().

Fixes: ef3c613ccd68 ("clk: renesas: Add CPG core wrapper for RZ/G2L SoC")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20210617155432.18827-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-rzg2l-cpg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/renesas-rzg2l-cpg.c b/drivers/clk/renesas/renesas-rzg2l-cpg.c
index e7c59af2a1d8..f894a210de90 100644
--- a/drivers/clk/renesas/renesas-rzg2l-cpg.c
+++ b/drivers/clk/renesas/renesas-rzg2l-cpg.c
@@ -229,7 +229,7 @@ static struct clk
 
 	case CPG_MOD:
 		type = "module";
-		if (clkidx > priv->num_mod_clks) {
+		if (clkidx >= priv->num_mod_clks) {
 			dev_err(dev, "Invalid %s clock index %u\n", type,
 				clkidx);
 			return ERR_PTR(-EINVAL);
-- 
2.30.2



