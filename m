Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9BF4CD6B6
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbfJFRlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729468AbfJFRlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:41:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98F2D20700;
        Sun,  6 Oct 2019 17:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383674;
        bh=lDL5rQ0iQjQPgcCdFBsieK5RO/jzJBnGB/H48wyFqpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPvh9aZbHCLe9JYGGt0yJ+faRE2bw78mzumCa8C9+c0mzY+qQYjCcxLaAcEd5d20U
         dJIwBqqa4lCsEeScJ4s+LZrXiK27nz3+JnSGdrRXYZCPfOGXLeiZiK8GqYmKfvQ+YT
         n8hOzXIkUuapli0nJa0vylHgGZwKTOC2QaXswfv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 054/166] clk: renesas: cpg-mssr: Set GENPD_FLAG_ALWAYS_ON for clock domain
Date:   Sun,  6 Oct 2019 19:20:20 +0200
Message-Id: <20191006171217.626162443@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f787216f33ce5b5a2567766398f44ab62157114c ]

The CPG/MSSR Clock Domain driver does not implement the
generic_pm_domain.power_{on,off}() callbacks, as the domain itself
cannot be powered down.  Hence the domain should be marked as always-on
by setting the GENPD_FLAG_ALWAYS_ON flag, to prevent the core PM Domain
code from considering it for power-off, and doing unnessary processing.

Note that this only affects RZ/A2 SoCs.  On R-Car Gen2 and Gen3 SoCs,
the R-Car SYSC driver handles Clock Domain creation, and offloads only
device attachment/detachment to the CPG/MSSR driver.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index d4075b1306742..132cc96895e3a 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -551,7 +551,8 @@ static int __init cpg_mssr_add_clk_domain(struct device *dev,
 
 	genpd = &pd->genpd;
 	genpd->name = np->name;
-	genpd->flags = GENPD_FLAG_PM_CLK | GENPD_FLAG_ACTIVE_WAKEUP;
+	genpd->flags = GENPD_FLAG_PM_CLK | GENPD_FLAG_ALWAYS_ON |
+		       GENPD_FLAG_ACTIVE_WAKEUP;
 	genpd->attach_dev = cpg_mssr_attach_dev;
 	genpd->detach_dev = cpg_mssr_detach_dev;
 	pm_genpd_init(genpd, &pm_domain_always_on_gov, false);
-- 
2.20.1



