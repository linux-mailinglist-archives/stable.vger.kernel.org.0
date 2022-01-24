Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E8049A2B3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365943AbiAXXwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843482AbiAXXED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:04:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCDAC06C5B4;
        Mon, 24 Jan 2022 13:15:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1E7A614AA;
        Mon, 24 Jan 2022 21:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF55C340E9;
        Mon, 24 Jan 2022 21:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058939;
        bh=A0N4YdBGt5+tY/dPPMqDq1dg+euWxHCa2Fb1Nmu3dQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1nPt+nu61vquKL9TMV/TOKXPApSkpASNIvvb83J3zOVbm/clYYevKejPf/lknpPbL
         Yy9K1Gh2y8Mu0Q4go2dAVxbwgA+EGSHcZHZAhhrynosnSdfVvPsxX/oth/2j/JYKSN
         NIhkBmXPjiafz56pC5gV08cv672W4BZt0Fjxvejc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0452/1039] clk: renesas: rzg2l: Check return value of pm_genpd_init()
Date:   Mon, 24 Jan 2022 19:37:21 +0100
Message-Id: <20220124184140.490570059@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 27527a3d3b162e4512798c058c0e8a216c721187 ]

Make sure we check the return value of pm_genpd_init() which might fail.
Also add a devres action to remove the power-domain in-case the probe
callback fails further down in the code flow.

Fixes: ef3c613ccd68a ("clk: renesas: Add CPG core wrapper for RZ/G2L SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Link: https://lore.kernel.org/r/20211117115101.28281-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzg2l-cpg.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/rzg2l-cpg.c b/drivers/clk/renesas/rzg2l-cpg.c
index 4021f6cabda4b..4f04ff57d468a 100644
--- a/drivers/clk/renesas/rzg2l-cpg.c
+++ b/drivers/clk/renesas/rzg2l-cpg.c
@@ -850,10 +850,16 @@ static void rzg2l_cpg_detach_dev(struct generic_pm_domain *unused, struct device
 		pm_clk_destroy(dev);
 }
 
+static void rzg2l_cpg_genpd_remove(void *data)
+{
+	pm_genpd_remove(data);
+}
+
 static int __init rzg2l_cpg_add_clk_domain(struct device *dev)
 {
 	struct device_node *np = dev->of_node;
 	struct generic_pm_domain *genpd;
+	int ret;
 
 	genpd = devm_kzalloc(dev, sizeof(*genpd), GFP_KERNEL);
 	if (!genpd)
@@ -864,7 +870,13 @@ static int __init rzg2l_cpg_add_clk_domain(struct device *dev)
 		       GENPD_FLAG_ACTIVE_WAKEUP;
 	genpd->attach_dev = rzg2l_cpg_attach_dev;
 	genpd->detach_dev = rzg2l_cpg_detach_dev;
-	pm_genpd_init(genpd, &pm_domain_always_on_gov, false);
+	ret = pm_genpd_init(genpd, &pm_domain_always_on_gov, false);
+	if (ret)
+		return ret;
+
+	ret = devm_add_action_or_reset(dev, rzg2l_cpg_genpd_remove, genpd);
+	if (ret)
+		return ret;
 
 	of_genpd_add_provider_simple(np, genpd);
 	return 0;
-- 
2.34.1



