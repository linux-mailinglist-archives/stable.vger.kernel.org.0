Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EFA658292
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbiL1QiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbiL1QhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:37:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E039B1A21E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:33:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82240B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E727DC433D2;
        Wed, 28 Dec 2022 16:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245207;
        bh=5Q6EOdHHdb7v57Kcm3OpxqH9JtcDWtT9XCaGiSmVKPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PXrAlnRwk++jSNW5e/eKxq62RL0O5f3r4KzhFBgQLpVDdcNJlGASspVXr89QLpHZC
         R2i00eYoAJ0EV/AQPcumCk6mkQzZqCOciyhHXmi4Hx3QTx020sR/TBdeKGNL0qjyYf
         SLCRFVaCV9rEvlydUEOuYFoHXQZcHKrWr3WRLyVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaochen Shen <xiaochen.shen@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0815/1146] dmaengine: idxd: Make read buffer sysfs attributes invisible for Intel IAA
Date:   Wed, 28 Dec 2022 15:39:14 +0100
Message-Id: <20221228144352.289479356@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Xiaochen Shen <xiaochen.shen@intel.com>

[ Upstream commit 9a8ddb35a9d5d3ad76784a012459b256a9d7de7e ]

In current code, the following sysfs attributes are exposed to user to
show or update the values:
  max_read_buffers (max_tokens)
  read_buffer_limit (token_limit)
  group/read_buffers_allowed (group/tokens_allowed)
  group/read_buffers_reserved (group/tokens_reserved)
  group/use_read_buffer_limit (group/use_token_limit)

>From Intel IAA spec [1], Intel IAA does not support Read Buffer
allocation control. So these sysfs attributes should not be supported on
IAA device.

Fix this issue by making these sysfs attributes invisible through
is_visible() filter when the device is IAA.

Add description in the ABI documentation to mention that these
attributes are not visible when the device does not support Read Buffer
allocation control.

[1]: https://cdrdv2.intel.com/v1/dl/getContent/721858

Fixes: fde212e44f45 ("dmaengine: idxd: deprecate token sysfs attributes for read buffers")
Fixes: c52ca478233c ("dmaengine: idxd: add configuration component of driver")
Signed-off-by: Xiaochen Shen <xiaochen.shen@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20221022074949.11719-1-xiaochen.shen@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/stable/sysfs-driver-dma-idxd          | 10 ++++++
 drivers/dma/idxd/sysfs.c                      | 36 +++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-driver-dma-idxd b/Documentation/ABI/stable/sysfs-driver-dma-idxd
index 69e2d9155e0d..3becc9a82bdf 100644
--- a/Documentation/ABI/stable/sysfs-driver-dma-idxd
+++ b/Documentation/ABI/stable/sysfs-driver-dma-idxd
@@ -50,6 +50,8 @@ Description:    The total number of read buffers supported by this device.
 		The read buffers represent resources within the DSA
 		implementation, and these resources are allocated by engines to
 		support operations. See DSA spec v1.2 9.2.4 Total Read Buffers.
+		It's not visible when the device does not support Read Buffer
+		allocation control.
 
 What:           /sys/bus/dsa/devices/dsa<m>/max_transfer_size
 Date:           Oct 25, 2019
@@ -123,6 +125,8 @@ Contact:        dmaengine@vger.kernel.org
 Description:    The maximum number of read buffers that may be in use at
 		one time by operations that access low bandwidth memory in the
 		device. See DSA spec v1.2 9.2.8 GENCFG on Global Read Buffer Limit.
+		It's not visible when the device does not support Read Buffer
+		allocation control.
 
 What:		/sys/bus/dsa/devices/dsa<m>/cmd_status
 Date:		Aug 28, 2020
@@ -252,6 +256,8 @@ KernelVersion:	5.17.0
 Contact:	dmaengine@vger.kernel.org
 Description:	Enable the use of global read buffer limit for the group. See DSA
 		spec v1.2 9.2.18 GRPCFG Use Global Read Buffer Limit.
+		It's not visible when the device does not support Read Buffer
+		allocation control.
 
 What:		/sys/bus/dsa/devices/group<m>.<n>/read_buffers_allowed
 Date:		Dec 10, 2021
@@ -260,6 +266,8 @@ Contact:	dmaengine@vger.kernel.org
 Description:	Indicates max number of read buffers that may be in use at one time
 		by all engines in the group. See DSA spec v1.2 9.2.18 GRPCFG Read
 		Buffers Allowed.
+		It's not visible when the device does not support Read Buffer
+		allocation control.
 
 What:		/sys/bus/dsa/devices/group<m>.<n>/read_buffers_reserved
 Date:		Dec 10, 2021
@@ -268,6 +276,8 @@ Contact:	dmaengine@vger.kernel.org
 Description:	Indicates the number of Read Buffers reserved for the use of
 		engines in the group. See DSA spec v1.2 9.2.18 GRPCFG Read Buffers
 		Reserved.
+		It's not visible when the device does not support Read Buffer
+		allocation control.
 
 What:		/sys/bus/dsa/devices/group<m>.<n>/desc_progress_limit
 Date:		Sept 14, 2022
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 7909767e9836..3229dfc78650 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -528,6 +528,22 @@ static bool idxd_group_attr_progress_limit_invisible(struct attribute *attr,
 		!idxd->hw.group_cap.progress_limit;
 }
 
+static bool idxd_group_attr_read_buffers_invisible(struct attribute *attr,
+						   struct idxd_device *idxd)
+{
+	/*
+	 * Intel IAA does not support Read Buffer allocation control,
+	 * make these attributes invisible.
+	 */
+	return (attr == &dev_attr_group_use_token_limit.attr ||
+		attr == &dev_attr_group_use_read_buffer_limit.attr ||
+		attr == &dev_attr_group_tokens_allowed.attr ||
+		attr == &dev_attr_group_read_buffers_allowed.attr ||
+		attr == &dev_attr_group_tokens_reserved.attr ||
+		attr == &dev_attr_group_read_buffers_reserved.attr) &&
+		idxd->data->type == IDXD_TYPE_IAX;
+}
+
 static umode_t idxd_group_attr_visible(struct kobject *kobj,
 				       struct attribute *attr, int n)
 {
@@ -538,6 +554,9 @@ static umode_t idxd_group_attr_visible(struct kobject *kobj,
 	if (idxd_group_attr_progress_limit_invisible(attr, idxd))
 		return 0;
 
+	if (idxd_group_attr_read_buffers_invisible(attr, idxd))
+		return 0;
+
 	return attr->mode;
 }
 
@@ -1552,6 +1571,20 @@ static bool idxd_device_attr_max_batch_size_invisible(struct attribute *attr,
 	       idxd->data->type == IDXD_TYPE_IAX;
 }
 
+static bool idxd_device_attr_read_buffers_invisible(struct attribute *attr,
+						    struct idxd_device *idxd)
+{
+	/*
+	 * Intel IAA does not support Read Buffer allocation control,
+	 * make these attributes invisible.
+	 */
+	return (attr == &dev_attr_max_tokens.attr ||
+		attr == &dev_attr_max_read_buffers.attr ||
+		attr == &dev_attr_token_limit.attr ||
+		attr == &dev_attr_read_buffer_limit.attr) &&
+		idxd->data->type == IDXD_TYPE_IAX;
+}
+
 static umode_t idxd_device_attr_visible(struct kobject *kobj,
 					struct attribute *attr, int n)
 {
@@ -1561,6 +1594,9 @@ static umode_t idxd_device_attr_visible(struct kobject *kobj,
 	if (idxd_device_attr_max_batch_size_invisible(attr, idxd))
 		return 0;
 
+	if (idxd_device_attr_read_buffers_invisible(attr, idxd))
+		return 0;
+
 	return attr->mode;
 }
 
-- 
2.35.1



