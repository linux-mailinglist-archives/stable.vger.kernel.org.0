Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E8866C67F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbjAPQVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:21:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbjAPQUZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:20:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B661DB95
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:11:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C50D261047
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:11:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB1CDC433D2;
        Mon, 16 Jan 2023 16:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885462;
        bh=uyUqZKuheL/XAU7IrfDmjYPVPE2AktbTQyrptVQ53nM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KE1iVFXcxY70rwEYpX2radhED89024Xgr1ejTX1P0ChwD3S72ngKXOQO8VF/7GZ8N
         N2u09LDCt6u0S/7OC9B0dfC42gMAKC95u3G34MOcb1ZToiRUtY50FvO7+XeRHwYyGp
         nj7QGlsKrkz7VKUzwfGg9gF42TsBPujN12iQMbpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Punit Agrawal <punit.agrawal@bytedance.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 031/658] perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()
Date:   Mon, 16 Jan 2023 16:41:59 +0100
Message-Id: <20230116154911.037040242@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit 6f2d566b46436a50a80d6445e82879686b89588c ]

arm_smmu_pmu_init() won't remove the callback added by
cpuhp_setup_state_multi() when platform_driver_register() failed. Remove
the callback by cpuhp_remove_multi_state() in fail path.

Similar to the handling of arm_ccn_init() in commit 26242b330093 ("bus:
arm-ccn: Prevent hotplug callback leak")

Fixes: 7d839b4b9e00 ("perf/smmuv3: Add arm64 smmuv3 pmu driver")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Punit Agrawal <punit.agrawal@bytedance.com>
Link: https://lore.kernel.org/r/20221115115540.6245-3-shangxiaojing@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_smmuv3_pmu.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm_smmuv3_pmu.c b/drivers/perf/arm_smmuv3_pmu.c
index 6a3fa1f69e68..0b6af7719641 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -872,6 +872,8 @@ static struct platform_driver smmu_pmu_driver = {
 
 static int __init arm_smmu_pmu_init(void)
 {
+	int ret;
+
 	cpuhp_state_num = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN,
 						  "perf/arm/pmcg:online",
 						  NULL,
@@ -879,7 +881,11 @@ static int __init arm_smmu_pmu_init(void)
 	if (cpuhp_state_num < 0)
 		return cpuhp_state_num;
 
-	return platform_driver_register(&smmu_pmu_driver);
+	ret = platform_driver_register(&smmu_pmu_driver);
+	if (ret)
+		cpuhp_remove_multi_state(cpuhp_state_num);
+
+	return ret;
 }
 module_init(arm_smmu_pmu_init);
 
-- 
2.35.1



