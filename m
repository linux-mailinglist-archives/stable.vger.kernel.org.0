Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7123851A88B
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355738AbiEDRL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356915AbiEDRJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C444F47383;
        Wed,  4 May 2022 09:56:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69922B82795;
        Wed,  4 May 2022 16:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BAE6C385AA;
        Wed,  4 May 2022 16:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683385;
        bh=DZc9vvguRZ/lyKSb/utrxbO+TjjSi011tbvZ3KPPSg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AF25SrJjeLn9fHZK/fbslQNYKCAFtqX7pl+3JSAexjTb1HUmxl9w+9bvq3BF92/3g
         ITyOswuEdGnH1aw0YpbwX6LFSxX0Q5lfW5rHM0RUfIyoflTZczxuRSr5J9v6O1LHsq
         HJlzS/GqWSC9ruuN1VFfd74zwLIxs4hBlsSuE7z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 057/225] cpufreq: qcom-hw: fix the opp entries refcounting
Date:   Wed,  4 May 2022 18:44:55 +0200
Message-Id: <20220504153115.251833804@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 6240aaad75e1a623872a830d13393d7aabf1052c ]

The qcom_lmh_dcvs_notify() will get the dev_pm_opp instance for
throttling, but will not put it, ending up with leaking a reference
count and the following backtrace when putting the CPU offline.

Correctly put the reference count of the returned opp instance.

[   84.418025] ------------[ cut here ]------------
[   84.422770] WARNING: CPU: 7 PID: 43 at drivers/opp/core.c:1396 _opp_table_kref_release+0x188/0x190
[   84.431966] Modules linked in:
[   84.435106] CPU: 7 PID: 43 Comm: cpuhp/7 Tainted: G S                5.17.0-rc6-00388-g7cf3c0d89c44-dirty #721
[   84.451631] pstate: 82400005 (Nzcv daif +PAN -UAO +TCO -DIT -SSBS BTYPE=--)
[   84.458781] pc : _opp_table_kref_release+0x188/0x190
[   84.463878] lr : _opp_table_kref_release+0x78/0x190
[   84.468885] sp : ffff80000841bc70
[   84.472294] x29: ffff80000841bc70 x28: ffff6664afe3d000 x27: ffff1db6729e5908
[   84.479621] x26: 0000000000000000 x25: 0000000000000000 x24: ffff1db6729e58e0
[   84.486946] x23: ffff8000080a5000 x22: ffff1db40aad80e0 x21: ffff1db4002fec80
[   84.494277] x20: ffff1db40aad8000 x19: ffffb751c3186300 x18: ffffffffffffffff
[   84.501603] x17: 5300326563697665 x16: 645f676e696c6f6f x15: 00001186c1df5448
[   84.508928] x14: 00000000000002e9 x13: 0000000000000000 x12: 0000000000000000
[   84.516256] x11: ffffb751c3186368 x10: ffffb751c39a2a70 x9 : 0000000000000000
[   84.523585] x8 : ffff1db4008edf00 x7 : ffffb751c328c000 x6 : 0000000000000001
[   84.530916] x5 : 0000000000040000 x4 : 0000000000000001 x3 : ffff1db4008edf00
[   84.538247] x2 : 0000000000000000 x1 : ffff1db400aa6100 x0 : ffff1db40aad80d0
[   84.545579] Call trace:
[   84.548101]  _opp_table_kref_release+0x188/0x190
[   84.552842]  dev_pm_opp_remove_all_dynamic+0x8c/0xc0
[   84.557949]  qcom_cpufreq_hw_cpu_exit+0x30/0xdc
[   84.562608]  cpufreq_offline.isra.0+0x1b4/0x1d8
[   84.567270]  cpuhp_cpufreq_offline+0x10/0x6c
[   84.571663]  cpuhp_invoke_callback+0x16c/0x2b0
[   84.576231]  cpuhp_thread_fun+0x190/0x250
[   84.580353]  smpboot_thread_fn+0x12c/0x230
[   84.584568]  kthread+0xfc/0x100
[   84.587810]  ret_from_fork+0x10/0x20
[   84.591490] irq event stamp: 3482
[   84.594901] hardirqs last  enabled at (3481): [<ffffb751c13c3db0>] call_rcu+0x39c/0x50c
[   84.603119] hardirqs last disabled at (3482): [<ffffb751c236b518>] el1_dbg+0x24/0x8c
[   84.611074] softirqs last  enabled at (310): [<ffffb751c1290410>] _stext+0x410/0x588
[   84.619028] softirqs last disabled at (305): [<ffffb751c131bf68>] __irq_exit_rcu+0x158/0x174
[   84.627691] ---[ end trace 0000000000000000 ]---

Fixes: 275157b367f4 ("cpufreq: qcom-cpufreq-hw: Add dcvs interrupt support")
Reported-by: kernel test robot <lkp@intel.com>
Tested-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index dc0d5f84d863..60d38f62308a 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -292,12 +292,18 @@ static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 
 	opp = dev_pm_opp_find_freq_floor(dev, &freq_hz);
 	if (IS_ERR(opp) && PTR_ERR(opp) == -ERANGE)
-		dev_pm_opp_find_freq_ceil(dev, &freq_hz);
+		opp = dev_pm_opp_find_freq_ceil(dev, &freq_hz);
 
-	throttled_freq = freq_hz / HZ_PER_KHZ;
+	if (IS_ERR(opp)) {
+		dev_warn(dev, "Can't find the OPP for throttling: %pe!\n", opp);
+	} else {
+		throttled_freq = freq_hz / HZ_PER_KHZ;
+
+		/* Update thermal pressure (the boost frequencies are accepted) */
+		arch_update_thermal_pressure(policy->related_cpus, throttled_freq);
 
-	/* Update thermal pressure (the boost frequencies are accepted) */
-	arch_update_thermal_pressure(policy->related_cpus, throttled_freq);
+		dev_pm_opp_put(opp);
+	}
 
 	/*
 	 * In the unlikely case policy is unregistered do not enable
-- 
2.35.1



