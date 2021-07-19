Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4733CD854
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242734AbhGSOVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242736AbhGSOUj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9342C610D2;
        Mon, 19 Jul 2021 15:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706879;
        bh=Qbe14ViApLo4BnwrGsChjVqOq0qVtB+nCq9Q2MjtzcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnfpsV1n3ul+HjmCwU8flFWGprY8CFVe1ZNlh9uaZtg8wfALS41ARZcUJCyoOKd7R
         p8JgBoDMVbtqn5i7EfwzcXx6OhDjx9lMkFSQAIJPJqAG8dDpO/avNI1LCj8v3dbBe2
         sUGQ9ScNSTC9SiMdcJQF4BRlHQuAR37LkYKeFJtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+af4fa391ef18efdd5f69@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 4.4 136/188] media: zr364xx: fix memory leak in zr364xx_start_readpipe
Date:   Mon, 19 Jul 2021 16:52:00 +0200
Message-Id: <20210719144940.934426492@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 0a045eac8d0427b64577a24d74bb8347c905ac65 upstream.

syzbot reported memory leak in zr364xx driver.
The problem was in non-freed urb in case of
usb_submit_urb() fail.

backtrace:
  [<ffffffff82baedf6>] kmalloc include/linux/slab.h:561 [inline]
  [<ffffffff82baedf6>] usb_alloc_urb+0x66/0xe0 drivers/usb/core/urb.c:74
  [<ffffffff82f7cce8>] zr364xx_start_readpipe+0x78/0x130 drivers/media/usb/zr364xx/zr364xx.c:1022
  [<ffffffff84251dfc>] zr364xx_board_init drivers/media/usb/zr364xx/zr364xx.c:1383 [inline]
  [<ffffffff84251dfc>] zr364xx_probe+0x6a3/0x851 drivers/media/usb/zr364xx/zr364xx.c:1516
  [<ffffffff82bb6507>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
  [<ffffffff826018a9>] really_probe+0x159/0x500 drivers/base/dd.c:576

Fixes: ccbf035ae5de ("V4L/DVB (12278): zr364xx: implement V4L2_CAP_STREAMING")
Cc: stable@vger.kernel.org
Reported-by: syzbot+af4fa391ef18efdd5f69@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/zr364xx/zr364xx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1068,6 +1068,7 @@ static int zr364xx_start_readpipe(struct
 	DBG("submitting URB %p\n", pipe_info->stream_urb);
 	retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
 	if (retval) {
+		usb_free_urb(pipe_info->stream_urb);
 		printk(KERN_ERR KBUILD_MODNAME ": start read pipe failed\n");
 		return retval;
 	}


