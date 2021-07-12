Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160693C4D18
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242386AbhGLHL4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:11:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244134AbhGLHK1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B497610CD;
        Mon, 12 Jul 2021 07:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073583;
        bh=meGSFOMCtdiAnXguur9WjgDTfZSBr3cYmsBkn61VCDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ImTuFIHCqfYL6REZZNqX1rj5GqevUrayxgqIzLaqDyiznxcYI/w75C8hB4LAO+o7G
         /ajGey74R8oDWfkirSZDsvao+lWGD6zr3uVLcrdsP0HgtA6kpuGQ8eOWBLbeqz/P83
         p8sgxqjJxfbTR2BPa8SHGqCfpjscuEHg7UXS4U+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 290/700] media: subdev: remove VIDIOC_DQEVENT_TIME32 handling
Date:   Mon, 12 Jul 2021 08:06:13 +0200
Message-Id: <20210712061007.077175053@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 765ba251d2522e2a0daa2f0793fd0f0ce34816ec ]

Converting the VIDIOC_DQEVENT_TIME32/VIDIOC_DQEVENT32/
VIDIOC_DQEVENT32_TIME32 arguments to the canonical form is done in common
code, but for some reason I ended up adding another conversion helper to
subdev_do_ioctl() as well. I must have concluded that this does not go
through the common conversion, but it has done that since the ioctl
handler was first added.

I assume this one is harmless as there should be no way to arrive here
from user space if CONFIG_COMPAT_32BIT_TIME is set, but since it is dead
code, it should just get removed.

On a 64-bit architecture, as well as a 32-bit architecture without
CONFIG_COMPAT_32BIT_TIME, handling this command is a mistake,
and the kernel should return an error.

Fixes: 1a6c0b36dd19 ("media: v4l2-core: fix VIDIOC_DQEVENT for time64 ABI")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 956dafab43d4..bf3aa9252458 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -428,30 +428,6 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 
 		return v4l2_event_dequeue(vfh, arg, file->f_flags & O_NONBLOCK);
 
-	case VIDIOC_DQEVENT_TIME32: {
-		struct v4l2_event_time32 *ev32 = arg;
-		struct v4l2_event ev = { };
-
-		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_EVENTS))
-			return -ENOIOCTLCMD;
-
-		rval = v4l2_event_dequeue(vfh, &ev, file->f_flags & O_NONBLOCK);
-
-		*ev32 = (struct v4l2_event_time32) {
-			.type		= ev.type,
-			.pending	= ev.pending,
-			.sequence	= ev.sequence,
-			.timestamp.tv_sec  = ev.timestamp.tv_sec,
-			.timestamp.tv_nsec = ev.timestamp.tv_nsec,
-			.id		= ev.id,
-		};
-
-		memcpy(&ev32->u, &ev.u, sizeof(ev.u));
-		memcpy(&ev32->reserved, &ev.reserved, sizeof(ev.reserved));
-
-		return rval;
-	}
-
 	case VIDIOC_SUBSCRIBE_EVENT:
 		return v4l2_subdev_call(sd, core, subscribe_event, vfh, arg);
 
-- 
2.30.2



