Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C166B44E5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbjCJO3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:29:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbjCJO3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:29:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5DFF767
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:27:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDB03B822DF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25415C4339C;
        Fri, 10 Mar 2023 14:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458439;
        bh=rHkEUisRgjJ0rKTKETm/96BXXxzJUqW2bLWOkFpLbS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvfiTpismUM8RbdgRrmDlOy1NX2Wp3Myr0xEo3XhmpRSI2wCA6GjElloqOHCmFgQq
         rPmx250LIJ/jLXgVvcCZ4nYDEEegWPMGH2IA0oNok+gk7VS8i8iclyWlACEjbjsnBE
         9grpeNqnGKN3dooizFxkkpXQ7WQYb8KdC8atgwdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/357] s390/dasd: Prepare for additional path event handling
Date:   Fri, 10 Mar 2023 14:35:16 +0100
Message-Id: <20230310133735.202398784@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Höppner <hoeppner@linux.ibm.com>

[ Upstream commit b72949328869dfd45f6452c2410647afd7db5f1a ]

As more path events need to be handled for ECKD the current path
verification infrastructure can be reused. Rename all path verifcation
code to fit the more broadly based task of path event handling and put
the path verification in a new separate function.

Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 460e9bed82e4 ("s390/dasd: Fix potential memleak in dasd_eckd_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd.c      |  4 +-
 drivers/s390/block/dasd_eckd.c | 78 +++++++++++++++++++---------------
 drivers/s390/block/dasd_int.h  |  1 +
 3 files changed, 47 insertions(+), 36 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index e0570cd0e520c..3362f235e8919 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2128,8 +2128,8 @@ static void __dasd_device_check_path_events(struct dasd_device *device)
 	if (device->stopped &
 	    ~(DASD_STOPPED_DC_WAIT | DASD_UNRESUMED_PM))
 		return;
-	rc = device->discipline->verify_path(device,
-					     dasd_path_get_tbvpm(device));
+	rc = device->discipline->pe_handler(device,
+					    dasd_path_get_tbvpm(device));
 	if (rc)
 		dasd_device_set_timer(device, 50);
 	else
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 53d22975a32fd..d1429936f38c6 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -103,7 +103,7 @@ struct ext_pool_exhaust_work_data {
 };
 
 /* definitions for the path verification worker */
-struct path_verification_work_data {
+struct pe_handler_work_data {
 	struct work_struct worker;
 	struct dasd_device *device;
 	struct dasd_ccw_req cqr;
@@ -112,8 +112,8 @@ struct path_verification_work_data {
 	int isglobal;
 	__u8 tbvpm;
 };
-static struct path_verification_work_data *path_verification_worker;
-static DEFINE_MUTEX(dasd_path_verification_mutex);
+static struct pe_handler_work_data *pe_handler_worker;
+static DEFINE_MUTEX(dasd_pe_handler_mutex);
 
 struct check_attention_work_data {
 	struct work_struct worker;
@@ -1219,7 +1219,7 @@ static int verify_fcx_max_data(struct dasd_device *device, __u8 lpm)
 }
 
 static int rebuild_device_uid(struct dasd_device *device,
-			      struct path_verification_work_data *data)
+			      struct pe_handler_work_data *data)
 {
 	struct dasd_eckd_private *private = device->private;
 	__u8 lpm, opm = dasd_path_get_opm(device);
@@ -1257,10 +1257,9 @@ static int rebuild_device_uid(struct dasd_device *device,
 	return rc;
 }
 
-static void do_path_verification_work(struct work_struct *work)
+static void dasd_eckd_path_available_action(struct dasd_device *device,
+					    struct pe_handler_work_data *data)
 {
-	struct path_verification_work_data *data;
-	struct dasd_device *device;
 	struct dasd_eckd_private path_private;
 	struct dasd_uid *uid;
 	__u8 path_rcd_buf[DASD_ECKD_RCD_DATA_SIZE];
@@ -1269,19 +1268,6 @@ static void do_path_verification_work(struct work_struct *work)
 	char print_uid[60];
 	int rc;
 
-	data = container_of(work, struct path_verification_work_data, worker);
-	device = data->device;
-
-	/* delay path verification until device was resumed */
-	if (test_bit(DASD_FLAG_SUSPENDED, &device->flags)) {
-		schedule_work(work);
-		return;
-	}
-	/* check if path verification already running and delay if so */
-	if (test_and_set_bit(DASD_FLAG_PATH_VERIFY, &device->flags)) {
-		schedule_work(work);
-		return;
-	}
 	opm = 0;
 	npm = 0;
 	ppm = 0;
@@ -1418,30 +1404,54 @@ static void do_path_verification_work(struct work_struct *work)
 		dasd_path_add_nohpfpm(device, hpfpm);
 		spin_unlock_irqrestore(get_ccwdev_lock(device->cdev), flags);
 	}
+}
+
+static void do_pe_handler_work(struct work_struct *work)
+{
+	struct pe_handler_work_data *data;
+	struct dasd_device *device;
+
+	data = container_of(work, struct pe_handler_work_data, worker);
+	device = data->device;
+
+	/* delay path verification until device was resumed */
+	if (test_bit(DASD_FLAG_SUSPENDED, &device->flags)) {
+		schedule_work(work);
+		return;
+	}
+	/* check if path verification already running and delay if so */
+	if (test_and_set_bit(DASD_FLAG_PATH_VERIFY, &device->flags)) {
+		schedule_work(work);
+		return;
+	}
+
+	dasd_eckd_path_available_action(device, data);
+
 	clear_bit(DASD_FLAG_PATH_VERIFY, &device->flags);
 	dasd_put_device(device);
 	if (data->isglobal)
-		mutex_unlock(&dasd_path_verification_mutex);
+		mutex_unlock(&dasd_pe_handler_mutex);
 	else
 		kfree(data);
 }
 
-static int dasd_eckd_verify_path(struct dasd_device *device, __u8 lpm)
+static int dasd_eckd_pe_handler(struct dasd_device *device, __u8 lpm)
 {
-	struct path_verification_work_data *data;
+	struct pe_handler_work_data *data;
 
 	data = kmalloc(sizeof(*data), GFP_ATOMIC | GFP_DMA);
 	if (!data) {
-		if (mutex_trylock(&dasd_path_verification_mutex)) {
-			data = path_verification_worker;
+		if (mutex_trylock(&dasd_pe_handler_mutex)) {
+			data = pe_handler_worker;
 			data->isglobal = 1;
-		} else
+		} else {
 			return -ENOMEM;
+		}
 	} else {
 		memset(data, 0, sizeof(*data));
 		data->isglobal = 0;
 	}
-	INIT_WORK(&data->worker, do_path_verification_work);
+	INIT_WORK(&data->worker, do_pe_handler_work);
 	dasd_get_device(device);
 	data->device = device;
 	data->tbvpm = lpm;
@@ -6694,7 +6704,7 @@ static struct dasd_discipline dasd_eckd_discipline = {
 	.check_device = dasd_eckd_check_characteristics,
 	.uncheck_device = dasd_eckd_uncheck_device,
 	.do_analysis = dasd_eckd_do_analysis,
-	.verify_path = dasd_eckd_verify_path,
+	.pe_handler = dasd_eckd_pe_handler,
 	.basic_to_ready = dasd_eckd_basic_to_ready,
 	.online_to_ready = dasd_eckd_online_to_ready,
 	.basic_to_known = dasd_eckd_basic_to_known,
@@ -6755,16 +6765,16 @@ dasd_eckd_init(void)
 				    GFP_KERNEL | GFP_DMA);
 	if (!dasd_vol_info_req)
 		return -ENOMEM;
-	path_verification_worker = kmalloc(sizeof(*path_verification_worker),
-				   GFP_KERNEL | GFP_DMA);
-	if (!path_verification_worker) {
+	pe_handler_worker = kmalloc(sizeof(*pe_handler_worker),
+				    GFP_KERNEL | GFP_DMA);
+	if (!pe_handler_worker) {
 		kfree(dasd_reserve_req);
 		kfree(dasd_vol_info_req);
 		return -ENOMEM;
 	}
 	rawpadpage = (void *)__get_free_page(GFP_KERNEL);
 	if (!rawpadpage) {
-		kfree(path_verification_worker);
+		kfree(pe_handler_worker);
 		kfree(dasd_reserve_req);
 		kfree(dasd_vol_info_req);
 		return -ENOMEM;
@@ -6773,7 +6783,7 @@ dasd_eckd_init(void)
 	if (!ret)
 		wait_for_device_probe();
 	else {
-		kfree(path_verification_worker);
+		kfree(pe_handler_worker);
 		kfree(dasd_reserve_req);
 		kfree(dasd_vol_info_req);
 		free_page((unsigned long)rawpadpage);
@@ -6785,7 +6795,7 @@ static void __exit
 dasd_eckd_cleanup(void)
 {
 	ccw_driver_unregister(&dasd_eckd_driver);
-	kfree(path_verification_worker);
+	kfree(pe_handler_worker);
 	kfree(dasd_reserve_req);
 	free_page((unsigned long)rawpadpage);
 }
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 9d9685c25253d..e8a06d85d6f72 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -299,6 +299,7 @@ struct dasd_discipline {
 	 * configuration.
 	 */
 	int (*verify_path)(struct dasd_device *, __u8);
+	int (*pe_handler)(struct dasd_device *, __u8);
 
 	/*
 	 * Last things to do when a device is set online, and first things
-- 
2.39.2



