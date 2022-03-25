Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1D14E6EE7
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 08:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347359AbiCYHcL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 03:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350106AbiCYHcJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 03:32:09 -0400
Received: from out28-197.mail.aliyun.com (out28-197.mail.aliyun.com [115.124.28.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F228C748A;
        Fri, 25 Mar 2022 00:30:33 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07642309|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.00954498-0.000797976-0.989657;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047192;MF=kant@allwinnertech.com;NM=1;PH=DS;RN=11;RT=11;SR=0;TI=SMTPD_---.NCDOraZ_1648193429;
Received: from sunxibot.allwinnertech.com(mailfrom:kant@allwinnertech.com fp:SMTPD_---.NCDOraZ_1648193429)
          by smtp.aliyun-inc.com(33.37.73.205);
          Fri, 25 Mar 2022 15:30:30 +0800
From:   Kant Fan <kant@allwinnertech.com>
To:     rafael@kernel.org, daniel.lezcano@linaro.org, lukasz.luba@arm.com,
        ionela.voinescu@arm.com
Cc:     amitk@kernel.org, rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        allwinner-opensource-support@allwinnertech.com,
        Kant Fan <kant@allwinnertech.com>, stable@vger.kernel.org
Subject: [PATCH v2] thermal: devfreq_cooling: use local ops instead of global ops
Date:   Fri, 25 Mar 2022 15:30:30 +0800
Message-Id: <20220325073030.91919-1-kant@allwinnertech.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix access illegal address problem in following condition:
There are muti devfreq cooling devices in system, some of them has
em model but other does not, energy model ops such as state2power will
append to global devfreq_cooling_ops when the cooling device with
em model register. It makes the cooling device without em model
also use devfreq_cooling_ops after appending when register later by
of_devfreq_cooling_register_power() or of_devfreq_cooling_register().

IPA governor regards the cooling devices without em model as a power actor
because they also have energy model ops, and will access illegal address
at dfc->em_pd when execute cdev->ops->get_requested_power,
cdev->ops->state2power or cdev->ops->power2state.

Fixes: 615510fe13bd2 ("thermal: devfreq_cooling: remove old power model and use EM")
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Kant Fan <kant@allwinnertech.com>
---
 drivers/thermal/devfreq_cooling.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/devfreq_cooling.c b/drivers/thermal/devfreq_cooling.c
index 4310cb342a9f..d38a80adec73 100644
--- a/drivers/thermal/devfreq_cooling.c
+++ b/drivers/thermal/devfreq_cooling.c
@@ -358,21 +358,28 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
 	struct thermal_cooling_device *cdev;
 	struct device *dev = df->dev.parent;
 	struct devfreq_cooling_device *dfc;
+	struct thermal_cooling_device_ops *ops;
 	char *name;
 	int err, num_opps;
 
-	dfc = kzalloc(sizeof(*dfc), GFP_KERNEL);
-	if (!dfc)
+	ops = kmemdup(&devfreq_cooling_ops, sizeof(*ops), GFP_KERNEL);
+	if (!ops)
 		return ERR_PTR(-ENOMEM);
 
+	dfc = kzalloc(sizeof(*dfc), GFP_KERNEL);
+	if (!dfc) {
+		err = -ENOMEM;
+		goto free_ops;
+	}
+
 	dfc->devfreq = df;
 
 	dfc->em_pd = em_pd_get(dev);
 	if (dfc->em_pd) {
-		devfreq_cooling_ops.get_requested_power =
+		ops->get_requested_power =
 			devfreq_cooling_get_requested_power;
-		devfreq_cooling_ops.state2power = devfreq_cooling_state2power;
-		devfreq_cooling_ops.power2state = devfreq_cooling_power2state;
+		ops->state2power = devfreq_cooling_state2power;
+		ops->power2state = devfreq_cooling_power2state;
 
 		dfc->power_ops = dfc_power;
 
@@ -407,8 +414,7 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
 	if (!name)
 		goto remove_qos_req;
 
-	cdev = thermal_of_cooling_device_register(np, name, dfc,
-						  &devfreq_cooling_ops);
+	cdev = thermal_of_cooling_device_register(np, name, dfc, ops);
 	kfree(name);
 
 	if (IS_ERR(cdev)) {
@@ -429,6 +435,8 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
 	kfree(dfc->freq_table);
 free_dfc:
 	kfree(dfc);
+free_ops:
+	kfree(ops);
 
 	return ERR_PTR(err);
 }
@@ -510,11 +518,13 @@ EXPORT_SYMBOL_GPL(devfreq_cooling_em_register);
 void devfreq_cooling_unregister(struct thermal_cooling_device *cdev)
 {
 	struct devfreq_cooling_device *dfc;
+	const struct thermal_cooling_device_ops *ops;
 	struct device *dev;
 
 	if (IS_ERR_OR_NULL(cdev))
 		return;
 
+	ops = cdev->ops;
 	dfc = cdev->devdata;
 	dev = dfc->devfreq->dev.parent;
 
@@ -525,5 +535,6 @@ void devfreq_cooling_unregister(struct thermal_cooling_device *cdev)
 
 	kfree(dfc->freq_table);
 	kfree(dfc);
+	kfree(ops);
 }
 EXPORT_SYMBOL_GPL(devfreq_cooling_unregister);
-- 
2.29.0

