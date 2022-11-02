Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1296261581C
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiKBCpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiKBCpa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:45:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3081220F60
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3D78601C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA08C433D6;
        Wed,  2 Nov 2022 02:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357129;
        bh=N0maZI+dlNd0MKUr3JXI89eW/ayQTLXKm5YHHXG6Uxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSQEmRZ2prQtSlyMim7M9Wy0sgiyNVdhmm37ZipB3es6omGr3jRZhr9B+4AWJH4lY
         zzLf59+48w8dOIXVy83RsyGm5/yxo10gHkq02upzh5o4AvUq9dBgdFvXkANfccuTCs
         kQeXLXh+JJZ1OjuSErWeUXDl2qyFFWe2x7cZGuQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 117/240] media: sunxi: Fix some error handling path of sun6i_mipi_csi2_probe()
Date:   Wed,  2 Nov 2022 03:31:32 +0100
Message-Id: <20221102022114.032962527@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 51e1440d309a74a3e4e252019a00f9d0df329945 ]

Release some resources in the error handling path of the probe and of
sun6i_mipi_csi2_resources_setup(), as already done in the remove
function.

Fixes: af54b4f4c17f ("media: sunxi: Add support for the A31 MIPI CSI-2 controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c   | 20 +++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c b/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
index a4e3f9a6b2ff..30d6c0c5161f 100644
--- a/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
+++ b/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
@@ -661,7 +661,8 @@ sun6i_mipi_csi2_resources_setup(struct sun6i_mipi_csi2_device *csi2_dev,
 	csi2_dev->reset = devm_reset_control_get_shared(dev, NULL);
 	if (IS_ERR(csi2_dev->reset)) {
 		dev_err(dev, "failed to get reset controller\n");
-		return PTR_ERR(csi2_dev->reset);
+		ret = PTR_ERR(csi2_dev->reset);
+		goto error_clock_rate_exclusive;
 	}
 
 	/* D-PHY */
@@ -669,13 +670,14 @@ sun6i_mipi_csi2_resources_setup(struct sun6i_mipi_csi2_device *csi2_dev,
 	csi2_dev->dphy = devm_phy_get(dev, "dphy");
 	if (IS_ERR(csi2_dev->dphy)) {
 		dev_err(dev, "failed to get MIPI D-PHY\n");
-		return PTR_ERR(csi2_dev->dphy);
+		ret = PTR_ERR(csi2_dev->dphy);
+		goto error_clock_rate_exclusive;
 	}
 
 	ret = phy_init(csi2_dev->dphy);
 	if (ret) {
 		dev_err(dev, "failed to initialize MIPI D-PHY\n");
-		return ret;
+		goto error_clock_rate_exclusive;
 	}
 
 	/* Runtime PM */
@@ -683,6 +685,11 @@ sun6i_mipi_csi2_resources_setup(struct sun6i_mipi_csi2_device *csi2_dev,
 	pm_runtime_enable(dev);
 
 	return 0;
+
+error_clock_rate_exclusive:
+	clk_rate_exclusive_put(csi2_dev->clock_mod);
+
+	return ret;
 }
 
 static void
@@ -712,9 +719,14 @@ static int sun6i_mipi_csi2_probe(struct platform_device *platform_dev)
 
 	ret = sun6i_mipi_csi2_bridge_setup(csi2_dev);
 	if (ret)
-		return ret;
+		goto error_resources;
 
 	return 0;
+
+error_resources:
+	sun6i_mipi_csi2_resources_cleanup(csi2_dev);
+
+	return ret;
 }
 
 static int sun6i_mipi_csi2_remove(struct platform_device *platform_dev)
-- 
2.35.1



