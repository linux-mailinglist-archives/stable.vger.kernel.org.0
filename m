Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61416462784
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:05:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbhK2XHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236242AbhK2XEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:04:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1138EC1A0D2D;
        Mon, 29 Nov 2021 10:36:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC315B815CC;
        Mon, 29 Nov 2021 18:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB891C53FAD;
        Mon, 29 Nov 2021 18:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210999;
        bh=FAIUCb9/xtIEC7SuMX0DxKhfAjPgwxMfuF8K8qCYZto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pFWplqfU+l1A6P/y9eL01LpFi/Zm5cTH8J0/1fcfwpbbccoHes5hahFWkpPICI6y2
         DEnYegZ5WVDCd+FW9ify9jFZFoJHkGNgEfdtiNrXLtGjjY+Vp5dJkxLu0C3AczbCL2
         HqtooeEEzsbX6x41JeljLhWcRK7fcuEQ1NbQGSb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/179] media: v4l2-core: fix VIDIOC_DQEVENT handling on non-x86
Date:   Mon, 29 Nov 2021 19:17:43 +0100
Message-Id: <20211129181721.221468270@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 678d92b6126b9f55419b6a51ef0a88bce2ef2f20 ]

My previous bugfix addressed an API inconsistency found by syzbot,
and it correctly fixed the issue on x86-64 machines, which now behave
correctly for both native and compat tasks.

Unfortunately, John found that the patch broke compat mode on all other
architectures, as they can no longer rely on the VIDIOC_DQEVENT_TIME32
code from the native handler as a fallback in the compat code.

The best way I can see for addressing this is to generalize the
VIDIOC_DQEVENT32_TIME32 code from x86 and use that for all architectures,
leaving only the VIDIOC_DQEVENT32 variant as x86 specific. The original
code was trying to be clever and use the same conversion helper for native
32-bit code and compat mode, but that turned out to be too obscure so
even I missed that bit I had introduced myself when I made the fix.

Fixes: c344f07aa1b4 ("media: v4l2-core: ignore native time32 ioctls on 64-bit")
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 41 ++++++++-----------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index 47aff3b197426..80aaf07b16f28 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -744,10 +744,6 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *p64,
 /*
  * x86 is the only compat architecture with different struct alignment
  * between 32-bit and 64-bit tasks.
- *
- * On all other architectures, v4l2_event32 and v4l2_event32_time32 are
- * the same as v4l2_event and v4l2_event_time32, so we can use the native
- * handlers, converting v4l2_event to v4l2_event_time32 if necessary.
  */
 struct v4l2_event32 {
 	__u32				type;
@@ -765,21 +761,6 @@ struct v4l2_event32 {
 	__u32				reserved[8];
 };
 
-#ifdef CONFIG_COMPAT_32BIT_TIME
-struct v4l2_event32_time32 {
-	__u32				type;
-	union {
-		compat_s64		value64;
-		__u8			data[64];
-	} u;
-	__u32				pending;
-	__u32				sequence;
-	struct old_timespec32		timestamp;
-	__u32				id;
-	__u32				reserved[8];
-};
-#endif
-
 static int put_v4l2_event32(struct v4l2_event *p64,
 			    struct v4l2_event32 __user *p32)
 {
@@ -795,7 +776,22 @@ static int put_v4l2_event32(struct v4l2_event *p64,
 	return 0;
 }
 
+#endif
+
 #ifdef CONFIG_COMPAT_32BIT_TIME
+struct v4l2_event32_time32 {
+	__u32				type;
+	union {
+		compat_s64		value64;
+		__u8			data[64];
+	} u;
+	__u32				pending;
+	__u32				sequence;
+	struct old_timespec32		timestamp;
+	__u32				id;
+	__u32				reserved[8];
+};
+
 static int put_v4l2_event32_time32(struct v4l2_event *p64,
 				   struct v4l2_event32_time32 __user *p32)
 {
@@ -811,7 +807,6 @@ static int put_v4l2_event32_time32(struct v4l2_event *p64,
 	return 0;
 }
 #endif
-#endif
 
 struct v4l2_edid32 {
 	__u32 pad;
@@ -873,9 +868,7 @@ static int put_v4l2_edid32(struct v4l2_edid *p64,
 #define VIDIOC_QUERYBUF32_TIME32	_IOWR('V',  9, struct v4l2_buffer32_time32)
 #define VIDIOC_QBUF32_TIME32		_IOWR('V', 15, struct v4l2_buffer32_time32)
 #define VIDIOC_DQBUF32_TIME32		_IOWR('V', 17, struct v4l2_buffer32_time32)
-#ifdef CONFIG_X86_64
 #define	VIDIOC_DQEVENT32_TIME32		_IOR ('V', 89, struct v4l2_event32_time32)
-#endif
 #define VIDIOC_PREPARE_BUF32_TIME32	_IOWR('V', 93, struct v4l2_buffer32_time32)
 #endif
 
@@ -929,10 +922,10 @@ unsigned int v4l2_compat_translate_cmd(unsigned int cmd)
 #ifdef CONFIG_X86_64
 	case VIDIOC_DQEVENT32:
 		return VIDIOC_DQEVENT;
+#endif
 #ifdef CONFIG_COMPAT_32BIT_TIME
 	case VIDIOC_DQEVENT32_TIME32:
 		return VIDIOC_DQEVENT;
-#endif
 #endif
 	}
 	return cmd;
@@ -1025,10 +1018,10 @@ int v4l2_compat_put_user(void __user *arg, void *parg, unsigned int cmd)
 #ifdef CONFIG_X86_64
 	case VIDIOC_DQEVENT32:
 		return put_v4l2_event32(parg, arg);
+#endif
 #ifdef CONFIG_COMPAT_32BIT_TIME
 	case VIDIOC_DQEVENT32_TIME32:
 		return put_v4l2_event32_time32(parg, arg);
-#endif
 #endif
 	}
 	return 0;
-- 
2.33.0



