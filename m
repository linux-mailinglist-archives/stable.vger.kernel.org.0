Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9CA2E160C
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgLWC5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:57:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbgLWCUt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 077F522248;
        Wed, 23 Dec 2020 02:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690008;
        bh=xsujZuYTs+rWJSomwqtj1+QjlAWeKURknxZUciyVNgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l6XBe4mduqBK00a1a7zanvF8249zMoP+WG2gZeWECiQPjHl/nH6LaVmuT/2fDQQW3
         ar4U4X4rCPi2IHGILlD4ZFpUteovCHgwZmOdAP4mbHFiENX3wC0Kc1k6XNr4wf9o6R
         Y2/IgabiRidxO7H78xZ6XBG8z5/LKfeIkV+jqmKF3ZO2AmICqVZVCDMdk25X7Kghxi
         F1Rq/gQruMgOTIz8+4M0asoylK6nzu3I64snYwBqeLhvPWiEm54LxfIC8wCOhund7E
         A/rP2cpNRWJLDKciU+2e6nXXO7EC+DznSI9902ncMN/FSRQq7CEhTX3P/ewrg9NDPE
         91wSotopK9YbA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 089/130] cpufreq: mediatek: add missing platform_driver_unregister() on error in mtk_cpufreq_driver_init
Date:   Tue, 22 Dec 2020 21:17:32 -0500
Message-Id: <20201223021813.2791612-89-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
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
index 0c98dd08273d0..253eece49148c 100644
--- a/drivers/cpufreq/mediatek-cpufreq.c
+++ b/drivers/cpufreq/mediatek-cpufreq.c
@@ -572,6 +572,7 @@ static int __init mtk_cpufreq_driver_init(void)
 	pdev = platform_device_register_simple("mtk-cpufreq", -1, NULL, 0);
 	if (IS_ERR(pdev)) {
 		pr_err("failed to register mtk-cpufreq platform device\n");
+		platform_driver_unregister(&mtk_cpufreq_platdrv);
 		return PTR_ERR(pdev);
 	}
 
-- 
2.27.0

