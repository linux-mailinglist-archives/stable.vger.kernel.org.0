Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBB266C702
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjAPQ1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232956AbjAPQ04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:26:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBAD241D0
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:15:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A9926102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:15:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1812DC433EF;
        Mon, 16 Jan 2023 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885701;
        bh=n5fwTiX5VfIRRBP/YTcLGN6FK0b7c1644UnpRNiCTws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzexoE4jf6f+PBTFEQXvPIWGzgZb2fWeJAP21AEaxTdhu1uvZGomK0+cCUWF1hMZA
         ttgwB8pAZR0R7HAX9Nf+q4ozWSTsbkxlM8NeNfy++7sI61dVZF4iSPU2gcfGDw8AgE
         K31xkzI/ZdKLWS1Plm4dHtDnpVtaRcBgRq041IYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 124/658] media: camss: Clean up received buffers on failed start of streaming
Date:   Mon, 16 Jan 2023 16:43:32 +0100
Message-Id: <20230116154915.131062826@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 4c2675b43718..6a5ec133a957 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -438,7 +438,7 @@ static int video_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	ret = media_pipeline_start(&vdev->entity, &video->pipe);
 	if (ret < 0)
-		return ret;
+		goto flush_buffers;
 
 	ret = video_check_format(video);
 	if (ret < 0)
@@ -467,6 +467,7 @@ static int video_start_streaming(struct vb2_queue *q, unsigned int count)
 error:
 	media_pipeline_stop(&vdev->entity);
 
+flush_buffers:
 	video->ops->flush_buffers(video, VB2_BUF_STATE_QUEUED);
 
 	return ret;
-- 
2.35.1



