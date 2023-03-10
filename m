Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624446B42C7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231687AbjCJOG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjCJOGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:06:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B0511785E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:06:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 52A34CE28F8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FBBC433D2;
        Fri, 10 Mar 2023 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457169;
        bh=6XUcGncTS9Qe8AaaVqGKkGa2F2qNA+Hb9sTapvYbQzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PUi32oEjXZJ7fDVAOMwyQxCa22451CrD/p9VhXBSF+i/2yoDu6GF6ro+YaY09UxRW
         5v9b8QbG0dOMWT6PKk8kErIYdpdemA30r7G/xwDeR6aDgHqJVTfxwHKDjI9eb0QmvZ
         YeY2eXvCGfu8/V8wBwRz74O+fNkA81hf47FqXwPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthias Kaehlcke <mka@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/200] soc: qcom: stats: Populate all subsystem debugfs files
Date:   Fri, 10 Mar 2023 14:37:31 +0100
Message-Id: <20230310133718.449359992@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit acdbf5f9b2c492505145f6e50c65418521a547c4 ]

This driver relies on SMEM to populate items for each subsystem before
the device probes. The items in SMEM that are being looked for are
populated by the subsystems lazily, and therefore may not exist until
the device has booted. For example, if I build this driver into the
kernel on Trogdor Lazor and boot up, I don't see a 'modem' debugfs file
populated, because the modem boots and populates the SMEM item after
this driver probes.

Always populate the files for the subsystems if they're in SMEM, and
make the qcom_subsystem_sleep_stats_show() function return 0 if the SMEM
items still isn't there. This way we can run a simple command like

	grep ^ /sys/kernel/debug/qcom_stats/*

and collect the subsystem sleep stats without interspersed errors or
missing details entirely because this driver probed first.

Fixes: 1d7724690344 ("soc: qcom: Add Sleep stats driver")
Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230119032329.2909383-1-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qcom_stats.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/qcom/qcom_stats.c b/drivers/soc/qcom/qcom_stats.c
index 121ea409fafcd..b252bedf0cf10 100644
--- a/drivers/soc/qcom/qcom_stats.c
+++ b/drivers/soc/qcom/qcom_stats.c
@@ -92,7 +92,7 @@ static int qcom_subsystem_sleep_stats_show(struct seq_file *s, void *unused)
 	/* Items are allocated lazily, so lookup pointer each time */
 	stat = qcom_smem_get(subsystem->pid, subsystem->smem_item, NULL);
 	if (IS_ERR(stat))
-		return -EIO;
+		return 0;
 
 	qcom_print_stats(s, stat);
 
@@ -170,20 +170,14 @@ static void qcom_create_soc_sleep_stat_files(struct dentry *root, void __iomem *
 static void qcom_create_subsystem_stat_files(struct dentry *root,
 					     const struct stats_config *config)
 {
-	const struct sleep_stats *stat;
 	int i;
 
 	if (!config->subsystem_stats_in_smem)
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(subsystems); i++) {
-		stat = qcom_smem_get(subsystems[i].pid, subsystems[i].smem_item, NULL);
-		if (IS_ERR(stat))
-			continue;
-
+	for (i = 0; i < ARRAY_SIZE(subsystems); i++)
 		debugfs_create_file(subsystems[i].name, 0400, root, (void *)&subsystems[i],
 				    &qcom_subsystem_sleep_stats_fops);
-	}
 }
 
 static int qcom_stats_probe(struct platform_device *pdev)
-- 
2.39.2



