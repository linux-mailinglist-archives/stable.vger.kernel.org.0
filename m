Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDFF12084A
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 15:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfLPOPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 09:15:23 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:49881 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728072AbfLPOPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 09:15:23 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MDy54-1iWzmS1RJc-009zVF; Mon, 16 Dec 2019 15:15:16 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     linux-media@vger.kernel.org, mchehab@kernel.org,
        y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, stable@vger.kernel.org
Subject: [PATCH v6 3/8] media: v4l2-core: compat: ignore native command codes
Date:   Mon, 16 Dec 2019 15:15:01 +0100
Message-Id: <20191216141506.121728-4-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191216141506.121728-1-arnd@arndb.de>
References: <20191216141506.121728-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:F+gxqVSWhEt8sdRjM5TYRL1zL7TfqOeKoKt/F35+PfKIantReTR
 uMRoYKZ5nzFNwyPmFncqqEMpHxovpvfC52FwWLiBPVxfWeIdwf7Bt7bT70abw15uC7W2QjH
 a3sg6lLtsg0zPhXP7EUKRV7mGnQYF51CwGvoKy5blnTCPQnhMfMzzF0w6XEp/4FuFN8ayBn
 hoG1dwd/hN0rsb8CbtM/w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qyTBv4huTYg=:f668tiGbN00UEjf3IyvTfq
 zNiZnyScMVM62rAFLxUoQ2HevKluRn7Ailxm8lUTrZVPR1dLe9+hPDurspCiqn3allRnMR2ZC
 S9ZRLX1MB2ZHa0uFaFOY05yGQ0CP/FWRnGnvqUY/Kq0hduc7/CVh9tedpZfV4leEbeep2k2WM
 7S6AODJT2Q2TmrYS7KvKep77ua9nv2PHIdPav0BcL7qX5jhVnoAb493r/RAu4MXURLBbuaQlp
 yTr/3qlsBbKyQ1UjVFBXBG8W6x8tv+LFdpHNNKkgSgzL/gjyPPDOSjUIo9V1pDV+0iwzGnPFS
 KYoo0zAmWZmz3N0aYtLrwGjffxfV2NK4QPnaCpBW6iXumE7aaQvj+9rhLm7uaufyFIfUJQbfL
 xu9JtdM2YGP9bxNf5ElUbV1K4fD/+eO1AKzIDCvjU14o1OSOvxYPro/si/rPNBqhOhuR7oSfr
 TV2yLK/yjAXnJQsJn1WEMLEsDHSAId1BHmPfclpgH8o6zJmrsZrvCaSzq9Yx57hHe7Egcfs81
 gMhDvFuLpCA5/hUii677/7D3kEIIZ69wpZS9OEGhj+dTiPXeeFp6t/l9VM8ys92XyZqmns/AB
 5zJEi6QWWEdUcze04O3mIQWMe65b21pl8WoGxU+nqs/l0A6VnZs25uiU/xKWQ2XS7Idd7X+il
 lZh/uouJGTb3OsphEDJWf7U5GOrOn6jeSg1wKIkLAER9CmHy6r5J3FsdnIRa1Ebjc2PzSUDNw
 bgM5OhvLWHT9AY8W/BiW1Zg8vC0KCeZwQFN1kjen+MlVi7tDWW1JNpqPnl2tc8tefscroUcoR
 aonbDL9ZHgnfKc5KIOi78NyekwkzhSN0ZjZexYDFFHiPWbvDjTk5AB/hiN34uF12C2YxIgMD+
 NaSY13pEOd1u8jlrCSMw==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The do_video_ioctl() compat handler converts the compat command
codes into the native ones before processing further, but this
causes problems for 32-bit user applications that pass a command
code that matches a 64-bit native number, which will then be
handled the same way.

Specifically, this breaks VIDIOC_DQEVENT_TIME from user space
applications with 64-bit time_t, as the structure layout is
the same as the native 64-bit layout on many architectures
(x86 being the notable exception).

Change the handler to use the converted command code only for
passing into the native ioctl handler, not for deciding on the
conversion, in order to make the compat behavior match the
native behavior.

Actual support for the 64-bit time_t version of VIDIOC_DQEVENT_TIME
and other commands still needs to be added in a separate patch.

Cc: stable@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 148 +++++++++---------
 1 file changed, 75 insertions(+), 73 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index e1eaf1135c7f..7ad6db8dd9f6 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -1183,36 +1183,38 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	u32 aux_space;
 	int compatible_arg = 1;
 	long err = 0;
+	unsigned int ncmd;
 
 	/*
 	 * 1. When struct size is different, converts the command.
 	 */
 	switch (cmd) {
-	case VIDIOC_G_FMT32: cmd = VIDIOC_G_FMT; break;
-	case VIDIOC_S_FMT32: cmd = VIDIOC_S_FMT; break;
-	case VIDIOC_QUERYBUF32: cmd = VIDIOC_QUERYBUF; break;
-	case VIDIOC_G_FBUF32: cmd = VIDIOC_G_FBUF; break;
-	case VIDIOC_S_FBUF32: cmd = VIDIOC_S_FBUF; break;
-	case VIDIOC_QBUF32: cmd = VIDIOC_QBUF; break;
-	case VIDIOC_DQBUF32: cmd = VIDIOC_DQBUF; break;
-	case VIDIOC_ENUMSTD32: cmd = VIDIOC_ENUMSTD; break;
-	case VIDIOC_ENUMINPUT32: cmd = VIDIOC_ENUMINPUT; break;
-	case VIDIOC_TRY_FMT32: cmd = VIDIOC_TRY_FMT; break;
-	case VIDIOC_G_EXT_CTRLS32: cmd = VIDIOC_G_EXT_CTRLS; break;
-	case VIDIOC_S_EXT_CTRLS32: cmd = VIDIOC_S_EXT_CTRLS; break;
-	case VIDIOC_TRY_EXT_CTRLS32: cmd = VIDIOC_TRY_EXT_CTRLS; break;
-	case VIDIOC_DQEVENT32: cmd = VIDIOC_DQEVENT; break;
-	case VIDIOC_OVERLAY32: cmd = VIDIOC_OVERLAY; break;
-	case VIDIOC_STREAMON32: cmd = VIDIOC_STREAMON; break;
-	case VIDIOC_STREAMOFF32: cmd = VIDIOC_STREAMOFF; break;
-	case VIDIOC_G_INPUT32: cmd = VIDIOC_G_INPUT; break;
-	case VIDIOC_S_INPUT32: cmd = VIDIOC_S_INPUT; break;
-	case VIDIOC_G_OUTPUT32: cmd = VIDIOC_G_OUTPUT; break;
-	case VIDIOC_S_OUTPUT32: cmd = VIDIOC_S_OUTPUT; break;
-	case VIDIOC_CREATE_BUFS32: cmd = VIDIOC_CREATE_BUFS; break;
-	case VIDIOC_PREPARE_BUF32: cmd = VIDIOC_PREPARE_BUF; break;
-	case VIDIOC_G_EDID32: cmd = VIDIOC_G_EDID; break;
-	case VIDIOC_S_EDID32: cmd = VIDIOC_S_EDID; break;
+	case VIDIOC_G_FMT32: ncmd = VIDIOC_G_FMT; break;
+	case VIDIOC_S_FMT32: ncmd = VIDIOC_S_FMT; break;
+	case VIDIOC_QUERYBUF32: ncmd = VIDIOC_QUERYBUF; break;
+	case VIDIOC_G_FBUF32: ncmd = VIDIOC_G_FBUF; break;
+	case VIDIOC_S_FBUF32: ncmd = VIDIOC_S_FBUF; break;
+	case VIDIOC_QBUF32: ncmd = VIDIOC_QBUF; break;
+	case VIDIOC_DQBUF32: ncmd = VIDIOC_DQBUF; break;
+	case VIDIOC_ENUMSTD32: ncmd = VIDIOC_ENUMSTD; break;
+	case VIDIOC_ENUMINPUT32: ncmd = VIDIOC_ENUMINPUT; break;
+	case VIDIOC_TRY_FMT32: ncmd = VIDIOC_TRY_FMT; break;
+	case VIDIOC_G_EXT_CTRLS32: ncmd = VIDIOC_G_EXT_CTRLS; break;
+	case VIDIOC_S_EXT_CTRLS32: ncmd = VIDIOC_S_EXT_CTRLS; break;
+	case VIDIOC_TRY_EXT_CTRLS32: ncmd = VIDIOC_TRY_EXT_CTRLS; break;
+	case VIDIOC_DQEVENT32: ncmd = VIDIOC_DQEVENT; break;
+	case VIDIOC_OVERLAY32: ncmd = VIDIOC_OVERLAY; break;
+	case VIDIOC_STREAMON32: ncmd = VIDIOC_STREAMON; break;
+	case VIDIOC_STREAMOFF32: ncmd = VIDIOC_STREAMOFF; break;
+	case VIDIOC_G_INPUT32: ncmd = VIDIOC_G_INPUT; break;
+	case VIDIOC_S_INPUT32: ncmd = VIDIOC_S_INPUT; break;
+	case VIDIOC_G_OUTPUT32: ncmd = VIDIOC_G_OUTPUT; break;
+	case VIDIOC_S_OUTPUT32: ncmd = VIDIOC_S_OUTPUT; break;
+	case VIDIOC_CREATE_BUFS32: ncmd = VIDIOC_CREATE_BUFS; break;
+	case VIDIOC_PREPARE_BUF32: ncmd = VIDIOC_PREPARE_BUF; break;
+	case VIDIOC_G_EDID32: ncmd = VIDIOC_G_EDID; break;
+	case VIDIOC_S_EDID32: ncmd = VIDIOC_S_EDID; break;
+	default: ncmd = cmd; break;
 	}
 
 	/*
@@ -1221,11 +1223,11 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	 * argument into it.
 	 */
 	switch (cmd) {
-	case VIDIOC_OVERLAY:
-	case VIDIOC_STREAMON:
-	case VIDIOC_STREAMOFF:
-	case VIDIOC_S_INPUT:
-	case VIDIOC_S_OUTPUT:
+	case VIDIOC_OVERLAY32:
+	case VIDIOC_STREAMON32:
+	case VIDIOC_STREAMOFF32:
+	case VIDIOC_S_INPUT32:
+	case VIDIOC_S_OUTPUT32:
 		err = alloc_userspace(sizeof(unsigned int), 0, &new_p64);
 		if (!err && assign_in_user((unsigned int __user *)new_p64,
 					   (compat_uint_t __user *)p32))
@@ -1233,23 +1235,23 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		compatible_arg = 0;
 		break;
 
-	case VIDIOC_G_INPUT:
-	case VIDIOC_G_OUTPUT:
+	case VIDIOC_G_INPUT32:
+	case VIDIOC_G_OUTPUT32:
 		err = alloc_userspace(sizeof(unsigned int), 0, &new_p64);
 		compatible_arg = 0;
 		break;
 
-	case VIDIOC_G_EDID:
-	case VIDIOC_S_EDID:
+	case VIDIOC_G_EDID32:
+	case VIDIOC_S_EDID32:
 		err = alloc_userspace(sizeof(struct v4l2_edid), 0, &new_p64);
 		if (!err)
 			err = get_v4l2_edid32(new_p64, p32);
 		compatible_arg = 0;
 		break;
 
-	case VIDIOC_G_FMT:
-	case VIDIOC_S_FMT:
-	case VIDIOC_TRY_FMT:
+	case VIDIOC_G_FMT32:
+	case VIDIOC_S_FMT32:
+	case VIDIOC_TRY_FMT32:
 		err = bufsize_v4l2_format(p32, &aux_space);
 		if (!err)
 			err = alloc_userspace(sizeof(struct v4l2_format),
@@ -1262,7 +1264,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		compatible_arg = 0;
 		break;
 
-	case VIDIOC_CREATE_BUFS:
+	case VIDIOC_CREATE_BUFS32:
 		err = bufsize_v4l2_create(p32, &aux_space);
 		if (!err)
 			err = alloc_userspace(sizeof(struct v4l2_create_buffers),
@@ -1275,10 +1277,10 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		compatible_arg = 0;
 		break;
 
-	case VIDIOC_PREPARE_BUF:
-	case VIDIOC_QUERYBUF:
-	case VIDIOC_QBUF:
-	case VIDIOC_DQBUF:
+	case VIDIOC_PREPARE_BUF32:
+	case VIDIOC_QUERYBUF32:
+	case VIDIOC_QBUF32:
+	case VIDIOC_DQBUF32:
 		err = bufsize_v4l2_buffer(p32, &aux_space);
 		if (!err)
 			err = alloc_userspace(sizeof(struct v4l2_buffer),
@@ -1291,7 +1293,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		compatible_arg = 0;
 		break;
 
-	case VIDIOC_S_FBUF:
+	case VIDIOC_S_FBUF32:
 		err = alloc_userspace(sizeof(struct v4l2_framebuffer), 0,
 				      &new_p64);
 		if (!err)
@@ -1299,13 +1301,13 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		compatible_arg = 0;
 		break;
 
-	case VIDIOC_G_FBUF:
+	case VIDIOC_G_FBUF32:
 		err = alloc_userspace(sizeof(struct v4l2_framebuffer), 0,
 				      &new_p64);
 		compatible_arg = 0;
 		break;
 
-	case VIDIOC_ENUMSTD:
+	case VIDIOC_ENUMSTD32:
 		err = alloc_userspace(sizeof(struct v4l2_standard), 0,
 				      &new_p64);
 		if (!err)
@@ -1313,16 +1315,16 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		compatible_arg = 0;
 		break;
 
-	case VIDIOC_ENUMINPUT:
+	case VIDIOC_ENUMINPUT32:
 		err = alloc_userspace(sizeof(struct v4l2_input), 0, &new_p64);
 		if (!err)
 			err = get_v4l2_input32(new_p64, p32);
 		compatible_arg = 0;
 		break;
 
-	case VIDIOC_G_EXT_CTRLS:
-	case VIDIOC_S_EXT_CTRLS:
-	case VIDIOC_TRY_EXT_CTRLS:
+	case VIDIOC_G_EXT_CTRLS32:
+	case VIDIOC_S_EXT_CTRLS32:
+	case VIDIOC_TRY_EXT_CTRLS32:
 		err = bufsize_v4l2_ext_controls(p32, &aux_space);
 		if (!err)
 			err = alloc_userspace(sizeof(struct v4l2_ext_controls),
@@ -1334,7 +1336,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 		}
 		compatible_arg = 0;
 		break;
-	case VIDIOC_DQEVENT:
+	case VIDIOC_DQEVENT32:
 		err = alloc_userspace(sizeof(struct v4l2_event), 0, &new_p64);
 		compatible_arg = 0;
 		break;
@@ -1352,9 +1354,9 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	 * Otherwise, it will pass the newly allocated @new_p64 argument.
 	 */
 	if (compatible_arg)
-		err = native_ioctl(file, cmd, (unsigned long)p32);
+		err = native_ioctl(file, ncmd, (unsigned long)p32);
 	else
-		err = native_ioctl(file, cmd, (unsigned long)new_p64);
+		err = native_ioctl(file, ncmd, (unsigned long)new_p64);
 
 	if (err == -ENOTTY)
 		return err;
@@ -1370,13 +1372,13 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	 * the blocks to maximum allowed value.
 	 */
 	switch (cmd) {
-	case VIDIOC_G_EXT_CTRLS:
-	case VIDIOC_S_EXT_CTRLS:
-	case VIDIOC_TRY_EXT_CTRLS:
+	case VIDIOC_G_EXT_CTRLS32:
+	case VIDIOC_S_EXT_CTRLS32:
+	case VIDIOC_TRY_EXT_CTRLS32:
 		if (put_v4l2_ext_controls32(file, new_p64, p32))
 			err = -EFAULT;
 		break;
-	case VIDIOC_S_EDID:
+	case VIDIOC_S_EDID32:
 		if (put_v4l2_edid32(new_p64, p32))
 			err = -EFAULT;
 		break;
@@ -1389,49 +1391,49 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
 	 * the original 32 bits structure.
 	 */
 	switch (cmd) {
-	case VIDIOC_S_INPUT:
-	case VIDIOC_S_OUTPUT:
-	case VIDIOC_G_INPUT:
-	case VIDIOC_G_OUTPUT:
+	case VIDIOC_S_INPUT32:
+	case VIDIOC_S_OUTPUT32:
+	case VIDIOC_G_INPUT32:
+	case VIDIOC_G_OUTPUT32:
 		if (assign_in_user((compat_uint_t __user *)p32,
 				   ((unsigned int __user *)new_p64)))
 			err = -EFAULT;
 		break;
 
-	case VIDIOC_G_FBUF:
+	case VIDIOC_G_FBUF32:
 		err = put_v4l2_framebuffer32(new_p64, p32);
 		break;
 
-	case VIDIOC_DQEVENT:
+	case VIDIOC_DQEVENT32:
 		err = put_v4l2_event32(new_p64, p32);
 		break;
 
-	case VIDIOC_G_EDID:
+	case VIDIOC_G_EDID32:
 		err = put_v4l2_edid32(new_p64, p32);
 		break;
 
-	case VIDIOC_G_FMT:
-	case VIDIOC_S_FMT:
-	case VIDIOC_TRY_FMT:
+	case VIDIOC_G_FMT32:
+	case VIDIOC_S_FMT32:
+	case VIDIOC_TRY_FMT32:
 		err = put_v4l2_format32(new_p64, p32);
 		break;
 
-	case VIDIOC_CREATE_BUFS:
+	case VIDIOC_CREATE_BUFS32:
 		err = put_v4l2_create32(new_p64, p32);
 		break;
 
-	case VIDIOC_PREPARE_BUF:
-	case VIDIOC_QUERYBUF:
-	case VIDIOC_QBUF:
-	case VIDIOC_DQBUF:
+	case VIDIOC_PREPARE_BUF32:
+	case VIDIOC_QUERYBUF32:
+	case VIDIOC_QBUF32:
+	case VIDIOC_DQBUF32:
 		err = put_v4l2_buffer32(new_p64, p32);
 		break;
 
-	case VIDIOC_ENUMSTD:
+	case VIDIOC_ENUMSTD32:
 		err = put_v4l2_standard32(new_p64, p32);
 		break;
 
-	case VIDIOC_ENUMINPUT:
+	case VIDIOC_ENUMINPUT32:
 		err = put_v4l2_input32(new_p64, p32);
 		break;
 	}
-- 
2.20.0

