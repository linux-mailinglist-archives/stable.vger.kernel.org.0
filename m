Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D281CD55F
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729213AbfJFRfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:34332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730176AbfJFRfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:35:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 867ED20700;
        Sun,  6 Oct 2019 17:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383341;
        bh=Z1FXg++vbpg9xKSA6xmGTikQgX/VXgM9vHZDwXnfifc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7fhCKAR9D3dZkDTM+SmUnpx20zuMD9zuoPY6iB4KVJyeBqqqdrVk8W2BpiFD2n69
         w4zoEkxxhICrvPJUuglN3dkSNwvm8jHPOK9AaU7TC19bopbJ7IpYkU2n035qK+9HxV
         q4iRYQH+S7ROTOMSmcNrrek43vCn8X+Pt+dvtis4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 067/137] clk: renesas: cpg-mssr: Set GENPD_FLAG_ALWAYS_ON for clock domain
Date:   Sun,  6 Oct 2019 19:20:51 +0200
Message-Id: <20191006171214.797840292@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171209.403038733@linuxfoundation.org>
References: <20191006171209.403038733@linuxfoundation.org>
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



