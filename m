Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6830A499C11
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:06:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1577148AbiAXV7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456750AbiAXVzC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:55:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61500C07E295;
        Mon, 24 Jan 2022 12:36:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01C4E61536;
        Mon, 24 Jan 2022 20:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D111CC340E5;
        Mon, 24 Jan 2022 20:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056559;
        bh=mVwKOa9TdbM1aRje2DNNGkcxM/BY7WVf6u62VGJnVNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTUsgdr899ihHNllE6u+2f8mw2tcMhBipmfFdg6peEWTnH+xzZ4iWosNBhc5UE2fm
         J0VEYiLoMqUH0xiU/Yz1CCBgJ3uowk8h6IvcQN3HPOb1LKx+BA7p2yRMi9QWd6IZgc
         2P9J4m8mvfahU0O9NQb/1jx+Dvseh/YzitPTD53U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 524/846] media: rcar-vin: Update format alignment constraints
Date:   Mon, 24 Jan 2022 19:40:41 +0100
Message-Id: <20220124184119.088634474@linuxfoundation.org>
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
index 0d141155f0e3e..eb8c79bac540f 100644
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



