Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3491D4F2774
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbiDEIGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbiDEH7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3840457B08;
        Tue,  5 Apr 2022 00:54:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C5E3B81BA7;
        Tue,  5 Apr 2022 07:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB2EC340EE;
        Tue,  5 Apr 2022 07:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145250;
        bh=F7Oer8AIMDb2O/FBCHAaJcCBaC52QQNAgWq9QZsk8f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAsxmPMMbQSwhK23XPttUpo2epGUc5ql2FJhG8eoSsUa5P+Mg+bLv8IKA8a+wwSvH
         8k7pP1GN0wMaZ2tuEQJmTqX9yaIOdcniHfFcqQ/a4GjG8Tpl/BkH6Y94hLkf5fQuRb
         X/HRh8fxp5eutSaH/ET+0b+vJA2tcfOp840gN8IA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Zary <linux@zary.sk>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0302/1126] media: bttv: fix WARNING regression on tunerless devices
Date:   Tue,  5 Apr 2022 09:17:29 +0200
Message-Id: <20220405070416.479001166@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Zary <linux@zary.sk>

[ Upstream commit ef058cc8b7193d15a771272359c7454839ae74ee ]

Commit 2161536516ed ("media: media/pci: set device_caps in struct video_device")
introduced a regression: V4L2_CAP_TUNER is always present in device_caps,
even when the device has no tuner.

This causes a warning:
WARNING: CPU: 0 PID: 249 at drivers/media/v4l2-core/v4l2-ioctl.c:1102 v4l_querycap+0xa0/0xb0 [videodev]

Fixes: 2161536516ed ("media: media/pci: set device_caps in struct video_device")
Signed-off-by: Ondrej Zary <linux@zary.sk>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/bt8xx/bttv-driver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 8cc9bec43688..5ca3d0cc653a 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -3890,7 +3890,7 @@ static int bttv_register_video(struct bttv *btv)
 
 	/* video */
 	vdev_init(btv, &btv->video_dev, &bttv_video_template, "video");
-	btv->video_dev.device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
+	btv->video_dev.device_caps = V4L2_CAP_VIDEO_CAPTURE |
 				     V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 	if (btv->tuner_type != TUNER_ABSENT)
 		btv->video_dev.device_caps |= V4L2_CAP_TUNER;
@@ -3911,7 +3911,7 @@ static int bttv_register_video(struct bttv *btv)
 	/* vbi */
 	vdev_init(btv, &btv->vbi_dev, &bttv_video_template, "vbi");
 	btv->vbi_dev.device_caps = V4L2_CAP_VBI_CAPTURE | V4L2_CAP_READWRITE |
-				   V4L2_CAP_STREAMING | V4L2_CAP_TUNER;
+				   V4L2_CAP_STREAMING;
 	if (btv->tuner_type != TUNER_ABSENT)
 		btv->vbi_dev.device_caps |= V4L2_CAP_TUNER;
 
-- 
2.34.1



