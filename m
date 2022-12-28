Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E0A6579DF
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbiL1PFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiL1PFi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:05:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6283313D4D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:05:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0011161365
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17476C433D2;
        Wed, 28 Dec 2022 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239936;
        bh=yXaZLheoiO4PxKdoSQgLF1jcKV5ev5XwmmUT8LYPM/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnxxs4RKprojgpvJ0aKDpRqME+JHd4ZuPrv8YC614GyZVzYzKshimSclslrfGAaw/
         ScecPnM7i2zlLfT2YRD7cwoLVyBkBPfDcM3FBKYfsVkVKMOeQ7yIpmYWUu4LFjF6zY
         vOY1ijCNlfYXS2+S2DjYObj4yBAn4RyMNlBqZ6kI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0060/1146] drivers: perf: marvell_cn10k: Fix hotplug callback leak in tad_pmu_init()
Date:   Wed, 28 Dec 2022 15:26:39 +0100
Message-Id: <20221228144331.789365990@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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



