Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABF6F51A87F
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356150AbiEDRLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356920AbiEDRJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD99447386;
        Wed,  4 May 2022 09:56:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84E25B8279C;
        Wed,  4 May 2022 16:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDA3C385A5;
        Wed,  4 May 2022 16:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683384;
        bh=XXe5e6LTOiqCf7n9YpwIDSJ2KM10tPHdgipwNToxAwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8bHGCVCgfyagBkT+LYPwhk1CvuAmrGNRt4pq0657O5fur0MTjH2xybBZZNJJqy5X
         qo6tcNquEm7DqKnmbCybOQgI1gDYpr5RiKpdRPBv4LNEtwnDI6MoFxKhxzusmHDNPs
         US2MBINe6mgemGz15VB+97ElcTswFBoTidqQ8z7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 056/225] cpufreq: qcom-hw: fix the race between LMH worker and cpuhp
Date:   Wed,  4 May 2022 18:44:54 +0200
Message-Id: <20220504153115.159210170@linuxfoundation.org>
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

[ Upstream commit 5e4f009da6be563984ba4db4ef4f32529e9aeb90 ]

The driver would disable the worker when cpu is being put offline, but
it happens closer to the end of cpufreq_offline(). The function
qcom_lmh_dcvs_poll() can be running in parallel with this, when
policy->cpus already has been updated. Read policy->related_cpus
instead.

[   37.122433] ------------[ cut here ]------------
[   37.127225] WARNING: CPU: 0 PID: 187 at drivers/base/arch_topology.c:180 topology_update_thermal_pressure+0xec/0x100
[   37.138098] Modules linked in:
[   37.141279] CPU: 0 PID: 187 Comm: kworker/0:3 Tainted: G S                5.17.0-rc6-00389-g37c83d0b8710-dirty #713
[   37.158306] Workqueue: events qcom_lmh_dcvs_poll
[   37.163095] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   37.170278] pc : topology_update_thermal_pressure+0xec/0x100
[   37.176131] lr : topology_update_thermal_pressure+0x20/0x100
[   37.181977] sp : ffff800009b6bce0
[   37.185402] x29: ffff800009b6bce0 x28: ffffd87abe92b000 x27: ffff04bd7292e205
[   37.192792] x26: ffffd87abe930af8 x25: ffffd87abe94e4c8 x24: 0000000000000000
[   37.200180] x23: ffff04bb01177018 x22: ffff04bb011770c0 x21: ffff04bb01177000
[   37.207567] x20: ffff04bb0a419000 x19: 00000000000c4e00 x18: 0000000000000000
[   37.214954] x17: 000000040044ffff x16: 004000b2b5503510 x15: 0000006aaa1326d2
[   37.222333] x14: 0000000000000232 x13: 0000000000000001 x12: 0000000000000040
[   37.229718] x11: ffff04bb00400000 x10: 968f57bd39f701c8 x9 : ffff04bb0acc8674
[   37.237095] x8 : fefefefefefefeff x7 : 0000000000000018 x6 : ffffd87abd90092c
[   37.244478] x5 : 0000000000000016 x4 : 0000000000000000 x3 : 0000000000000100
[   37.251852] x2 : ffff04bb0a419020 x1 : 0000000000000100 x0 : 0000000000000100
[   37.259235] Call trace:
[   37.261771]  topology_update_thermal_pressure+0xec/0x100
[   37.267266]  qcom_lmh_dcvs_poll+0xbc/0x154
[   37.271505]  process_one_work+0x288/0x69c
[   37.275654]  worker_thread+0x74/0x470
[   37.279450]  kthread+0xfc/0x100
[   37.282712]  ret_from_fork+0x10/0x20
[   37.286417] irq event stamp: 74
[   37.289664] hardirqs last  enabled at (73): [<ffffd87abdd78af4>] _raw_spin_unlock_irq+0x44/0x80
[   37.298632] hardirqs last disabled at (74): [<ffffd87abdd71fc0>] __schedule+0x710/0xa10
[   37.306885] softirqs last  enabled at (58): [<ffffd87abcc90410>] _stext+0x410/0x588
[   37.314778] softirqs last disabled at (51): [<ffffd87abcd1bf68>] __irq_exit_rcu+0x158/0x174
[   37.323386] ---[ end trace 0000000000000000 ]---

Fixes: 275157b367f4 ("cpufreq: qcom-cpufreq-hw: Add dcvs interrupt support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 740518d8ae16..dc0d5f84d863 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -277,7 +277,7 @@ static unsigned int qcom_lmh_get_throttle_freq(struct qcom_cpufreq_data *data)
 static void qcom_lmh_dcvs_notify(struct qcom_cpufreq_data *data)
 {
 	struct cpufreq_policy *policy = data->policy;
-	int cpu = cpumask_first(policy->cpus);
+	int cpu = cpumask_first(policy->related_cpus);
 	struct device *dev = get_cpu_device(cpu);
 	unsigned long freq_hz, throttled_freq;
 	struct dev_pm_opp *opp;
-- 
2.35.1



