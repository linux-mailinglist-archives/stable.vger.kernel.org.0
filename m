Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12AF3304BEB
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbhAZV5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 16:57:45 -0500
Received: from www.linuxtv.org ([130.149.80.248]:51910 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394546AbhAZSR7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 13:17:59 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1l4Sts-00F4E2-H5; Tue, 26 Jan 2021 18:17:12 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Tue, 26 Jan 2021 18:15:32 +0000
Subject: [git:media_tree/fixes] media: cedrus: Fix H264 decoding
To:     linuxtv-commits@linuxtv.org
Cc:     Andre Heider <a.heider@gmail.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1l4Sts-00F4E2-H5@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cedrus: Fix H264 decoding
Author:  Jernej Skrabec <jernej.skrabec@siol.net>
Date:    Wed Dec 23 12:06:59 2020 +0100

During H264 API overhaul subtle bug was introduced Cedrus driver.
Progressive references have both, top and bottom reference flags set.
Cedrus reference list expects only bottom reference flag and only when
interlaced frames are decoded. However, due to a bug in Cedrus check,
exclusivity is not tested and that flag is set also for progressive
references. That causes "jumpy" background with many videos.

Fix that by checking that only bottom reference flag is set in control
and nothing else.

Tested-by: Andre Heider <a.heider@gmail.com>
Fixes: cfc8c3ed533e ("media: cedrus: h264: Properly configure reference field")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/staging/media/sunxi/cedrus/cedrus_h264.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h264.c b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
index 781c84a9b1b7..de7442d4834d 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
@@ -203,7 +203,7 @@ static void _cedrus_write_ref_list(struct cedrus_ctx *ctx,
 		position = cedrus_buf->codec.h264.position;
 
 		sram_array[i] |= position << 1;
-		if (ref_list[i].fields & V4L2_H264_BOTTOM_FIELD_REF)
+		if (ref_list[i].fields == V4L2_H264_BOTTOM_FIELD_REF)
 			sram_array[i] |= BIT(0);
 	}
 
