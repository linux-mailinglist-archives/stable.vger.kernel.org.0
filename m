Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE2E551D18
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245099AbiFTNKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245646AbiFTNJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:09:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1BCC33;
        Mon, 20 Jun 2022 06:03:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9271B61555;
        Mon, 20 Jun 2022 13:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A414C3411B;
        Mon, 20 Jun 2022 13:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730138;
        bh=I4JmcuB1+HhYqCZmRjbSUTBu23rTFSbwGQygKGZwloY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zdJGgKDWzahaOCpXiaDvDZhLFV1poD7cM4LUzc6o51G/+eTyxdcJI2Iq90ByetkV+
         amKl8OYwsu4vSfHbhgbJceD6Je7vjhhLbPa86kARMJbH+9G7Q62T2hNS+8UAPI6n35
         BipqQc6HA264kK3xEVVXFnIOOTuFQ49zP8vDxoBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Daniel Wagner <dwagner@suse.de>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/84] nvme: use sysfs_emit instead of sprintf
Date:   Mon, 20 Jun 2022 14:51:08 +0200
Message-Id: <20220620124722.223087283@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit bff4bcf3cfc1595e0ef2aeb774b2403c88de1486 ]

sysfs_emit is the recommended API to use for formatting strings to be
returned to user space. It is equivalent to scnprintf and aware of the
PAGE_SIZE buffer size.

Suggested-by: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c      | 40 +++++++++++++++++------------------
 drivers/nvme/host/multipath.c |  8 +++----
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d301f0280ff6..c8c8c567a000 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2813,8 +2813,8 @@ static ssize_t subsys_##field##_show(struct device *dev,		\
 {									\
 	struct nvme_subsystem *subsys =					\
 		container_of(dev, struct nvme_subsystem, dev);		\
-	return sprintf(buf, "%.*s\n",					\
-		       (int)sizeof(subsys->field), subsys->field);	\
+	return sysfs_emit(buf, "%.*s\n",				\
+			   (int)sizeof(subsys->field), subsys->field);	\
 }									\
 static SUBSYS_ATTR_RO(field, S_IRUGO, subsys_##field##_show);
 
@@ -3335,13 +3335,13 @@ static ssize_t wwid_show(struct device *dev, struct device_attribute *attr,
 	int model_len = sizeof(subsys->model);
 
 	if (!uuid_is_null(&ids->uuid))
-		return sprintf(buf, "uuid.%pU\n", &ids->uuid);
+		return sysfs_emit(buf, "uuid.%pU\n", &ids->uuid);
 
 	if (memchr_inv(ids->nguid, 0, sizeof(ids->nguid)))
-		return sprintf(buf, "eui.%16phN\n", ids->nguid);
+		return sysfs_emit(buf, "eui.%16phN\n", ids->nguid);
 
 	if (memchr_inv(ids->eui64, 0, sizeof(ids->eui64)))
-		return sprintf(buf, "eui.%8phN\n", ids->eui64);
+		return sysfs_emit(buf, "eui.%8phN\n", ids->eui64);
 
 	while (serial_len > 0 && (subsys->serial[serial_len - 1] == ' ' ||
 				  subsys->serial[serial_len - 1] == '\0'))
@@ -3350,7 +3350,7 @@ static ssize_t wwid_show(struct device *dev, struct device_attribute *attr,
 				 subsys->model[model_len - 1] == '\0'))
 		model_len--;
 
-	return sprintf(buf, "nvme.%04x-%*phN-%*phN-%08x\n", subsys->vendor_id,
+	return sysfs_emit(buf, "nvme.%04x-%*phN-%*phN-%08x\n", subsys->vendor_id,
 		serial_len, subsys->serial, model_len, subsys->model,
 		head->ns_id);
 }
@@ -3359,7 +3359,7 @@ static DEVICE_ATTR_RO(wwid);
 static ssize_t nguid_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	return sprintf(buf, "%pU\n", dev_to_ns_head(dev)->ids.nguid);
+	return sysfs_emit(buf, "%pU\n", dev_to_ns_head(dev)->ids.nguid);
 }
 static DEVICE_ATTR_RO(nguid);
 
@@ -3374,23 +3374,23 @@ static ssize_t uuid_show(struct device *dev, struct device_attribute *attr,
 	if (uuid_is_null(&ids->uuid)) {
 		printk_ratelimited(KERN_WARNING
 				   "No UUID available providing old NGUID\n");
-		return sprintf(buf, "%pU\n", ids->nguid);
+		return sysfs_emit(buf, "%pU\n", ids->nguid);
 	}
-	return sprintf(buf, "%pU\n", &ids->uuid);
+	return sysfs_emit(buf, "%pU\n", &ids->uuid);
 }
 static DEVICE_ATTR_RO(uuid);
 
 static ssize_t eui_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	return sprintf(buf, "%8ph\n", dev_to_ns_head(dev)->ids.eui64);
+	return sysfs_emit(buf, "%8ph\n", dev_to_ns_head(dev)->ids.eui64);
 }
 static DEVICE_ATTR_RO(eui);
 
 static ssize_t nsid_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	return sprintf(buf, "%d\n", dev_to_ns_head(dev)->ns_id);
+	return sysfs_emit(buf, "%d\n", dev_to_ns_head(dev)->ns_id);
 }
 static DEVICE_ATTR_RO(nsid);
 
@@ -3455,7 +3455,7 @@ static ssize_t  field##_show(struct device *dev,				\
 			    struct device_attribute *attr, char *buf)		\
 {										\
         struct nvme_ctrl *ctrl = dev_get_drvdata(dev);				\
-        return sprintf(buf, "%.*s\n",						\
+        return sysfs_emit(buf, "%.*s\n",					\
 		(int)sizeof(ctrl->subsys->field), ctrl->subsys->field);		\
 }										\
 static DEVICE_ATTR(field, S_IRUGO, field##_show, NULL);
@@ -3469,7 +3469,7 @@ static ssize_t  field##_show(struct device *dev,				\
 			    struct device_attribute *attr, char *buf)		\
 {										\
         struct nvme_ctrl *ctrl = dev_get_drvdata(dev);				\
-        return sprintf(buf, "%d\n", ctrl->field);	\
+        return sysfs_emit(buf, "%d\n", ctrl->field);				\
 }										\
 static DEVICE_ATTR(field, S_IRUGO, field##_show, NULL);
 
@@ -3517,9 +3517,9 @@ static ssize_t nvme_sysfs_show_state(struct device *dev,
 
 	if ((unsigned)ctrl->state < ARRAY_SIZE(state_name) &&
 	    state_name[ctrl->state])
-		return sprintf(buf, "%s\n", state_name[ctrl->state]);
+		return sysfs_emit(buf, "%s\n", state_name[ctrl->state]);
 
-	return sprintf(buf, "unknown state\n");
+	return sysfs_emit(buf, "unknown state\n");
 }
 
 static DEVICE_ATTR(state, S_IRUGO, nvme_sysfs_show_state, NULL);
@@ -3571,9 +3571,9 @@ static ssize_t nvme_ctrl_loss_tmo_show(struct device *dev,
 	struct nvmf_ctrl_options *opts = ctrl->opts;
 
 	if (ctrl->opts->max_reconnects == -1)
-		return sprintf(buf, "off\n");
-	return sprintf(buf, "%d\n",
-			opts->max_reconnects * opts->reconnect_delay);
+		return sysfs_emit(buf, "off\n");
+	return sysfs_emit(buf, "%d\n",
+			  opts->max_reconnects * opts->reconnect_delay);
 }
 
 static ssize_t nvme_ctrl_loss_tmo_store(struct device *dev,
@@ -3603,8 +3603,8 @@ static ssize_t nvme_ctrl_reconnect_delay_show(struct device *dev,
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
 
 	if (ctrl->opts->reconnect_delay == -1)
-		return sprintf(buf, "off\n");
-	return sprintf(buf, "%d\n", ctrl->opts->reconnect_delay);
+		return sysfs_emit(buf, "off\n");
+	return sysfs_emit(buf, "%d\n", ctrl->opts->reconnect_delay);
 }
 
 static ssize_t nvme_ctrl_reconnect_delay_store(struct device *dev,
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index a9e15c8f907b..379d6818a063 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -624,8 +624,8 @@ static ssize_t nvme_subsys_iopolicy_show(struct device *dev,
 	struct nvme_subsystem *subsys =
 		container_of(dev, struct nvme_subsystem, dev);
 
-	return sprintf(buf, "%s\n",
-			nvme_iopolicy_names[READ_ONCE(subsys->iopolicy)]);
+	return sysfs_emit(buf, "%s\n",
+			  nvme_iopolicy_names[READ_ONCE(subsys->iopolicy)]);
 }
 
 static ssize_t nvme_subsys_iopolicy_store(struct device *dev,
@@ -650,7 +650,7 @@ SUBSYS_ATTR_RW(iopolicy, S_IRUGO | S_IWUSR,
 static ssize_t ana_grpid_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
-	return sprintf(buf, "%d\n", nvme_get_ns_from_dev(dev)->ana_grpid);
+	return sysfs_emit(buf, "%d\n", nvme_get_ns_from_dev(dev)->ana_grpid);
 }
 DEVICE_ATTR_RO(ana_grpid);
 
@@ -659,7 +659,7 @@ static ssize_t ana_state_show(struct device *dev, struct device_attribute *attr,
 {
 	struct nvme_ns *ns = nvme_get_ns_from_dev(dev);
 
-	return sprintf(buf, "%s\n", nvme_ana_state_names[ns->ana_state]);
+	return sysfs_emit(buf, "%s\n", nvme_ana_state_names[ns->ana_state]);
 }
 DEVICE_ATTR_RO(ana_state);
 
-- 
2.35.1



