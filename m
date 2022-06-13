Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A598549273
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380946AbiFMOMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381103AbiFMOKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:10:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A882D1E3;
        Mon, 13 Jun 2022 04:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B555B80EB2;
        Mon, 13 Jun 2022 11:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E791DC34114;
        Mon, 13 Jun 2022 11:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120518;
        bh=wKYQNm6xG3nOwG/8tiktpJg4CqIDjgkr82oZoP7izT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ibSR8U0fTQivdfTFvOonOyByoT7jxau/B54GXM/JEsvYLSdPdZUyDdqiUXZzMSHqr
         up58GENHjlCsNL+sgT6yDuQJGoJShDJsz1+SFZxGlhpyqB8pVNqfVUMK3O6LR+uTxU
         guB6xlr0U7LnhqqJYizQijfLDAVMm9L9ceHMwlJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 038/298] power: supply: ab8500_fg: Allocate wq in probe
Date:   Mon, 13 Jun 2022 12:08:52 +0200
Message-Id: <20220613094926.091998782@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 010ddb813f3554cbbf8bd13b731452236a2c8017 ]

The workqueue is allocated in bind() but all interrupts are
registered in probe().

Some interrupts put work on the workqueue, which can have
bad side effects.

Allocate the workqueue in probe() instead, destroy it in
.remove() and make unbind() simply flush the workqueue.

Fixes: 1c1f13a006ed ("power: supply: ab8500: Move to componentized binding")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 09a4cbd69676..23adcb597ff9 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -2995,13 +2995,6 @@ static int ab8500_fg_bind(struct device *dev, struct device *master,
 {
 	struct ab8500_fg *di = dev_get_drvdata(dev);
 
-	/* Create a work queue for running the FG algorithm */
-	di->fg_wq = alloc_ordered_workqueue("ab8500_fg_wq", WQ_MEM_RECLAIM);
-	if (di->fg_wq == NULL) {
-		dev_err(dev, "failed to create work queue\n");
-		return -ENOMEM;
-	}
-
 	di->bat_cap.max_mah_design = di->bm->bi->charge_full_design_uah;
 	di->bat_cap.max_mah = di->bat_cap.max_mah_design;
 	di->vbat_nom_uv = di->bm->bi->voltage_max_design_uv;
@@ -3025,8 +3018,7 @@ static void ab8500_fg_unbind(struct device *dev, struct device *master,
 	if (ret)
 		dev_err(dev, "failed to disable coulomb counter\n");
 
-	destroy_workqueue(di->fg_wq);
-	flush_scheduled_work();
+	flush_workqueue(di->fg_wq);
 }
 
 static const struct component_ops ab8500_fg_component_ops = {
@@ -3070,6 +3062,13 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	ab8500_fg_charge_state_to(di, AB8500_FG_CHARGE_INIT);
 	ab8500_fg_discharge_state_to(di, AB8500_FG_DISCHARGE_INIT);
 
+	/* Create a work queue for running the FG algorithm */
+	di->fg_wq = alloc_ordered_workqueue("ab8500_fg_wq", WQ_MEM_RECLAIM);
+	if (di->fg_wq == NULL) {
+		dev_err(dev, "failed to create work queue\n");
+		return -ENOMEM;
+	}
+
 	/* Init work for running the fg algorithm instantly */
 	INIT_WORK(&di->fg_work, ab8500_fg_instant_work);
 
@@ -3181,6 +3180,8 @@ static int ab8500_fg_remove(struct platform_device *pdev)
 	int ret = 0;
 	struct ab8500_fg *di = platform_get_drvdata(pdev);
 
+	destroy_workqueue(di->fg_wq);
+	flush_scheduled_work();
 	component_del(&pdev->dev, &ab8500_fg_component_ops);
 	list_del(&di->node);
 	ab8500_fg_sysfs_exit(di);
-- 
2.35.1



