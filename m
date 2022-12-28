Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60333657B03
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbiL1PRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiL1PRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:17:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0D713F9D
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:17:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44A8CB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3BC9C433D2;
        Wed, 28 Dec 2022 15:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240628;
        bh=LVfGN92gWg8D37EC0qoo7xa1xxd46DRrRGWQGV0stTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzvSE2hTtmcVEylLuu6vChltWRwbkT9P5HFya4XL6H+KDfFwwP4S749b/QNl40zY2
         WFarJvjmaRv9/dTNiVoA03/DYWs0OjTy3DAmLmV0FqDsO8m9vG7MySw5Jxzp/x1QgS
         hQL04iBjzx0tCg7QPMgOgQgFppKwEizPSEbYAsEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shang XiaoJing <shangxiaojing@huawei.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0147/1146] irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()
Date:   Wed, 28 Dec 2022 15:28:06 +0100
Message-Id: <20221228144334.138360015@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index b60e1853593f..3989d16f997b 100644
--- a/drivers/irqchip/irq-gic-pm.c
+++ b/drivers/irqchip/irq-gic-pm.c
@@ -102,7 +102,7 @@ static int gic_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 
-	ret = pm_runtime_get_sync(dev);
+	ret = pm_runtime_resume_and_get(dev);
 	if (ret < 0)
 		goto rpm_disable;
 
-- 
2.35.1



