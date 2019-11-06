Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C71F1F39
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 20:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732141AbfKFTrn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Nov 2019 14:47:43 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:33597 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbfKFTrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Nov 2019 14:47:43 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MRTEp-1iG9aU48ov-00NOI1; Wed, 06 Nov 2019 20:47:28 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        y2038@lists.linaro.org,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Daniel Mentz <danielmentz@google.com>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Subject: [PATCH v3 3/8] media: v4l2-core: ignore native command codes
Date:   Wed,  6 Nov 2019 20:47:10 +0100
Message-Id: <20191106194715.2238044-4-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
In-Reply-To: <20191106194715.2238044-1-arnd@arndb.de>
References: <20191106194715.2238044-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Wjz4+hIcGWg831trgGTz9lydjzlKkTmAxk7jsyabPcLGvW64b+y
 laQcE/SJ0DWMYAst/2Kp8p7Wd2YwQr1j00fcGPDBySe/8D6MkTVktfoP5Fpp39k0FjXXGJd
 1smQJxmvx89Ax7I+zCty1Bx9g7fNmWOB7PbwoV9l+DiGgeF9LzoqEQ1wljxYMmaPoQ1FA2t
 f5A/q9wf+lsPIhD8m9c9Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:plw5zs7+EXg=:NvC+gbDnMiFh56yYUbNsjD
 h3hIB0FrgTPjOOb6VqdNpVbU7R10OcEYePX6AInUklAw/dTXZAYrsukz7yBFekPzCLfIP//Ty
 v2EbaSCqorTOKXpqAaBQz/OzRCIT3bHJpCqa2ETwiXAPi3BQtGShdSxfHgT0pJuM8c3I0d2R1
 PH03PgDpLy919Rjm/TL4PpFC6/P8NBDe45mFEqKMGRHw0TUuLW/4hnJDkLFlGJS9FiVTBkRqm
 MIsm/B0I0jVSGW5cD62NyKchStv3o7sOsOC5KWkkX2By5yhVUELEtKzqZg+8ndyw57Z3nd4HO
 e7D1mVbbbFijfQOQC+Ap9PYlq2gunMAHoZ2TjivfBYOyrZ0dYFMm8JOwrpyF7phdTxQkUz2mg
 QcYJ4AAWfYM9jXkyvgqrLGLMKGBJsjGQU6SQt3dmwGgtq33A2m+9N/hAaZpMdjvmgirqzTYr7
 0IbmMBOQkGLy08eFuqobWtCyfSrAxeUq2mJgYX1W5u9WPpAB4ex2L26IsNYuKakHF/MMpcMZb
 mFtu1SHZOsbCDY4Dkl+v2Iv6VoqnxzP1td/92c0Xh7ZNCQfB/UoGemLj+YTTzGrWiLaCB9Pax
 WhwRHJjz0eB9UU1DhOlRbvhyiIaLwiOThg/ZzBgaQkppy17PqXWa8ppUMZ/mrM+UkWN8ikwf8
 vC6t5PUBRhgmma2CMqCQcHrK2zabLrdYaTjvP2co4hnmrdeol0nCj6WEtHE8gIdyJXrejg2d/
 mJ+hRjX1nne+ivlXO3qduk1NJ/i+tCbCiVwi+6YfGwZzUQrq5pwypzj1W1kHmhhN44FlSyP82
 aj74o1XL4UvqZ+zdL/Rby01pkDU3VsU2LMFfa+yXAUPiJhK6cEGMF+1InZFJOE5d9vfEBAmws
 sh248LnAA4o2PICJtx0w==
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

