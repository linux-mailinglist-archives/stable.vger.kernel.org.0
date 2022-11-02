Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813F961581B
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiKBCp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiKBCpZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:45:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221AD20F66
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEDA9617C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C64C433C1;
        Wed,  2 Nov 2022 02:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357123;
        bh=4znVXB0Vv4LoaSzoysZvQhj5hcuIjRvw/7gwuHGE6iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pD3nmO3ASLkc9eyALbKWzrXWHMWKNknNY2+TNK2ja7jwLChXOLRUqYFiaUMkEOzZt
         /r7hGqWLY3fL1DC9B+lRE+6S38kmpXryqn5N8lTFe1iePs/zSH+1jy2GtVKQdTFasy
         iYk6+jY9Qg0R8oM2CV8bIVpQsygXvNLX7NmuXgk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 116/240] media: sunxi: Fix some error handling path of sun8i_a83t_mipi_csi2_probe()
Date:   Wed,  2 Nov 2022 03:31:31 +0100
Message-Id: <20221102022114.010573176@linuxfoundation.org>
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

[ Upstream commit 466c1e6d05003707e8baa16668e7bc287d875d5e ]

Release some resources in the error handling path of the probe and of
sun8i_a83t_mipi_csi2_resources_setup(), as already done in the remove
function.

Fixes: 576d196c522b ("media: sunxi: Add support for the A83T MIPI CSI-2 controller")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../sun8i_a83t_mipi_csi2.c                    | 23 +++++++++++++++----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c
index d052ee77ef0a..b032ec13a683 100644
--- a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c
+++ b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c
@@ -719,13 +719,15 @@ sun8i_a83t_mipi_csi2_resources_setup(struct sun8i_a83t_mipi_csi2_device *csi2_de
 	csi2_dev->clock_mipi = devm_clk_get(dev, "mipi");
 	if (IS_ERR(csi2_dev->clock_mipi)) {
 		dev_err(dev, "failed to acquire mipi clock\n");
-		return PTR_ERR(csi2_dev->clock_mipi);
+		ret = PTR_ERR(csi2_dev->clock_mipi);
+		goto error_clock_rate_exclusive;
 	}
 
 	csi2_dev->clock_misc = devm_clk_get(dev, "misc");
 	if (IS_ERR(csi2_dev->clock_misc)) {
 		dev_err(dev, "failed to acquire misc clock\n");
-		return PTR_ERR(csi2_dev->clock_misc);
+		ret = PTR_ERR(csi2_dev->clock_misc);
+		goto error_clock_rate_exclusive;
 	}
 
 	/* Reset */
@@ -733,7 +735,8 @@ sun8i_a83t_mipi_csi2_resources_setup(struct sun8i_a83t_mipi_csi2_device *csi2_de
 	csi2_dev->reset = devm_reset_control_get_shared(dev, NULL);
 	if (IS_ERR(csi2_dev->reset)) {
 		dev_err(dev, "failed to get reset controller\n");
-		return PTR_ERR(csi2_dev->reset);
+		ret = PTR_ERR(csi2_dev->reset);
+		goto error_clock_rate_exclusive;
 	}
 
 	/* D-PHY */
@@ -741,7 +744,7 @@ sun8i_a83t_mipi_csi2_resources_setup(struct sun8i_a83t_mipi_csi2_device *csi2_de
 	ret = sun8i_a83t_dphy_register(csi2_dev);
 	if (ret) {
 		dev_err(dev, "failed to initialize MIPI D-PHY\n");
-		return ret;
+		goto error_clock_rate_exclusive;
 	}
 
 	/* Runtime PM */
@@ -749,6 +752,11 @@ sun8i_a83t_mipi_csi2_resources_setup(struct sun8i_a83t_mipi_csi2_device *csi2_de
 	pm_runtime_enable(dev);
 
 	return 0;
+
+error_clock_rate_exclusive:
+	clk_rate_exclusive_put(csi2_dev->clock_mod);
+
+	return ret;
 }
 
 static void
@@ -778,9 +786,14 @@ static int sun8i_a83t_mipi_csi2_probe(struct platform_device *platform_dev)
 
 	ret = sun8i_a83t_mipi_csi2_bridge_setup(csi2_dev);
 	if (ret)
-		return ret;
+		goto error_resources;
 
 	return 0;
+
+error_resources:
+	sun8i_a83t_mipi_csi2_resources_cleanup(csi2_dev);
+
+	return ret;
 }
 
 static int sun8i_a83t_mipi_csi2_remove(struct platform_device *platform_dev)
-- 
2.35.1



