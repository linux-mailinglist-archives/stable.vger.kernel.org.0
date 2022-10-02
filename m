Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF015F2675
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 00:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJBWxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiJBWxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:53:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6749C3DBDB;
        Sun,  2 Oct 2022 15:51:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A072D60EF1;
        Sun,  2 Oct 2022 22:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C78EC43470;
        Sun,  2 Oct 2022 22:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751066;
        bh=jNa3pV2947ZPoyhRr1Jkx2YtuVxadqOVOz3cexijJZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4n5Jgx1PdybMevQfp+8f1ZcB3TyxM9Q866+HVByoIugIqByVxHoQm0YaAmwTMfSQ
         kPQRsTKqBoPxMkJYF15DmTIn+qVISajq3HyFJtnSL5DvJ0HB284OmGzdHAe8t2Qchw
         2Y4I/dbVYFFBHIqnGRs8g2TTMqgznPDkMBXrFXS6xA/tj3/k5Zfc4Mv2RkexQEWBUI
         Q+Bls2NLXNfKxd9JxFrSsmCz23I7j0f0zYcbJDDiPzZNAh5Tvzam+j64RhID4QlERp
         /0XGPirBeHAaRPlc33Ifm2LUFEOL2MnKPsIxyKfCgPN9RhCYNwojjHfxUnzwZQ2f/7
         SBtNZcrvHUZbw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 04/20] firmware: arm_scmi: Add SCMI PM driver remove routine
Date:   Sun,  2 Oct 2022 18:50:43 -0400
Message-Id: <20221002225100.239217-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225100.239217-1-sashal@kernel.org>
References: <20221002225100.239217-1-sashal@kernel.org>
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
index 581d34c95769..4e27c3d66a83 100644
--- a/drivers/firmware/arm_scmi/scmi_pm_domain.c
+++ b/drivers/firmware/arm_scmi/scmi_pm_domain.c
@@ -138,9 +138,28 @@ static int scmi_pm_domain_probe(struct scmi_device *sdev)
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
@@ -150,6 +169,7 @@ MODULE_DEVICE_TABLE(scmi, scmi_id_table);
 static struct scmi_driver scmi_power_domain_driver = {
 	.name = "scmi-power-domain",
 	.probe = scmi_pm_domain_probe,
+	.remove = scmi_pm_domain_remove,
 	.id_table = scmi_id_table,
 };
 module_scmi_driver(scmi_power_domain_driver);
-- 
2.35.1

