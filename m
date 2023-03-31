Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74B06D1E53
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 12:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjCaKuO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 06:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbjCaKuN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 06:50:13 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B5A6C1CBAB
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 03:50:12 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9A5C42F4;
        Fri, 31 Mar 2023 03:50:56 -0700 (PDT)
Received: from e120937-lin.. (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BF763F6C4;
        Fri, 31 Mar 2023 03:50:11 -0700 (PDT)
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 4.19] firmware: arm_scmi: Fix device node validation for mailbox transport
Date:   Fri, 31 Mar 2023 11:49:55 +0100
Message-Id: <20230331104955.3800788-1-cristian.marussi@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2ab4f4018cb6b8010ca5002c3bdc37783b5d28c2 upstream.

When mailboxes are used as a transport it is possible to setup the SCMI
transport layer, depending on the underlying channels configuration, to use
one or two mailboxes, associated, respectively, to one or two, distinct,
shared memory areas: any other combination should be treated as invalid.

Add more strict checking of SCMI mailbox transport device node descriptors.

Fixes: fbc4d81ad285 ("firmware: arm_scmi: refactor in preparation to support per-protocol channels")
Cc: <stable@vger.kernel.org> # 4.19
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20230307162324.891866-1-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
[Cristian: backported to v4.19]
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
---
Backporting was trivial but required since the patched function
was moved around in a different file.
---
 drivers/firmware/arm_scmi/driver.c | 37 ++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index e8cd66705ad7..5ccbbb3eb68e 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -705,6 +705,39 @@ static int scmi_remove(struct platform_device *pdev)
 	return ret;
 }
 
+static int scmi_mailbox_chan_validate(struct device *cdev)
+{
+	int num_mb, num_sh, ret = 0;
+	struct device_node *np = cdev->of_node;
+
+	num_mb = of_count_phandle_with_args(np, "mboxes", "#mbox-cells");
+	num_sh = of_count_phandle_with_args(np, "shmem", NULL);
+	/* Bail out if mboxes and shmem descriptors are inconsistent */
+	if (num_mb <= 0 || num_sh > 2 || num_mb != num_sh) {
+		dev_warn(cdev, "Invalid channel descriptor for '%s'\n",
+			 of_node_full_name(np));
+		return -EINVAL;
+	}
+
+	if (num_sh > 1) {
+		struct device_node *np_tx, *np_rx;
+
+		np_tx = of_parse_phandle(np, "shmem", 0);
+		np_rx = of_parse_phandle(np, "shmem", 1);
+		/* SCMI Tx and Rx shared mem areas have to be distinct */
+		if (!np_tx || !np_rx || np_tx == np_rx) {
+			dev_warn(cdev, "Invalid shmem descriptor for '%s'\n",
+				 of_node_full_name(np));
+			ret = -EINVAL;
+		}
+
+		of_node_put(np_tx);
+		of_node_put(np_rx);
+	}
+
+	return ret;
+}
+
 static inline int
 scmi_mbox_chan_setup(struct scmi_info *info, struct device *dev, int prot_id)
 {
@@ -720,6 +753,10 @@ scmi_mbox_chan_setup(struct scmi_info *info, struct device *dev, int prot_id)
 		goto idr_alloc;
 	}
 
+	ret = scmi_mailbox_chan_validate(dev);
+	if (ret)
+		return ret;
+
 	cinfo = devm_kzalloc(info->dev, sizeof(*cinfo), GFP_KERNEL);
 	if (!cinfo)
 		return -ENOMEM;
-- 
2.34.1

