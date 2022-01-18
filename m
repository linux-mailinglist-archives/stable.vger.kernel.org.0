Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE1BA49144D
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244661AbiARCVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:21:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244675AbiARCVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:21:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCA6C061769;
        Mon, 17 Jan 2022 18:21:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57A9CB8122C;
        Tue, 18 Jan 2022 02:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CFBC36AEB;
        Tue, 18 Jan 2022 02:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472466;
        bh=oN+riz2KPBpT4JWOx2X4OywlB2pWHJD4t8/cTC9SMSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvZ44EzXkUAJDymBLi0xca+pVRZjoSLL7CslTwxTTYEySkGqt+Ye5SUxZ6aA0roTX
         SGXMIQSQnfnVdT2/vhe6GdT1qWprevH1nYEgG723diX5q4lUgMXfUO+/o0NDvLOFev
         BeXxJqIhUsp+/kkVVLcSrK/cdI2Z4RPVfugwFQ1E8+XSQrASqKwq6Yw3xFGQ8nJ1a/
         1BOd8ydNpNUR9au2BT6tPDJbsof+lZip4zh36ELB6VsohIVHx4ka+tZmsz3BpuxwRB
         aznhBPt7yTsyIAaX6xLUyAQPX2lY5j1VR0HDttUMZ+ZA+OMHDz1Duxcmo4/Awy9dep
         0WOEQmOpBs/pw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, hverkuil-cisco@xs4all.nl,
        kitakar@gmail.com, arnd@arndb.de, tomi.valkeinen@ideasonboard.com,
        alex.dewar90@gmail.com, alinesantanacordeiro@gmail.com,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.16 022/217] media: atomisp: check before deference asd variable
Date:   Mon, 17 Jan 2022 21:16:25 -0500
Message-Id: <20220118021940.1942199-22-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 71665d816214124d6bc4eb80314ac8f84ecacd78 ]

The asd->isp was referenced before checking if asd is not
NULL.

This fixes this warning:

	../drivers/staging/media/atomisp/pci/atomisp_cmd.c:5548 atomisp_set_fmt_to_snr() warn: variable dereferenced before check 'asd' (see line 5540)

While here, avoid getting the pipe pointer twice.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_cmd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
index 75a531667d743..1ddb9c815a3cb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_cmd.c
@@ -5529,8 +5529,8 @@ static int atomisp_set_fmt_to_snr(struct video_device *vdev,
 				  unsigned int padding_w, unsigned int padding_h,
 				  unsigned int dvs_env_w, unsigned int dvs_env_h)
 {
-	struct atomisp_sub_device *asd = atomisp_to_video_pipe(vdev)->asd;
 	struct atomisp_video_pipe *pipe = atomisp_to_video_pipe(vdev);
+	struct atomisp_sub_device *asd = pipe->asd;
 	const struct atomisp_format_bridge *format;
 	struct v4l2_subdev_pad_config pad_cfg;
 	struct v4l2_subdev_state pad_state = {
@@ -5541,7 +5541,7 @@ static int atomisp_set_fmt_to_snr(struct video_device *vdev,
 	};
 	struct v4l2_mbus_framefmt *ffmt = &vformat.format;
 	struct v4l2_mbus_framefmt *req_ffmt;
-	struct atomisp_device *isp = asd->isp;
+	struct atomisp_device *isp;
 	struct atomisp_input_stream_info *stream_info =
 	    (struct atomisp_input_stream_info *)ffmt->reserved;
 	u16 stream_index = ATOMISP_INPUT_STREAM_GENERAL;
@@ -5555,6 +5555,8 @@ static int atomisp_set_fmt_to_snr(struct video_device *vdev,
 		return -EINVAL;
 	}
 
+	isp = asd->isp;
+
 	v4l2_fh_init(&fh.vfh, vdev);
 
 	stream_index = atomisp_source_pad_to_stream_id(asd, source_pad);
-- 
2.34.1

