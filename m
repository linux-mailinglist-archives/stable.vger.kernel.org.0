Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755F93CAB7C
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343508AbhGOTUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243412AbhGOTSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7B5161158;
        Thu, 15 Jul 2021 19:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376419;
        bh=2bHFb3E+HFcUoTnG9M5Bm+wjMeg1RvtsMh3EYOc2xIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xecu3Ww7YgFh/2OexSYdNiyJK0KvhfyjtG2ujAIfLXveWBDTnx5boPQlrJC2eB8Dq
         JN2DJy8YoCuVU9V7WlRfCsDmpMpmMGOC0s6ZJehCgCivl3zt7UXVJoO0fibspoX+wf
         dNkWpk/jOkgUlMY9FFbRejtX5X2YwcGkrEwFU5lo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.13 264/266] media: v4l2-core: explicitly clear ioctl input data
Date:   Thu, 15 Jul 2021 20:40:19 +0200
Message-Id: <20210715182653.481266998@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 7b53cca764f9b291b7907fcd39d9e66ad728ee0b upstream.

As seen from a recent syzbot bug report, mistakes in the compat ioctl
implementation can lead to uninitialized kernel stack data getting used
as input for driver ioctl handlers.

The reported bug is now fixed, but it's possible that other related
bugs are still present or get added in the future. As the drivers need
to check user input already, the possible impact is fairly low, but it
might still cause an information leak.

To be on the safe side, always clear the entire ioctl buffer before
calling the conversion handler functions that are meant to initialize
them.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -3124,8 +3124,10 @@ static int video_get_user(void __user *a
 		if (copy_from_user(parg, (void __user *)arg, n))
 			err = -EFAULT;
 	} else if (in_compat_syscall()) {
+		memset(parg, 0, n);
 		err = v4l2_compat_get_user(arg, parg, cmd);
 	} else {
+		memset(parg, 0, n);
 #if !defined(CONFIG_64BIT) && defined(CONFIG_COMPAT_32BIT_TIME)
 		switch (cmd) {
 		case VIDIOC_QUERYBUF_TIME32:


