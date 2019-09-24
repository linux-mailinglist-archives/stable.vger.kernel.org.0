Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFE8BCF92
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbfIXQ6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2633288AbfIXQrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:47:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CFBE217D9;
        Tue, 24 Sep 2019 16:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343661;
        bh=Z1FXg++vbpg9xKSA6xmGTikQgX/VXgM9vHZDwXnfifc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjzcB8Wv8BrT5i/7uxMaYwNvczot2GT0b7f5RuPEorScljIz4rRbKvO2KnMDklaKG
         WM+g+x73uUd1mTLEAU5dpKkP/P1auFt0Rdb/f30JIZ5JszbAEas0cU9a3FqNkuUQlx
         lOHyr/Wvm7V+DsBHbEMw1DnuJWIoc2s+kAVn7Ckk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 46/70] clk: renesas: cpg-mssr: Set GENPD_FLAG_ALWAYS_ON for clock domain
Date:   Tue, 24 Sep 2019 12:45:25 -0400
Message-Id: <20190924164549.27058-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164549.27058-1-sashal@kernel.org>
References: <20190924164549.27058-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9dfa28d6fd9f9..cbe5fb468b7f9 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -555,7 +555,8 @@ static int __init cpg_mssr_add_clk_domain(struct device *dev,
 
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

