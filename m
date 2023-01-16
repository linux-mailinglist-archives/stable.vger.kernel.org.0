Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683FC66CD4E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbjAPRfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbjAPRew (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:34:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CFD55B5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:10:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56161B81071
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47FAC433D2;
        Mon, 16 Jan 2023 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889056;
        bh=YK35kXil+ag8qxrSIaKf/5Rc+ML3luyqQ8EwiPko1qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dBwy11o6VGtM/V+7SQ4xHoWUH3CIRvOSA73NbgGcnBp5Ev97et2a1CXi/eYSPZTHR
         TPj5EMyAq/4ILgLxkRjOirzAQU8RS8o5nFt+st1OsxjLGu1z/ar9lZuYurRbsDyHPa
         1AKYBVPiNm1wiJ9t65kChd7CVnW8VRcPhLQOKPgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lin Ma <linma@zju.edu.cn>,
        kernel test robot <lkp@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 240/338] media: dvbdev: adopts refcnt to avoid UAF
Date:   Mon, 16 Jan 2023 16:51:53 +0100
Message-Id: <20230116154831.511750579@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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
 drivers/media/dvb-core/dvbdev.h         | 31 +++++++++++++-----------
 4 files changed, 44 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 95b3723282f4..56114d85510f 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -167,7 +167,7 @@ static void dvb_ca_private_free(struct dvb_ca_private *ca)
 {
 	unsigned int i;
 
-	dvb_free_device(ca->dvbdev);
+	dvb_device_put(ca->dvbdev);
 	for (i = 0; i < ca->slot_count; i++)
 		vfree(ca->slot_info[i].rx_buffer.data);
 
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index f7d4ec37fdbc..e3a4a4688c2e 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -146,7 +146,7 @@ static void __dvb_frontend_free(struct dvb_frontend *fe)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
 	if (fepriv)
-		dvb_free_device(fepriv->dvbdev);
+		dvb_device_put(fepriv->dvbdev);
 
 	dvb_frontend_invoke_release(fe, fe->ops.release);
 
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 1628cbdd20d7..4c89c37713bd 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -84,7 +84,7 @@ static int dvb_device_open(struct inode *inode, struct file *file)
 		new_fops = fops_get(dvbdev->fops);
 		if (!new_fops)
 			goto fail;
-		file->private_data = dvbdev;
+		file->private_data = dvb_device_get(dvbdev);
 		replace_fops(file, new_fops);
 		if (file->f_op->open)
 			err = file->f_op->open(inode, file);
@@ -148,6 +148,9 @@ int dvb_generic_release(struct inode *inode, struct file *file)
 	}
 
 	dvbdev->users++;
+
+	dvb_device_put(dvbdev);
+
 	return 0;
 }
 EXPORT_SYMBOL(dvb_generic_release);
@@ -462,6 +465,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 		return -ENOMEM;
 	}
 
+	kref_init(&dvbdev->ref);
 	memcpy(dvbdev, template, sizeof(struct dvb_device));
 	dvbdev->type = type;
 	dvbdev->id = id;
@@ -493,7 +497,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 #endif
 
 	dvbdev->minor = minor;
-	dvb_minors[minor] = dvbdev;
+	dvb_minors[minor] = dvb_device_get(dvbdev);
 	up_write(&minor_rwsem);
 
 	ret = dvb_register_media_device(dvbdev, type, minor, demux_sink_pads);
@@ -534,6 +538,7 @@ void dvb_remove_device(struct dvb_device *dvbdev)
 
 	down_write(&minor_rwsem);
 	dvb_minors[dvbdev->minor] = NULL;
+	dvb_device_put(dvbdev);
 	up_write(&minor_rwsem);
 
 	dvb_media_device_free(dvbdev);
@@ -545,21 +550,34 @@ void dvb_remove_device(struct dvb_device *dvbdev)
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
 
diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
index 49189392cf3b..5f6a6e7cda61 100644
--- a/drivers/media/dvb-core/dvbdev.h
+++ b/drivers/media/dvb-core/dvbdev.h
@@ -133,6 +133,7 @@ struct dvb_adapter {
  */
 struct dvb_device {
 	struct list_head list_head;
+	struct kref ref;
 	const struct file_operations *fops;
 	struct dvb_adapter *adapter;
 	int type;
@@ -164,6 +165,20 @@ struct dvb_device {
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
@@ -210,29 +225,17 @@ int dvb_register_device(struct dvb_adapter *adap,
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



