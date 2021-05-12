Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129FE37CCDA
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237120AbhELQsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243667AbhELQly (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55AA26194D;
        Wed, 12 May 2021 16:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835547;
        bh=uoffoVtnZ+OsSYxdFTUiuo1TnBfjBWE6BOUDpLNoBPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3UcytDbYqc6BY4EjlkLbYBC7FV9OGV7MbkKz3dElYzjKMsmVZwGFcz/aZy07rDbG
         OiVl4RtIzNRsROHvYc4Be9Ce26eDf0RaDxIlHRIofrBIaa6sIZ4esECJcQG4kZIYK9
         2xtoFmoQ1TUDCe0Hw+xFvzosp5tAWuJlfNRtv0qE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 389/677] media: ccs: Fix sub-device function
Date:   Wed, 12 May 2021 16:47:15 +0200
Message-Id: <20210512144850.251577796@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 8c43126e8c9f0990fa75fb5219c03b20d5ead7b7 ]

Fix sub-device function for the pixel array and the scaler.

It seems that the pixel array had gotten assigned as SCALER whereas the
scaler had CAM_SENSOR function. Fix this by setting the pixel array
function to CAM_SENSOR and that of scaler to SCALER.

Fixes: 9ec2ac9bd0f9 ("media: ccs: Give all subdevs a function")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ccs/ccs-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ccs/ccs-core.c b/drivers/media/i2c/ccs/ccs-core.c
index 15afbb4f5b31..4505594996bd 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3522,11 +3522,11 @@ static int ccs_probe(struct i2c_client *client)
 	sensor->pll.scale_n = CCS_LIM(sensor, SCALER_N_MIN);
 
 	ccs_create_subdev(sensor, sensor->scaler, " scaler", 2,
-			  MEDIA_ENT_F_CAM_SENSOR);
+			  MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	ccs_create_subdev(sensor, sensor->binner, " binner", 2,
 			  MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	ccs_create_subdev(sensor, sensor->pixel_array, " pixel_array", 1,
-			  MEDIA_ENT_F_PROC_VIDEO_SCALER);
+			  MEDIA_ENT_F_CAM_SENSOR);
 
 	rval = ccs_init_controls(sensor);
 	if (rval < 0)
-- 
2.30.2



