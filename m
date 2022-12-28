Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59B36657953
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiL1PAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiL1O7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:59:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E2610054
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:59:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A3BA61544
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5CAC433D2;
        Wed, 28 Dec 2022 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239587;
        bh=yXaZLheoiO4PxKdoSQgLF1jcKV5ev5XwmmUT8LYPM/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALnkcTTeQDu9y3CZc8Ht2RILhOJxKi18H98WRryWCYDHexxf01Z/xxNKqgyuFghFG
         j7oDUd3TuPQmJh1Pc+/Fjw/blCTA97wfwORTSqtO3wX8ygG80hYpGnVFnldkMpq2PM
         TGgWHLwY2olUTsfFslkvndpB2VvxWG3B/DItpZl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0053/1073] drivers: perf: marvell_cn10k: Fix hotplug callback leak in tad_pmu_init()
Date:   Wed, 28 Dec 2022 15:27:21 +0100
Message-Id: <20221228144329.549663710@linuxfoundation.org>
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

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 973ae93d80d9d262f695eb485a1902b74c4b9098 ]

tad_pmu_init() won't remove the callback added by cpuhp_setup_state_multi()
when platform_driver_register() failed. Remove the callback by
cpuhp_remove_multi_state() in fail path.

Similar to the handling of arm_ccn_init() in commit 26242b330093 ("bus:
arm-ccn: Prevent hotplug callback leak")

Fixes: 036a7584bede ("drivers: perf: Add LLC-TAD perf counter support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221115070207.32634-3-yuancan@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/marvell_cn10k_tad_pmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/marvell_cn10k_tad_pmu.c b/drivers/perf/marvell_cn10k_tad_pmu.c
index 69c3050a4348..a1166afb3702 100644
--- a/drivers/perf/marvell_cn10k_tad_pmu.c
+++ b/drivers/perf/marvell_cn10k_tad_pmu.c
@@ -408,7 +408,11 @@ static int __init tad_pmu_init(void)
 	if (ret < 0)
 		return ret;
 	tad_pmu_cpuhp_state = ret;
-	return platform_driver_register(&tad_pmu_driver);
+	ret = platform_driver_register(&tad_pmu_driver);
+	if (ret)
+		cpuhp_remove_multi_state(tad_pmu_cpuhp_state);
+
+	return ret;
 }
 
 static void __exit tad_pmu_exit(void)
-- 
2.35.1



