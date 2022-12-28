Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03021657958
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233337AbiL1PAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbiL1PAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:00:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B1A12744
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:00:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 231B361541
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:00:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DACC433F0;
        Wed, 28 Dec 2022 15:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239600;
        bh=xLMSABwJiBXNgc997gcjKHd9GNASxvEMxkI0yI52mec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HOAL0HcZe22Z9dD0KoZpLxYMXX2/rYSXqLcoAtdtA2pqyoq6qHMc7EHUKMCWl+aN4
         ns+5bDJW4fFsqlgVqsdC0gkLmOPTxT9OkWAu/vAX3tu2405feLyKvQcPgEmwoe+h6E
         I4IQtZWnMiuLdJo8p2bopBvx2V9e0kl+sVchU764=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Punit Agrawal <punit.agrawal@bytedance.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0054/1073] perf/arm_dmc620: Fix hotplug callback leak in dmc620_pmu_init()
Date:   Wed, 28 Dec 2022 15:27:22 +0100
Message-Id: <20221228144329.574444641@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit d9f564c966e63925aac4ba273a9319d7fb6f4b4e ]

dmc620_pmu_init() won't remove the callback added by
cpuhp_setup_state_multi() when platform_driver_register() failed. Remove
the callback by cpuhp_remove_multi_state() in fail path.

Similar to the handling of arm_ccn_init() in commit 26242b330093 ("bus:
arm-ccn: Prevent hotplug callback leak")

Fixes: 53c218da220c ("driver/perf: Add PMU driver for the ARM DMC-620 memory controller")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Punit Agrawal <punit.agrawal@bytedance.com>
Link: https://lore.kernel.org/r/20221115115540.6245-2-shangxiaojing@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_dmc620_pmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm_dmc620_pmu.c b/drivers/perf/arm_dmc620_pmu.c
index 280a6ae3e27c..54aa4658fb36 100644
--- a/drivers/perf/arm_dmc620_pmu.c
+++ b/drivers/perf/arm_dmc620_pmu.c
@@ -725,6 +725,8 @@ static struct platform_driver dmc620_pmu_driver = {
 
 static int __init dmc620_pmu_init(void)
 {
+	int ret;
+
 	cpuhp_state_num = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN,
 				      DMC620_DRVNAME,
 				      NULL,
@@ -732,7 +734,11 @@ static int __init dmc620_pmu_init(void)
 	if (cpuhp_state_num < 0)
 		return cpuhp_state_num;
 
-	return platform_driver_register(&dmc620_pmu_driver);
+	ret = platform_driver_register(&dmc620_pmu_driver);
+	if (ret)
+		cpuhp_remove_multi_state(cpuhp_state_num);
+
+	return ret;
 }
 
 static void __exit dmc620_pmu_exit(void)
-- 
2.35.1



