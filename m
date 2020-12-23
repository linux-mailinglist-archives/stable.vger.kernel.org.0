Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D082E160F
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731263AbgLWC5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:57:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:49580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729089AbgLWCUs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4E7422525;
        Wed, 23 Dec 2020 02:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690007;
        bh=dWFQx3kO/XpieQ9wmZQGQXwB5w130lMudtO/Wj94Drk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmv3FA1cjQX4m+nUuesbZGk84P7uexj0einPrfLIZZsJ8L0AS9oos0jbYeaYu/oGO
         7V0MS7yb9wm5hYwNvHpSJwT+kf73oOZXTZFWgqSR8bgE4VYwqFYIjcioqdLnPl9lcc
         DguLvRuOIYgG+EKWSZ1KevKzOaI8SPMCMvRr0KovPYGoa4DCDGVFA2xZeT3kK2Xeu9
         jHxADyz9Ze9hMHPKmdITqepfRwI/PC29W0EMIW2UIHurgqNY64ZvUljAxHacI7AAaF
         mFFtn94+GRsGbok3neJbLoi92svG3n4nlI5AsJ5xKgIMEonioqXV6Y7svqXRS4AdWJ
         6JOv2FhbxVULg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yangtao Li <tiny.windzz@gmail.com>,
        Yangtao Li <frank@allwinnertech.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 088/130] cpufreq: sti-cpufreq: fix mem leak in sti_cpufreq_set_opp_info()
Date:   Tue, 22 Dec 2020 21:17:31 -0500
Message-Id: <20201223021813.2791612-88-sashal@kernel.org>
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

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit 3a5e6732a74c44d7c78a764b9a7701135565df8f ]

Use dev_pm_opp_put_prop_name() to avoid mem leak, which free opp_table.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Signed-off-by: Yangtao Li <frank@allwinnertech.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sti-cpufreq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/sti-cpufreq.c b/drivers/cpufreq/sti-cpufreq.c
index 2855b7878a204..858be66ee7d08 100644
--- a/drivers/cpufreq/sti-cpufreq.c
+++ b/drivers/cpufreq/sti-cpufreq.c
@@ -223,7 +223,8 @@ static int sti_cpufreq_set_opp_info(void)
 	opp_table = dev_pm_opp_set_supported_hw(dev, version, VERSION_ELEMENTS);
 	if (IS_ERR(opp_table)) {
 		dev_err(dev, "Failed to set supported hardware\n");
-		return PTR_ERR(opp_table);
+		ret = PTR_ERR(opp_table);
+		goto err_put_prop_name;
 	}
 
 	dev_dbg(dev, "pcode: %d major: %d minor: %d substrate: %d\n",
@@ -232,6 +233,10 @@ static int sti_cpufreq_set_opp_info(void)
 		version[0], version[1], version[2]);
 
 	return 0;
+
+err_put_prop_name:
+	dev_pm_opp_put_prop_name(opp_table);
+	return ret;
 }
 
 static int sti_cpufreq_fetch_syscon_registers(void)
-- 
2.27.0

