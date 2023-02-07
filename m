Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B86068D7BB
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbjBGNDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbjBGNCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:02:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB27232533
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:02:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71F15613FB
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612DCC433D2;
        Tue,  7 Feb 2023 13:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774932;
        bh=sQo+hRjVK4MTZJw/OBCO8wZJRvS1gVdryyB+JvjR8JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrLhlw2Pq5NUTTek9HGbL4+QXcZ+q+Anz6RpJSEbgBaUao3WcF6SSYHLrC4F/8rfx
         oOYqxxGGvFSRoUsuN6ZJZ9uIxUtwf7oIWAkGeETgjZccfjqnwgjCVBJN1fUsYayo/Q
         WLzG0bmeJxxJ5naqWJchF3pHAiWK6eFcGEcb8Hvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/208] platform/x86/amd/pmf: Add helper routine to update SPS thermals
Date:   Tue,  7 Feb 2023 13:55:08 +0100
Message-Id: <20230207125636.726658310@linuxfoundation.org>
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

[ Upstream commit c5258d39fc4cbed37e20945715e7eb102f26d65b ]

Add helper routine to update the static slider information
and remove the duplicate code occurrences after this change.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230125095936.3292883-2-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 635f79bc73cf ("platform/x86/amd/pmf: Fix to update SPS default pprof thermals")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/auto-mode.c |  7 +------
 drivers/platform/x86/amd/pmf/cnqf.c      |  8 ++------
 drivers/platform/x86/amd/pmf/pmf.h       |  1 +
 drivers/platform/x86/amd/pmf/sps.c       | 20 ++++++++++++++------
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/auto-mode.c b/drivers/platform/x86/amd/pmf/auto-mode.c
index 85ce9ed25b85..96a8e1832c05 100644
--- a/drivers/platform/x86/amd/pmf/auto-mode.c
+++ b/drivers/platform/x86/amd/pmf/auto-mode.c
@@ -275,13 +275,8 @@ int amd_pmf_reset_amt(struct amd_pmf_dev *dev)
 	 */
 
 	if (is_apmf_func_supported(dev, APMF_FUNC_STATIC_SLIDER_GRANULAR)) {
-		int mode = amd_pmf_get_pprof_modes(dev);
-
-		if (mode < 0)
-			return mode;
-
 		dev_dbg(dev->dev, "resetting AMT thermals\n");
-		amd_pmf_update_slider(dev, SLIDER_OP_SET, mode, NULL);
+		amd_pmf_set_sps_power_limits(dev);
 	}
 	return 0;
 }
diff --git a/drivers/platform/x86/amd/pmf/cnqf.c b/drivers/platform/x86/amd/pmf/cnqf.c
index 668c7c0fea83..ef2ac30ff15e 100644
--- a/drivers/platform/x86/amd/pmf/cnqf.c
+++ b/drivers/platform/x86/amd/pmf/cnqf.c
@@ -307,13 +307,9 @@ static ssize_t cnqf_enable_store(struct device *dev,
 				 const char *buf, size_t count)
 {
 	struct amd_pmf_dev *pdev = dev_get_drvdata(dev);
-	int mode, result, src;
+	int result, src;
 	bool input;
 
-	mode = amd_pmf_get_pprof_modes(pdev);
-	if (mode < 0)
-		return mode;
-
 	result = kstrtobool(buf, &input);
 	if (result)
 		return result;
@@ -325,7 +321,7 @@ static ssize_t cnqf_enable_store(struct device *dev,
 		amd_pmf_set_cnqf(pdev, src, config_store.current_mode, NULL);
 	} else {
 		if (is_apmf_func_supported(pdev, APMF_FUNC_STATIC_SLIDER_GRANULAR))
-			amd_pmf_update_slider(pdev, SLIDER_OP_SET, mode, NULL);
+			amd_pmf_set_sps_power_limits(pdev);
 	}
 
 	dev_dbg(pdev->dev, "Received CnQF %s\n", input ? "on" : "off");
diff --git a/drivers/platform/x86/amd/pmf/pmf.h b/drivers/platform/x86/amd/pmf/pmf.h
index 84bbe2c6ea61..b5b77a353b96 100644
--- a/drivers/platform/x86/amd/pmf/pmf.h
+++ b/drivers/platform/x86/amd/pmf/pmf.h
@@ -394,6 +394,7 @@ int apmf_get_static_slider_granular(struct amd_pmf_dev *pdev,
 
 
 int apmf_update_fan_idx(struct amd_pmf_dev *pdev, bool manual, u32 idx);
+int amd_pmf_set_sps_power_limits(struct amd_pmf_dev *pmf);
 
 /* Auto Mode Layer */
 int apmf_get_auto_mode_def(struct amd_pmf_dev *pdev, struct apmf_auto_mode *data);
diff --git a/drivers/platform/x86/amd/pmf/sps.c b/drivers/platform/x86/amd/pmf/sps.c
index dba7e36962dc..5f842d6e6db2 100644
--- a/drivers/platform/x86/amd/pmf/sps.c
+++ b/drivers/platform/x86/amd/pmf/sps.c
@@ -70,6 +70,19 @@ void amd_pmf_update_slider(struct amd_pmf_dev *dev, bool op, int idx,
 	}
 }
 
+int amd_pmf_set_sps_power_limits(struct amd_pmf_dev *pmf)
+{
+	int mode;
+
+	mode = amd_pmf_get_pprof_modes(pmf);
+	if (mode < 0)
+		return mode;
+
+	amd_pmf_update_slider(pmf, SLIDER_OP_SET, mode, NULL);
+
+	return 0;
+}
+
 static int amd_pmf_profile_get(struct platform_profile_handler *pprof,
 			       enum platform_profile_option *profile)
 {
@@ -105,15 +118,10 @@ static int amd_pmf_profile_set(struct platform_profile_handler *pprof,
 			       enum platform_profile_option profile)
 {
 	struct amd_pmf_dev *pmf = container_of(pprof, struct amd_pmf_dev, pprof);
-	int mode;
 
 	pmf->current_profile = profile;
-	mode = amd_pmf_get_pprof_modes(pmf);
-	if (mode < 0)
-		return mode;
 
-	amd_pmf_update_slider(pmf, SLIDER_OP_SET, mode, NULL);
-	return 0;
+	return amd_pmf_set_sps_power_limits(pmf);
 }
 
 int amd_pmf_init_sps(struct amd_pmf_dev *dev)
-- 
2.39.0



