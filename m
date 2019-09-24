Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90BCFBCE3B
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410646AbfIXQtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410119AbfIXQtz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:49:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92050222E2;
        Tue, 24 Sep 2019 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343794;
        bh=iFNLHfZGTgPUdhXaraunHws1uO5Hq9xIxfd6f9z792E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o58nHW/GTY33r1rthju7fLKsikJUvIjUPgtVrGc+2eGTTcUosXcaJ9yAI2KQiN5qc
         hBBGkWQW1VKdCPjZUVITuet9LahsEBjwkbAUztoCf9JeVLojdPj5gfndGiBx6lQFCz
         D2tJmLEU0GYhVq1iLI71R6jbt22Jk0Ks85HSAAaU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, linux-clk@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 33/50] clk: renesas: mstp: Set GENPD_FLAG_ALWAYS_ON for clock domain
Date:   Tue, 24 Sep 2019 12:48:30 -0400
Message-Id: <20190924164847.27780-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164847.27780-1-sashal@kernel.org>
References: <20190924164847.27780-1-sashal@kernel.org>
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
index e82adcb16a52a..45d94fb9703d2 100644
--- a/drivers/clk/renesas/clk-mstp.c
+++ b/drivers/clk/renesas/clk-mstp.c
@@ -341,7 +341,8 @@ void __init cpg_mstp_add_clk_domain(struct device_node *np)
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

