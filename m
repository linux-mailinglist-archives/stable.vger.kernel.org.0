Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D6551A882
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356171AbiEDRLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356899AbiEDRJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC8F47053;
        Wed,  4 May 2022 09:56:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94F7CB82552;
        Wed,  4 May 2022 16:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360E2C385A4;
        Wed,  4 May 2022 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683378;
        bh=7+kZSzGKTNg8TZC5Dz8eHP1lgFCzqxnQ9mOapg3IUQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRkQpqsRS0l/nZXFZeGaxMzYHFa3muCbiz8NXz6A+iLhD6+o/Ug+Hfohj4uu3N521
         zxYfdek7s+Q2+sS9B97Lw2JFE8oz18WQs/hVRRJc6QMpTqfA1mPQEU+tw8/MkNxXBf
         9C+YRx1mS0Css0t3aPZEsAKJfCZkiA3hShXFfCBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 055/225] cpufreq: qcom-hw: drop affinity hint before freeing the IRQ
Date:   Wed,  4 May 2022 18:44:53 +0200
Message-Id: <20220504153115.072987652@linuxfoundation.org>
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

[ Upstream commit be5985b3dbce5ba2af3c8b0f2b7df235c93907e6 ]

Drop affinity hint before freeing the throttling IRQ to fix the
following trace:

[  185.114773] ------------[ cut here ]------------
[  185.119517] WARNING: CPU: 7 PID: 43 at kernel/irq/manage.c:1887 free_irq+0x3a4/0x3dc
[  185.127474] Modules linked in:
[  185.130618] CPU: 7 PID: 43 Comm: cpuhp/7 Tainted: G S      W         5.17.0-rc6-00386-g67382a5b705d-dirty #690
[  185.147125] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  185.154269] pc : free_irq+0x3a4/0x3dc
[  185.158031] lr : free_irq+0x33c/0x3dc
[  185.161792] sp : ffff80000841bc90
[  185.165195] x29: ffff80000841bc90 x28: ffffa6edc5c3d000 x27: ffff6d93729e5908
[  185.172515] x26: 0000000000000000 x25: ffff6d910109fc00 x24: ffff6d91011490e0
[  185.179838] x23: ffff6d9101149218 x22: 0000000000000080 x21: 0000000000000000
[  185.187163] x20: ffff6d9101149000 x19: ffff6d910ab61500 x18: ffffffffffffffff
[  185.194487] x17: 2e35202020202020 x16: 2020202020202020 x15: ffff80008841b9a7
[  185.201805] x14: 00000000000003c9 x13: 0000000000000001 x12: 0000000000000040
[  185.209135] x11: ffff6d91005aab58 x10: ffff6d91005aab5a x9 : ffffc6a5ad1c5408
[  185.216455] x8 : ffff6d91005adb88 x7 : 0000000000000000 x6 : ffffc6a5ab5a91f4
[  185.223776] x5 : 0000000000000000 x4 : ffff6d91011490a8 x3 : ffffc6a5ad266108
[  185.231098] x2 : 0000000013033204 x1 : ffff6d9101149000 x0 : ffff6d910a9cc000
[  185.238421] Call trace:
[  185.240932]  free_irq+0x3a4/0x3dc
[  185.244334]  qcom_cpufreq_hw_cpu_exit+0x78/0xcc
[  185.248985]  cpufreq_offline.isra.0+0x228/0x270
[  185.253639]  cpuhp_cpufreq_offline+0x10/0x20
[  185.258027]  cpuhp_invoke_callback+0x16c/0x2b0
[  185.262592]  cpuhp_thread_fun+0x190/0x250
[  185.266710]  smpboot_thread_fn+0x12c/0x230
[  185.270914]  kthread+0xfc/0x100
[  185.274145]  ret_from_fork+0x10/0x20
[  185.277820] irq event stamp: 212
[  185.281136] hardirqs last  enabled at (211): [<ffffc6a5ac57973c>] _raw_spin_unlock_irqrestore+0x8c/0xa0
[  185.290775] hardirqs last disabled at (212): [<ffffc6a5ac572100>] __schedule+0x710/0xa10
[  185.299081] softirqs last  enabled at (0): [<ffffc6a5ab50f7b0>] copy_process+0x7d0/0x1a14
[  185.307475] softirqs last disabled at (0): [<0000000000000000>] 0x0

Fixes: 3ed6dfbd3bb98 ("cpufreq: qcom-hw: Set CPU affinity of dcvsh interrupts")
Tested-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index effbb680b453..740518d8ae16 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -412,6 +412,7 @@ static void qcom_cpufreq_hw_lmh_exit(struct qcom_cpufreq_data *data)
 	mutex_unlock(&data->throttle_lock);
 
 	cancel_delayed_work_sync(&data->throttle_work);
+	irq_set_affinity_hint(data->throttle_irq, NULL);
 	free_irq(data->throttle_irq, data);
 }
 
-- 
2.35.1



