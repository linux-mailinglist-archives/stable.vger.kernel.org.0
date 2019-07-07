Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB66361726
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfGGTiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56964 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727486AbfGGTiD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:03 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz2-0006eK-Mg; Sun, 07 Jul 2019 20:38:00 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz1-0005YM-7l; Sun, 07 Jul 2019 20:37:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        "Jacek Anaszewski" <jacek.anaszewski@gmail.com>,
        "Pawe? Chmiel" <pawel.mikolaj.chmiel@gmail.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.126870290@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 026/129] media: s5p-jpeg: Check for fmt_ver_flag when
 doing fmt enumeration
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pawe? Chmiel <pawel.mikolaj.chmiel@gmail.com>

commit 49710c32cd9d6626a77c9f5f978a5f58cb536b35 upstream.

Previously when doing format enumeration, it was returning all
 formats supported by driver, even if they're not supported by hw.
Add missing check for fmt_ver_flag, so it'll be fixed and only those
 supported by hw will be returned. Similar thing is already done
 in s5p_jpeg_find_format.

It was found by using v4l2-compliance tool and checking result
 of VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS test
and using v4l2-ctl to get list of all supported formats.

Tested on s5pv210-galaxys (Samsung i9000 phone).

Fixes: bb677f3ac434 ("[media] Exynos4 JPEG codec v4l2 driver")

Signed-off-by: Pawe? Chmiel <pawel.mikolaj.chmiel@gmail.com>
Reviewed-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>
[hverkuil-cisco@xs4all.nl: fix a few alignment issues]
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -859,13 +859,16 @@ static int s5p_jpeg_querycap(struct file
 	return 0;
 }
 
-static int enum_fmt(struct s5p_jpeg_fmt *sjpeg_formats, int n,
+static int enum_fmt(struct s5p_jpeg_ctx *ctx,
+		    struct s5p_jpeg_fmt *sjpeg_formats, int n,
 		    struct v4l2_fmtdesc *f, u32 type)
 {
 	int i, num = 0;
+	unsigned int fmt_ver_flag = ctx->jpeg->variant->fmt_ver_flag;
 
 	for (i = 0; i < n; ++i) {
-		if (sjpeg_formats[i].flags & type) {
+		if (sjpeg_formats[i].flags & type &&
+		    sjpeg_formats[i].flags & fmt_ver_flag) {
 			/* index-th format of type type found ? */
 			if (num == f->index)
 				break;
@@ -891,11 +894,11 @@ static int s5p_jpeg_enum_fmt_vid_cap(str
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
-		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+		return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
 				SJPEG_FMT_FLAG_ENC_CAPTURE);
 
-	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
-					SJPEG_FMT_FLAG_DEC_CAPTURE);
+	return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
+			SJPEG_FMT_FLAG_DEC_CAPTURE);
 }
 
 static int s5p_jpeg_enum_fmt_vid_out(struct file *file, void *priv,
@@ -904,11 +907,11 @@ static int s5p_jpeg_enum_fmt_vid_out(str
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE)
-		return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
+		return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
 				SJPEG_FMT_FLAG_ENC_OUTPUT);
 
-	return enum_fmt(sjpeg_formats, SJPEG_NUM_FORMATS, f,
-					SJPEG_FMT_FLAG_DEC_OUTPUT);
+	return enum_fmt(ctx, sjpeg_formats, SJPEG_NUM_FORMATS, f,
+			SJPEG_FMT_FLAG_DEC_OUTPUT);
 }
 
 static struct s5p_jpeg_q_data *get_q_data(struct s5p_jpeg_ctx *ctx,

