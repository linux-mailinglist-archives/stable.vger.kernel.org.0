Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD84B695F76
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 10:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbjBNJl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 04:41:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjBNJl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 04:41:27 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5BFC148
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 01:41:25 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b5so16474623plz.5
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 01:41:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fXF4aiObQqM4BGutqE03xyAKHDYTqvDe3hT1w9nB6Ds=;
        b=AsSOw48/eYWpAph8NDZwYZOMsIjVILQxvFf32tBBFv0vQWW5F0m1/zz2tQ/snxvLYg
         HTj/NLVWTFRuYFq2OXxCR8K6h9efKDEJp4HTk/O6ZqhqpNG/doLONgQ3Vv2Yu2pLLcdL
         iPFu1mc3RH+j8gsK8yYf0w9gime8G20HhWh2FFoIgosEpSJtGqWHSbKq7vZ/JirXCp5m
         zgoso9TBiYFsFitvi26QAhO+vKK14Dyf3Zd0fWm+eoX1fMwxWIDbLmvldFhgcXNWuZ8j
         kzbzEwU24Qz4SbpXpgBDG8+oMyPz+Y8FiUZ4EhDvQBnLV8RdD1ABWvq3XD8243mp7kBs
         uJXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fXF4aiObQqM4BGutqE03xyAKHDYTqvDe3hT1w9nB6Ds=;
        b=S+agMOThCQLbTN0os5YSf80jR3r0hkI9KACwlSZ+Dv0WQTw6ilOvf76LeMuur8hm3M
         ykqPfgPmvs7TeGCmXSAMjVH7MY84Gjf8fv7vweF9T3SDKpeGkxt0Ac5tMO90FonMzgxA
         PpSuiFj4fibgtkIy8QlPArehdHAwpgkNjw3Fq8l5vrJ9G97r2G1S+c6b/o2nfoWQy31k
         vwRipa1ituF5yS+7nMmvlAfbyz0V3cCASljBhaKGj/2FJreezJVJ6CT1PsNWJWSdSUh+
         Pw1o0i1Haq8h6GA7Fz+gafGICReVGi3nkX/3j8BZ4BKEL4CBtgUh8wZ9W+ylX32D1n8q
         q4/Q==
X-Gm-Message-State: AO0yUKWfUyHECOHiLfbDhjFboDqd5M82s5P456WyY4RarQktZUEowLQu
        rFPCaEhjriBgyvLWxZlPAKRU
X-Google-Smtp-Source: AK7set85h3b9oZBx7uPbXQ1ArhLvE9ehWjcxIVvpsRGNyLH8cAD9a7UhnFPiII9FvN6e4cpW7SmNXQ==
X-Received: by 2002:a17:90b:3910:b0:230:fac8:d7e7 with SMTP id ob16-20020a17090b391000b00230fac8d7e7mr1810318pjb.2.1676367684465;
        Tue, 14 Feb 2023 01:41:24 -0800 (PST)
Received: from localhost.localdomain ([117.217.179.87])
        by smtp.gmail.com with ESMTPSA id m3-20020a17090a5a4300b00233cde36909sm5095572pji.21.2023.02.14.01.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 01:41:23 -0800 (PST)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     andersson@kernel.org, rafael@kernel.org, viresh.kumar@linaro.org
Cc:     konrad.dybcio@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] cpufreq: qcom-hw: Add missing null pointer check
Date:   Tue, 14 Feb 2023 15:11:15 +0530
Message-Id: <20230214094115.23338-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

of_device_get_match_data() may return NULL, so add a check to prevent
potential null pointer dereference.

Issue reported by Qualcomm's internal static analysis tool.

Cc: stable@vger.kernel.org # v6.2
Fixes: 4f7961706c63 ("cpufreq: qcom-hw: Move soc_data to struct qcom_cpufreq")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index 340fed35e45d..6425c6b6e393 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -689,6 +689,8 @@ static int qcom_cpufreq_hw_driver_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	qcom_cpufreq.soc_data = of_device_get_match_data(dev);
+	if (!qcom_cpufreq.soc_data)
+		return -ENODEV;
 
 	clk_data = devm_kzalloc(dev, struct_size(clk_data, hws, num_domains), GFP_KERNEL);
 	if (!clk_data)
-- 
2.25.1

