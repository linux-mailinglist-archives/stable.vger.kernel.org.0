Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9792068D7BC
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231865AbjBGNDD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232072AbjBGNCv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:02:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3FF360AC
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:02:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FEA461408
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CD4C433D2;
        Tue,  7 Feb 2023 13:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774938;
        bh=96qEb0F/SFiVLO9z3AtxE9ht97Pzeh/tEFQ3LavXpZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPxkKhGJdC1Ew9mwgU8+Vf0XZ8gn9ZEyRKbZyFszpJtm4WkcZQJgenCAzTBermzwd
         LuIIveoBThIR7M2qxO92UaNvBEwLOJ15rv+1PaD0Y7YhY9WEsPrtj3LXrBiAKuI842
         Ic6l1QXQX6Ld3wN6N/pxBJr7Y3s/7aFmKNzg5QyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 056/208] platform/x86/amd/pmf: Add helper routine to check pprof is balanced
Date:   Tue,  7 Feb 2023 13:55:10 +0100
Message-Id: <20230207125636.810295905@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 16909aa8c9cc284085f1202c6403ecb9814af812 ]

Add helper routine to check if the current platform profile
is balanced mode and remove duplicate code occurrences.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230125095936.3292883-3-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: f21bf62290dd ("platform/x86/amd/pmf: Fix to update SPS thermals when power supply change")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/cnqf.c | 6 +++---
 drivers/platform/x86/amd/pmf/pmf.h  | 1 +
 drivers/platform/x86/amd/pmf/sps.c  | 5 +++++
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/cnqf.c b/drivers/platform/x86/amd/pmf/cnqf.c
index ef2ac30ff15e..f39275ec5cc9 100644
--- a/drivers/platform/x86/amd/pmf/cnqf.c
+++ b/drivers/platform/x86/amd/pmf/cnqf.c
@@ -103,7 +103,7 @@ int amd_pmf_trans_cnqf(struct amd_pmf_dev *dev, int socket_power, ktime_t time_l
 
 	src = amd_pmf_cnqf_get_power_source(dev);
 
-	if (dev->current_profile == PLATFORM_PROFILE_BALANCED) {
+	if (is_pprof_balanced(dev)) {
 		amd_pmf_set_cnqf(dev, src, config_store.current_mode, NULL);
 	} else {
 		/*
@@ -317,7 +317,7 @@ static ssize_t cnqf_enable_store(struct device *dev,
 	src = amd_pmf_cnqf_get_power_source(pdev);
 	pdev->cnqf_enabled = input;
 
-	if (pdev->cnqf_enabled && pdev->current_profile == PLATFORM_PROFILE_BALANCED) {
+	if (pdev->cnqf_enabled && is_pprof_balanced(pdev)) {
 		amd_pmf_set_cnqf(pdev, src, config_store.current_mode, NULL);
 	} else {
 		if (is_apmf_func_supported(pdev, APMF_FUNC_STATIC_SLIDER_GRANULAR))
@@ -382,7 +382,7 @@ int amd_pmf_init_cnqf(struct amd_pmf_dev *dev)
 	dev->cnqf_enabled = amd_pmf_check_flags(dev);
 
 	/* update the thermal for CnQF */
-	if (dev->cnqf_enabled && dev->current_profile == PLATFORM_PROFILE_BALANCED) {
+	if (dev->cnqf_enabled && is_pprof_balanced(dev)) {
 		src = amd_pmf_cnqf_get_power_source(dev);
 		amd_pmf_set_cnqf(dev, src, config_store.current_mode, NULL);
 	}
diff --git a/drivers/platform/x86/amd/pmf/pmf.h b/drivers/platform/x86/amd/pmf/pmf.h
index b5b77a353b96..b94e1a9030f8 100644
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -391,6 +391,7 @@ int amd_pmf_init_sps(struct amd_pmf_dev *dev);
 void amd_pmf_deinit_sps(struct amd_pmf_dev *dev);
 int apmf_get_static_slider_granular(struct amd_pmf_dev *pdev,
 				    struct apmf_static_slider_granular_output *output);
+bool is_pprof_balanced(struct amd_pmf_dev *pmf);
 
 
 int apmf_update_fan_idx(struct amd_pmf_dev *pdev, bool manual, u32 idx);
diff --git a/drivers/platform/x86/amd/pmf/sps.c b/drivers/platform/x86/amd/pmf/sps.c
index 5bccea137bda..bed762d47a14 100644
--- a/drivers/platform/x86/amd/pmf/sps.c
+++ b/drivers/platform/x86/amd/pmf/sps.c
@@ -83,6 +83,11 @@ int amd_pmf_set_sps_power_limits(struct amd_pmf_dev *pmf)
 	return 0;
 }
 
+bool is_pprof_balanced(struct amd_pmf_dev *pmf)
+{
+	return (pmf->current_profile == PLATFORM_PROFILE_BALANCED) ? true : false;
+}
+
 static int amd_pmf_profile_get(struct platform_profile_handler *pprof,
 			       enum platform_profile_option *profile)
 {
-- 
2.39.0



