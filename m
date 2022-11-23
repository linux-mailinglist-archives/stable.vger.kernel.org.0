Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842E4635683
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237749AbiKWJbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237675AbiKWJaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:30:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27597DCB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:29:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0358B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EAB7C433D6;
        Wed, 23 Nov 2022 09:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195765;
        bh=3WkrmEoAFgzP3rS0WAcjwHIGzNUq1a486mzZdGRC2ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRcHAMihLYpFHM1pqDqolGJIhNR0Iyi4ON4y/ri3m2RK/4x9TS3IUT8o+WP7Bj1ve
         V8vn62DY9OC9l8BuP9cMCFF4P+LCDkFKRh/pURHYgV6A2KOOu0BeU7tXtiDHUxwzyZ
         xi5kJrYSC0MG7Hl6l9RP4m+jXxlGuH0y7dIPF4cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/181] firmware: arm_scmi: Cleanup the core driver removal callback
Date:   Wed, 23 Nov 2022 09:49:49 +0100
Message-Id: <20221123084603.537554541@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 3f4071cbd2063b917486d1047a4da47718215fee ]

Platform drivers .remove callbacks are not supposed to fail and report
errors. Such errors are indeed ignored by the core platform drivers
and the driver unbind process is anyway completed.

The SCMI core platform driver as it is now, instead, bails out reporting
an error in case of an explicit unbind request.

Fix the removal path by adding proper device links between the core SCMI
device and the SCMI protocol devices so that a full SCMI stack unbind is
triggered when the core driver is removed. The remove process does not
bail out anymore on the anomalous conditions triggered by an explicit
unbind but the user is still warned.

Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20221028140833.280091-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/bus.c    | 11 +++++++++++
 drivers/firmware/arm_scmi/common.h |  1 +
 drivers/firmware/arm_scmi/driver.c | 31 ++++++++++++++++++------------
 3 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/arm_scmi/bus.c b/drivers/firmware/arm_scmi/bus.c
index f6fe723ab869..7c1c0951e562 100644
--- a/drivers/firmware/arm_scmi/bus.c
+++ b/drivers/firmware/arm_scmi/bus.c
@@ -216,9 +216,20 @@ void scmi_device_destroy(struct scmi_device *scmi_dev)
 	device_unregister(&scmi_dev->dev);
 }
 
+void scmi_device_link_add(struct device *consumer, struct device *supplier)
+{
+	struct device_link *link;
+
+	link = device_link_add(consumer, supplier, DL_FLAG_AUTOREMOVE_CONSUMER);
+
+	WARN_ON(!link);
+}
+
 void scmi_set_handle(struct scmi_device *scmi_dev)
 {
 	scmi_dev->handle = scmi_handle_get(&scmi_dev->dev);
+	if (scmi_dev->handle)
+		scmi_device_link_add(&scmi_dev->dev, scmi_dev->handle->dev);
 }
 
 int scmi_protocol_register(const struct scmi_protocol *proto)
diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index dea1bfbe1052..b9f5829c0c4d 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -272,6 +272,7 @@ struct scmi_xfer_ops {
 struct scmi_revision_info *
 scmi_revision_area_get(const struct scmi_protocol_handle *ph);
 int scmi_handle_put(const struct scmi_handle *handle);
+void scmi_device_link_add(struct device *consumer, struct device *supplier);
 struct scmi_handle *scmi_handle_get(struct device *dev);
 void scmi_set_handle(struct scmi_device *scmi_dev);
 void scmi_setup_protocol_implemented(const struct scmi_protocol_handle *ph,
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 16569af4a2ba..a8ff4c9508b7 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1731,10 +1731,16 @@ int scmi_protocol_device_request(const struct scmi_device_id *id_table)
 			sdev = scmi_get_protocol_device(child, info,
 							id_table->protocol_id,
 							id_table->name);
-			/* Set handle if not already set: device existed */
-			if (sdev && !sdev->handle)
-				sdev->handle =
-					scmi_handle_get_from_info_unlocked(info);
+			if (sdev) {
+				/* Set handle if not already set: device existed */
+				if (!sdev->handle)
+					sdev->handle =
+						scmi_handle_get_from_info_unlocked(info);
+				/* Relink consumer and suppliers */
+				if (sdev->handle)
+					scmi_device_link_add(&sdev->dev,
+							     sdev->handle->dev);
+			}
 		} else {
 			dev_err(info->dev,
 				"Failed. SCMI protocol %d not active.\n",
@@ -1920,20 +1926,17 @@ void scmi_free_channel(struct scmi_chan_info *cinfo, struct idr *idr, int id)
 
 static int scmi_remove(struct platform_device *pdev)
 {
-	int ret = 0, id;
+	int ret, id;
 	struct scmi_info *info = platform_get_drvdata(pdev);
 	struct device_node *child;
 
 	mutex_lock(&scmi_list_mutex);
 	if (info->users)
-		ret = -EBUSY;
-	else
-		list_del(&info->node);
+		dev_warn(&pdev->dev,
+			 "Still active SCMI users will be forcibly unbound.\n");
+	list_del(&info->node);
 	mutex_unlock(&scmi_list_mutex);
 
-	if (ret)
-		return ret;
-
 	scmi_notification_exit(&info->handle);
 
 	mutex_lock(&info->protocols_mtx);
@@ -1945,7 +1948,11 @@ static int scmi_remove(struct platform_device *pdev)
 	idr_destroy(&info->active_protocols);
 
 	/* Safe to free channels since no more users */
-	return scmi_cleanup_txrx_channels(info);
+	ret = scmi_cleanup_txrx_channels(info);
+	if (ret)
+		dev_warn(&pdev->dev, "Failed to cleanup SCMI channels.\n");
+
+	return 0;
 }
 
 static ssize_t protocol_version_show(struct device *dev,
-- 
2.35.1



