Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63113592E73
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 13:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiHOLso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 07:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240452AbiHOLsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 07:48:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF0A24F28
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 04:48:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BA6FB80E23
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 11:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC93C433C1;
        Mon, 15 Aug 2022 11:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660564119;
        bh=gb3hbZkRBkxbhu+fTmGxlyVZkBUpjVPS67iy3RVdwK8=;
        h=Subject:To:Cc:From:Date:From;
        b=gV6tioSJuj7fLHK3MQ63iNLudftq4bbFHKLDpMswGWd+NUiu/qcxGI8UbkcJW7hUE
         6YS1k808JOveAHUnm0ISV0sfy5qfsYw7nxtsr/pVqwSEM8Uc5osumt4IvGxkClJ9uM
         BoyH04DQlgWTwbH+Skm3ZVEnbemwDeBjGWkaaRoU=
Subject: FAILED: patch "[PATCH] firmware: arm_scpi: Ensure scpi_info is not assigned if the" failed to apply to 4.19-stable tree
To:     sudeep.holla@arm.com, huhai@kylinos.cn, liuyun01@kylinos.cn
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Aug 2022 13:48:36 +0200
Message-ID: <166056411623254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 689640efc0a2c4e07e6f88affe6d42cd40cc3f85 Mon Sep 17 00:00:00 2001
From: Sudeep Holla <sudeep.holla@arm.com>
Date: Fri, 1 Jul 2022 17:03:10 +0100
Subject: [PATCH] firmware: arm_scpi: Ensure scpi_info is not assigned if the
 probe fails

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

diff --git a/drivers/firmware/arm_scpi.c b/drivers/firmware/arm_scpi.c
index ddf0b9ff9e15..435d0e2658a4 100644
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
@@ -913,13 +913,14 @@ static int scpi_probe(struct platform_device *pdev)
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
@@ -927,19 +928,19 @@ static int scpi_probe(struct platform_device *pdev)
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
 
@@ -986,45 +987,53 @@ static int scpi_probe(struct platform_device *pdev)
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

