Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1983B6578CE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbiL1Oyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbiL1OyW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:54:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1047495
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:54:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ED0D61552
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADEDFC433D2;
        Wed, 28 Dec 2022 14:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239261;
        bh=xlUw489YlVwhdm/wRM7oXua3Dzwr1f/PtjW3DGkIVZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aoTzmbeTHleHOyIoHYy0oxU90P0kNHCVVNbING7zITKNZY6fgTixYvSSHIAtu87gx
         k2OajRq8k4gnahADPiJtEH76d/SUcRoDhkeZLscxqzgGHAO4Jc3Cf2U6lI2fp9A2ox
         BBFrpu1phEnIdWZwP2ka1FRFdtegJRavpKPewzg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/731] media: camss: Clean up received buffers on failed start of streaming
Date:   Wed, 28 Dec 2022 15:34:56 +0100
Message-Id: <20221228144302.037927547@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit c8f3582345e6a69da65ab588f7c4c2d1685b0e80 ]

It is required to return the received buffers, if streaming can not be
started. For instance media_pipeline_start() may fail with EPIPE, if
a link validation between entities is not passed, and in such a case
a user gets a kernel warning:

  WARNING: CPU: 1 PID: 520 at drivers/media/common/videobuf2/videobuf2-core.c:1592 vb2_start_streaming+0xec/0x160
  <snip>
  Call trace:
   vb2_start_streaming+0xec/0x160
   vb2_core_streamon+0x9c/0x1a0
   vb2_ioctl_streamon+0x68/0xbc
   v4l_streamon+0x30/0x3c
   __video_do_ioctl+0x184/0x3e0
   video_usercopy+0x37c/0x7b0
   video_ioctl2+0x24/0x40
   v4l2_ioctl+0x4c/0x70

The fix is to correct the error path in video_start_streaming() of camss.

Fixes: 0ac2586c410f ("media: camss: Add files which handle the video device nodes")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-video.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss/camss-video.c b/drivers/media/platform/qcom/camss/camss-video.c
index f282275af626..5173b79995ee 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -493,7 +493,7 @@ static int video_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	ret = media_pipeline_start(&vdev->entity, &video->pipe);
 	if (ret < 0)
-		return ret;
+		goto flush_buffers;
 
 	ret = video_check_format(video);
 	if (ret < 0)
@@ -522,6 +522,7 @@ static int video_start_streaming(struct vb2_queue *q, unsigned int count)
 error:
 	media_pipeline_stop(&vdev->entity);
 
+flush_buffers:
 	video->ops->flush_buffers(video, VB2_BUF_STATE_QUEUED);
 
 	return ret;
-- 
2.35.1



