Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B36DC540709
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiFGRlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347312AbiFGRjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:39:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5545736147;
        Tue,  7 Jun 2022 10:33:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1654B822AD;
        Tue,  7 Jun 2022 17:33:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C4EC385A5;
        Tue,  7 Jun 2022 17:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623183;
        bh=HWrh3eNyUWp0UeZbAh0SxbRayZHDbgIJWamQdjsz8cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlhWFEMhwJAlon2Y+v99nHH9QiPqvVgP0twIeMvnyTnBJ2JvWQ0WlFtZsPQDzPtP9
         StXVa6iLK78DsE44HF8R6RLHx2IGeuOGTm4qJoIw0PdGDZeFF8hUZc6179/9ooBXQb
         ArptaftaCorV9D+VQuk8HgU6bUmYTikWZcDY0XUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rex-BC Chen <rex-bc.chen@mediatek.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 324/452] cpufreq: mediatek: Unregister platform device on exit
Date:   Tue,  7 Jun 2022 19:03:01 +0200
Message-Id: <20220607164918.215272229@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rex-BC Chen <rex-bc.chen@mediatek.com>

[ Upstream commit f126fbadce92b92c3a7be41e4abc1fbae93ae2ef ]

We register the platform device when driver inits. However, we do not
unregister it when driver exits.

To resolve this, we declare the platform data to be a global static
variable and rename it to be "cpufreq_pdev". With this global variable,
we can do platform_device_unregister() when driver exits.

Fixes: 501c574f4e3a ("cpufreq: mediatek: Add support of cpufreq to MT2701/MT7623 SoC")
Signed-off-by: Rex-BC Chen <rex-bc.chen@mediatek.com>
[ Viresh: Commit log and Subject ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/mediatek-cpufreq.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/mediatek-cpufreq.c b/drivers/cpufreq/mediatek-cpufreq.c
index 07ba238a0e0e..82f6592bbadb 100644
--- a/drivers/cpufreq/mediatek-cpufreq.c
+++ b/drivers/cpufreq/mediatek-cpufreq.c
@@ -44,6 +44,8 @@ struct mtk_cpu_dvfs_info {
 	bool need_voltage_tracking;
 };
 
+static struct platform_device *cpufreq_pdev;
+
 static LIST_HEAD(dvfs_info_list);
 
 static struct mtk_cpu_dvfs_info *mtk_cpu_dvfs_info_lookup(int cpu)
@@ -546,7 +548,6 @@ static int __init mtk_cpufreq_driver_init(void)
 {
 	struct device_node *np;
 	const struct of_device_id *match;
-	struct platform_device *pdev;
 	int err;
 
 	np = of_find_node_by_path("/");
@@ -570,11 +571,11 @@ static int __init mtk_cpufreq_driver_init(void)
 	 * and the device registration codes are put here to handle defer
 	 * probing.
 	 */
-	pdev = platform_device_register_simple("mtk-cpufreq", -1, NULL, 0);
-	if (IS_ERR(pdev)) {
+	cpufreq_pdev = platform_device_register_simple("mtk-cpufreq", -1, NULL, 0);
+	if (IS_ERR(cpufreq_pdev)) {
 		pr_err("failed to register mtk-cpufreq platform device\n");
 		platform_driver_unregister(&mtk_cpufreq_platdrv);
-		return PTR_ERR(pdev);
+		return PTR_ERR(cpufreq_pdev);
 	}
 
 	return 0;
@@ -583,6 +584,7 @@ module_init(mtk_cpufreq_driver_init)
 
 static void __exit mtk_cpufreq_driver_exit(void)
 {
+	platform_device_unregister(cpufreq_pdev);
 	platform_driver_unregister(&mtk_cpufreq_platdrv);
 }
 module_exit(mtk_cpufreq_driver_exit)
-- 
2.35.1



