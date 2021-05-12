Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7929E37C4D5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhELPdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235642AbhELP2n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74C51613AF;
        Wed, 12 May 2021 15:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832462;
        bh=6w7TqbEPhJJFeiN8jvIQ29HQqDs43kksLmXQyng8Q1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xMsJN/nZlUp8phzzZnr/CIYRH0TDML1NshM/OuO46g/6NYzpP/zCJGb7Z6H1f0kIu
         1T8w6CrST3gZyizbfw51bcrhTF/lhgmfnzisl39U+6wdW7S95ufrfEgywwhdMBXIkv
         SrtdimJKQ0sZrqNukQ3wBZ/LEVOHqeNS2GzJmLDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dafna Hirschfeld <dafna.hirschfeld@collabora.com>,
        Helen Koike <helen.koike@collabora.com>,
        Sebastian Fricke <sebastian.fricke.linux@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 288/530] media: rkisp1: rsz: crash fix when setting src format
Date:   Wed, 12 May 2021 16:46:38 +0200
Message-Id: <20210512144829.274236695@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>

[ Upstream commit cbe8373ca7e7cbb4b263b6bf222ccc19f5e119d2 ]

When setting the source media bus code in the resizer,
we first check that the current media bus code in the
source is yuv encoded format. This is done by
retrieving the data from the formats list of the isp
entity. This cause a crash when the media bus code on the
source is YUYV8_1_5X8 which is not supported by the isp
entity. Instead we should test the sink format of the resizer
which is guaranteed to be supported by the isp entity.

Fixes: 251b6eebb6c49 ("media: staging: rkisp1: rsz: Add support to more YUV encoded mbus codes on src pad")
Signed-off-by: Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
Acked-by: Helen Koike <helen.koike@collabora.com>
Tested-by: Sebastian Fricke <sebastian.fricke.linux@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkisp1/rkisp1-resizer.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/rkisp1/rkisp1-resizer.c b/drivers/staging/media/rkisp1/rkisp1-resizer.c
index 1687d82e6c68..4dcc342ac2b2 100644
--- a/drivers/staging/media/rkisp1/rkisp1-resizer.c
+++ b/drivers/staging/media/rkisp1/rkisp1-resizer.c
@@ -520,14 +520,15 @@ static void rkisp1_rsz_set_src_fmt(struct rkisp1_resizer *rsz,
 				   struct v4l2_mbus_framefmt *format,
 				   unsigned int which)
 {
-	const struct rkisp1_isp_mbus_info *mbus_info;
-	struct v4l2_mbus_framefmt *src_fmt;
+	const struct rkisp1_isp_mbus_info *sink_mbus_info;
+	struct v4l2_mbus_framefmt *src_fmt, *sink_fmt;
 
+	sink_fmt = rkisp1_rsz_get_pad_fmt(rsz, cfg, RKISP1_RSZ_PAD_SINK, which);
 	src_fmt = rkisp1_rsz_get_pad_fmt(rsz, cfg, RKISP1_RSZ_PAD_SRC, which);
-	mbus_info = rkisp1_isp_mbus_info_get(src_fmt->code);
+	sink_mbus_info = rkisp1_isp_mbus_info_get(sink_fmt->code);
 
 	/* for YUV formats, userspace can change the mbus code on the src pad if it is supported */
-	if (mbus_info->pixel_enc == V4L2_PIXEL_ENC_YUV &&
+	if (sink_mbus_info->pixel_enc == V4L2_PIXEL_ENC_YUV &&
 	    rkisp1_rsz_get_yuv_mbus_info(format->code))
 		src_fmt->code = format->code;
 
-- 
2.30.2



