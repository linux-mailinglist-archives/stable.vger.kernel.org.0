Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F89D2C443D
	for <lists+stable@lfdr.de>; Wed, 25 Nov 2020 16:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbgKYPmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Nov 2020 10:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:53724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730501AbgKYPgZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Nov 2020 10:36:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8966921D1A;
        Wed, 25 Nov 2020 15:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606318584;
        bh=RMrGW5fUW+s/0FXfRqugpnfe2Ya9KtsxGllhgvAD7i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aw+AJlSs8MfW4pDekDU0mEXzNzH7cz2w+yYif5/D2bTvg95jXrBcGVVT0s4Xvy597
         rdn0c4suSfwRcH3Ry/H9HjOJGBCgfiFKFLxUGNOoCs2zT4tG2CmPfTQLULe6rUutvQ
         HzzSt3owMP4L8S71s1nB13u/FrlD1+gHxyQZLX1Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 24/33] cpuidle: tegra: Annotate tegra_pm_set_cpu_in_lp2() with RCU_NONIDLE
Date:   Wed, 25 Nov 2020 10:35:41 -0500
Message-Id: <20201125153550.810101-24-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201125153550.810101-1-sashal@kernel.org>
References: <20201125153550.810101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit c39de538a06e76d89b7e598a71e16688009cd56c ]

Annotate tegra_pm_set[clear]_cpu_in_lp2() with RCU_NONIDLE in order to
fix lockdep warning about suspicious RCU usage of a spinlock during late
idling phase.

 WARNING: suspicious RCU usage
 ...
 include/trace/events/lock.h:13 suspicious rcu_dereference_check() usage!
 ...
  (dump_stack) from (lock_acquire)
  (lock_acquire) from (_raw_spin_lock)
  (_raw_spin_lock) from (tegra_pm_set_cpu_in_lp2)
  (tegra_pm_set_cpu_in_lp2) from (tegra_cpuidle_enter)
  (tegra_cpuidle_enter) from (cpuidle_enter_state)
  (cpuidle_enter_state) from (cpuidle_enter_state_coupled)
  (cpuidle_enter_state_coupled) from (cpuidle_enter)
  (cpuidle_enter) from (do_idle)
 ...

Tested-by: Peter Geis <pgwipeout@gmail.com>
Reported-by: Peter Geis <pgwipeout@gmail.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-tegra.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-tegra.c b/drivers/cpuidle/cpuidle-tegra.c
index e8956706a2917..191966dc8d023 100644
--- a/drivers/cpuidle/cpuidle-tegra.c
+++ b/drivers/cpuidle/cpuidle-tegra.c
@@ -189,7 +189,7 @@ static int tegra_cpuidle_state_enter(struct cpuidle_device *dev,
 	}
 
 	local_fiq_disable();
-	tegra_pm_set_cpu_in_lp2();
+	RCU_NONIDLE(tegra_pm_set_cpu_in_lp2());
 	cpu_pm_enter();
 
 	switch (index) {
@@ -207,7 +207,7 @@ static int tegra_cpuidle_state_enter(struct cpuidle_device *dev,
 	}
 
 	cpu_pm_exit();
-	tegra_pm_clear_cpu_in_lp2();
+	RCU_NONIDLE(tegra_pm_clear_cpu_in_lp2());
 	local_fiq_enable();
 
 	return err ?: index;
-- 
2.27.0

