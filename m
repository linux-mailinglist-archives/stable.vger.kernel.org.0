Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613C6657A05
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbiL1PHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233574AbiL1PHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:07:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D5713D73
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:07:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5244DB816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED73C433D2;
        Wed, 28 Dec 2022 15:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240026;
        bh=o1YzpXgQYj519sWD9kChGCNvfZ8/8vRFsOJSvwkpebg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K6BQW47lF5y7Tyb5fcAQxxOqnE9ElQ/8OK8QbZD0i2yNvDGdHfuHn6y+SM28KqyBD
         JB9NzHRmLsrRQva/sOg87SRaRuvovJe2dBBlHIbF94ky2M0iCHW/rflgCHAKXQvEVi
         AKJeI1wtUj8IfJE5j3oMj0xIhHq/Z0z4SUHAkwKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Hui <judy.chenhui@huawei.com>,
        Sibi Sankar <quic_sibis@quicinc.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0109/1073] cpufreq: qcom-hw: Fix memory leak in qcom_cpufreq_hw_read_lut()
Date:   Wed, 28 Dec 2022 15:28:17 +0100
Message-Id: <20221228144331.003044471@linuxfoundation.org>
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

From: Chen Hui <judy.chenhui@huawei.com>

[ Upstream commit 9901c21bcaf2f01fe5078f750d624f4ddfa8f81b ]

If "cpu_dev" fails to get opp table in qcom_cpufreq_hw_read_lut(),
the program will return, resulting in "table" resource is not released.

Fixes: 51c843cf77bb ("cpufreq: qcom: Update the bandwidth levels on frequency change")
Signed-off-by: Chen Hui <judy.chenhui@huawei.com>
Reviewed-by: Sibi Sankar <quic_sibis@quicinc.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
index bb32659820ce..9221a416230a 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -190,6 +190,7 @@ static int qcom_cpufreq_hw_read_lut(struct device *cpu_dev,
 		}
 	} else if (ret != -ENODEV) {
 		dev_err(cpu_dev, "Invalid opp table in device tree\n");
+		kfree(table);
 		return ret;
 	} else {
 		policy->fast_switch_possible = true;
-- 
2.35.1



