Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69EDC15AFB
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfEGFue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:59560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbfEGFkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70C57214AE;
        Tue,  7 May 2019 05:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207604;
        bh=wO4dgz5fNDr1DLrHbr7ktCK4VAv7TGAa/7Uat55/mj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzWvclZ1nLA4vb5cElcz4SX1V/Sc6ng20MFyluy9AXER8wCaCZT8swT/Oqz6sKa2+
         DXpogNUkGI7X0x6n3Gm16f/1PLYLi9Vfeon/EYC4mM32Q4LxSkc8altggPMlP8Q8Rz
         dkcF4MEicBGFXCTnZTEZaGKB2ihDr6J7VrRYBclY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hugues Fruchet <hugues.fruchet@st.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 51/95] media: ov5640: fix wrong binning value in exposure calculation
Date:   Tue,  7 May 2019 01:37:40 -0400
Message-Id: <20190507053826.31622-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugues Fruchet <hugues.fruchet@st.com>

[ Upstream commit c2c3f42df4dd9bb231d756bacb0c897f662c6d3c ]

ov5640_set_mode_exposure_calc() is checking binning value but
binning value read is buggy, fix this.
Rename ov5640_binning_on() to ov5640_get_binning() as per other
similar functions.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 drivers/media/i2c/ov5640.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 39a2269c0bee..0366c8dc6ecf 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -1216,7 +1216,7 @@ static int ov5640_set_ae_target(struct ov5640_dev *sensor, int target)
 	return ov5640_write_reg(sensor, OV5640_REG_AEC_CTRL1F, fast_low);
 }
 
-static int ov5640_binning_on(struct ov5640_dev *sensor)
+static int ov5640_get_binning(struct ov5640_dev *sensor)
 {
 	u8 temp;
 	int ret;
@@ -1224,8 +1224,8 @@ static int ov5640_binning_on(struct ov5640_dev *sensor)
 	ret = ov5640_read_reg(sensor, OV5640_REG_TIMING_TC_REG21, &temp);
 	if (ret)
 		return ret;
-	temp &= 0xfe;
-	return temp ? 1 : 0;
+
+	return temp & BIT(0);
 }
 
 static int ov5640_set_virtual_channel(struct ov5640_dev *sensor)
@@ -1293,7 +1293,7 @@ static int ov5640_set_mode_exposure_calc(
 	if (ret < 0)
 		return ret;
 	prev_shutter = ret;
-	ret = ov5640_binning_on(sensor);
+	ret = ov5640_get_binning(sensor);
 	if (ret < 0)
 		return ret;
 	if (ret && mode->id != OV5640_MODE_720P_1280_720 &&
-- 
2.20.1

