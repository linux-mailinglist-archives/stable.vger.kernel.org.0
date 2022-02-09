Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9CD4AFB5E
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240672AbiBISpp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240611AbiBISpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:45:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF76EC014C9A;
        Wed,  9 Feb 2022 10:43:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2627B612AC;
        Wed,  9 Feb 2022 18:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906C8C340ED;
        Wed,  9 Feb 2022 18:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432187;
        bh=1DHbdGxJ4/bK7M6HfagiOwNN9waYSr1PE3n4r6TtNGQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Lme0JoS8RfX3U3dBm8LOhlSqbScQqvdRyFVxLLCIM/cuWezSAY6BmkBq09oWlHdOm
         6sU0KEJWAOFWr/SRCx9bi4+lo6/ZVc9x2ObuLseZifN7E0ckfDKSRkPd1b1QrfcaOd
         ku4RJbMD7/s+FJCk8cS9cllyU6xrJY58XH5FkCn0n18zK6CSIiUfYj3xL8ciVAye0P
         REPU7vhkZdwrU0FwEthn37uvo5MVLTFjrpn8e7gk4LR4vyW1wGpYZkV7fSL/pHqNpX
         49hU0ujIZupMrizbMeQTVyjDYxHeEQzJqKz3dpr3uRJR583sNpsyt2Zkt4xw9cD3bc
         bVBwfcWo9MkjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Liwei Song <liwei.song@windriver.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, markgross@kernel.org,
        hpa@redhat.com, andriy.shevchenko@linux.intel.com,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/15] platform/x86: ISST: Fix possible circular locking dependency detected
Date:   Wed,  9 Feb 2022 13:42:47 -0500
Message-Id: <20220209184305.47983-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 17da2d5f93692086dd096a975225ffd5622d0bf8 ]

As reported:

[  256.104522] ======================================================
[  256.113783] WARNING: possible circular locking dependency detected
[  256.120093] 5.16.0-rc6-yocto-standard+ #99 Not tainted
[  256.125362] ------------------------------------------------------
[  256.131673] intel-speed-sel/844 is trying to acquire lock:
[  256.137290] ffffffffc036f0d0 (punit_misc_dev_lock){+.+.}-{3:3}, at: isst_if_open+0x18/0x90 [isst_if_common]
[  256.147171]
[  256.147171] but task is already holding lock:
[  256.153135] ffffffff8ee7cb50 (misc_mtx){+.+.}-{3:3}, at: misc_open+0x2a/0x170
[  256.160407]
[  256.160407] which lock already depends on the new lock.
[  256.160407]
[  256.168712]
[  256.168712] the existing dependency chain (in reverse order) is:
[  256.176327]
[  256.176327] -> #1 (misc_mtx){+.+.}-{3:3}:
[  256.181946]        lock_acquire+0x1e6/0x330
[  256.186265]        __mutex_lock+0x9b/0x9b0
[  256.190497]        mutex_lock_nested+0x1b/0x20
[  256.195075]        misc_register+0x32/0x1a0
[  256.199390]        isst_if_cdev_register+0x65/0x180 [isst_if_common]
[  256.205878]        isst_if_probe+0x144/0x16e [isst_if_mmio]
...
[  256.241976]
[  256.241976] -> #0 (punit_misc_dev_lock){+.+.}-{3:3}:
[  256.248552]        validate_chain+0xbc6/0x1750
[  256.253131]        __lock_acquire+0x88c/0xc10
[  256.257618]        lock_acquire+0x1e6/0x330
[  256.261933]        __mutex_lock+0x9b/0x9b0
[  256.266165]        mutex_lock_nested+0x1b/0x20
[  256.270739]        isst_if_open+0x18/0x90 [isst_if_common]
[  256.276356]        misc_open+0x100/0x170
[  256.280409]        chrdev_open+0xa5/0x1e0
...

The call sequence suggested that misc_device /dev file can be opened
before misc device is yet to be registered, which is done only once.

Here punit_misc_dev_lock was used as common lock, to protect the
registration by multiple ISST HW drivers, one time setup, prevent
duplicate registry of misc device and prevent load/unload when device
is open.

We can split into locks:
- One which just prevent duplicate call to misc_register() and one
time setup. Also never call again if the misc_register() failed or
required one time setup is failed. This lock is not shared with
any misc device callbacks.

- The other lock protects registry, load and unload of HW drivers.

Sequence in isst_if_cdev_register()
- Register callbacks under punit_misc_dev_open_lock
- Call isst_misc_reg() which registers misc_device on the first
registry which is under punit_misc_dev_reg_lock, which is not
shared with callbacks.

Sequence in isst_if_cdev_unregister
Just opposite of isst_if_cdev_register

Reported-and-tested-by: Liwei Song <liwei.song@windriver.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://lore.kernel.org/r/20220112022521.54669-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel_speed_select_if/isst_if_common.c    | 97 ++++++++++++-------
 1 file changed, 63 insertions(+), 34 deletions(-)

diff --git a/drivers/platform/x86/intel_speed_select_if/isst_if_common.c b/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
index 3de5a3c66529d..cf7b6dee82191 100644
--- a/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
+++ b/drivers/platform/x86/intel_speed_select_if/isst_if_common.c
@@ -529,7 +529,10 @@ static long isst_if_def_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
-static DEFINE_MUTEX(punit_misc_dev_lock);
+/* Lock to prevent module registration when already opened by user space */
+static DEFINE_MUTEX(punit_misc_dev_open_lock);
+/* Lock to allow one share misc device for all ISST interace */
+static DEFINE_MUTEX(punit_misc_dev_reg_lock);
 static int misc_usage_count;
 static int misc_device_ret;
 static int misc_device_open;
@@ -539,7 +542,7 @@ static int isst_if_open(struct inode *inode, struct file *file)
 	int i, ret = 0;
 
 	/* Fail open, if a module is going away */
-	mutex_lock(&punit_misc_dev_lock);
+	mutex_lock(&punit_misc_dev_open_lock);
 	for (i = 0; i < ISST_IF_DEV_MAX; ++i) {
 		struct isst_if_cmd_cb *cb = &punit_callbacks[i];
 
@@ -561,7 +564,7 @@ static int isst_if_open(struct inode *inode, struct file *file)
 	} else {
 		misc_device_open++;
 	}
-	mutex_unlock(&punit_misc_dev_lock);
+	mutex_unlock(&punit_misc_dev_open_lock);
 
 	return ret;
 }
@@ -570,7 +573,7 @@ static int isst_if_relase(struct inode *inode, struct file *f)
 {
 	int i;
 
-	mutex_lock(&punit_misc_dev_lock);
+	mutex_lock(&punit_misc_dev_open_lock);
 	misc_device_open--;
 	for (i = 0; i < ISST_IF_DEV_MAX; ++i) {
 		struct isst_if_cmd_cb *cb = &punit_callbacks[i];
@@ -578,7 +581,7 @@ static int isst_if_relase(struct inode *inode, struct file *f)
 		if (cb->registered)
 			module_put(cb->owner);
 	}
-	mutex_unlock(&punit_misc_dev_lock);
+	mutex_unlock(&punit_misc_dev_open_lock);
 
 	return 0;
 }
@@ -595,6 +598,43 @@ static struct miscdevice isst_if_char_driver = {
 	.fops		= &isst_if_char_driver_ops,
 };
 
+static int isst_misc_reg(void)
+{
+	mutex_lock(&punit_misc_dev_reg_lock);
+	if (misc_device_ret)
+		goto unlock_exit;
+
+	if (!misc_usage_count) {
+		misc_device_ret = isst_if_cpu_info_init();
+		if (misc_device_ret)
+			goto unlock_exit;
+
+		misc_device_ret = misc_register(&isst_if_char_driver);
+		if (misc_device_ret) {
+			isst_if_cpu_info_exit();
+			goto unlock_exit;
+		}
+	}
+	misc_usage_count++;
+
+unlock_exit:
+	mutex_unlock(&punit_misc_dev_reg_lock);
+
+	return misc_device_ret;
+}
+
+static void isst_misc_unreg(void)
+{
+	mutex_lock(&punit_misc_dev_reg_lock);
+	if (misc_usage_count)
+		misc_usage_count--;
+	if (!misc_usage_count && !misc_device_ret) {
+		misc_deregister(&isst_if_char_driver);
+		isst_if_cpu_info_exit();
+	}
+	mutex_unlock(&punit_misc_dev_reg_lock);
+}
+
 /**
  * isst_if_cdev_register() - Register callback for IOCTL
  * @device_type: The device type this callback handling.
@@ -612,38 +652,31 @@ static struct miscdevice isst_if_char_driver = {
  */
 int isst_if_cdev_register(int device_type, struct isst_if_cmd_cb *cb)
 {
-	if (misc_device_ret)
-		return misc_device_ret;
+	int ret;
 
 	if (device_type >= ISST_IF_DEV_MAX)
 		return -EINVAL;
 
-	mutex_lock(&punit_misc_dev_lock);
+	mutex_lock(&punit_misc_dev_open_lock);
+	/* Device is already open, we don't want to add new callbacks */
 	if (misc_device_open) {
-		mutex_unlock(&punit_misc_dev_lock);
+		mutex_unlock(&punit_misc_dev_open_lock);
 		return -EAGAIN;
 	}
-	if (!misc_usage_count) {
-		int ret;
-
-		misc_device_ret = misc_register(&isst_if_char_driver);
-		if (misc_device_ret)
-			goto unlock_exit;
-
-		ret = isst_if_cpu_info_init();
-		if (ret) {
-			misc_deregister(&isst_if_char_driver);
-			misc_device_ret = ret;
-			goto unlock_exit;
-		}
-	}
 	memcpy(&punit_callbacks[device_type], cb, sizeof(*cb));
 	punit_callbacks[device_type].registered = 1;
-	misc_usage_count++;
-unlock_exit:
-	mutex_unlock(&punit_misc_dev_lock);
+	mutex_unlock(&punit_misc_dev_open_lock);
 
-	return misc_device_ret;
+	ret = isst_misc_reg();
+	if (ret) {
+		/*
+		 * No need of mutex as the misc device register failed
+		 * as no one can open device yet. Hence no contention.
+		 */
+		punit_callbacks[device_type].registered = 0;
+		return ret;
+	}
+	return 0;
 }
 EXPORT_SYMBOL_GPL(isst_if_cdev_register);
 
@@ -658,16 +691,12 @@ EXPORT_SYMBOL_GPL(isst_if_cdev_register);
  */
 void isst_if_cdev_unregister(int device_type)
 {
-	mutex_lock(&punit_misc_dev_lock);
-	misc_usage_count--;
+	isst_misc_unreg();
+	mutex_lock(&punit_misc_dev_open_lock);
 	punit_callbacks[device_type].registered = 0;
 	if (device_type == ISST_IF_DEV_MBOX)
 		isst_delete_hash();
-	if (!misc_usage_count && !misc_device_ret) {
-		misc_deregister(&isst_if_char_driver);
-		isst_if_cpu_info_exit();
-	}
-	mutex_unlock(&punit_misc_dev_lock);
+	mutex_unlock(&punit_misc_dev_open_lock);
 }
 EXPORT_SYMBOL_GPL(isst_if_cdev_unregister);
 
-- 
2.34.1

