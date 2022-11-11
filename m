Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85BA6250A2
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiKKChN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbiKKCgl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:36:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC72FADB;
        Thu, 10 Nov 2022 18:35:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADF5061E7E;
        Fri, 11 Nov 2022 02:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585FEC433D7;
        Fri, 11 Nov 2022 02:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134121;
        bh=YP8IrGKf0vDad827G146Zm4KImx0RbAY4W8o1gUrL/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCnWQnOkbZ2cXQ791pZahWvZllIAScvcAU1XEC09R+AothHvu2QFp8Dz0GT7leWa/
         bXf94c4L0PB5NCfDGqoXwz+eKDMqIl+gsvfvZVpmQ4bjD1OUxP4C0W6FXrkOIGmxsS
         3TMhQ/G5aEs1RZZdgZi8wueFEgTErKEZOOiF8QdAzpq69W+K3LUUi20xqgHvyQR5Ej
         BG3nw33XAlWsGmbaysapSRMsWOtiiLEb/Bk9mYwLaDtfZZwFgq9Hnr4Webur1YI71m
         yyRN8gkaFlXXBWXdtGDurjNbDTD7livxO+3Zsi6wlGMJSNCQUlp/jxi0HrIgFPnCh6
         4cjxysJjmoSOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 05/11] firmware: arm_scmi: Cleanup the core driver removal callback
Date:   Thu, 10 Nov 2022 21:35:05 -0500
Message-Id: <20221111023511.227800-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023511.227800-1-sashal@kernel.org>
References: <20221111023511.227800-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e815b8f98739..20440b69b222 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1727,10 +1727,16 @@ int scmi_protocol_device_request(const struct scmi_device_id *id_table)
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
@@ -1916,20 +1922,17 @@ void scmi_free_channel(struct scmi_chan_info *cinfo, struct idr *idr, int id)
 
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
@@ -1941,7 +1944,11 @@ static int scmi_remove(struct platform_device *pdev)
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

