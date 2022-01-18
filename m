Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE40349179E
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347674AbiARCmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:33 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50262 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343551AbiARCdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:33:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70F2E6124E;
        Tue, 18 Jan 2022 02:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FC3C36AE3;
        Tue, 18 Jan 2022 02:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473188;
        bh=oN+riz2KPBpT4JWOx2X4OywlB2pWHJD4t8/cTC9SMSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c/x9kBT3xmjY7hCR/jT6VhnCJwEhrCQljVSU8E3oOIDbjQNFxThGMSzowTP5wtYOn
         B9enGai7xP47Is+DRSbbvCqmrRmmWpxA0+9z1F9k0u3xSO4AosP1WNtv7ftjPvUGTL
         gDSkTrUXIiNdm/R6HXCXpwhWu/A6xhUquFl5A/nQTse5jvuRLT1tr+LUADHANWUJsm
         2oVTSd7CnWejxCKB1jqr7MqH995GhVN1G1ACnUaZMoqZzSNDzPv3Ce7JLIcZTtOP9g
         zmk4MINfcoPyugEVqCLJ8vHLxYk+AMvLABeTQlRapAUCyZPHcUaiNxLYHC24SMDa30
         PFb+d2vJE3T3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        gregkh@linuxfoundation.org, hverkuil-cisco@xs4all.nl,
        kitakar@gmail.com, arnd@arndb.de, tomi.valkeinen@ideasonboard.com,
        alex.dewar90@gmail.com, alinesantanacordeiro@gmail.com,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 018/188] media: atomisp: check before deference asd variable
Date:   Mon, 17 Jan 2022 21:29:02 -0500
Message-Id: <20220118023152.1948105-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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

