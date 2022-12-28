Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B0E4657828
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiL1OsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:48:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233087AbiL1Oro (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:47:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F59BC3A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:47:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E6226154D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAF4C433EF;
        Wed, 28 Dec 2022 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238854;
        bh=o/63evzikijMXM82Yty6BXn3o60sRba2ZaN6y8PcAI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XecByGdmzUpGveaUi2Kq09TeMR0LXDzRRu+Efep4fHaZxS92mgyb6/7NkZzPFOAmT
         XjdKmXbBTpxKSRWk5oVmSpgRG+tmg8IwjJ3vEJj4x13cyAwjve0AJoiA482NFUXqD0
         zY0oo2+0wrlayj+97vQsoToggvG3tcqRuTL9peFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Punit Agrawal <punit.agrawal@bytedance.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 035/731] perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()
Date:   Wed, 28 Dec 2022 15:32:22 +0100
Message-Id: <20221228144257.569287570@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 226348822ab3..5933ad151f86 100644
--- a/drivers/perf/arm_smmuv3_pmu.c
+++ b/drivers/perf/arm_smmuv3_pmu.c
@@ -896,6 +896,8 @@ static struct platform_driver smmu_pmu_driver = {
 
 static int __init arm_smmu_pmu_init(void)
 {
+	int ret;
+
 	cpuhp_state_num = cpuhp_setup_state_multi(CPUHP_AP_ONLINE_DYN,
 						  "perf/arm/pmcg:online",
 						  NULL,
@@ -903,7 +905,11 @@ static int __init arm_smmu_pmu_init(void)
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



