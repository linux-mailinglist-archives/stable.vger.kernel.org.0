Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044B34E7034
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 10:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243283AbiCYJqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 05:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243192AbiCYJqm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 05:46:42 -0400
Received: from out29-173.mail.aliyun.com (out29-173.mail.aliyun.com [115.124.29.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43E569CC5;
        Fri, 25 Mar 2022 02:45:03 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.0745066|-1;BR=01201311R121S62rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0264882-0.0159725-0.957539;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=kant@allwinnertech.com;NM=1;PH=DS;RN=11;RT=11;SR=0;TI=SMTPD_---.NCJqz9-_1648201498;
Received: from sunxibot.allwinnertech.com(mailfrom:kant@allwinnertech.com fp:SMTPD_---.NCJqz9-_1648201498)
          by smtp.aliyun-inc.com(33.13.201.118);
          Fri, 25 Mar 2022 17:44:59 +0800
From:   Kant Fan <kant@allwinnertech.com>
To:     rui.zhang@intel.com, daniel.lezcano@linaro.org,
        javi.merino@kernel.org, edubezval@gmail.com, orjan.eide@arm.com
Cc:     amitk@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        allwinner-opensource-support@allwinnertech.com,
        Kant Fan <kant@allwinnertech.com>, stable@vger.kernel.org
Subject: [PATCH] thermal: devfreq_cooling: use local ops instead of global ops
Date:   Fri, 25 Mar 2022 17:44:36 +0800
Message-Id: <20220325094436.101419-1-kant@allwinnertech.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 7b62935828266658714f81d4e9176edad808dc70 upstream.

Fix access illegal address problem in following condition:
There are muti devfreq cooling devices in system, some of them register
with dfc_power but other does not, power model ops such as state2power will
append to global devfreq_cooling_ops when the cooling device with
dfc_power register. It makes the cooling device without dfc_power
also use devfreq_cooling_ops after appending when register later by
of_devfreq_cooling_register_power() or of_devfreq_cooling_register().

IPA governor regards the cooling devices without dfc_power as a power actor
because they also have power model ops, and will access illegal address at
dfc->power_ops when execute cdev->ops->get_requested_power or
cdev->ops->power2state. As the calltrace below shows:

Unable to handle kernel NULL pointer dereference at virtual address
00000008
...
calltrace:
[<c06e5488>] devfreq_cooling_power2state+0x24/0x184
[<c06df420>] power_actor_set_power+0x54/0xa8
[<c06e3774>] power_allocator_throttle+0x770/0x97c
[<c06dd120>] handle_thermal_trip+0x1b4/0x26c
[<c06ddb48>] thermal_zone_device_update+0x154/0x208
[<c014159c>] process_one_work+0x1ec/0x36c
[<c0141c58>] worker_thread+0x204/0x2ec
[<c0146788>] kthread+0x140/0x154
[<c01010e8>] ret_from_fork+0x14/0x2c

Fixes: a76caf55e5b35 ("thermal: Add devfreq cooling")
Cc: stable@vger.kernel.org # 4.4+
Signed-off-by: Kant Fan <kant@allwinnertech.com>
---
 drivers/thermal/devfreq_cooling.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/thermal/devfreq_cooling.c b/drivers/thermal/devfreq_cooling.c
index dfab49a67252..d36f70513e6a 100644
--- a/drivers/thermal/devfreq_cooling.c
+++ b/drivers/thermal/devfreq_cooling.c
@@ -462,22 +462,29 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
 {
 	struct thermal_cooling_device *cdev;
 	struct devfreq_cooling_device *dfc;
+	struct thermal_cooling_device_ops *ops;
 	char dev_name[THERMAL_NAME_LENGTH];
 	int err;
 
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
 
 	if (dfc_power) {
 		dfc->power_ops = dfc_power;
 
-		devfreq_cooling_ops.get_requested_power =
+		ops->get_requested_power =
 			devfreq_cooling_get_requested_power;
-		devfreq_cooling_ops.state2power = devfreq_cooling_state2power;
-		devfreq_cooling_ops.power2state = devfreq_cooling_power2state;
+		ops->state2power = devfreq_cooling_state2power;
+		ops->power2state = devfreq_cooling_power2state;
 	}
 
 	err = devfreq_cooling_gen_tables(dfc);
@@ -497,8 +504,7 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
 
 	snprintf(dev_name, sizeof(dev_name), "thermal-devfreq-%d", dfc->id);
 
-	cdev = thermal_of_cooling_device_register(np, dev_name, dfc,
-						  &devfreq_cooling_ops);
+	cdev = thermal_of_cooling_device_register(np, dev_name, dfc, ops);
 	if (IS_ERR(cdev)) {
 		err = PTR_ERR(cdev);
 		dev_err(df->dev.parent,
@@ -522,6 +528,8 @@ of_devfreq_cooling_register_power(struct device_node *np, struct devfreq *df,
 	kfree(dfc->freq_table);
 free_dfc:
 	kfree(dfc);
+free_ops:
+	kfree(ops);
 
 	return ERR_PTR(err);
 }
@@ -557,10 +565,12 @@ EXPORT_SYMBOL_GPL(devfreq_cooling_register);
 void devfreq_cooling_unregister(struct thermal_cooling_device *cdev)
 {
 	struct devfreq_cooling_device *dfc;
+	const struct thermal_cooling_device_ops *ops;
 
 	if (!cdev)
 		return;
 
+	ops = cdev->ops;
 	dfc = cdev->devdata;
 
 	thermal_cooling_device_unregister(dfc->cdev);
@@ -570,5 +580,6 @@ void devfreq_cooling_unregister(struct thermal_cooling_device *cdev)
 	kfree(dfc->freq_table);
 
 	kfree(dfc);
+	kfree(ops);
 }
 EXPORT_SYMBOL_GPL(devfreq_cooling_unregister);
-- 
2.29.0

