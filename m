Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AD52E141A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgLWCiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:38:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728621AbgLWCYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69523233EF;
        Wed, 23 Dec 2020 02:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690237;
        bh=AdvCUUjEWCB+AlSRRlpc+0q1mOiMyNlVANWERmSuMF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRGRL2gTGfkpSPQI37Vy79+iENPDhYDOC1lts95BXld+nJpS8C72wxlQo8V2Bo4aY
         4O8q7ikhCfcD4a+jMJeWfEymB6jE071coRZbvVbuOk+Cca58uAz89QjTT76jT0Hxgy
         KWKVDfZr4L/K1JFgeFDI024DlbNo3oVd9xjTNBUN4qPg2JqHcdGfuhQYyBDJ3EQph8
         0a2usMOZqvTg/+Q9REdP5/S0XrSIK40lOo7EImJA5vqhd6gMsNvoyJXv8B0ZUog8FA
         97vgXGQHU81vxm6DguoRKq9XbOqsroym5nGtFb6V+b1UCRbIPi6W0orklwGG7ouP9o
         Ki4OGeMnnmyLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 51/66] cpufreq: mediatek: add missing platform_driver_unregister() on error in mtk_cpufreq_driver_init
Date:   Tue, 22 Dec 2020 21:22:37 -0500
Message-Id: <20201223022253.2793452-51-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 2f05c19d9ef4f5a42634f83bdb0db596ffc0dd30 ]

Add the missing platform_driver_unregister() before return from
mtk_cpufreq_driver_init in the error handling case when failed
to register mtk-cpufreq platform device

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/mediatek-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/mediatek-cpufreq.c b/drivers/cpufreq/mediatek-cpufreq.c
index 18c4bd9a5c656..30af84b921130 100644
--- a/drivers/cpufreq/mediatek-cpufreq.c
+++ b/drivers/cpufreq/mediatek-cpufreq.c
@@ -614,6 +614,7 @@ static int __init mtk_cpufreq_driver_init(void)
 	pdev = platform_device_register_simple("mtk-cpufreq", -1, NULL, 0);
 	if (IS_ERR(pdev)) {
 		pr_err("failed to register mtk-cpufreq platform device\n");
+		platform_driver_unregister(&mtk_cpufreq_platdrv);
 		return PTR_ERR(pdev);
 	}
 
-- 
2.27.0

