Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4D366C9E1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjAPQ5N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbjAPQ4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:56:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A64D582BB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:39:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23F69B8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:39:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7679EC433EF;
        Mon, 16 Jan 2023 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887190;
        bh=bloqT0XLlL6pZlvfDkPmdF+ymEdYgihtx++/A0gF1zA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yKl5Yyn6xkflXyNzyaqw+Vzv7xzfxdunhE3/26NteUwSUAAQF+O1G6k/dojsUKJot
         l5On3nqwiMH+dlZG8xWSrdcYn4eZji9PFHrUimJVPD0RlS7FxQYLyyFOPEF+Wgbh+/
         bkrB/42cMa9PRnCUwhl8fi1W+vMi8c/L1I9oh3EU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 056/521] irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()
Date:   Mon, 16 Jan 2023 16:45:18 +0100
Message-Id: <20230116154849.766128921@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit f9ee20c85b3a3ba0afd3672630ec4f93d339f015 ]

gic_probe() calls pm_runtime_get_sync() and added fail path as
rpm_put to put usage_counter. However, pm_runtime_get_sync()
will increment usage_counter even it failed. Fix it by replacing it with
pm_runtime_resume_and_get() to keep usage counter balanced.

Fixes: 9c8edddfc992 ("irqchip/gic: Add platform driver for non-root GICs that require RPM")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221124065150.22809-1-shangxiaojing@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-pm.c b/drivers/irqchip/irq-gic-pm.c
index ecafd295c31c..21c5decfc55b 100644
--- a/drivers/irqchip/irq-gic-pm.c
+++ b/drivers/irqchip/irq-gic-pm.c
@@ -112,7 +112,7 @@ static int gic_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		goto rpm_disable;
 
-- 
2.35.1



