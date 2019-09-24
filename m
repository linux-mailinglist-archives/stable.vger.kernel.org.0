Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C83BCFC8
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfIXRBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 13:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387913AbfIXQoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:44:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2C3B21928;
        Tue, 24 Sep 2019 16:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343460;
        bh=bSxSZR+V3L5L3KCQ7M6cYOUgKsuuT07h+lzgj35jKmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruOitwMRPz9dJYChAbxVkm5XLCV7JQMyh49jCynn6Eq6uGw78NPeKV8/VhYv6WPyH
         o25at64PQt6sPePvw7xDD0k+myJouXrlKJKfSWTG0PVcUyPmDEk09Xe854n9ynq4Gq
         nzdywkCxw5zQYSYLanOQPqm2mxFSa/+6fkLo2Lzo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 57/87] clk: renesas: mstp: Set GENPD_FLAG_ALWAYS_ON for clock domain
Date:   Tue, 24 Sep 2019 12:41:13 -0400
Message-Id: <20190924164144.25591-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit a459a184c978ca9ad538aab93aafdde873953f30 ]

The CPG/MSTP Clock Domain driver does not implement the
generic_pm_domain.power_{on,off}() callbacks, as the domain itself
cannot be powered down.  Hence the domain should be marked as always-on
by setting the GENPD_FLAG_ALWAYS_ON flag, to prevent the core PM Domain
code from considering it for power-off, and doing unnessary processing.

This also gets rid of a boot warning when the Clock Domain contains an
IRQ-safe device, e.g. on RZ/A1:

    sh_mtu2 fcff0000.timer: PM domain cpg_clocks will not be powered off

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Simon Horman <horms+renesas@verge.net.au>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/clk-mstp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/renesas/clk-mstp.c b/drivers/clk/renesas/clk-mstp.c
index 2db9093546c60..e326e6dc09fce 100644
--- a/drivers/clk/renesas/clk-mstp.c
+++ b/drivers/clk/renesas/clk-mstp.c
@@ -334,7 +334,8 @@ void __init cpg_mstp_add_clk_domain(struct device_node *np)
 		return;
 
 	pd->name = np->name;
-	pd->flags = GENPD_FLAG_PM_CLK | GENPD_FLAG_ACTIVE_WAKEUP;
+	pd->flags = GENPD_FLAG_PM_CLK | GENPD_FLAG_ALWAYS_ON |
+		    GENPD_FLAG_ACTIVE_WAKEUP;
 	pd->attach_dev = cpg_mstp_attach_dev;
 	pd->detach_dev = cpg_mstp_detach_dev;
 	pm_genpd_init(pd, &pm_domain_always_on_gov, false);
-- 
2.20.1

