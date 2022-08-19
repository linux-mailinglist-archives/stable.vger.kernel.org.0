Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F74859A49D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353551AbiHSQmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353793AbiHSQkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:40:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F9A12502E;
        Fri, 19 Aug 2022 09:09:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99212B8281C;
        Fri, 19 Aug 2022 16:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A584FC433C1;
        Fri, 19 Aug 2022 16:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925359;
        bh=ocZVZLMCrhl4jjlPjRd9yvQ4dTkVv5C12WDslHgyOBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cCjNoIwuv03atmyJLEKAg+4ubsMNFdLOoLfcjRXhUxL4jULqkyPtRLXB8E1pXG4XL
         n1b0/Pkn1zPi3HqcNIOKYRLdvkXybbo1tdOUe2k+cjqcVmPqQBqgU/7fk9cQw780WP
         60CjlZpacero+WO8QDMkn3K6OmPK4qKXXuy9r9aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, huhai <huhai@kylinos.cn>,
        Jackie Liu <liuyun01@kylinos.cn>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 466/545] firmware: arm_scpi: Ensure scpi_info is not assigned if the probe fails
Date:   Fri, 19 Aug 2022 17:43:56 +0200
Message-Id: <20220819153850.251825254@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 689640efc0a2c4e07e6f88affe6d42cd40cc3f85 ]

When scpi probe fails, at any point, we need to ensure that the scpi_info
is not set and will remain NULL until the probe succeeds. If it is not
taken care, then it could result use-after-free as the value is exported
via get_scpi_ops() and could refer to a memory allocated via devm_kzalloc()
but freed when the probe fails.

Link: https://lore.kernel.org/r/20220701160310.148344-1-sudeep.holla@arm.com
Cc: stable@vger.kernel.org # 4.19+
Reported-by: huhai <huhai@kylinos.cn>
Reviewed-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scpi.c | 61 +++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index 4ceba5ef7895..36391cb5130e 100644
--- a/drivers/firmware/arm_scpi.c
+++ b/drivers/firmware/arm_scpi.c
@@ -815,7 +815,7 @@ static int scpi_init_versions(struct scpi_drvinfo *info)
 		info->firmware_version = le32_to_cpu(caps.platform_version);
 	}
 	/* Ignore error if not implemented */
-	if (scpi_info->is_legacy && ret == -EOPNOTSUPP)
+	if (info->is_legacy && ret == -EOPNOTSUPP)
 		return 0;
 
 	return ret;
@@ -905,13 +905,14 @@ static int scpi_probe(struct platform_device *pdev)
 	struct resource res;
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
+	struct scpi_drvinfo *scpi_drvinfo;
 
-	scpi_info = devm_kzalloc(dev, sizeof(*scpi_info), GFP_KERNEL);
-	if (!scpi_info)
+	scpi_drvinfo = devm_kzalloc(dev, sizeof(*scpi_drvinfo), GFP_KERNEL);
+	if (!scpi_drvinfo)
 		return -ENOMEM;
 
 	if (of_match_device(legacy_scpi_of_match, &pdev->dev))
-		scpi_info->is_legacy = true;
+		scpi_drvinfo->is_legacy = true;
 
 	count = of_count_phandle_with_args(np, "mboxes", "#mbox-cells");
 	if (count < 0) {
@@ -919,19 +920,19 @@ static int scpi_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	scpi_info->channels = devm_kcalloc(dev, count, sizeof(struct scpi_chan),
-					   GFP_KERNEL);
-	if (!scpi_info->channels)
+	scpi_drvinfo->channels =
+		devm_kcalloc(dev, count, sizeof(struct scpi_chan), GFP_KERNEL);
+	if (!scpi_drvinfo->channels)
 		return -ENOMEM;
 
-	ret = devm_add_action(dev, scpi_free_channels, scpi_info);
+	ret = devm_add_action(dev, scpi_free_channels, scpi_drvinfo);
 	if (ret)
 		return ret;
 
-	for (; scpi_info->num_chans < count; scpi_info->num_chans++) {
+	for (; scpi_drvinfo->num_chans < count; scpi_drvinfo->num_chans++) {
 		resource_size_t size;
-		int idx = scpi_info->num_chans;
-		struct scpi_chan *pchan = scpi_info->channels + idx;
+		int idx = scpi_drvinfo->num_chans;
+		struct scpi_chan *pchan = scpi_drvinfo->channels + idx;
 		struct mbox_client *cl = &pchan->cl;
 		struct device_node *shmem = of_parse_phandle(np, "shmem", idx);
 
@@ -975,45 +976,53 @@ static int scpi_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	scpi_info->commands = scpi_std_commands;
+	scpi_drvinfo->commands = scpi_std_commands;
 
-	platform_set_drvdata(pdev, scpi_info);
+	platform_set_drvdata(pdev, scpi_drvinfo);
 
-	if (scpi_info->is_legacy) {
+	if (scpi_drvinfo->is_legacy) {
 		/* Replace with legacy variants */
 		scpi_ops.clk_set_val = legacy_scpi_clk_set_val;
-		scpi_info->commands = scpi_legacy_commands;
+		scpi_drvinfo->commands = scpi_legacy_commands;
 
 		/* Fill priority bitmap */
 		for (idx = 0; idx < ARRAY_SIZE(legacy_hpriority_cmds); idx++)
 			set_bit(legacy_hpriority_cmds[idx],
-				scpi_info->cmd_priority);
+				scpi_drvinfo->cmd_priority);
 	}
 
-	ret = scpi_init_versions(scpi_info);
+	scpi_info = scpi_drvinfo;
+
+	ret = scpi_init_versions(scpi_drvinfo);
 	if (ret) {
 		dev_err(dev, "incorrect or no SCP firmware found\n");
+		scpi_info = NULL;
 		return ret;
 	}
 
-	if (scpi_info->is_legacy && !scpi_info->protocol_version &&
-	    !scpi_info->firmware_version)
+	if (scpi_drvinfo->is_legacy && !scpi_drvinfo->protocol_version &&
+	    !scpi_drvinfo->firmware_version)
 		dev_info(dev, "SCP Protocol legacy pre-1.0 firmware\n");
 	else
 		dev_info(dev, "SCP Protocol %lu.%lu Firmware %lu.%lu.%lu version\n",
 			 FIELD_GET(PROTO_REV_MAJOR_MASK,
-				   scpi_info->protocol_version),
+				   scpi_drvinfo->protocol_version),
 			 FIELD_GET(PROTO_REV_MINOR_MASK,
-				   scpi_info->protocol_version),
+				   scpi_drvinfo->protocol_version),
 			 FIELD_GET(FW_REV_MAJOR_MASK,
-				   scpi_info->firmware_version),
+				   scpi_drvinfo->firmware_version),
 			 FIELD_GET(FW_REV_MINOR_MASK,
-				   scpi_info->firmware_version),
+				   scpi_drvinfo->firmware_version),
 			 FIELD_GET(FW_REV_PATCH_MASK,
-				   scpi_info->firmware_version));
-	scpi_info->scpi_ops = &scpi_ops;
+				   scpi_drvinfo->firmware_version));
+
+	scpi_drvinfo->scpi_ops = &scpi_ops;
 
-	return devm_of_platform_populate(dev);
+	ret = devm_of_platform_populate(dev);
+	if (ret)
+		scpi_info = NULL;
+
+	return ret;
 }
 
 static const struct of_device_id scpi_of_match[] = {
-- 
2.35.1



