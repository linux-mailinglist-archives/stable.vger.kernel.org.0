Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4162E9301
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 11:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbhADKBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 05:01:46 -0500
Received: from www.linuxtv.org ([130.149.80.248]:47784 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbhADKBq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 05:01:46 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1kwMff-0008SQ-Ax; Mon, 04 Jan 2021 10:01:03 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Mon, 04 Jan 2021 10:00:25 +0000
Subject: [git:media_tree/fixes] media: rc: ensure that uevent can be read directly after rc device register
To:     linuxtv-commits@linuxtv.org
Cc:     Sean Young <sean@mess.org>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1kwMff-0008SQ-Ax@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: rc: ensure that uevent can be read directly after rc device register
Author:  Sean Young <sean@mess.org>
Date:    Sun Dec 20 13:29:54 2020 +0100

There is a race condition where if the /sys/class/rc0/uevent file is read
before rc_dev->registered is set to true, -ENODEV will be returned.

Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1901089

Cc: stable@vger.kernel.org
Fixes: a2e2d73fa281 ("media: rc: do not access device via sysfs after rc_unregister_device()")
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/rc/rc-main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1d811e5ffb55..29d4d01896ff 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1928,6 +1928,8 @@ int rc_register_device(struct rc_dev *dev)
 			goto out_raw;
 	}
 
+	dev->registered = true;
+
 	rc = device_add(&dev->dev);
 	if (rc)
 		goto out_rx_free;
@@ -1937,8 +1939,6 @@ int rc_register_device(struct rc_dev *dev)
 		 dev->device_name ?: "Unspecified device", path ?: "N/A");
 	kfree(path);
 
-	dev->registered = true;
-
 	/*
 	 * once the the input device is registered in rc_setup_rx_device,
 	 * userspace can open the input device and rc_open() will be called
