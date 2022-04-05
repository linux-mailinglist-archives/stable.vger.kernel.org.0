Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782E74F2734
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiDEIGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbiDEH6l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:58:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94659A94C5;
        Tue,  5 Apr 2022 00:52:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7ED2B81B14;
        Tue,  5 Apr 2022 07:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209B4C34110;
        Tue,  5 Apr 2022 07:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145176;
        bh=w6IIUKVs89R5LQU7C6a2ZqdX/tYHmHkwDBHZ4jPxnts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9u2zBbEx0Die03jb+wy98vvKMRFaritjGyOZtQPs1BjGWTaxE2YtKs9rVJgnxJ5N
         fUW1/tAg7Vt08TzVEV0y7KuQEmTL0ePwJLSEc36yVM/I+mfNxkgRV9f8MrW3ld9qIo
         CrTD0uoNOGhf32Qh8IdNNlcMFdOLSIO2xh+crdFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0313/1126] media: v4l: Avoid unaligned access warnings when printing 4cc modifiers
Date:   Tue,  5 Apr 2022 09:17:40 +0200
Message-Id: <20220405070416.803405485@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 24bb30c8c894ec7213ad810b46e2a6a4c12136c1 ]

Pointers V4L2 pixelformat and dataformat fields in a few packed structs
are directly passed to printk family of functions. This could result in an
unaligned access albeit no such possibility appears to exist at the
moment i.e. this clang warning appears to be a false positive.

Address the warning by copying the pixelformat or dataformat value to a
local variable first.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: e927e1e0f0dd ("v4l: ioctl: Use %p4cc printk modifier to print FourCC codes")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 9ac557b8e146..642cb90f457c 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -279,8 +279,8 @@ static void v4l_print_format(const void *arg, bool write_only)
 	const struct v4l2_vbi_format *vbi;
 	const struct v4l2_sliced_vbi_format *sliced;
 	const struct v4l2_window *win;
-	const struct v4l2_sdr_format *sdr;
 	const struct v4l2_meta_format *meta;
+	u32 pixelformat;
 	u32 planes;
 	unsigned i;
 
@@ -299,8 +299,9 @@ static void v4l_print_format(const void *arg, bool write_only)
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		mp = &p->fmt.pix_mp;
+		pixelformat = mp->pixelformat;
 		pr_cont(", width=%u, height=%u, format=%p4cc, field=%s, colorspace=%d, num_planes=%u, flags=0x%x, ycbcr_enc=%u, quantization=%u, xfer_func=%u\n",
-			mp->width, mp->height, &mp->pixelformat,
+			mp->width, mp->height, &pixelformat,
 			prt_names(mp->field, v4l2_field_names),
 			mp->colorspace, mp->num_planes, mp->flags,
 			mp->ycbcr_enc, mp->quantization, mp->xfer_func);
@@ -343,14 +344,15 @@ static void v4l_print_format(const void *arg, bool write_only)
 		break;
 	case V4L2_BUF_TYPE_SDR_CAPTURE:
 	case V4L2_BUF_TYPE_SDR_OUTPUT:
-		sdr = &p->fmt.sdr;
-		pr_cont(", pixelformat=%p4cc\n", &sdr->pixelformat);
+		pixelformat = p->fmt.sdr.pixelformat;
+		pr_cont(", pixelformat=%p4cc\n", &pixelformat);
 		break;
 	case V4L2_BUF_TYPE_META_CAPTURE:
 	case V4L2_BUF_TYPE_META_OUTPUT:
 		meta = &p->fmt.meta;
+		pixelformat = meta->dataformat;
 		pr_cont(", dataformat=%p4cc, buffersize=%u\n",
-			&meta->dataformat, meta->buffersize);
+			&pixelformat, meta->buffersize);
 		break;
 	}
 }
-- 
2.34.1



