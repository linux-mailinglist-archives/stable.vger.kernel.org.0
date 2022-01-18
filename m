Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BAA49183A
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348096AbiARCou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48976 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343926AbiARCmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:42:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08370B8128F;
        Tue, 18 Jan 2022 02:42:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB90FC36AE3;
        Tue, 18 Jan 2022 02:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473734;
        bh=qDhR74ah9joXahceyFh9WO/6szkMtojGpRt+7xDLEdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nmMrI7OBuA/1CJOkMwbbHDggBRXK/G+Z1i6TBtgeHxS6ccGxhtYMdZCEv1horgT3P
         JPVyR43Vx7AAdjj61TxiPWnvu9A4iJJGU1IXpRqah8v4bTkZB1jf+ne33P/eQCyMuT
         SYzuRBUmi5TEHmQY99d05D4GtMvpy5dBw0w49pyZ9iF+bpXdvRJMx5Jkqv8pb/MKRp
         WpFrFOcCH4td2C1QpbJyJOcQo2xxUubo4RT4xvEciJFVjMa8E/u+0U86nEenSPbwTZ
         JJAeJOFLWMTZLZGpuOVB7zU8tZIe29WRn86djjo7EOmjb+DGG6qZOnA4PQ+LqwIYKu
         tAsWjRKfgjoiw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, niklas.soderlund@ragnatech.se,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 046/116] media: rcar-vin: Update format alignment constraints
Date:   Mon, 17 Jan 2022 21:38:57 -0500
Message-Id: <20220118024007.1950576-46-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit da6911f330d40cfe115a37249e47643eff555e82 ]

This change fixes two issues with the size constraints for buffers.

- There is no width alignment constraint for RGB formats. Prior to this
  change they were treated as YUV and as a result were more restricted
  than needed. Add a new check to differentiate between the two.

- The minimum width and height supported is 5x2, not 2x4, this is an
  artifact from the driver's soc-camera days. Fix this incorrect
  assumption.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-v4l2.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 3e7a3ae2a6b97..0bbe6f9f92062 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -175,20 +175,27 @@ static void rvin_format_align(struct rvin_dev *vin, struct v4l2_pix_format *pix)
 		break;
 	}
 
-	/* HW limit width to a multiple of 32 (2^5) for NV12/16 else 2 (2^1) */
+	/* Hardware limits width alignment based on format. */
 	switch (pix->pixelformat) {
+	/* Multiple of 32 (2^5) for NV12/16. */
 	case V4L2_PIX_FMT_NV12:
 	case V4L2_PIX_FMT_NV16:
 		walign = 5;
 		break;
-	default:
+	/* Multiple of 2 (2^1) for YUV. */
+	case V4L2_PIX_FMT_YUYV:
+	case V4L2_PIX_FMT_UYVY:
 		walign = 1;
 		break;
+	/* No multiple for RGB. */
+	default:
+		walign = 0;
+		break;
 	}
 
 	/* Limit to VIN capabilities */
-	v4l_bound_align_image(&pix->width, 2, vin->info->max_width, walign,
-			      &pix->height, 4, vin->info->max_height, 2, 0);
+	v4l_bound_align_image(&pix->width, 5, vin->info->max_width, walign,
+			      &pix->height, 2, vin->info->max_height, 0, 0);
 
 	pix->bytesperline = rvin_format_bytesperline(vin, pix);
 	pix->sizeimage = rvin_format_sizeimage(pix);
-- 
2.34.1

