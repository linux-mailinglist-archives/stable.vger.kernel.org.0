Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B965F271C
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiJBXLv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 19:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiJBXLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 19:11:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BCE04BA65;
        Sun,  2 Oct 2022 16:05:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B5ABB80DA4;
        Sun,  2 Oct 2022 22:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E611C433C1;
        Sun,  2 Oct 2022 22:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751159;
        bh=clqMLo8si0W5e46evh3BggiIvOUCFs2EZmoLr7MDpF8=;
        h=From:To:Cc:Subject:Date:From;
        b=CPLekjUJ6pHjz/tJUd1ABmJD4Iclse3bBo65fCxwO/z64zPWAqRrliigAAw0DKVKi
         OHe7/No1Rp54mzYSVf1eafzaP74dL47osCcrclCEBO1l8WktH5DVA60JOdmBY8A6U2
         roYhmChGh5OYxXVwBqJBkoPGLTYK3iITU82UhbzjSPSa5cebyB+oxNlSPEKlXl13T3
         jAYWcUhYNOUmr397b/CDayKvrhVImnw+f6zj4x91At8UMihpo3eRphilG0fIdOF9M8
         ielLzPr7buIAqQupFbpZGtT+heLdAXhnn/+1aXDpkyvgpTI20Z7f71EnmtRtkZgOqO
         eZywsps4Bt6Xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Cristian Marussi <cristian.marussi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 1/9] firmware: arm_scmi: Add SCMI PM driver remove routine
Date:   Sun,  2 Oct 2022 18:52:28 -0400
Message-Id: <20221002225236.239675-1-sashal@kernel.org>
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
index 177874adccf0..b0c8962b9885 100644
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
 	{ SCMI_PROTOCOL_POWER },
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

