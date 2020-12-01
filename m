Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F702C9D18
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389717AbgLAJSw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:18:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389705AbgLAJK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:10:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA2B02223C;
        Tue,  1 Dec 2020 09:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813788;
        bh=RMrGW5fUW+s/0FXfRqugpnfe2Ya9KtsxGllhgvAD7i0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zjUoU4G5NniaYanFOzISrsV4Ng0i/1LT5/bRapeYJ7rxff5HV2irPqBDMAn/qnTUw
         oYzx2hrjlH7w9sCR2L3Mp/uhhoskIScDTVEDEHZwVrgOjGiC2OyVsZz8IAjpc8Ty+o
         fDE9RIldZBh9H0MBpHxQEGYoRsUgaxhC8eJXu7BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Geis <pgwipeout@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 060/152] cpuidle: tegra: Annotate tegra_pm_set_cpu_in_lp2() with RCU_NONIDLE
Date:   Tue,  1 Dec 2020 09:52:55 +0100
Message-Id: <20201201084719.781091645@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



