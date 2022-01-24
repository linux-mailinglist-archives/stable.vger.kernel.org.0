Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49BC149A325
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2364924AbiAXXtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:49:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455294AbiAXVfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:35:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C326BC075D3A;
        Mon, 24 Jan 2022 12:21:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F9B361382;
        Mon, 24 Jan 2022 20:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB1FC340E5;
        Mon, 24 Jan 2022 20:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055715;
        bh=ZTyiFhQJN4fI0ohqFr2xGTdcTomL+FISSSU8k9rBfuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lJloNfS4rl761O+hDBvql4J+EecySsbHYRxrHIz0SIa5lmWHUSP2pc8W8rSWApr7L
         Y3QhiFAjjYJt2RkpFtX6E1zjDqzjZ6KhhbYG8UDq0sff8BJVC+ooOLHazvP8Zrb64k
         5SF7EmCYYREXGtSad3x2pdyrEgEn3/4Mk026M4ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 242/846] perf/arm-cmn: Fix CPU hotplug unregistration
Date:   Mon, 24 Jan 2022 19:35:59 +0100
Message-Id: <20220124184109.282417542@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 56c7c6eaf3eb8ac1ec40d56096c0f2b27250da5f ]

Attempting to migrate the PMU context after we've unregistered the PMU
device, or especially if we never successfully registered it in the
first place, is a woefully bad idea. It's also fundamentally pointless
anyway. Make sure to unregister an instance from the hotplug handler
*without* invoking the teardown callback.

Fixes: 0ba64770a2f2 ("perf: Add Arm CMN-600 PMU driver")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/2c221d745544774e4b07583b65b5d4d94f7e0fe4.1638530442.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index bc3cba5f8c5dc..400eb7f579dce 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1561,7 +1561,8 @@ static int arm_cmn_probe(struct platform_device *pdev)
 
 	err = perf_pmu_register(&cmn->pmu, name, -1);
 	if (err)
-		cpuhp_state_remove_instance(arm_cmn_hp_state, &cmn->cpuhp_node);
+		cpuhp_state_remove_instance_nocalls(arm_cmn_hp_state, &cmn->cpuhp_node);
+
 	return err;
 }
 
@@ -1572,7 +1573,7 @@ static int arm_cmn_remove(struct platform_device *pdev)
 	writel_relaxed(0, cmn->dtc[0].base + CMN_DT_DTC_CTL);
 
 	perf_pmu_unregister(&cmn->pmu);
-	cpuhp_state_remove_instance(arm_cmn_hp_state, &cmn->cpuhp_node);
+	cpuhp_state_remove_instance_nocalls(arm_cmn_hp_state, &cmn->cpuhp_node);
 	return 0;
 }
 
-- 
2.34.1



