Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6822E1431
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgLWCWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:22:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729677AbgLWCWh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:22:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDB1A2312E;
        Wed, 23 Dec 2020 02:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690141;
        bh=X9kGNPC/uquO0NuoTTHGigG2uPGOTanUbGBEW4NI0RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XafFF0MZCVIKw94Jw8h06JqWUoKppNVwItAmNXPpFr1i0cHknoDZzXqhfZMss/LSj
         H4JBwcluspG93oQKqV/dKjDrcjsgzhnpZmjCbLYBur71K5Os/YVJq1MPJE9aJcAg6k
         TMdJL60iRQVzLALAWzgLEIRrL9ylPtqML/dEC7rgAp0LRElsPtNYRZkMM2nICWbKbt
         3APjodKNvT57rnzoPHb6gUTc4R7npBil0kAT0h+xAVx+LMiPoxs3O6vMgChrUBfRO8
         8jo0UqprxgYF10T+LgBex5JRcIyjKsJEjZOol3cL1OlW6IiSusYIhQbHZe+ZLXH6In
         SNSabgTERRNpQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 63/87] cpufreq: mediatek: add missing platform_driver_unregister() on error in mtk_cpufreq_driver_init
Date:   Tue, 22 Dec 2020 21:20:39 -0500
Message-Id: <20201223022103.2792705-63-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
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
index eb8920d398181..83c0c078d3048 100644
--- a/drivers/cpufreq/mediatek-cpufreq.c
+++ b/drivers/cpufreq/mediatek-cpufreq.c
@@ -586,6 +586,7 @@ static int __init mtk_cpufreq_driver_init(void)
 	pdev = platform_device_register_simple("mtk-cpufreq", -1, NULL, 0);
 	if (IS_ERR(pdev)) {
 		pr_err("failed to register mtk-cpufreq platform device\n");
+		platform_driver_unregister(&mtk_cpufreq_platdrv);
 		return PTR_ERR(pdev);
 	}
 
-- 
2.27.0

