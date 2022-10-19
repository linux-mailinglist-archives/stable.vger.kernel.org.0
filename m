Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91376603D78
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiJSJCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbiJSJB1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:01:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D0A6B145;
        Wed, 19 Oct 2022 01:55:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C37E61868;
        Wed, 19 Oct 2022 08:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C81AC433D7;
        Wed, 19 Oct 2022 08:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169632;
        bh=XnpClHE9RQmHtFBJmFrb2Cl9NXJDMVz8DiOdTVUb21I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fX0/fdnOFdDPF9F3oQbTmiRPeqRJCtt+A3qYB/sndfUfcAY6Cvh2/NlkuwTJ2jpZ1
         ZGE0ykDR5/OlgggLrefEoKwQemjC5MYVAmy4vlhGPdOensph+OyaZw6NGOZICZjcrv
         KPP0XQksb8k6qMLOBpouOoF8xk+igPYYM63bc0Lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        Dave Stevenson <dave.stevenson@raspberrypi.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 350/862] drm/vc4: drv: Call component_unbind_all()
Date:   Wed, 19 Oct 2022 10:27:17 +0200
Message-Id: <20221019083305.514238398@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit 6cf61bf49c9bdb9ba2d33be812d90dd406326c6c ]

While we were using the component framework to deal with all the DRM
subdevices, we were not calling component_unbind_all().

This leads to none of the subdevices freeing up their resources as part of
their unbind() or device managed hooks.

Fixes: c8b75bca92cb ("drm/vc4: Add KMS support for Raspberry Pi.")
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20220711173939.1132294-13-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.c | 14 ++++++++++++--
 drivers/gpu/drm/vc4/vc4_drv.h |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.c b/drivers/gpu/drm/vc4/vc4_drv.c
index 292d1b6a01b6..6b8dfa1e7650 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.c
+++ b/drivers/gpu/drm/vc4/vc4_drv.c
@@ -267,6 +267,13 @@ static void vc4_match_add_drivers(struct device *dev,
 	}
 }
 
+static void vc4_component_unbind_all(void *ptr)
+{
+	struct vc4_dev *vc4 = ptr;
+
+	component_unbind_all(vc4->dev, &vc4->base);
+}
+
 static const struct of_device_id vc4_dma_range_matches[] = {
 	{ .compatible = "brcm,bcm2711-hvs" },
 	{ .compatible = "brcm,bcm2835-hvs" },
@@ -310,6 +317,7 @@ static int vc4_drm_bind(struct device *dev)
 	if (IS_ERR(vc4))
 		return PTR_ERR(vc4);
 	vc4->is_vc5 = is_vc5;
+	vc4->dev = dev;
 
 	drm = &vc4->base;
 	platform_set_drvdata(pdev, drm);
@@ -360,6 +368,10 @@ static int vc4_drm_bind(struct device *dev)
 	if (ret)
 		return ret;
 
+	ret = devm_add_action_or_reset(dev, vc4_component_unbind_all, vc4);
+	if (ret)
+		return ret;
+
 	ret = vc4_plane_create_additional_planes(drm);
 	if (ret)
 		goto unbind_all;
@@ -380,8 +392,6 @@ static int vc4_drm_bind(struct device *dev)
 	return 0;
 
 unbind_all:
-	component_unbind_all(dev, drm);
-
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/vc4/vc4_drv.h b/drivers/gpu/drm/vc4/vc4_drv.h
index 1beb96b77b8c..950056b83843 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.h
+++ b/drivers/gpu/drm/vc4/vc4_drv.h
@@ -76,6 +76,7 @@ struct vc4_perfmon {
 
 struct vc4_dev {
 	struct drm_device base;
+	struct device *dev;
 
 	bool is_vc5;
 
-- 
2.35.1



