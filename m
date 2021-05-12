Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D561037C91F
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbhELQPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239495AbhELQIK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:08:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6506461D22;
        Wed, 12 May 2021 15:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833932;
        bh=u++EYZyRRXgZy2eNc9xEmS9+9QAgstoWGXrKK5MTBD4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVGk2JHZalZFRIXi71zHSoEcn5bzGW7CFCshBH9yP+/OtiTNuN1MdqJuH88EW8lUF
         RMbYxGB9HUFwC1k99/ikMB//DYWN1+jhUXw9PHhOmiUqv0eGQULAYjrTR0/pIG94bW
         0LxN86Aok+j4+xfJpRDvp1QDehduAJHy2PfgCmwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 345/601] media: ccs: Fix sub-device function
Date:   Wed, 12 May 2021 16:47:02 +0200
Message-Id: <20210512144839.158493556@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index b39ae5f8446b..6a02d8852398 100644
--- a/drivers/media/i2c/ccs/ccs-core.c
+++ b/drivers/media/i2c/ccs/ccs-core.c
@@ -3290,11 +3290,11 @@ static int ccs_probe(struct i2c_client *client)
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



