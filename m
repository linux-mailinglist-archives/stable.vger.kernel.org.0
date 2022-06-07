Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B272F541B8E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382032AbiFGVtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381444AbiFGVsM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:48:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF40239099;
        Tue,  7 Jun 2022 12:08:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66965617DA;
        Tue,  7 Jun 2022 19:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777DAC385A2;
        Tue,  7 Jun 2022 19:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628890;
        bh=7gLmPXzMhNy7D2VimkqVQcs4oFEM8KSRbDToOpCrFlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6LAoqZy4UdzmE6fa9NbIkk/cQ1oBrhk2023b8W6wn44m/JhzGOCoVMi8bnwIQv2M
         SncGcolC8XnX68/t1qRKCp1LuJm1lznpXO5cLccFPhPSceaYC122ZJdHdDIWsu1qPu
         Zi/JFMMbjd/KNL5gOKSizLCAbGyXyrAf8FweiuGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 492/879] thermal/drivers/broadcom: Fix potential NULL dereference in sr_thermal_probe
Date:   Tue,  7 Jun 2022 19:00:10 +0200
Message-Id: <20220607165017.152295215@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit e20d136ec7d6f309989c447638365840d3424c8e ]

platform_get_resource() may return NULL, add proper check to
avoid potential NULL dereferencing.

Fixes: 250e211057c72 ("thermal: broadcom: Add Stingray thermal driver")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Link: https://lore.kernel.org/r/20220425092929.90412-1-zhengyongjun3@huawei.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/broadcom/sr-thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/broadcom/sr-thermal.c b/drivers/thermal/broadcom/sr-thermal.c
index 475ce2900771..85ab9edd580c 100644
--- a/drivers/thermal/broadcom/sr-thermal.c
+++ b/drivers/thermal/broadcom/sr-thermal.c
@@ -60,6 +60,9 @@ static int sr_thermal_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -ENOENT;
+
 	sr_thermal->regs = (void __iomem *)devm_memremap(&pdev->dev, res->start,
 							 resource_size(res),
 							 MEMREMAP_WB);
-- 
2.35.1



