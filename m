Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09105650065
	for <lists+stable@lfdr.de>; Sun, 18 Dec 2022 17:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiLRQOI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Dec 2022 11:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiLRQNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Dec 2022 11:13:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC9D6256;
        Sun, 18 Dec 2022 08:05:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5D6A60DC8;
        Sun, 18 Dec 2022 16:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAA2C433D2;
        Sun, 18 Dec 2022 16:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379543;
        bh=hth2e3ZhAbSSvLOV4bWQs1byxgWkN7BXIj/oOBhBUMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCVpWzLdj81rShdcNeuirkuvGenFrU5Tx4RdyQekbMobzRXW88Nu87r6DPeZW+Zky
         F6MRp5ht2v5I6VLlhOugpXmnaalWbfH8ii1wRsNtv++vRlTvjsDK5teje6xpOOKlPr
         kKw+n9EluoGmeQH1IkPN1rW/Pbn2az6dlHTvA508QSpk4gSgNAk7JfrL2LatWMMiHh
         4WrbFXF4fhldt4xebldaPcISVYd7tOT4ZgIs3UeqtlSVM/GFrdRMtmCatrbHvevvqI
         b5BmkVNG5zat8xGNZ0rGYhYapqTZhqhrZEasWGjpFAW/ZcOsg6Wxjj4+aQijqk8QNl
         bScNKltA1fsQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>, kernel test robot <lkp@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 59/85] media: dvbdev: adopts refcnt to avoid UAF
Date:   Sun, 18 Dec 2022 11:01:16 -0500
Message-Id: <20221218160142.925394-59-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160142.925394-1-sashal@kernel.org>
References: <20221218160142.925394-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 0fc044b2b5e2d05a1fa1fb0d7f270367a7855d79 ]

dvb_unregister_device() is known that prone to use-after-free.
That is, the cleanup from dvb_unregister_device() releases the dvb_device
even if there are pointers stored in file->private_data still refer to it.

This patch adds a reference counter into struct dvb_device and delays its
deallocation until no pointer refers to the object.

Link: https://lore.kernel.org/linux-media/20220807145952.10368-1-linma@zju.edu.cn
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvb_ca_en50221.c |  2 +-
 drivers/media/dvb-core/dvb_frontend.c   |  2 +-
 drivers/media/dvb-core/dvbdev.c         | 32 +++++++++++++++++++------
 include/media/dvbdev.h                  | 31 +++++++++++++-----------
 4 files changed, 44 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 15a08d8c69ef..c2d2792227f8 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -157,7 +157,7 @@ static void dvb_ca_private_free(struct dvb_ca_private *ca)
 {
 	unsigned int i;
 
-	dvb_free_device(ca->dvbdev);
+	dvb_device_put(ca->dvbdev);
 	for (i = 0; i < ca->slot_count; i++)
 		vfree(ca->slot_info[i].rx_buffer.data);
 
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 48e735cdbe6b..c376cd954e5e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -136,7 +136,7 @@ static void __dvb_frontend_free(struct dvb_frontend *fe)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
 	if (fepriv)
-		dvb_free_device(fepriv->dvbdev);
+		dvb_device_put(fepriv->dvbdev);
 
 	dvb_frontend_invoke_release(fe, fe->ops.release);
 
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 675d877a67b2..14f0e140d541 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -97,7 +97,7 @@ static int dvb_device_open(struct inode *inode, struct file *file)
 		new_fops = fops_get(dvbdev->fops);
 		if (!new_fops)
 			goto fail;
-		file->private_data = dvbdev;
+		file->private_data = dvb_device_get(dvbdev);
 		replace_fops(file, new_fops);
 		if (file->f_op->open)
 			err = file->f_op->open(inode, file);
@@ -161,6 +161,9 @@ int dvb_generic_release(struct inode *inode, struct file *file)
 	}
 
 	dvbdev->users++;
+
+	dvb_device_put(dvbdev);
+
 	return 0;
 }
 EXPORT_SYMBOL(dvb_generic_release);
@@ -477,6 +480,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		return -ENOMEM;
 	}
 
+	kref_init(&dvbdev->ref);
 	memcpy(dvbdev, template, sizeof(struct dvb_device));
 	dvbdev->type = type;
 	dvbdev->id = id;
@@ -508,7 +512,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 #endif
 
 	dvbdev->minor = minor;
-	dvb_minors[minor] = dvbdev;
+	dvb_minors[minor] = dvb_device_get(dvbdev);
 	up_write(&minor_rwsem);
 
 	ret = dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
@@ -553,6 +557,7 @@ void dvb_remove_device(struct dvb_device *dvbdev)
 
 	down_write(&minor_rwsem);
 	dvb_minors[dvbdev->minor] = NULL;
+	dvb_device_put(dvbdev);
 	up_write(&minor_rwsem);
 
 	dvb_media_device_free(dvbdev);
@@ -564,21 +569,34 @@ void dvb_remove_device(struct dvb_device *dvbdev)
 EXPORT_SYMBOL(dvb_remove_device);
 
 
-void dvb_free_device(struct dvb_device *dvbdev)
+static void dvb_free_device(struct kref *ref)
 {
-	if (!dvbdev)
-		return;
+	struct dvb_device *dvbdev = container_of(ref, struct dvb_device, ref);
 
 	kfree (dvbdev->fops);
 	kfree (dvbdev);
 }
-EXPORT_SYMBOL(dvb_free_device);
+
+
+struct dvb_device *dvb_device_get(struct dvb_device *dvbdev)
+{
+	kref_get(&dvbdev->ref);
+	return dvbdev;
+}
+EXPORT_SYMBOL(dvb_device_get);
+
+
+void dvb_device_put(struct dvb_device *dvbdev)
+{
+	if (dvbdev)
+		kref_put(&dvbdev->ref, dvb_free_device);
+}
 
 
 void dvb_unregister_device(struct dvb_device *dvbdev)
 {
 	dvb_remove_device(dvbdev);
-	dvb_free_device(dvbdev);
+	dvb_device_put(dvbdev);
 }
 EXPORT_SYMBOL(dvb_unregister_device);
 
diff --git a/include/media/dvbdev.h b/include/media/dvbdev.h
index 2f6b0861322a..149b3d33c24b 100644
--- a/include/media/dvbdev.h
+++ b/include/media/dvbdev.h
@@ -156,6 +156,7 @@ struct dvb_adapter {
  */
 struct dvb_device {
 	struct list_head list_head;
+	struct kref ref;
 	const struct file_operations *fops;
 	struct dvb_adapter *adapter;
 	enum dvb_device_type type;
@@ -187,6 +188,20 @@ struct dvb_device {
 	void *priv;
 };
 
+/**
+ * dvb_device_get - Increase dvb_device reference
+ *
+ * @dvbdev:	pointer to struct dvb_device
+ */
+struct dvb_device *dvb_device_get(struct dvb_device *dvbdev);
+
+/**
+ * dvb_device_get - Decrease dvb_device reference
+ *
+ * @dvbdev:	pointer to struct dvb_device
+ */
+void dvb_device_put(struct dvb_device *dvbdev);
+
 /**
  * dvb_register_adapter - Registers a new DVB adapter
  *
@@ -231,29 +246,17 @@ int dvb_register_device(struct dvb_adapter *adap,
 /**
  * dvb_remove_device - Remove a registered DVB device
  *
- * This does not free memory.  To do that, call dvb_free_device().
+ * This does not free memory. dvb_free_device() will do that when
+ * reference counter is empty
  *
  * @dvbdev:	pointer to struct dvb_device
  */
 void dvb_remove_device(struct dvb_device *dvbdev);
 
-/**
- * dvb_free_device - Free memory occupied by a DVB device.
- *
- * Call dvb_unregister_device() before calling this function.
- *
- * @dvbdev:	pointer to struct dvb_device
- */
-void dvb_free_device(struct dvb_device *dvbdev);
 
 /**
  * dvb_unregister_device - Unregisters a DVB device
  *
- * This is a combination of dvb_remove_device() and dvb_free_device().
- * Using this function is usually a mistake, and is often an indicator
- * for a use-after-free bug (when a userspace process keeps a file
- * handle to a detached device).
- *
  * @dvbdev:	pointer to struct dvb_device
  */
 void dvb_unregister_device(struct dvb_device *dvbdev);
-- 
2.35.1

