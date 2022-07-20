Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD8657AD14
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241906AbiGTB0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241929AbiGTBZj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:25:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 303F074CE3;
        Tue, 19 Jul 2022 18:18:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E00C2617EB;
        Wed, 20 Jul 2022 01:17:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052CAC341CA;
        Wed, 20 Jul 2022 01:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279879;
        bh=sjgCMzzlr0pgAEg0sZVpHJj8s3ynOX+/T3ir9+DuS+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDAVb+6Alc/YosFC8CnRYpqkZelGLgCjDA6IK9ob914yEVXAM0VP3nezGcyZUKRgt
         rdGdSI18Xm3enwoYuRG3FHUjgBUqbhl6KpFdtHS2mJ3AzRN+KbnUnzL9PFRa9LBuwk
         1NAn2Ijqicg3Wj5Q1N+3bGTLu95G3sqlKGRKEZWHp8YU+r+36IFg0LuRZ+L9fsnaO9
         q1rtg0K5zYyLI1cCt3LCBA26bTIN3kEaaoHkXKocwr9YxbsqHuf0BPcq6Q1mdngaiP
         KMvTcZmOmNhMdAuQEZqQYFg1O74JBzJn5roXe60whk+sw1F7hHM3ZxEpqM0vzUZYmV
         MrzkLQBBl7nOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Owens <daowens01@gmail.com>,
        David Owens <dowens@precisionplanting.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, peter.ujfalusi@gmail.com,
        jarkko.nikula@bitmer.com, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.com, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/16] ASoC: ti: omap-mcbsp: duplicate sysfs error
Date:   Tue, 19 Jul 2022 21:17:24 -0400
Message-Id: <20220720011730.1025099-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011730.1025099-1-sashal@kernel.org>
References: <20220720011730.1025099-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Owens <daowens01@gmail.com>

[ Upstream commit f0d96937d31c4615a6418e4bed5cee50a952040e ]

Convert to managed versions of sysfs and clk allocation to simplify
unbinding and error handling in probe.  Managed sysfs node
creation specifically addresses the following error seen the second time
probe is attempted after sdma_pcm_platform_register() previously requsted
probe deferral:

sysfs: cannot create duplicate filename '/devices/platform/68000000.ocp/49022000.mcbsp/max_tx_thres'

Signed-off-by: David Owens <dowens@precisionplanting.com>
Link: https://lore.kernel.org/r/20220620183744.3176557-1-dowens@precisionplanting.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/omap-mcbsp-priv.h |  2 --
 sound/soc/ti/omap-mcbsp-st.c   | 14 ++------------
 sound/soc/ti/omap-mcbsp.c      | 19 ++-----------------
 3 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/sound/soc/ti/omap-mcbsp-priv.h b/sound/soc/ti/omap-mcbsp-priv.h
index 7865cda4bf0a..da519ea1f303 100644
--- a/sound/soc/ti/omap-mcbsp-priv.h
+++ b/sound/soc/ti/omap-mcbsp-priv.h
@@ -316,8 +316,6 @@ static inline int omap_mcbsp_read(struct omap_mcbsp *mcbsp, u16 reg,
 
 /* Sidetone specific API */
 int omap_mcbsp_st_init(struct platform_device *pdev);
-void omap_mcbsp_st_cleanup(struct platform_device *pdev);
-
 int omap_mcbsp_st_start(struct omap_mcbsp *mcbsp);
 int omap_mcbsp_st_stop(struct omap_mcbsp *mcbsp);
 
diff --git a/sound/soc/ti/omap-mcbsp-st.c b/sound/soc/ti/omap-mcbsp-st.c
index 1a3fe854e856..23dc35192e39 100644
--- a/sound/soc/ti/omap-mcbsp-st.c
+++ b/sound/soc/ti/omap-mcbsp-st.c
@@ -350,7 +350,7 @@ int omap_mcbsp_st_init(struct platform_device *pdev)
 	if (!st_data)
 		return -ENOMEM;
 
-	st_data->mcbsp_iclk = clk_get(mcbsp->dev, "ick");
+	st_data->mcbsp_iclk = devm_clk_get(mcbsp->dev, "ick");
 	if (IS_ERR(st_data->mcbsp_iclk)) {
 		dev_warn(mcbsp->dev,
 			 "Failed to get ick, sidetone might be broken\n");
@@ -362,7 +362,7 @@ int omap_mcbsp_st_init(struct platform_device *pdev)
 	if (!st_data->io_base_st)
 		return -ENOMEM;
 
-	ret = sysfs_create_group(&mcbsp->dev->kobj, &sidetone_attr_group);
+	ret = devm_device_add_group(mcbsp->dev, &sidetone_attr_group);
 	if (ret)
 		return ret;
 
@@ -371,16 +371,6 @@ int omap_mcbsp_st_init(struct platform_device *pdev)
 	return 0;
 }
 
-void omap_mcbsp_st_cleanup(struct platform_device *pdev)
-{
-	struct omap_mcbsp *mcbsp = platform_get_drvdata(pdev);
-
-	if (mcbsp->st_data) {
-		sysfs_remove_group(&mcbsp->dev->kobj, &sidetone_attr_group);
-		clk_put(mcbsp->st_data->mcbsp_iclk);
-	}
-}
-
 static int omap_mcbsp_st_info_volsw(struct snd_kcontrol *kcontrol,
 				    struct snd_ctl_elem_info *uinfo)
 {
diff --git a/sound/soc/ti/omap-mcbsp.c b/sound/soc/ti/omap-mcbsp.c
index 3273b317fa3b..8f9d4a2c1d71 100644
--- a/sound/soc/ti/omap-mcbsp.c
+++ b/sound/soc/ti/omap-mcbsp.c
@@ -706,8 +706,7 @@ static int omap_mcbsp_init(struct platform_device *pdev)
 		mcbsp->max_tx_thres = max_thres(mcbsp) - 0x10;
 		mcbsp->max_rx_thres = max_thres(mcbsp) - 0x10;
 
-		ret = sysfs_create_group(&mcbsp->dev->kobj,
-					 &additional_attr_group);
+		ret = devm_device_add_group(mcbsp->dev, &additional_attr_group);
 		if (ret) {
 			dev_err(mcbsp->dev,
 				"Unable to create additional controls\n");
@@ -715,16 +714,7 @@ static int omap_mcbsp_init(struct platform_device *pdev)
 		}
 	}
 
-	ret = omap_mcbsp_st_init(pdev);
-	if (ret)
-		goto err_st;
-
-	return 0;
-
-err_st:
-	if (mcbsp->pdata->buffer_size)
-		sysfs_remove_group(&mcbsp->dev->kobj, &additional_attr_group);
-	return ret;
+	return omap_mcbsp_st_init(pdev);
 }
 
 /*
@@ -1435,11 +1425,6 @@ static int asoc_mcbsp_remove(struct platform_device *pdev)
 	if (pm_qos_request_active(&mcbsp->pm_qos_req))
 		pm_qos_remove_request(&mcbsp->pm_qos_req);
 
-	if (mcbsp->pdata->buffer_size)
-		sysfs_remove_group(&mcbsp->dev->kobj, &additional_attr_group);
-
-	omap_mcbsp_st_cleanup(pdev);
-
 	return 0;
 }
 
-- 
2.35.1

