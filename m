Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6C2608C2D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 13:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJVLDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 07:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiJVLCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 07:02:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40DC2FACE2;
        Sat, 22 Oct 2022 03:21:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 093F3B82DF7;
        Sat, 22 Oct 2022 07:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DEEC433C1;
        Sat, 22 Oct 2022 07:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425207;
        bh=KnC0eVRrajGhZ5HIxfCVZGcjDmnvlTYo6SUexl+tkS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hswTckQR3a/keiU8FJ3bgflkKuv1NbMzn8ggvRJVETZbZjnlSNe4DvDxqeSNmawNR
         DTFpULLH+d5hugidJX5D7LVB1jGO6DhraZ2+IUkESqMk4FhCRTyAn7i2NNwnL1cvMR
         snYMc5X18MQZWZQB/MNP7r2Uovd293PHOtMw4Fko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Qian <ming.qian@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 397/717] media: amphion: adjust the encoders value range of gop size
Date:   Sat, 22 Oct 2022 09:24:36 +0200
Message-Id: <20221022072515.402386581@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 996f4e89fabe44ab9ac0aabb0697aeecbe717eca ]

adjust the value range of gop size from [0, 65535] to [1, 8000].
when the gop size is set to a too large value,
it may affect the encoded picture quality.
so constrain it to a reasonable range.

Fixes: 0401e659c1f92 ("media: amphion: add v4l2 m2m vpu encoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/venc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/amphion/venc.c b/drivers/media/platform/amphion/venc.c
index 43d61d82f58c..0f21a181c1de 100644
--- a/drivers/media/platform/amphion/venc.c
+++ b/drivers/media/platform/amphion/venc.c
@@ -644,7 +644,7 @@ static int venc_ctrl_init(struct vpu_inst *inst)
 			  BITRATE_DEFAULT_PEAK);
 
 	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
-			  V4L2_CID_MPEG_VIDEO_GOP_SIZE, 0, (1 << 16) - 1, 1, 30);
+			  V4L2_CID_MPEG_VIDEO_GOP_SIZE, 1, 8000, 1, 30);
 
 	v4l2_ctrl_new_std(&inst->ctrl_handler, &venc_ctrl_ops,
 			  V4L2_CID_MPEG_VIDEO_B_FRAMES, 0, 4, 1, 0);
-- 
2.35.1



