Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB6727C729
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731088AbgI2Lvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:51:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731093AbgI2LsL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:48:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C8BC2074A;
        Tue, 29 Sep 2020 11:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380091;
        bh=E+h+4T8t9gvH2CklFUCUtEYdfN0kaDKomiSDEuZ1QaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=So1/gJ6QWxNBQOVTgJ18nTARX0skk7fo4S2tA0RD2NeIjmgmE1fqULum08u1Tzarv
         oMjRmDFxrJfE3/0eD2BY1AIOZaJNMfY44gDw5O6DN3VGszH4wsOyV1KLIlukY5g5Ui
         Nox+7yxo3GSscjP0MDB4pKPU5U8djRKHykidDRjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 64/99] PM / devfreq: tegra30: Disable clock on error in probe
Date:   Tue, 29 Sep 2020 13:01:47 +0200
Message-Id: <20200929105932.880194205@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6bf560766a8ef5afe4faa3244220cf5b3a934549 ]

This error path needs to call clk_disable_unprepare().

Fixes: 7296443b900e ("PM / devfreq: tegra30: Handle possible round-rate error")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/tegra30-devfreq.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/tegra30-devfreq.c b/drivers/devfreq/tegra30-devfreq.c
index e94a27804c209..dedd39de73675 100644
--- a/drivers/devfreq/tegra30-devfreq.c
+++ b/drivers/devfreq/tegra30-devfreq.c
@@ -836,7 +836,8 @@ static int tegra_devfreq_probe(struct platform_device *pdev)
 	rate = clk_round_rate(tegra->emc_clock, ULONG_MAX);
 	if (rate < 0) {
 		dev_err(&pdev->dev, "Failed to round clock rate: %ld\n", rate);
-		return rate;
+		err = rate;
+		goto disable_clk;
 	}
 
 	tegra->max_freq = rate / KHZ;
@@ -897,6 +898,7 @@ static int tegra_devfreq_probe(struct platform_device *pdev)
 	dev_pm_opp_remove_all_dynamic(&pdev->dev);
 
 	reset_control_reset(tegra->reset);
+disable_clk:
 	clk_disable_unprepare(tegra->clock);
 
 	return err;
-- 
2.25.1



