Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71E794EC192
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243017AbiC3Lzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344228AbiC3Lwo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A8725E33A;
        Wed, 30 Mar 2022 04:48:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7A1561624;
        Wed, 30 Mar 2022 11:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4944AC340F2;
        Wed, 30 Mar 2022 11:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640919;
        bh=5UMlgXP9Kt7zNY8E5AlJDpLF7i4vLGx8OtzMkKu8RiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PikCB93XPTCCr0re3EL9qHWPejEbZ21oILcVneJnZRm+41O/uwxbLx4KFR6lx/BNj
         jn/1KYFAN3HHm7vgfG+HyzCFL+gj9K8XEmdw5LqURIXMZ3MVpPbowMXs4vjTu3q9yy
         8yrB1J5souGFF1HJQJQ3Ndxv9pPRuPJ5iVpTUIeX10hA72FsQKp0F00SD3CaiDto0O
         c+D2ymR0bBNEHQN9QjbaaH/Hc9TfALpc8IRM5rRcNiwxQwe6bHPOhV1dJS7fztIBWr
         ZjYW817bWu8ZK7cvgY44FL3xIh3Y+xjxuWoTzVuQeu0IE73BpHWjm3gEWM4d6Ikr2w
         rPJ3CebkEFxpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugen Hristev <eugen.hristev@microchip.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 04/59] media: atmel: atmel-isc-base: report frame sizes as full supported range
Date:   Wed, 30 Mar 2022 07:47:36 -0400
Message-Id: <20220330114831.1670235-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 72802a86e11c34e819fbfb38f58c5aef668f833d ]

The ISC supports a full broad range of frame sizes.
Until now, the subdevice was queried for possible frame sizes and these
were reported to the user space.
However, the ISC should not care about which frame sizes the subdev
supports, as long as this frame size is supported.
Thus, report a continuous range from smallest frame size up to the max
resolution.

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c | 22 +++++++++----------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index 660cd0ab6749..24807782c9e5 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -1369,14 +1369,12 @@ static int isc_enum_framesizes(struct file *file, void *fh,
 			       struct v4l2_frmsizeenum *fsize)
 {
 	struct isc_device *isc = video_drvdata(file);
-	struct v4l2_subdev_frame_size_enum fse = {
-		.code = isc->config.sd_format->mbus_code,
-		.index = fsize->index,
-		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
-	};
 	int ret = -EINVAL;
 	int i;
 
+	if (fsize->index)
+		return -EINVAL;
+
 	for (i = 0; i < isc->num_user_formats; i++)
 		if (isc->user_formats[i]->fourcc == fsize->pixel_format)
 			ret = 0;
@@ -1388,14 +1386,14 @@ static int isc_enum_framesizes(struct file *file, void *fh,
 	if (ret)
 		return ret;
 
-	ret = v4l2_subdev_call(isc->current_subdev->sd, pad, enum_frame_size,
-			       NULL, &fse);
-	if (ret)
-		return ret;
+	fsize->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
 
-	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
-	fsize->discrete.width = fse.max_width;
-	fsize->discrete.height = fse.max_height;
+	fsize->stepwise.min_width = 16;
+	fsize->stepwise.max_width = isc->max_width;
+	fsize->stepwise.min_height = 16;
+	fsize->stepwise.max_height = isc->max_height;
+	fsize->stepwise.step_width = 1;
+	fsize->stepwise.step_height = 1;
 
 	return 0;
 }
-- 
2.34.1

