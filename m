Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9B44521F3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376943AbhKPBHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245278AbhKOTT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C2D163527;
        Mon, 15 Nov 2021 18:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001099;
        bh=2JYBnu26lh+xnfocP3ExYnaUlwXlPUeVfjs51btJ/Zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+THYWJ1YUrQ5/ALFrtqWWXRDpysad6XxgMzdEhIMoZk5wrdshEA0DMq+nKZd8mlO
         IFqADsqhIMC1PfnaQuncT+ExtsHh703GrKro8fl7K7nosfuJDCzdTD/EY57ASJePgC
         aM1+CMyW3Spxc0qz5OiG/SmgOl1xjBW3AfPImXDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wenst@chromium.org>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 027/917] media: rkvdec: Do not override sizeimage for output format
Date:   Mon, 15 Nov 2021 17:52:02 +0100
Message-Id: <20211115165429.648773143@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wenst@chromium.org>

commit 298d8e8f7bcf023aceb60232d59b983255fec0df upstream.

The rkvdec H.264 decoder currently overrides sizeimage for the output
format. This causes issues when userspace requires and requests a larger
buffer, but ends up with one of insufficient size.

Instead, only provide a default size if none was requested. This fixes
the video_decode_accelerator_tests from Chromium failing on the first
frame due to insufficient buffer space. It also aligns the behavior
of the rkvdec driver with the Hantro and Cedrus drivers.

Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/rkvdec/rkvdec-h264.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/rkvdec/rkvdec-h264.c
+++ b/drivers/staging/media/rkvdec/rkvdec-h264.c
@@ -1015,8 +1015,9 @@ static int rkvdec_h264_adjust_fmt(struct
 	struct v4l2_pix_format_mplane *fmt = &f->fmt.pix_mp;
 
 	fmt->num_planes = 1;
-	fmt->plane_fmt[0].sizeimage = fmt->width * fmt->height *
-				      RKVDEC_H264_MAX_DEPTH_IN_BYTES;
+	if (!fmt->plane_fmt[0].sizeimage)
+		fmt->plane_fmt[0].sizeimage = fmt->width * fmt->height *
+					      RKVDEC_H264_MAX_DEPTH_IN_BYTES;
 	return 0;
 }
 


