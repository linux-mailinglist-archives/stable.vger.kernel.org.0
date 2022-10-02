Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B86EB5F26A7
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbiJBW4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbiJBWzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:55:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17253F1F9;
        Sun,  2 Oct 2022 15:52:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9311C60EE8;
        Sun,  2 Oct 2022 22:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45652C433D6;
        Sun,  2 Oct 2022 22:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751118;
        bh=ze8Kwqc6HzjN8J0TweMqtxWJyDX3NdfE7J09Nyh4haE=;
        h=From:To:Cc:Subject:Date:From;
        b=j2X0kdgPIzpRXfXxWPTOqMAGFfmwx/rz82t9kbRgl9q1rPtx9CrYeTau9S/A1AwWW
         R/3tvmm3JZIAVP49sfRBKcune9z7JAeFCYLB/nfgTaBKykPOl/V9HSip0dY9T7dW9e
         9QLY2AaNbUXcaBFEIXaz6yFiJmtX35awSwbt48Sn/Zfy5NcnrYkwwaRQIEC5IwzxzI
         g2RmAwasP0kySuC5iQxbfdBKyyG9c6GSrx4y5FVw9dKFW+JUvGAzahO1lbZx3ERtXk
         sO668CiSjulUDqTajO20+1pS9Pl5k2LRTP/G6TYEurnezImVExztothFV5Oe4fOR3g
         21RruZ3aL7jhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 01/14] firmware: arm_scmi: Add SCMI PM driver remove routine
Date:   Sun,  2 Oct 2022 18:51:42 -0400
Message-Id: <20221002225155.239480-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
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

[ Upstream commit dea796fcab0a219830831c070b8dc367d7e0f708 ]

Currently, when removing the SCMI PM driver not all the resources
registered with genpd subsystem are properly de-registered.

As a side effect of this after a driver unload/load cycle you get a
splat with a few warnings like this:

 | debugfs: Directory 'BIG_CPU0' with parent 'pm_genpd' already present!
 | debugfs: Directory 'BIG_CPU1' with parent 'pm_genpd' already present!
 | debugfs: Directory 'LITTLE_CPU0' with parent 'pm_genpd' already present!
 | debugfs: Directory 'LITTLE_CPU1' with parent 'pm_genpd' already present!
 | debugfs: Directory 'LITTLE_CPU2' with parent 'pm_genpd' already present!
 | debugfs: Directory 'LITTLE_CPU3' with parent 'pm_genpd' already present!
 | debugfs: Directory 'BIG_SSTOP' with parent 'pm_genpd' already present!
 | debugfs: Directory 'LITTLE_SSTOP' with parent 'pm_genpd' already present!
 | debugfs: Directory 'DBGSYS' with parent 'pm_genpd' already present!
 | debugfs: Directory 'GPUTOP' with parent 'pm_genpd' already present!

Add a proper scmi_pm_domain_remove callback to the driver in order to
take care of all the needed cleanups not handled by devres framework.

Link: https://lore.kernel.org/r/20220817172731.1185305-7-cristian.marussi@arm.com
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/scmi_pm_domain.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/firmware/arm_scmi/scmi_pm_domain.c b/drivers/firmware/arm_scmi/scmi_pm_domain.c
index a4e4aa9a3542..af74e521f89f 100644
--- a/drivers/firmware/arm_scmi/scmi_pm_domain.c
+++ b/drivers/firmware/arm_scmi/scmi_pm_domain.c
@@ -106,9 +106,28 @@ static int scmi_pm_domain_probe(struct scmi_device *sdev)
 	scmi_pd_data->domains = domains;
 	scmi_pd_data->num_domains = num_domains;
 
+	dev_set_drvdata(dev, scmi_pd_data);
+
 	return of_genpd_add_provider_onecell(np, scmi_pd_data);
 }
 
+static void scmi_pm_domain_remove(struct scmi_device *sdev)
+{
+	int i;
+	struct genpd_onecell_data *scmi_pd_data;
+	struct device *dev = &sdev->dev;
+	struct device_node *np = dev->of_node;
+
+	of_genpd_del_provider(np);
+
+	scmi_pd_data = dev_get_drvdata(dev);
+	for (i = 0; i < scmi_pd_data->num_domains; i++) {
+		if (!scmi_pd_data->domains[i])
+			continue;
+		pm_genpd_remove(scmi_pd_data->domains[i]);
+	}
+}
+
 static const struct scmi_device_id scmi_id_table[] = {
 	{ SCMI_PROTOCOL_POWER, "genpd" },
 	{ },
@@ -118,6 +137,7 @@ MODULE_DEVICE_TABLE(scmi, scmi_id_table);
 static struct scmi_driver scmi_power_domain_driver = {
 	.name = "scmi-power-domain",
 	.probe = scmi_pm_domain_probe,
+	.remove = scmi_pm_domain_remove,
 	.id_table = scmi_id_table,
 };
 module_scmi_driver(scmi_power_domain_driver);
-- 
2.35.1

