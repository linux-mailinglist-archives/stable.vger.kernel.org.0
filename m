Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751F8657E4E
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiL1Pwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbiL1Pwd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:52:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B2B186D2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:52:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84955B81732
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4657C433D2;
        Wed, 28 Dec 2022 15:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242749;
        bh=KcnYeku5C3BrNcd6nl2rTnAy0lpy2etHaWln6/lEW2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaFY/cJ1YHNu77prGkgHzGoVJD5Q9hazxkkzEYFaRP6g/c0MP6TCdRHXPg79nTKdK
         XlC4sIpwKizgZ7PFAKnNQLGyAu0Z0Bme7PeoPhLJ6EvmqnZbz4E/LzjQMQOCHqNm8o
         6T3yN2IrbUaLHuCzL/2JWp3t2vytbO7Uc8Xnlvns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0409/1146] media: sun8i-a83t-mipi-csi2: Register async subdev with no sensor attached
Date:   Wed, 28 Dec 2022 15:32:28 +0100
Message-Id: <20221228144341.274870749@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 614f6e35a9e214c80270ab942bf58d85066a3e34 ]

This allows the device to probe and register its async subdev without
a sensor attached.

The rationale is that the parent driver might otherwise wait for the
subdev to be registered when it should be available (from the fwnode
graph endpoint perspective). This is generally not problematic when
the MIPI CSI-2 bridge is the only device attached to the parent, but
in the case of a CSI controller that can feed from both MIPI CSI-2
and parallel, it would prevent using the parallel sensor due to the
parent waiting for the MIPI CSI-2 subdev to register.

Fixes: 576d196c522b ("media: sunxi: Add support for the A83T MIPI CSI-2 controller")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c
index 5e1c25db7bc4..d993c09a4820 100644
--- a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c
+++ b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/sun8i_a83t_mipi_csi2.c
@@ -536,6 +536,7 @@ sun8i_a83t_mipi_csi2_bridge_setup(struct sun8i_a83t_mipi_csi2_device *csi2_dev)
 	struct v4l2_async_notifier *notifier = &bridge->notifier;
 	struct media_pad *pads = bridge->pads;
 	struct device *dev = csi2_dev->dev;
+	bool notifier_registered = false;
 	int ret;
 
 	mutex_init(&bridge->lock);
@@ -573,12 +574,17 @@ sun8i_a83t_mipi_csi2_bridge_setup(struct sun8i_a83t_mipi_csi2_device *csi2_dev)
 	notifier->ops = &sun8i_a83t_mipi_csi2_notifier_ops;
 
 	ret = sun8i_a83t_mipi_csi2_bridge_source_setup(csi2_dev);
-	if (ret)
+	if (ret && ret != -ENODEV)
 		goto error_v4l2_notifier_cleanup;
 
-	ret = v4l2_async_subdev_nf_register(subdev, notifier);
-	if (ret < 0)
-		goto error_v4l2_notifier_cleanup;
+	/* Only register the notifier when a sensor is connected. */
+	if (ret != -ENODEV) {
+		ret = v4l2_async_subdev_nf_register(subdev, notifier);
+		if (ret < 0)
+			goto error_v4l2_notifier_cleanup;
+
+		notifier_registered = true;
+	}
 
 	/* V4L2 Subdev */
 
@@ -589,7 +595,8 @@ sun8i_a83t_mipi_csi2_bridge_setup(struct sun8i_a83t_mipi_csi2_device *csi2_dev)
 	return 0;
 
 error_v4l2_notifier_unregister:
-	v4l2_async_nf_unregister(notifier);
+	if (notifier_registered)
+		v4l2_async_nf_unregister(notifier);
 
 error_v4l2_notifier_cleanup:
 	v4l2_async_nf_cleanup(notifier);
-- 
2.35.1



