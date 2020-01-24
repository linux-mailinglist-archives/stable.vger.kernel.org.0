Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D56147FFE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388809AbgAXLGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:41764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387790AbgAXLGu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:06:50 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BACA0214AF;
        Fri, 24 Jan 2020 11:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864009;
        bh=40Zodo+wKCCu9fsjcp24ZcTvNJAKtnk69lIPtJiO0cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ME3Ggr+FoNU0iY1qDPrAbqa293scrTVtUQAFSL2RHf23v0oy62J8LzWG6hINkTQba
         G95cBAYacPF/Xagwd2KgAs385hJ5EqLX49SHcZDtqVS20u4XR8SW3/Ol9Zgds1Kpmg
         yEjc03/BL1ZLxbbig8UejcdhzQYAtoTv84ZgT8r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/639] memory: tegra: Dont invoke Tegra30+ specific memory timing setup on Tegra20
Date:   Fri, 24 Jan 2020 10:25:02 +0100
Message-Id: <20200124093103.816845759@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit be4dbdec2bab8635c7a41573668624ee13d83022 ]

This fixes irrelevant "tegra-mc 7000f000.memory-controller: no memory
timings for RAM code 0 registered" warning message during of kernels
boot-up on Tegra20.

Fixes: a8d502fd3348 ("memory: tegra: Squash tegra20-mc into common tegra-mc driver")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/tegra/mc.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/memory/tegra/mc.c b/drivers/memory/tegra/mc.c
index c8f16666256cc..346d8eadb44b1 100644
--- a/drivers/memory/tegra/mc.c
+++ b/drivers/memory/tegra/mc.c
@@ -664,12 +664,13 @@ static int tegra_mc_probe(struct platform_device *pdev)
 		}
 
 		isr = tegra_mc_irq;
-	}
 
-	err = tegra_mc_setup_timings(mc);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to setup timings: %d\n", err);
-		return err;
+		err = tegra_mc_setup_timings(mc);
+		if (err < 0) {
+			dev_err(&pdev->dev, "failed to setup timings: %d\n",
+				err);
+			return err;
+		}
 	}
 
 	mc->irq = platform_get_irq(pdev, 0);
-- 
2.20.1



