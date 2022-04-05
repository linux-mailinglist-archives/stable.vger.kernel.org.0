Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07474F275F
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbiDEIFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbiDEH7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414DC3EAB0;
        Tue,  5 Apr 2022 00:55:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E714EB81B14;
        Tue,  5 Apr 2022 07:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD57C340EE;
        Tue,  5 Apr 2022 07:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145306;
        bh=4mNg/F94fD5ePGFoWZAISjOcsN7uVsRt2932zEV02wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzHeXWfe1/3ExWb1uS2Uk3EQrIZ6fIg4v2Vi1eG9nbuXfSkqM6xZL0lM3FTjK9VeE
         8pOXnATgrsP0H1+e9nYN78qvHITMRgaPdn/2WSluDMTXd1O7stIN12ZmF+4ublGtzU
         DhJ5B0e46vRgjX9b7rDDYF9+WjcJMrpvDuZbqxlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephan Gerhold <stephan@gerhold.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0342/1126] cpuidle: qcom-spm: Check if any CPU is managed by SPM
Date:   Tue,  5 Apr 2022 09:18:09 +0200
Message-Id: <20220405070417.654379203@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 0ee30ace67e425ab83a1673bf51f50b577328cf9 ]

At the moment, the "qcom-spm-cpuidle" platform device is always created,
even if none of the CPUs is actually managed by the SPM. On non-qcom
platforms this will result in infinite probe-deferral due to the
failing qcom_scm_is_available() call.

To avoid this, look through the CPU DT nodes and check if there is
actually any CPU managed by a SPM (as indicated by the qcom,saw property).
It should also be available because e.g. MSM8916 has qcom,saw defined
but it's typically not enabled with ARM64/PSCI firmwares.

This is needed in preparation of a follow-up change that calls
qcom_scm_set_warm_boot_addr() a single time before registering any
cpuidle drivers. Otherwise this call might be made even on devices
that have this driver enabled but actually make use of PSCI.

Fixes: 60f3692b5f0b ("cpuidle: qcom_spm: Detach state machine from main SPM handling")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/86e3e09f-a8d7-3dff-3fc6-ddd7d30c5d78@samsung.com/
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211201130505.257379-2-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-qcom-spm.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/cpuidle/cpuidle-qcom-spm.c b/drivers/cpuidle/cpuidle-qcom-spm.c
index 01e77913a414..5f27dcc6c110 100644
--- a/drivers/cpuidle/cpuidle-qcom-spm.c
+++ b/drivers/cpuidle/cpuidle-qcom-spm.c
@@ -155,6 +155,22 @@ static struct platform_driver spm_cpuidle_driver = {
 	},
 };
 
+static bool __init qcom_spm_find_any_cpu(void)
+{
+	struct device_node *cpu_node, *saw_node;
+
+	for_each_of_cpu_node(cpu_node) {
+		saw_node = of_parse_phandle(cpu_node, "qcom,saw", 0);
+		if (of_device_is_available(saw_node)) {
+			of_node_put(saw_node);
+			of_node_put(cpu_node);
+			return true;
+		}
+		of_node_put(saw_node);
+	}
+	return false;
+}
+
 static int __init qcom_spm_cpuidle_init(void)
 {
 	struct platform_device *pdev;
@@ -164,6 +180,10 @@ static int __init qcom_spm_cpuidle_init(void)
 	if (ret)
 		return ret;
 
+	/* Make sure there is actually any CPU managed by the SPM */
+	if (!qcom_spm_find_any_cpu())
+		return 0;
+
 	pdev = platform_device_register_simple("qcom-spm-cpuidle",
 					       -1, NULL, 0);
 	if (IS_ERR(pdev)) {
-- 
2.34.1



