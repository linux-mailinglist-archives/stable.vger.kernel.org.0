Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4C333BA49
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhCOOIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234197AbhCOODD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D45064EEF;
        Mon, 15 Mar 2021 14:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816982;
        bh=wIIcVitSW8NYeM9iSd+AC5hGv/p8vMp9aaRKoOswoyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSkv+1YUySNYwfj/bPsvgmuMWCUxfyZKM+epfXm+SR0SJic5h3SzF1882BEJHCwmI
         hrotIWqxebojL1tGKZJA7bsQb3WhZNMmSzhwbce4T6Y6zHMyIMI5ArRtNcq18SUNUB
         6rwqfo4ZErK7WgcrKzBxjhwEYtV389MuvUUBTAlI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 243/306] cpufreq: qcom-hw: Fix return value check in qcom_cpufreq_hw_cpu_init()
Date:   Mon, 15 Mar 2021 14:55:06 +0100
Message-Id: <20210315135515.856496762@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 536eb97abeba857126ad055de5923fa592acef25 ]

In case of error, the function ioremap() returns NULL pointer
not ERR_PTR(). The IS_ERR() test in the return value check
should be replaced with NULL test.

Fixes: 67fc209b527d ("cpufreq: qcom-hw: drop devm_xxx() calls from init/exit hooks")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 5cdd20e38771..6de07556665b 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -317,9 +317,9 @@ static int qcom_cpufreq_hw_cpu_init(struct cpufreq_policy *policy)
 	}
 
 	base = ioremap(res->start, resource_size(res));
-	if (IS_ERR(base)) {
+	if (!base) {
 		dev_err(dev, "failed to map resource %pR\n", res);
-		ret = PTR_ERR(base);
+		ret = -ENOMEM;
 		goto release_region;
 	}
 
-- 
2.30.1



