Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C53F3CA98E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241673AbhGOTH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:07:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:45710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242775AbhGOTGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:06:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 313D5613DF;
        Thu, 15 Jul 2021 19:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375759;
        bh=2HI+/sRWXFFVhfZRSSABrrORznPJcyMpA1UMZaKJhBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRkDwg8pwplLMdTFoCh3XVIfMtdWoIhi45euPwhHX2aB95nhxy67kqQyJO0I96Mh8
         V3oP/8DGWFNJvtu5Jpwj+vZEVCgtOClKI1qDkEbcmNURIE9jrkFv/1UWWVRA0sMmRG
         +E33Dy92IcPmpq5rzKL+H140+28d4KAXk9I3wxqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+af4fa391ef18efdd5f69@syzkaller.appspotmail.com,
        Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.12 224/242] media: zr364xx: fix memory leak in zr364xx_start_readpipe
Date:   Thu, 15 Jul 2021 20:39:46 +0200
Message-Id: <20210715182632.381864812@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
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
@@ -1032,6 +1032,7 @@ static int zr364xx_start_readpipe(struct
 	DBG("submitting URB %p\n", pipe_info->stream_urb);
 	retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
 	if (retval) {
+		usb_free_urb(pipe_info->stream_urb);
 		printk(KERN_ERR KBUILD_MODNAME ": start read pipe failed\n");
 		return retval;
 	}


