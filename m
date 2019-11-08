Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 450D8F47D6
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 12:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391462AbfKHLqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:34964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391456AbfKHLqx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:46:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AF1522459;
        Fri,  8 Nov 2019 11:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213613;
        bh=pK3JiVdDG4pG661QQcM6zzwb4qeK05/7/x0H6NkhWIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzXTv3ypcivacx+jgK7OxE9bY7cmpiv2xa3pSxgxMWMtdCdxcKglyAq+Ihq0p0Zn0
         79HQf9CJoUHCgKM2pWgvsx/tPcWjU3SYyq5Jrzo2xfSaWWk2y2Cdi8RVTdUPREtnU0
         8czwMVeEQ0HTcAVS7eRU1vPUVF/px0Azw7Szq5Bc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 48/64] media: dvb: fix compat ioctl translation
Date:   Fri,  8 Nov 2019 06:45:29 -0500
Message-Id: <20191108114545.15351-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114545.15351-1-sashal@kernel.org>
References: <20191108114545.15351-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 1ccbeeb888ac33627d91f1ccf0b84ef3bcadef24 ]

The VIDEO_GET_EVENT and VIDEO_STILLPICTURE was added back in 2005 but
it never worked because the command number is wrong.

Using the right command number means we have a better chance of them
actually doing the right thing, though clearly nobody has ever tried
it successfully.

I noticed these while auditing the remaining users of compat_time_t
for y2038 bugs. This one is fine in that regard, it just never did
anything.

Fixes: 6e87abd0b8cb ("[DVB]: Add compat ioctl handling.")

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/compat_ioctl.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 4b7da4409c60c..5b832e83772a6 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -160,6 +160,7 @@ struct compat_video_event {
 		unsigned int frame_rate;
 	} u;
 };
+#define VIDEO_GET_EVENT32 _IOR('o', 28, struct compat_video_event)
 
 static int do_video_get_event(struct file *file,
 		unsigned int cmd, struct compat_video_event __user *up)
@@ -171,7 +172,7 @@ static int do_video_get_event(struct file *file,
 	if (kevent == NULL)
 		return -EFAULT;
 
-	err = do_ioctl(file, cmd, (unsigned long)kevent);
+	err = do_ioctl(file, VIDEO_GET_EVENT, (unsigned long)kevent);
 	if (!err) {
 		err  = convert_in_user(&kevent->type, &up->type);
 		err |= convert_in_user(&kevent->timestamp, &up->timestamp);
@@ -190,6 +191,7 @@ struct compat_video_still_picture {
         compat_uptr_t iFrame;
         int32_t size;
 };
+#define VIDEO_STILLPICTURE32 _IOW('o', 30, struct compat_video_still_picture)
 
 static int do_video_stillpicture(struct file *file,
 		unsigned int cmd, struct compat_video_still_picture __user *up)
@@ -212,7 +214,7 @@ static int do_video_stillpicture(struct file *file,
 	if (err)
 		return -EFAULT;
 
-	err = do_ioctl(file, cmd, (unsigned long) up_native);
+	err = do_ioctl(file, VIDEO_STILLPICTURE, (unsigned long) up_native);
 
 	return err;
 }
@@ -1484,9 +1486,9 @@ static long do_ioctl_trans(unsigned int cmd,
 		return rtc_ioctl(file, cmd, argp);
 
 	/* dvb */
-	case VIDEO_GET_EVENT:
+	case VIDEO_GET_EVENT32:
 		return do_video_get_event(file, cmd, argp);
-	case VIDEO_STILLPICTURE:
+	case VIDEO_STILLPICTURE32:
 		return do_video_stillpicture(file, cmd, argp);
 	case VIDEO_SET_SPU_PALETTE:
 		return do_video_set_spu_palette(file, cmd, argp);
-- 
2.20.1

