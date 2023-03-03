Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6AA6AA20B
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbjCCVpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbjCCVo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:44:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262A8637F5;
        Fri,  3 Mar 2023 13:43:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 419B961944;
        Fri,  3 Mar 2023 21:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B237C4339C;
        Fri,  3 Mar 2023 21:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879807;
        bh=27YCleqUjTg3cu6L16iWgrj9g+J8Xmv6fZe8VvJvwjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQw8P11h17xlVM7z5XnvWc+mEqZl3q6yH8cKwhnAjA+VLX1ntP1w+FxBGIM+3ly1R
         983WGrLu1soK9I9IEXeD4PSty3l5bVCLU4Hw9vNfMRuYEW4NU1V1IGxFRulDat7Goa
         KyRb3E6DQoG75lR2CgyWuHj7nSwXWvFEF/98O42VTuCJLBz1Xkw2Z5uHbFq5R+AgYY
         sPCK1cw7hdVHHoMiZRyXETjCvVMoC4jvcHxI6tBEBdy9sJYLPHmpJ87u6g4EOlwrma
         P8Q/o5mSw8AlfbakEqjMMsOJ3FDSLqn5kST+rWOVApjIlHJZdmgDI/EbK3Wms7MIiy
         0k6Ss5cusVlfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, ionut_n2001@yahoo.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 08/60] media: uvcvideo: Silence memcpy() run-time false positive warnings
Date:   Fri,  3 Mar 2023 16:42:22 -0500
Message-Id: <20230303214315.1447666-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit b839212988575c701aab4d3d9ca15e44c87e383c ]

The memcpy() in uvc_video_decode_meta() intentionally copies across the
length and flags members and into the trailing buf flexible array.
Split the copy so that the compiler can better reason about (the lack
of) buffer overflows here. Avoid the run-time false positive warning:

  memcpy: detected field-spanning write (size 12) of single field "&meta->length" at drivers/media/usb/uvc/uvc_video.c:1355 (size 1)

Additionally fix a typo in the documentation for struct uvc_meta_buf.

Reported-by: ionut_n2001@yahoo.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216810
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 4 +++-
 include/uapi/linux/uvcvideo.h     | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 53ea225972478..0d3a3b697b2d8 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1352,7 +1352,9 @@ static void uvc_video_decode_meta(struct uvc_streaming *stream,
 	if (has_scr)
 		memcpy(stream->clock.last_scr, scr, 6);
 
-	memcpy(&meta->length, mem, length);
+	meta->length = mem[0];
+	meta->flags  = mem[1];
+	memcpy(meta->buf, &mem[2], length - 2);
 	meta_buf->bytesused += length + sizeof(meta->ns) + sizeof(meta->sof);
 
 	uvc_dbg(stream->dev, FRAME,
diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
index 8288137387c0d..a9d0a64007ba5 100644
--- a/include/uapi/linux/uvcvideo.h
+++ b/include/uapi/linux/uvcvideo.h
@@ -86,7 +86,7 @@ struct uvc_xu_control_query {
  * struct. The first two fields are added by the driver, they can be used for
  * clock synchronisation. The rest is an exact copy of a UVC payload header.
  * Only complete objects with complete buffers are included. Therefore it's
- * always sizeof(meta->ts) + sizeof(meta->sof) + meta->length bytes large.
+ * always sizeof(meta->ns) + sizeof(meta->sof) + meta->length bytes large.
  */
 struct uvc_meta_buf {
 	__u64 ns;
-- 
2.39.2

