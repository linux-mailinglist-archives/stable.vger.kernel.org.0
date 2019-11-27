Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DBD10B8F1
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730116AbfK0UsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:48:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729023AbfK0UsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:48:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBC4921826;
        Wed, 27 Nov 2019 20:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887699;
        bh=J1to47OMKRkj9YZVUv1UjENY/JLzYU8gnUrjNEuIuok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VDBMgyvIcnQsuHF+rQaVoOPEf+Nau0RdHYRg8P2I/x/28RL0fLuAUl4gzTSZSwJTr
         huJlAKLU6UrvrCrb7t/oZvfxkMZp1lGqF9/P1KosRk68bSgVNScZ5apIAjSiGKHhtt
         1mAbftU5yFee1J4NiFBMNKKUMVpSdalizAWDQDRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 061/211] PM / Domains: Deal with multiple states but no governor in genpd
Date:   Wed, 27 Nov 2019 21:29:54 +0100
Message-Id: <20191127203059.762982903@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203049.431810767@linuxfoundation.org>
References: <20191127203049.431810767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 2c9b7f8772033cc8bafbd4eefe2ca605bf3eb094 ]

A caller of pm_genpd_init() that provides some states for the genpd via the
->states pointer in the struct generic_pm_domain, should also provide a
governor. This because it's the job of the governor to pick a state that
satisfies the constraints.

Therefore, let's print a warning to inform the user about such bogus
configuration and avoid to bail out, by instead picking the shallowest
state before genpd invokes the ->power_off() callback.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Lina Iyer <ilina@codeaurora.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/domain.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index c276ba1c0a19e..e811f24148897 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -369,6 +369,10 @@ static int genpd_power_off(struct generic_pm_domain *genpd, bool one_dev_on,
 			return -EAGAIN;
 	}
 
+	/* Default to shallowest state. */
+	if (!genpd->gov)
+		genpd->state_idx = 0;
+
 	if (genpd->power_off) {
 		int ret;
 
@@ -1598,6 +1602,8 @@ int pm_genpd_init(struct generic_pm_domain *genpd,
 		ret = genpd_set_default_power_state(genpd);
 		if (ret)
 			return ret;
+	} else if (!gov) {
+		pr_warn("%s : no governor for states\n", genpd->name);
 	}
 
 	mutex_lock(&gpd_list_lock);
-- 
2.20.1



