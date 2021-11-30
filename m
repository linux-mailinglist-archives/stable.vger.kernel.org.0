Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4EA463761
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242710AbhK3Ox1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242727AbhK3Owf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:52:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845DCC0613E0;
        Tue, 30 Nov 2021 06:48:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 13814CE1A4D;
        Tue, 30 Nov 2021 14:48:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D9E0C53FCF;
        Tue, 30 Nov 2021 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283697;
        bh=BhIew2AD86pu1If7zFqfREteOWJx4UUFBUVRbRKMWlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vg8CMKryZUFqwW9l5BY93MM4JG+I34CgMbkJKyXJ8ru8MTLNMyOBv5kcKhJ5TisXg
         lH89wqCdB0y5gF9Qv9Z8FhsmqVw6gjP237wqQNkeNUSRSse7sCYaDNSvXg3MIiDyBd
         eY2GOYnl6eS8NHsknvWdOOY6hY2URSGtGDGE2Jej3P7lIwwuKee6LwiuuLSN03qyLj
         b5963fI6YtTQshs2XCC+N3OZE1ummSxcl0b0pfJqGvZEdWZB8dLW5vuHQEYHxGA4nn
         s+9Kxf6tob6kyRQILB5QfYFkDdkUm9pB1wT+Z0aB2OOmo5ZneTRYhCfb5/9RLKA/gR
         vFOCYtMWE4oCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Zaidman <michael.zaidman@gmail.com>,
        Germain Hebert <germain.hebert@ca.abb.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 23/68] HID: ft260: fix i2c probing for hwmon devices
Date:   Tue, 30 Nov 2021 09:46:19 -0500
Message-Id: <20211130144707.944580-23-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Zaidman <michael.zaidman@gmail.com>

[ Upstream commit a94f61e63f337d95001e1a976ab701100fa1d666 ]

The below scenario causes the kernel NULL pointer dereference failure:
1. sudo insmod hid-ft260.ko
2. sudo modprobe lm75
3. unplug USB hid-ft260
4. plug USB hid-ft260

[  +0.000006] Call Trace:
[  +0.000004]  __i2c_smbus_xfer.part.0+0xd1/0x310
[  +0.000007]  ? ft260_smbus_write+0x140/0x140 [hid_ft260]
[  +0.000005]  __i2c_smbus_xfer+0x2b/0x80
[  +0.000004]  i2c_smbus_xfer+0x61/0xf0
[  +0.000005]  i2c_default_probe+0xf9/0x130
[  +0.000004]  i2c_detect_address+0x84/0x160
[  +0.000004]  ? kmem_cache_alloc_trace+0xf6/0x200
[  +0.000009]  ? i2c_detect.isra.0+0x69/0x130
[  +0.000005]  i2c_detect.isra.0+0xbf/0x130
[  +0.000004]  ? __process_new_driver+0x30/0x30
[  +0.000004]  __process_new_adapter+0x18/0x20
[  +0.000004]  bus_for_each_drv+0x84/0xd0
[  +0.000003]  i2c_register_adapter+0x1e4/0x400
[  +0.000005]  i2c_add_adapter+0x5c/0x80
[  +0.000004]  ft260_probe.cold+0x222/0x2e2 [hid_ft260]
[  +0.000006]  hid_device_probe+0x10e/0x170 [hid]
[  +0.000009]  really_probe+0xff/0x460
[  +0.000004]  driver_probe_device+0xe9/0x160
[  +0.000003]  __device_attach_driver+0x71/0xd0
[  +0.000004]  ? driver_allows_async_probing+0x50/0x50
[  +0.000004]  bus_for_each_drv+0x84/0xd0
[  +0.000002]  __device_attach+0xde/0x1e0
[  +0.000004]  device_initial_probe+0x13/0x20
[  +0.000004]  bus_probe_device+0x8f/0xa0
[  +0.000003]  device_add+0x333/0x5f0

It happened when i2c core probed for the devices associated with the lm75
driver by invoking 2c_detect()-->..-->ft260_smbus_write() from within the
ft260_probe before setting the adapter data with i2c_set_adapdata().

Moving the i2c_set_adapdata() before i2c_add_adapter() fixed the failure.

Signed-off-by: Michael Zaidman <michael.zaidman@gmail.com>
Signed-off-by: Germain Hebert <germain.hebert@ca.abb.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ft260.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-ft260.c b/drivers/hid/hid-ft260.c
index 4ef1c3b8094ea..8ee77f4afe9ff 100644
--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -966,24 +966,23 @@ static int ft260_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	mutex_init(&dev->lock);
 	init_completion(&dev->wait);
 
+	ret = ft260_xfer_status(dev);
+	if (ret)
+		ft260_i2c_reset(hdev);
+
+	i2c_set_adapdata(&dev->adap, dev);
 	ret = i2c_add_adapter(&dev->adap);
 	if (ret) {
 		hid_err(hdev, "failed to add i2c adapter\n");
 		goto err_hid_close;
 	}
 
-	i2c_set_adapdata(&dev->adap, dev);
-
 	ret = sysfs_create_group(&hdev->dev.kobj, &ft260_attr_group);
 	if (ret < 0) {
 		hid_err(hdev, "failed to create sysfs attrs\n");
 		goto err_i2c_free;
 	}
 
-	ret = ft260_xfer_status(dev);
-	if (ret)
-		ft260_i2c_reset(hdev);
-
 	return 0;
 
 err_i2c_free:
-- 
2.33.0

