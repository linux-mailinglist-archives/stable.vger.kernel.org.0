Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B6360C4E9
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 09:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiJYHV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 03:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbiJYHV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 03:21:27 -0400
Received: from out28-52.mail.aliyun.com (out28-52.mail.aliyun.com [115.124.28.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73CA875481;
        Tue, 25 Oct 2022 00:21:23 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07441602|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00302366-0.00215713-0.994819;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=kant@allwinnertech.com;NM=1;PH=DS;RN=9;RT=9;SR=0;TI=SMTPD_---.PpTooo6_1666682480;
Received: from SunxiBot.allwinnertech.com(mailfrom:kant@allwinnertech.com fp:SMTPD_---.PpTooo6_1666682480)
          by smtp.aliyun-inc.com;
          Tue, 25 Oct 2022 15:21:21 +0800
From:   Kant Fan <kant@allwinnertech.com>
To:     myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, mturquette@ti.com, rjw@rjwysocki.net,
        khilman@ti.com
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v4] PM/devfreq: governor: Add a private governor_data for governor
Date:   Tue, 25 Oct 2022 15:21:09 +0800
Message-Id: <20221025072109.64025-1-kant@allwinnertech.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The member void *data in the structure devfreq can be overwrite
by governor_userspace. For example:
1. The device driver assigned the devfreq governor to simple_ondemand
by the function devfreq_add_device() and init the devfreq member
void *data to a pointer of a static structure devfreq_simple_ondemand_data
by the function devfreq_add_device().
2. The user changed the devfreq governor to userspace by the command
"echo userspace > /sys/class/devfreq/.../governor".
3. The governor userspace alloced a dynamic memory for the struct
userspace_data and assigend the member void *data of devfreq to
this memory by the function userspace_init().
4. The user changed the devfreq governor back to simple_ondemand
by the command "echo simple_ondemand > /sys/class/devfreq/.../governor".
5. The governor userspace exited and assigned the member void *data
in the structure devfreq to NULL by the function userspace_exit().
6. The governor simple_ondemand fetched the static information of
devfreq_simple_ondemand_data in the function
devfreq_simple_ondemand_func() but the member void *data of devfreq was
assigned to NULL by the function userspace_exit().
7. The information of upthreshold and downdifferential is lost
and the governor simple_ondemand can't work correctly.

The member void *data in the structure devfreq is designed for
a static pointer used in a governor and inited by the function
devfreq_add_device(). This patch add an element named governor_data
in the devfreq structure which can be used by a governor(E.g userspace)
who want to assign a private data to do some private things.

Fixes: ce26c5bb9569 ("PM / devfreq: Add basic governors")
Cc: stable@vger.kernel.org # 5.10+
Reviewed-by: Chanwoo Choi <cwchoi00@gmail.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kant Fan <kant@allwinnertech.com>
---
 drivers/devfreq/devfreq.c            |  6 ++----
 drivers/devfreq/governor_userspace.c | 12 ++++++------
 include/linux/devfreq.h              |  7 ++++---
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 63347a5ae599..8c5f6f7fca11 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -776,8 +776,7 @@ static void remove_sysfs_files(struct devfreq *devfreq,
  * @dev:	the device to add devfreq feature.
  * @profile:	device-specific profile to run devfreq.
  * @governor_name:	name of the policy to choose frequency.
- * @data:	private data for the governor. The devfreq framework does not
- *		touch this value.
+ * @data:	devfreq driver pass to governors, governor should not change it.
  */
 struct devfreq *devfreq_add_device(struct device *dev,
 				   struct devfreq_dev_profile *profile,
@@ -1011,8 +1010,7 @@ static void devm_devfreq_dev_release(struct device *dev, void *res)
  * @dev:	the device to add devfreq feature.
  * @profile:	device-specific profile to run devfreq.
  * @governor_name:	name of the policy to choose frequency.
- * @data:	private data for the governor. The devfreq framework does not
- *		touch this value.
+ * @data:	 devfreq driver pass to governors, governor should not change it.
  *
  * This function manages automatically the memory of devfreq device using device
  * resource management and simplify the free operation for memory of devfreq
diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
index ab9db7adb3ad..d69672ccacc4 100644
--- a/drivers/devfreq/governor_userspace.c
+++ b/drivers/devfreq/governor_userspace.c
@@ -21,7 +21,7 @@ struct userspace_data {
 
 static int devfreq_userspace_func(struct devfreq *df, unsigned long *freq)
 {
-	struct userspace_data *data = df->data;
+	struct userspace_data *data = df->governor_data;
 
 	if (data->valid)
 		*freq = data->user_frequency;
@@ -40,7 +40,7 @@ static ssize_t set_freq_store(struct device *dev, struct device_attribute *attr,
 	int err = 0;
 
 	mutex_lock(&devfreq->lock);
-	data = devfreq->data;
+	data = devfreq->governor_data;
 
 	sscanf(buf, "%lu", &wanted);
 	data->user_frequency = wanted;
@@ -60,7 +60,7 @@ static ssize_t set_freq_show(struct device *dev,
 	int err = 0;
 
 	mutex_lock(&devfreq->lock);
-	data = devfreq->data;
+	data = devfreq->governor_data;
 
 	if (data->valid)
 		err = sprintf(buf, "%lu\n", data->user_frequency);
@@ -91,7 +91,7 @@ static int userspace_init(struct devfreq *devfreq)
 		goto out;
 	}
 	data->valid = false;
-	devfreq->data = data;
+	devfreq->governor_data = data;
 
 	err = sysfs_create_group(&devfreq->dev.kobj, &dev_attr_group);
 out:
@@ -107,8 +107,8 @@ static void userspace_exit(struct devfreq *devfreq)
 	if (devfreq->dev.kobj.sd)
 		sysfs_remove_group(&devfreq->dev.kobj, &dev_attr_group);
 
-	kfree(devfreq->data);
-	devfreq->data = NULL;
+	kfree(devfreq->governor_data);
+	devfreq->governor_data = NULL;
 }
 
 static int devfreq_userspace_handler(struct devfreq *devfreq,
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 34aab4dd336c..4dc7cda4fd46 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -152,8 +152,8 @@ struct devfreq_stats {
  * @max_state:		count of entry present in the frequency table.
  * @previous_freq:	previously configured frequency value.
  * @last_status:	devfreq user device info, performance statistics
- * @data:	Private data of the governor. The devfreq framework does not
- *		touch this.
+ * @data:	devfreq driver pass to governors, governor should not change it.
+ * @governor_data:	private data for governors, devfreq core doesn't touch it.
  * @user_min_freq_req:	PM QoS minimum frequency request from user (via sysfs)
  * @user_max_freq_req:	PM QoS maximum frequency request from user (via sysfs)
  * @scaling_min_freq:	Limit minimum frequency requested by OPP interface
@@ -193,7 +193,8 @@ struct devfreq {
 	unsigned long previous_freq;
 	struct devfreq_dev_status last_status;
 
-	void *data; /* private data for governors */
+	void *data;
+	void *governor_data;
 
 	struct dev_pm_qos_request user_min_freq_req;
 	struct dev_pm_qos_request user_max_freq_req;
-- 
2.29.0

