Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8311B65D811
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:11:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbjADQKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239981AbjADQKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:10:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C783FA12
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:09:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D5D6B8171C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E50FC433EF;
        Wed,  4 Jan 2023 16:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848593;
        bh=ahfXqPknj3AbBXkHGlCLemgISg0/eYlBQlOfNKMa9vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jhN45vsCxsyrngNg0maJ9xKgKeQ4uXrwAR7nFPASZA+WL5eAXeWzIlPl3dBejtP+m
         UGn7H42nAtAI10LR+xLbJagIK726UdFsD1vrXJZwZSZW5ZfG9Occ5wvmDI6q/CGQOe
         0maBPme9ofZiygn8rGRsUMPFDxj1XLw0Oq5XuEAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chanwoo Choi <cwchoi00@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kant Fan <kant@allwinnertech.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 6.1 033/207] PM/devfreq: governor: Add a private governor_data for governor
Date:   Wed,  4 Jan 2023 17:04:51 +0100
Message-Id: <20230104160512.964348536@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Kant Fan <kant@allwinnertech.com>

commit 5fdded8448924e3631d466eea499b11606c43640 upstream.

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
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/devfreq/devfreq.c            |    6 ++----
 drivers/devfreq/governor_userspace.c |   12 ++++++------
 include/linux/devfreq.h              |    7 ++++---
 3 files changed, 12 insertions(+), 13 deletions(-)

--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -776,8 +776,7 @@ static void remove_sysfs_files(struct de
  * @dev:	the device to add devfreq feature.
  * @profile:	device-specific profile to run devfreq.
  * @governor_name:	name of the policy to choose frequency.
- * @data:	private data for the governor. The devfreq framework does not
- *		touch this value.
+ * @data:	devfreq driver pass to governors, governor should not change it.
  */
 struct devfreq *devfreq_add_device(struct device *dev,
 				   struct devfreq_dev_profile *profile,
@@ -1011,8 +1010,7 @@ static void devm_devfreq_dev_release(str
  * @dev:	the device to add devfreq feature.
  * @profile:	device-specific profile to run devfreq.
  * @governor_name:	name of the policy to choose frequency.
- * @data:	private data for the governor. The devfreq framework does not
- *		touch this value.
+ * @data:	 devfreq driver pass to governors, governor should not change it.
  *
  * This function manages automatically the memory of devfreq device using device
  * resource management and simplify the free operation for memory of devfreq
--- a/drivers/devfreq/governor_userspace.c
+++ b/drivers/devfreq/governor_userspace.c
@@ -21,7 +21,7 @@ struct userspace_data {
 
 static int devfreq_userspace_func(struct devfreq *df, unsigned long *freq)
 {
-	struct userspace_data *data = df->data;
+	struct userspace_data *data = df->governor_data;
 
 	if (data->valid)
 		*freq = data->user_frequency;
@@ -40,7 +40,7 @@ static ssize_t set_freq_store(struct dev
 	int err = 0;
 
 	mutex_lock(&devfreq->lock);
-	data = devfreq->data;
+	data = devfreq->governor_data;
 
 	sscanf(buf, "%lu", &wanted);
 	data->user_frequency = wanted;
@@ -60,7 +60,7 @@ static ssize_t set_freq_show(struct devi
 	int err = 0;
 
 	mutex_lock(&devfreq->lock);
-	data = devfreq->data;
+	data = devfreq->governor_data;
 
 	if (data->valid)
 		err = sprintf(buf, "%lu\n", data->user_frequency);
@@ -91,7 +91,7 @@ static int userspace_init(struct devfreq
 		goto out;
 	}
 	data->valid = false;
-	devfreq->data = data;
+	devfreq->governor_data = data;
 
 	err = sysfs_create_group(&devfreq->dev.kobj, &dev_attr_group);
 out:
@@ -107,8 +107,8 @@ static void userspace_exit(struct devfre
 	if (devfreq->dev.kobj.sd)
 		sysfs_remove_group(&devfreq->dev.kobj, &dev_attr_group);
 
-	kfree(devfreq->data);
-	devfreq->data = NULL;
+	kfree(devfreq->governor_data);
+	devfreq->governor_data = NULL;
 }
 
 static int devfreq_userspace_handler(struct devfreq *devfreq,
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


