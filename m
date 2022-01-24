Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E108B4998EB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453744AbiAXVas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43552 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450620AbiAXVVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51211614BE;
        Mon, 24 Jan 2022 21:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18178C340E4;
        Mon, 24 Jan 2022 21:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059265;
        bh=oN+riz2KPBpT4JWOx2X4OywlB2pWHJD4t8/cTC9SMSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fRr+zAaL11a8UdbmQwnlmeQZwCH8lGtb8PkqKRZ03aRcWxVrI1I6kTUsXE4Y8snvK
         IlzB2w8M0HNvkELK6NtLSfgfkuOSpdksHmZHQpxYkCnMpirI6+8cPHS/fuUJl5yBsH
         sp2Aefp/SCNEfMUzLVcWKQpU8SON8bVBKuaCOpcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0559/1039] media: atomisp: check before deference asd variable
Date:   Mon, 24 Jan 2022 19:39:08 +0100
Message-Id: <20220124184144.099289157@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



