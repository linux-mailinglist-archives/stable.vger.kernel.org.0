Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B726A31BE
	for <lists+stable@lfdr.de>; Sun, 26 Feb 2023 16:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbjBZPDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 10:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231650AbjBZPDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 10:03:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2DD1EBCA;
        Sun, 26 Feb 2023 06:54:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D386560C4E;
        Sun, 26 Feb 2023 14:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F9D4C433D2;
        Sun, 26 Feb 2023 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677423144;
        bh=4FgsJJrp32SQEY1IT4iugEebgq40vaJNoXrqcAmbH1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tynlLB6W8P2IDyO5V34xX2b2oKRQycIoLsG+m6uMXD3DO9fS1MTaiV2mVrkF5wfUG
         uMfjBIYUTBFCvQeoLTSMbEAI/HEo6Qrbtznc0WaJ6sxqooZt1Tl8kwE/Q5EtF7pXSN
         3XqIFCyp8ZRWrxwdX6aKjXYqqUVwBGhHVQBEYdQMCnxGqT293QIFfcar5xAoDF0674
         jiRsss9tFDeSUgPdM0dZLMiCVUj5mvR8aQ4Rueq4j7p22T6tlmjG3UkX299OJAxWYB
         JBTPNxZtUT3J1Yi9N0lVqy2A2A0SWejQ7pJaGoYlFUm0V4YVRoZim0X/s8ohyfvMRq
         5wuWDVdvctlTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        daniel.lezcano@linaro.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/13] thermal: intel: Fix unsigned comparison with less than zero
Date:   Sun, 26 Feb 2023 09:52:05 -0500
Message-Id: <20230226145217.829485-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226145217.829485-1-sashal@kernel.org>
References: <20230226145217.829485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit e7fcfe67f9f410736b758969477b17ea285e8e6c ]

The return value from the call to intel_tcc_get_tjmax() is int, which can
be a negative error code. However, the return value is being assigned to
an u32 variable 'tj_max', so making 'tj_max' an int.

Eliminate the following warning:
./drivers/thermal/intel/intel_soc_dts_iosf.c:394:5-11: WARNING: Unsigned expression compared with zero: tj_max < 0

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3637
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel_soc_dts_iosf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/intel_soc_dts_iosf.c b/drivers/thermal/intel_soc_dts_iosf.c
index e0813dfaa2783..435a093998000 100644
--- a/drivers/thermal/intel_soc_dts_iosf.c
+++ b/drivers/thermal/intel_soc_dts_iosf.c
@@ -405,7 +405,7 @@ struct intel_soc_dts_sensors *intel_soc_dts_iosf_init(
 {
 	struct intel_soc_dts_sensors *sensors;
 	bool notification;
-	u32 tj_max;
+	int tj_max;
 	int ret;
 	int i;
 
-- 
2.39.0

