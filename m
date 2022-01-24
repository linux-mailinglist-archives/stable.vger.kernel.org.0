Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA0B49991F
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1454197AbiAXVb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1451799AbiAXVXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:23:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46451C09B060;
        Mon, 24 Jan 2022 12:17:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA3CF61497;
        Mon, 24 Jan 2022 20:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB5BC340E8;
        Mon, 24 Jan 2022 20:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055463;
        bh=ckyorOORVsIp70Q+mkMHGOBzftHyZMq+cQA994k0QLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ig7ub3xRW0Gel/f17JUAIQB80Phg5755om/lEaAyQM9vcfeByQGB8Ueg4/Pnhu3JM
         IaP7GPJOeJ49dvvo0Swhmzv37J7/V6Ug57BMr+IPE5rsw7jKCUjYL+0aE+LALZqiAJ
         8AmxnKdNsVG/zFcTH5/WA2Tsg1MepNlh+AiVXsVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 160/846] media: i2c: imx274: fix s_frame_interval runtime resume not requested
Date:   Mon, 24 Jan 2022 19:34:37 +0100
Message-Id: <20220124184106.503558732@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit da653498c20ba5b185214d8ae43b4e8e9594f520 ]

pm_runtime_resume_and_get should be called when the s_frame_interval
is called.

The driver will try to access device registers to configure VMAX, coarse
time and exposure.

Currently if the runtime is not resumed, this fails:
 # media-ctl -d /dev/media0 --set-v4l2 '"IMX274 1-001a":0[fmt:SRGGB10_1X10/3840x2
160@1/10]'

IMX274 1-001a: imx274_binning_goodness: ask 3840x2160, size 3840x2160, goodness 0
IMX274 1-001a: imx274_binning_goodness: ask 3840x2160, size 1920x1080, goodness -3000
IMX274 1-001a: imx274_binning_goodness: ask 3840x2160, size 1280x720, goodness -4000
IMX274 1-001a: imx274_binning_goodness: ask 3840x2160, size 1280x540, goodness -4180
IMX274 1-001a: __imx274_change_compose: selected 1x1 binning
IMX274 1-001a: imx274_set_frame_interval: input frame interval = 1 / 10
IMX274 1-001a: imx274_read_mbreg : addr 0x300e, val=0x1 (2 bytes)
IMX274 1-001a: imx274_set_frame_interval : register SVR = 1
IMX274 1-001a: imx274_read_mbreg : addr 0x30f6, val=0x6a8 (2 bytes)
IMX274 1-001a: imx274_set_frame_interval : register HMAX = 1704
IMX274 1-001a: imx274_set_frame_length : input length = 2112
IMX274 1-001a: imx274_write_mbreg : i2c bulk write failed, 30f8 = 884 (3 bytes)
IMX274 1-001a: imx274_set_frame_length error = -121
IMX274 1-001a: imx274_set_frame_interval error = -121
Unable to setup formats: Remote I/O error (121)

The device is not resumed thus the remote I/O error.

Setting the frame interval works at streaming time, because
pm_runtime_resume_and_get is called at s_stream time before sensor setup.
The failure happens when only the s_frame_interval is called separately
independently on streaming time.

Fixes: ad97bc37426c ("media: i2c: imx274: Add IMX274 power on and off sequence")
Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx274.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index 0dce92872176d..4d9b64c61f603 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -1367,6 +1367,10 @@ static int imx274_s_frame_interval(struct v4l2_subdev *sd,
 	int min, max, def;
 	int ret;
 
+	ret = pm_runtime_resume_and_get(&imx274->client->dev);
+	if (ret < 0)
+		return ret;
+
 	mutex_lock(&imx274->lock);
 	ret = imx274_set_frame_interval(imx274, fi->interval);
 
@@ -1398,6 +1402,7 @@ static int imx274_s_frame_interval(struct v4l2_subdev *sd,
 
 unlock:
 	mutex_unlock(&imx274->lock);
+	pm_runtime_put(&imx274->client->dev);
 
 	return ret;
 }
-- 
2.34.1



