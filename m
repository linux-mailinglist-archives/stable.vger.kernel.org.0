Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5E01F17C
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730472AbfEOLy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730869AbfEOLTB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:19:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12438206BF;
        Wed, 15 May 2019 11:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919140;
        bh=8xr0UHmS66hpz9oJZ6WyCqf5D5qb+7B5XC1ifioSG54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bPtNuBo4PWMKS4U88vLP6WC7xNjxaNefGIJ8GRnAPYvj25je4GKRh9yuHMp93Z3VG
         qe3yJICwlyUuEcHl5P8r/wXlziGN2ANJjvtMVw7y47XS8+/EkHgToqwT6Zg22YMeYS
         zI70BWhujjVR21CLH48dQgcjcTy82G+99ejyrH38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugues Fruchet <hugues.fruchet@st.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 055/115] media: ov5640: fix wrong binning value in exposure calculation
Date:   Wed, 15 May 2019 12:55:35 +0200
Message-Id: <20190515090703.596067527@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 39a2269c0beef..0366c8dc6ecf7 100644
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



