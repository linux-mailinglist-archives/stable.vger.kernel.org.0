Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D90C549438
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377538AbiFMNdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378511AbiFMNbo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:31:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE5B703EB;
        Mon, 13 Jun 2022 04:26:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19F6761038;
        Mon, 13 Jun 2022 11:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E54C341C5;
        Mon, 13 Jun 2022 11:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119573;
        bh=P2WvBvhNObln23cDiRXI50hZO+1ujw4dGKh/BQBU3KY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZamHkhetZCOUjBD982UhCCC5YbZVu61E/Qa2UcZlTd2k4iAYTEeCR4CeFzG0IgJjT
         dtbS6c7rIjL1gJWebKE5QqFYAaCau/Nn/oW/C550qekcYn1GYKa76537uyW3w/V0b3
         VOKSI9K5FCR9/9owfu0Gcoj1WO9wLeLaWNgRigaQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 044/339] power: supply: ab8500_fg: Allocate wq in probe
Date:   Mon, 13 Jun 2022 12:07:49 +0200
Message-Id: <20220613094927.858126177@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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
index 97ac588a9e9c..ec8a404d71b4 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3037,13 +3037,6 @@ static int ab8500_fg_bind(struct device *dev, struct device *master,
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
@@ -3067,8 +3060,7 @@ static void ab8500_fg_unbind(struct device *dev, struct device *master,
 	if (ret)
 		dev_err(dev, "failed to disable coulomb counter\n");
 
-	destroy_workqueue(di->fg_wq);
-	flush_scheduled_work();
+	flush_workqueue(di->fg_wq);
 }
 
 static const struct component_ops ab8500_fg_component_ops = {
@@ -3117,6 +3109,13 @@ static int ab8500_fg_probe(struct platform_device *pdev)
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
 
@@ -3227,6 +3226,8 @@ static int ab8500_fg_remove(struct platform_device *pdev)
 {
 	struct ab8500_fg *di = platform_get_drvdata(pdev);
 
+	destroy_workqueue(di->fg_wq);
+	flush_scheduled_work();
 	component_del(&pdev->dev, &ab8500_fg_component_ops);
 	list_del(&di->node);
 	ab8500_fg_sysfs_exit(di);
-- 
2.35.1



