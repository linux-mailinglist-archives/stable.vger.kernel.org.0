Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC51541419
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359409AbiFGUM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359219AbiFGUJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:09:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DA78FD7D;
        Tue,  7 Jun 2022 11:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD005B81FF8;
        Tue,  7 Jun 2022 18:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B78C385A5;
        Tue,  7 Jun 2022 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626437;
        bh=l+0I0SbIqtb+A2f2/RYmBLgaBp3aFf+0oUxXgNg1N6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fELWQ9OJ+KvnCLgA8z0AXDFvVCRifF4edTUPayvYILihzmuUHXZsJiTM/IxMa9yuj
         2Qxu+monuv9qGzPXLnlQY4Y9NWZMKhy2mLyaaevllZ1tvCeNE9brMPKggYk7WASeNC
         b1EWvNz+V4TmnQnmt2yZScYtQ85AUN9ovJfkOWbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 377/772] media: i2c: rdacm2x: properly set subdev entity function
Date:   Tue,  7 Jun 2022 18:59:29 +0200
Message-Id: <20220607165000.125041592@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>

[ Upstream commit d2facee67b4883bb3e7461a0a93fd70d0c7b7261 ]

The subdevice entity function was left unset, which produces a warning
when probing the device:

mxc-md bus@58000000:camera: Entity type for entity rdacm20 19-0051 was
not initialized!

This patch will set entity function to MEDIA_ENT_F_CAM_SENSOR and leave
flags unset.

Fixes: 34009bffc1c6 ("media: i2c: Add RDACM20 driver")
Fixes: a59f853b3b4b ("media: i2c: Add driver for RDACM21 camera module")
Signed-off-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/rdacm20.c | 2 +-
 drivers/media/i2c/rdacm21.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/rdacm20.c b/drivers/media/i2c/rdacm20.c
index 025a610de893..9c6f66cab564 100644
--- a/drivers/media/i2c/rdacm20.c
+++ b/drivers/media/i2c/rdacm20.c
@@ -611,7 +611,7 @@ static int rdacm20_probe(struct i2c_client *client)
 		goto error_free_ctrls;
 
 	dev->pad.flags = MEDIA_PAD_FL_SOURCE;
-	dev->sd.entity.flags |= MEDIA_ENT_F_CAM_SENSOR;
+	dev->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	ret = media_entity_pads_init(&dev->sd.entity, 1, &dev->pad);
 	if (ret < 0)
 		goto error_free_ctrls;
diff --git a/drivers/media/i2c/rdacm21.c b/drivers/media/i2c/rdacm21.c
index 12ec5467ed1e..ef31cf5f23ca 100644
--- a/drivers/media/i2c/rdacm21.c
+++ b/drivers/media/i2c/rdacm21.c
@@ -583,7 +583,7 @@ static int rdacm21_probe(struct i2c_client *client)
 		goto error_free_ctrls;
 
 	dev->pad.flags = MEDIA_PAD_FL_SOURCE;
-	dev->sd.entity.flags |= MEDIA_ENT_F_CAM_SENSOR;
+	dev->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
 	ret = media_entity_pads_init(&dev->sd.entity, 1, &dev->pad);
 	if (ret < 0)
 		goto error_free_ctrls;
-- 
2.35.1



