Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B466AE84F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjCGRPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230467AbjCGROj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:14:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4688C0FB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:09:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0538161507
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15F2C433EF;
        Tue,  7 Mar 2023 17:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678208966;
        bh=rTk69nocpTX5ACZCoLGZIks9FomZSl6Uk1+IpU3XJNM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NxVRdI+c9QnSm9bwGIfOgiCaaggGNzMjvDSTVmDYOdXxjI7NHmeV8np9lzW1OStoU
         P3McVW7mmgvrJf6/dzi2DK2jVjwwLolh3qFUsDkeA+mywkeMyuOZiFErBfCzKGpHDd
         QEA+byQswjtNIU2UN0YxJ89E3PiRORpF1gFyE14g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Angus Chen <angus.chen@jaguarmicro.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0068/1001] ARM: imx: Call ida_simple_remove() for ida_simple_get
Date:   Tue,  7 Mar 2023 17:47:20 +0100
Message-Id: <20230307170025.046341715@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Angus Chen <angus.chen@jaguarmicro.com>

[ Upstream commit ebeb49f43c8952f12aa20f03f00d7009edc2d1c5 ]

The function call ida_simple_get maybe fail,we should deal with it.
And if ida_simple_get success ,it need to call ida_simple_remove also.
BTW,devm_kasprintf can handle id is zero for consistency.

Fixes: e76bdfd7403a ("ARM: imx: Added perf functionality to mmdc driver")
Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/mmdc.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
index af12668d0bf51..b9efe9da06e0b 100644
--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -99,6 +99,7 @@ struct mmdc_pmu {
 	cpumask_t cpu;
 	struct hrtimer hrtimer;
 	unsigned int active_events;
+	int id;
 	struct device *dev;
 	struct perf_event *mmdc_events[MMDC_NUM_COUNTERS];
 	struct hlist_node node;
@@ -433,8 +434,6 @@ static enum hrtimer_restart mmdc_pmu_timer_handler(struct hrtimer *hrtimer)
 static int mmdc_pmu_init(struct mmdc_pmu *pmu_mmdc,
 		void __iomem *mmdc_base, struct device *dev)
 {
-	int mmdc_num;
-
 	*pmu_mmdc = (struct mmdc_pmu) {
 		.pmu = (struct pmu) {
 			.task_ctx_nr    = perf_invalid_context,
@@ -452,15 +451,16 @@ static int mmdc_pmu_init(struct mmdc_pmu *pmu_mmdc,
 		.active_events = 0,
 	};
 
-	mmdc_num = ida_simple_get(&mmdc_ida, 0, 0, GFP_KERNEL);
+	pmu_mmdc->id = ida_simple_get(&mmdc_ida, 0, 0, GFP_KERNEL);
 
-	return mmdc_num;
+	return pmu_mmdc->id;
 }
 
 static int imx_mmdc_remove(struct platform_device *pdev)
 {
 	struct mmdc_pmu *pmu_mmdc = platform_get_drvdata(pdev);
 
+	ida_simple_remove(&mmdc_ida, pmu_mmdc->id);
 	cpuhp_state_remove_instance_nocalls(cpuhp_mmdc_state, &pmu_mmdc->node);
 	perf_pmu_unregister(&pmu_mmdc->pmu);
 	iounmap(pmu_mmdc->mmdc_base);
@@ -474,7 +474,6 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 {
 	struct mmdc_pmu *pmu_mmdc;
 	char *name;
-	int mmdc_num;
 	int ret;
 	const struct of_device_id *of_id =
 		of_match_device(imx_mmdc_dt_ids, &pdev->dev);
@@ -497,14 +496,14 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 		cpuhp_mmdc_state = ret;
 	}
 
-	mmdc_num = mmdc_pmu_init(pmu_mmdc, mmdc_base, &pdev->dev);
-	pmu_mmdc->mmdc_ipg_clk = mmdc_ipg_clk;
-	if (mmdc_num == 0)
-		name = "mmdc";
-	else
-		name = devm_kasprintf(&pdev->dev,
-				GFP_KERNEL, "mmdc%d", mmdc_num);
+	ret = mmdc_pmu_init(pmu_mmdc, mmdc_base, &pdev->dev);
+	if (ret < 0)
+		goto  pmu_free;
 
+	name = devm_kasprintf(&pdev->dev,
+				GFP_KERNEL, "mmdc%d", ret);
+
+	pmu_mmdc->mmdc_ipg_clk = mmdc_ipg_clk;
 	pmu_mmdc->devtype_data = (struct fsl_mmdc_devtype_data *)of_id->data;
 
 	hrtimer_init(&pmu_mmdc->hrtimer, CLOCK_MONOTONIC,
@@ -525,6 +524,7 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 
 pmu_register_err:
 	pr_warn("MMDC Perf PMU failed (%d), disabled\n", ret);
+	ida_simple_remove(&mmdc_ida, pmu_mmdc->id);
 	cpuhp_state_remove_instance_nocalls(cpuhp_mmdc_state, &pmu_mmdc->node);
 	hrtimer_cancel(&pmu_mmdc->hrtimer);
 pmu_free:
-- 
2.39.2



