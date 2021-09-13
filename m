Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7825B40917C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343792AbhIMOBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343534AbhIMN7g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:59:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB90C613A4;
        Mon, 13 Sep 2021 13:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540239;
        bh=+KgFxSgNdFkMVgeqQhxhH1KWHyahO0U7bjcVk1OwuGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZYUGPrrkzra7kpv6wa94dU+WIHaCf43cDCxQ0uqctwYgnfrJ+0200jvPonWyOMXu4
         lZxakkNBALVCfD+ahTwoFD4Mv0LX3wABwa06k7+Sg6YVEibzxoBYU2VWsHjzZWre0r
         VtzNceQdISgiMn6ygRwYNHx/Y97B1VmcPvBaSPc4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 110/300] media: go7007: fix memory leak in go7007_usb_probe
Date:   Mon, 13 Sep 2021 15:12:51 +0200
Message-Id: <20210913131113.104415968@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 47d94dad8e64b2fc1d8f66ce7acf714f9462c60f ]

In commit 137641287eb4 ("go7007: add sanity checking for endpoints")
endpoint sanity check was introduced, but if check fails it simply
returns with leaked pointers.

Cutted log from my local syzbot instance:

BUG: memory leak
unreferenced object 0xffff8880209f0000 (size 8192):
  comm "kworker/0:4", pid 4916, jiffies 4295263583 (age 29.310s)
  hex dump (first 32 bytes):
    30 b0 27 22 80 88 ff ff 75 73 62 2d 64 75 6d 6d  0.'"....usb-dumm
    79 5f 68 63 64 2e 33 2d 31 00 00 00 00 00 00 00  y_hcd.3-1.......
  backtrace:
    [<ffffffff860ca856>] kmalloc include/linux/slab.h:556 [inline]
    [<ffffffff860ca856>] kzalloc include/linux/slab.h:686 [inline]
    [<ffffffff860ca856>] go7007_alloc+0x46/0xb40 drivers/media/usb/go7007/go7007-driver.c:696
    [<ffffffff860de74e>] go7007_usb_probe+0x13e/0x2200 drivers/media/usb/go7007/go7007-usb.c:1114
    [<ffffffff854a5f74>] usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396
    [<ffffffff845a7151>] really_probe+0x291/0xf60 drivers/base/dd.c:576

BUG: memory leak
unreferenced object 0xffff88801e2f2800 (size 512):
  comm "kworker/0:4", pid 4916, jiffies 4295263583 (age 29.310s)
  hex dump (first 32 bytes):
    00 87 40 8a ff ff ff ff 00 00 00 00 00 00 00 00  ..@.............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff860de794>] kmalloc include/linux/slab.h:556 [inline]
    [<ffffffff860de794>] kzalloc include/linux/slab.h:686 [inline]
    [<ffffffff860de794>] go7007_usb_probe+0x184/0x2200 drivers/media/usb/go7007/go7007-usb.c:1118
    [<ffffffff854a5f74>] usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396
    [<ffffffff845a7151>] really_probe+0x291/0xf60 drivers/base/dd.c:576

Fixes: 137641287eb4 ("go7007: add sanity checking for endpoints")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/go7007/go7007-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/go7007/go7007-usb.c b/drivers/media/usb/go7007/go7007-usb.c
index dbf0455d5d50..eeb85981e02b 100644
--- a/drivers/media/usb/go7007/go7007-usb.c
+++ b/drivers/media/usb/go7007/go7007-usb.c
@@ -1134,7 +1134,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 
 	ep = usb->usbdev->ep_in[4];
 	if (!ep)
-		return -ENODEV;
+		goto allocfail;
 
 	/* Allocate the URB and buffer for receiving incoming interrupts */
 	usb->intr_urb = usb_alloc_urb(0, GFP_KERNEL);
-- 
2.30.2



