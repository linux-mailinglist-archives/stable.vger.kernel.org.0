Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0E94094A1
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346464AbhIMOcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:32:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244972AbhIMOas (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:30:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16D3661BA7;
        Mon, 13 Sep 2021 13:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541092;
        bh=Ny8wVJn4A9i6ipl3UIAXM88BcEFMhX2inpmHcX3ehGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FAEwDmqrKhyGubcgeDVlnuyY2DZha7bY4xVf/sGMv7nCXobB1xbtVhZQHqyYxm6Wk
         AuMUsI4a/E6f1pp/QPVlY0at6/ODrXIL/p9BoN/3FDirvl3nMSQbb5vqq9+hNCIfWh
         AXzkgdQR77BvR5tE7YoIiCbVqpiSvfDPXPKFe+RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongliang Mu <mudongliangabcd@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 159/334] media: em28xx-input: fix refcount bug in em28xx_usb_disconnect
Date:   Mon, 13 Sep 2021 15:13:33 +0200
Message-Id: <20210913131118.730235772@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit 6fa54bc713c262e1cfbc5613377ef52280d7311f ]

If em28xx_ir_init fails, it would decrease the refcount of dev. However,
in the em28xx_ir_fini, when ir is NULL, it goes to ref_put and decrease
the refcount of dev. This will lead to a refcount bug.

Fix this bug by removing the kref_put in the error handling code
of em28xx_ir_init.

refcount_t: underflow; use-after-free.
WARNING: CPU: 0 PID: 7 at lib/refcount.c:28 refcount_warn_saturate+0x18e/0x1a0 lib/refcount.c:28
Modules linked in:
CPU: 0 PID: 7 Comm: kworker/0:1 Not tainted 5.13.0 #3
Workqueue: usb_hub_wq hub_event
RIP: 0010:refcount_warn_saturate+0x18e/0x1a0 lib/refcount.c:28
Call Trace:
  kref_put.constprop.0+0x60/0x85 include/linux/kref.h:69
  em28xx_usb_disconnect.cold+0xd7/0xdc drivers/media/usb/em28xx/em28xx-cards.c:4150
  usb_unbind_interface+0xbf/0x3a0 drivers/usb/core/driver.c:458
  __device_release_driver drivers/base/dd.c:1201 [inline]
  device_release_driver_internal+0x22a/0x230 drivers/base/dd.c:1232
  bus_remove_device+0x108/0x160 drivers/base/bus.c:529
  device_del+0x1fe/0x510 drivers/base/core.c:3540
  usb_disable_device+0xd1/0x1d0 drivers/usb/core/message.c:1419
  usb_disconnect+0x109/0x330 drivers/usb/core/hub.c:2221
  hub_port_connect drivers/usb/core/hub.c:5151 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5440 [inline]
  port_event drivers/usb/core/hub.c:5586 [inline]
  hub_event+0xf81/0x1d40 drivers/usb/core/hub.c:5668
  process_one_work+0x2c9/0x610 kernel/workqueue.c:2276
  process_scheduled_works kernel/workqueue.c:2338 [inline]
  worker_thread+0x333/0x5b0 kernel/workqueue.c:2424
  kthread+0x188/0x1d0 kernel/kthread.c:319
  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Fixes: ac5688637144 ("media: em28xx: Fix possible memory leak of em28xx struct")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-input.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 59529cbf9cd0..0b6d77c3bec8 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -842,7 +842,6 @@ error:
 	kfree(ir);
 ref_put:
 	em28xx_shutdown_buttons(dev);
-	kref_put(&dev->ref, em28xx_free_device);
 	return err;
 }
 
-- 
2.30.2



