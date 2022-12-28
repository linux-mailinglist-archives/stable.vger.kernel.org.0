Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6212C657861
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:49:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbiL1Ot6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbiL1Ot5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:49:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543D0B41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:49:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9F189CE1355
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A72C433D2;
        Wed, 28 Dec 2022 14:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238992;
        bh=ZETYinfxwxS2BbSNxY2mp97gjw2ozDAQpHkuGR4y3UI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G2ZqxYQxB5JrdIUraaCP4kIhdDjQVWi2YYF1DXf3IT5wNCiGXLoUGFFlO+gSPWKI3
         0wg1aqCweZYV4ybmgwKubTEwnPWSiVY509mnMzk1gmT3MS509t1SAF26gMb/uO3U7Y
         X29BZ/fLvgZnvPxOBHIydHPN9Xeo8O5LaCd5BmQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chen Hui <judy.chenhui@huawei.com>,
        Sibi Sankar <quic_sibis@quicinc.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 080/731] cpufreq: qcom-hw: Fix memory leak in qcom_cpufreq_hw_read_lut()
Date:   Wed, 28 Dec 2022 15:33:07 +0100
Message-Id: <20221228144258.870360468@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index bb2f59fd0de4..bbcba2c38e85 100644
--- a/drivers/cpufreq/qcom-cpufreq-hw.c
+++ b/drivers/cpufreq/qcom-cpufreq-hw.c
@@ -177,6 +177,7 @@ static int qcom_cpufreq_hw_read_lut(struct device *cpu_dev,
 		}
 	} else if (ret != -ENODEV) {
 		dev_err(cpu_dev, "Invalid opp table in device tree\n");
+		kfree(table);
 		return ret;
 	} else {
 		policy->fast_switch_possible = true;
-- 
2.35.1



