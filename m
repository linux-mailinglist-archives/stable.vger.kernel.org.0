Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A326AA2E5
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232777AbjCCVva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbjCCVtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:49:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CD86C19C;
        Fri,  3 Mar 2023 13:46:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89064B81A29;
        Fri,  3 Mar 2023 21:45:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797C4C433A0;
        Fri,  3 Mar 2023 21:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879943;
        bh=3roV8uW1v31n5edmx9W0JG+kRuQVOwex91joNPZwoSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i7k6ykjkZFPalh0D9BritICqdwA6GdY2ynIsenJ2CVPpL1rxC+ruN0DRj3gIwBcCc
         JNY+aVbpS6/9tppRaNnapX5DaPLmqNfxE+PUE8XlJ0XpJuh7u9Yprc3sIEEjMeytzw
         AW7UiHk0rDS5D5PbrXc0KwmKpnLSLgiOxX/lWBNO84lT7ueLVM9BlCp/Rea5l9LxiJ
         mW1BRGFjxosntulYabPm3HYLzuMlwyVN/557YrzLMpiPGj1EsuypyeNp3Xa+lVHyR8
         FgHF431vCTjZHXRRT9RPYpp5bIm7bLQWm8qAawzmgkcl4ykfipwBFwTx4Q9qV6KZpA
         EMSPMYzM+s+IA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>, ionut_n2001@yahoo.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>, mchehab@kernel.org,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/50] media: uvcvideo: Silence memcpy() run-time false positive warnings
Date:   Fri,  3 Mar 2023 16:44:48 -0500
Message-Id: <20230303214531.1450154-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index af2c6cb9fa3c4..f477cfbbb905a 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1334,7 +1334,9 @@ static void uvc_video_decode_meta(struct uvc_streaming *stream,
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

