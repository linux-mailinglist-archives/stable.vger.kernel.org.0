Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C86B49A49D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388175AbiAYAJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:09:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59174 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354330AbiAXVHG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:07:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C30B7B8105C;
        Mon, 24 Jan 2022 21:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D308EC340E5;
        Mon, 24 Jan 2022 21:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058423;
        bh=ZTyiFhQJN4fI0ohqFr2xGTdcTomL+FISSSU8k9rBfuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sn76BkUr7b3v3qs36ZCZdh8d/ix7VC4wsUKL4SmEhD+yciE8m3LzI60mb/Nqb8GzN
         dJOOZDr8EfItfLUsAbYi/QhHdLSf88mCiSNk+vaABv37mvYLC/9J6dNInu0Vup/nYD
         9+jAk4Di3Z18rbporIDUhNC41utHDXI5L+vy3bZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0284/1039] perf/arm-cmn: Fix CPU hotplug unregistration
Date:   Mon, 24 Jan 2022 19:34:33 +0100
Message-Id: <20220124184134.829380525@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



