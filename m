Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5041F310E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 03:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgFHXHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727815AbgFHXHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:07:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E6E520888;
        Mon,  8 Jun 2020 23:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657631;
        bh=CnVp9pwpDTm0m2p+hSbXaay1pQhH2Cr6uUvMrwh7L4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asC0ZA2Kf7DQBdLkqrlomrj2p18prOf9rXA/3a50M2saW74UL/sxWig7wuYS/0Trk
         cj2JzGb8u6WKcAG7IwLwbv2PwcYcx0IvfywyL4gfHw4gR4QyZBjxczCf1hE0GCw887
         VIojbkv2t5sHzIVeHdN0ameH6FJGoZM2I96Njzbs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Lina Iyer <ilina@codeaurora.org>,
        Sudeep Holla <sudeep.holla@arm.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 050/274] cpuidle: psci: Fixup execution order when entering a domain idle state
Date:   Mon,  8 Jun 2020 19:02:23 -0400
Message-Id: <20200608230607.3361041-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 8b7ce5e49049ca78c238f03d70569a73da049f32 ]

Moving forward, platforms are going to need to execute specific "last-man"
operations before a domain idle state can be entered. In one way or the
other, these operations needs to be triggered while walking the
hierarchical topology via runtime PM and genpd, as it's at that point the
last-man becomes known.

Moreover, executing last-man operations needs to be done after the CPU PM
notifications are sent through cpu_pm_enter(), as otherwise it's likely
that some notifications would fail. Therefore, let's re-order the sequence
in psci_enter_domain_idle_state(), so cpu_pm_enter() gets called prior
pm_runtime_put_sync().

Fixes: ce85aef570df ("cpuidle: psci: Manage runtime PM in the idle path")
Reported-by: Lina Iyer <ilina@codeaurora.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-psci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-psci.c b/drivers/cpuidle/cpuidle-psci.c
index bae9140a65a5..d0fb585073c6 100644
--- a/drivers/cpuidle/cpuidle-psci.c
+++ b/drivers/cpuidle/cpuidle-psci.c
@@ -58,6 +58,10 @@ static int psci_enter_domain_idle_state(struct cpuidle_device *dev,
 	u32 state;
 	int ret;
 
+	ret = cpu_pm_enter();
+	if (ret)
+		return -1;
+
 	/* Do runtime PM to manage a hierarchical CPU toplogy. */
 	pm_runtime_put_sync_suspend(pd_dev);
 
@@ -65,10 +69,12 @@ static int psci_enter_domain_idle_state(struct cpuidle_device *dev,
 	if (!state)
 		state = states[idx];
 
-	ret = psci_enter_state(idx, state);
+	ret = psci_cpu_suspend_enter(state) ? -1 : idx;
 
 	pm_runtime_get_sync(pd_dev);
 
+	cpu_pm_exit();
+
 	/* Clear the domain state to start fresh when back from idle. */
 	psci_set_domain_state(0);
 	return ret;
-- 
2.25.1

