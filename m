Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85146344288
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhCVMna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232089AbhCVMkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6A8060C41;
        Mon, 22 Mar 2021 12:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416734;
        bh=2Wc34VS0+OVGIcareQsge52XutGJz1fKlaC6x2L86e8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1KQiNCQ6VZVI72VocUDenjgtyOAbMsw+A/Jf2hE4WrCNOucSTGVdtu3klvXp6LKc
         WLvjJySzerntI1kzwxrE23Fbz0gcLvJtvZErPEAwI8ehZ8S3vSgIy9AzL06KWEgXsb
         BYfCLs6N1i3cbc5r+0e/ruOK2AffA+h/xnHExuPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ezequiel Garcia <ezequiel@collabora.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/157] media: cedrus: h264: Support profile controls
Date:   Mon, 22 Mar 2021 13:27:36 +0100
Message-Id: <20210322121936.916311853@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit c8363ff21b5168f2252aa8b8447173ce48ff0149 ]

Cedrus supports H.264 profiles from Baseline to High,
except for the Extended profile

Expose the V4L2_CID_MPEG_VIDEO_H264_PROFILE so that
userspace can query the driver for the supported
profiles and levels.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Jernej Skrabec <jernej.skrabec@siol.net>
Tested-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c b/drivers/staging/media/sunxi/cedrus/cedrus.c
index e0e35502e34a..1dd833757c4e 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
@@ -103,6 +103,25 @@ static const struct cedrus_control cedrus_controls[] = {
 		.codec		= CEDRUS_CODEC_H264,
 		.required	= false,
 	},
+	/*
+	 * We only expose supported profiles information,
+	 * and not levels as it's not clear what is supported
+	 * for each hardware/core version.
+	 * In any case, TRY/S_FMT will clamp the format resolution
+	 * to the maximum supported.
+	 */
+	{
+		.cfg = {
+			.id	= V4L2_CID_MPEG_VIDEO_H264_PROFILE,
+			.min	= V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE,
+			.def	= V4L2_MPEG_VIDEO_H264_PROFILE_MAIN,
+			.max	= V4L2_MPEG_VIDEO_H264_PROFILE_HIGH,
+			.menu_skip_mask =
+				BIT(V4L2_MPEG_VIDEO_H264_PROFILE_EXTENDED),
+		},
+		.codec		= CEDRUS_CODEC_H264,
+		.required	= false,
+	},
 	{
 		.cfg = {
 			.id	= V4L2_CID_MPEG_VIDEO_HEVC_SPS,
-- 
2.30.1



