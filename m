Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D44657950
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiL1PAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbiL1O7n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:59:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7711611C2F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:59:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 284E1B8171A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:59:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB25C433D2;
        Wed, 28 Dec 2022 14:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239579;
        bh=fjc/4DGVZxqMcISWjliLD6wf7N4uSoglUxuDfc+tnw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DY66JKILVJu8Un4ck3LAVjCiSNXneDYBRz6gu91ElgZP2VcCzrf+QfAhbY0/kwgLD
         0S7gM84Moo0OH7BdEjukcU0sB1weVm5V01ezTMI/3LK7R9+7sBQIdRALh4qCiBuUSX
         UdaqKFJ4OCSITEZJa9ZUCbayxGrA6MFYmYgPVbXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0052/1073] perf: arm_dsu: Fix hotplug callback leak in dsu_pmu_init()
Date:   Wed, 28 Dec 2022 15:27:20 +0100
Message-Id: <20221228144329.524370882@linuxfoundation.org>
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

[ Upstream commit facafab7611f7b872c6b9eeaff53461ef11f482e ]

dsu_pmu_init() won't remove the callback added by cpuhp_setup_state_multi()
when platform_driver_register() failed. Remove the callback by
cpuhp_remove_multi_state() in fail path.

Similar to the handling of arm_ccn_init() in commit 26242b330093 ("bus:
arm-ccn: Prevent hotplug callback leak")

Fixes: 7520fa99246d ("perf: ARM DynamIQ Shared Unit PMU support")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20221115070207.32634-2-yuancan@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_dsu_pmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/arm_dsu_pmu.c b/drivers/perf/arm_dsu_pmu.c
index a36698a90d2f..54b8ba032c78 100644
--- a/drivers/perf/arm_dsu_pmu.c
+++ b/drivers/perf/arm_dsu_pmu.c
@@ -858,7 +858,11 @@ static int __init dsu_pmu_init(void)
 	if (ret < 0)
 		return ret;
 	dsu_pmu_cpuhp_state = ret;
-	return platform_driver_register(&dsu_pmu_driver);
+	ret = platform_driver_register(&dsu_pmu_driver);
+	if (ret)
+		cpuhp_remove_multi_state(dsu_pmu_cpuhp_state);
+
+	return ret;
 }
 
 static void __exit dsu_pmu_exit(void)
-- 
2.35.1



