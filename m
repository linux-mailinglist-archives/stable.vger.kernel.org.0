Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0446357C7
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbiKWJqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238257AbiKWJqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:46:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94748115D08
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:43:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 430E8B81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E53EC433D6;
        Wed, 23 Nov 2022 09:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196586;
        bh=glbE3S9RsgFrlsq6jJGVxtzhTrP2Q4j6MV5sxQfWGkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMTXZb42FCbPn4iRLKzA8dOnmy3+30UwxIhEl3+HFmnyI2REzIgIu44ETf5t/l4Yj
         QDQ3gfxx/8nEvKkKJmdqRlvkFXEuAhjVsY3HHeOFwoITXMPosMR7VsRCsDOtQo0B9O
         77RLa4Ry9aaQYDU2nj8nayVXOP7zzUZD3s5FTJLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 043/314] firmware: arm_scmi: Cleanup the core driver removal callback
Date:   Wed, 23 Nov 2022 09:48:08 +0100
Message-Id: <20221123084627.473422332@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index d4e23101448a..35bb70724d44 100644
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
index 61aba7447c32..9b87b5b69535 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -97,6 +97,7 @@ static inline void unpack_scmi_header(u32 msg_hdr, struct scmi_msg_hdr *hdr)
 struct scmi_revision_info *
 scmi_revision_area_get(const struct scmi_protocol_handle *ph);
 int scmi_handle_put(const struct scmi_handle *handle);
+void scmi_device_link_add(struct device *consumer, struct device *supplier);
 struct scmi_handle *scmi_handle_get(struct device *dev);
 void scmi_set_handle(struct scmi_device *scmi_dev);
 void scmi_setup_protocol_implemented(const struct scmi_protocol_handle *ph,
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 9022f5ee29aa..244d94eeb092 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2277,10 +2277,16 @@ int scmi_protocol_device_request(const struct scmi_device_id *id_table)
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
@@ -2479,20 +2485,17 @@ void scmi_free_channel(struct scmi_chan_info *cinfo, struct idr *idr, int id)
 
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
@@ -2504,7 +2507,11 @@ static int scmi_remove(struct platform_device *pdev)
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



