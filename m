Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1244A43D1
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377259AbiAaLYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378714AbiAaLUh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2627C0698C2;
        Mon, 31 Jan 2022 03:13:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7146FB82A66;
        Mon, 31 Jan 2022 11:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A29BFC340E8;
        Mon, 31 Jan 2022 11:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627614;
        bh=MBN22VmzfNkPcLqzGiCFTU1wm89FYeeBn5uoaTj78F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pe6m7crt6ZGmh8GbGO5otDk1zex59zFQXK5UhyNJSKi8x0Ve0hKXWZ4llidUIM3SP
         WhgvAGDQBFdLGDMdISwxqXaYvN61CmphsN2SWfK2It8bfQomChKRY5ZO7EsiP2CHp4
         D9+KA1+Nlc9jNN4MjYLpANG7pQtEv9heImBadpng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Helge Deller <deller@gmx.de>, Wei Liu <wei.liu@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/171] video: hyperv_fb: Fix validation of screen resolution
Date:   Mon, 31 Jan 2022 11:56:47 +0100
Message-Id: <20220131105234.808706620@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Kelley <mikelley@microsoft.com>

[ Upstream commit 9ff5549b1d1d3c3a9d71220d44bd246586160f1d ]

In the WIN10 version of the Synthetic Video protocol with Hyper-V,
Hyper-V reports a list of supported resolutions as part of the protocol
negotiation. The driver calculates the maximum width and height from
the list of resolutions, and uses those maximums to validate any screen
resolution specified in the video= option on the kernel boot line.

This method of validation is incorrect. For example, the list of
supported resolutions could contain 1600x1200 and 1920x1080, both of
which fit in an 8 Mbyte frame buffer.  But calculating the max width
and height yields 1920 and 1200, and 1920x1200 resolution does not fit
in an 8 Mbyte frame buffer.  Unfortunately, this resolution is accepted,
causing a kernel fault when the driver accesses memory outside the
frame buffer.

Instead, validate the specified screen resolution by calculating
its size, and comparing against the frame buffer size.  Delete the
code for calculating the max width and height from the list of
resolutions, since these max values have no use.  Also add the
frame buffer size to the info message to aid in understanding why
a resolution might be rejected.

Fixes: 67e7cdb4829d ("video: hyperv: hyperv_fb: Obtain screen resolution from Hyper-V host")
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Acked-by: Helge Deller <deller@gmx.de>
Link: https://lore.kernel.org/r/1642360711-2335-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/hyperv_fb.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 23999df527393..c8e0ea27caf1d 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -287,8 +287,6 @@ struct hvfb_par {
 
 static uint screen_width = HVFB_WIDTH;
 static uint screen_height = HVFB_HEIGHT;
-static uint screen_width_max = HVFB_WIDTH;
-static uint screen_height_max = HVFB_HEIGHT;
 static uint screen_depth;
 static uint screen_fb_size;
 static uint dio_fb_size; /* FB size for deferred IO */
@@ -582,7 +580,6 @@ static int synthvid_get_supported_resolution(struct hv_device *hdev)
 	int ret = 0;
 	unsigned long t;
 	u8 index;
-	int i;
 
 	memset(msg, 0, sizeof(struct synthvid_msg));
 	msg->vid_hdr.type = SYNTHVID_RESOLUTION_REQUEST;
@@ -613,13 +610,6 @@ static int synthvid_get_supported_resolution(struct hv_device *hdev)
 		goto out;
 	}
 
-	for (i = 0; i < msg->resolution_resp.resolution_count; i++) {
-		screen_width_max = max_t(unsigned int, screen_width_max,
-		    msg->resolution_resp.supported_resolution[i].width);
-		screen_height_max = max_t(unsigned int, screen_height_max,
-		    msg->resolution_resp.supported_resolution[i].height);
-	}
-
 	screen_width =
 		msg->resolution_resp.supported_resolution[index].width;
 	screen_height =
@@ -941,7 +931,7 @@ static void hvfb_get_option(struct fb_info *info)
 
 	if (x < HVFB_WIDTH_MIN || y < HVFB_HEIGHT_MIN ||
 	    (synthvid_ver_ge(par->synthvid_version, SYNTHVID_VERSION_WIN10) &&
-	    (x > screen_width_max || y > screen_height_max)) ||
+	    (x * y * screen_depth / 8 > screen_fb_size)) ||
 	    (par->synthvid_version == SYNTHVID_VERSION_WIN8 &&
 	     x * y * screen_depth / 8 > SYNTHVID_FB_SIZE_WIN8) ||
 	    (par->synthvid_version == SYNTHVID_VERSION_WIN7 &&
@@ -1194,8 +1184,8 @@ static int hvfb_probe(struct hv_device *hdev,
 	}
 
 	hvfb_get_option(info);
-	pr_info("Screen resolution: %dx%d, Color depth: %d\n",
-		screen_width, screen_height, screen_depth);
+	pr_info("Screen resolution: %dx%d, Color depth: %d, Frame buffer size: %d\n",
+		screen_width, screen_height, screen_depth, screen_fb_size);
 
 	ret = hvfb_getmem(hdev, info);
 	if (ret) {
-- 
2.34.1



