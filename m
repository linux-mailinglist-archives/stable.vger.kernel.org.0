Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40BBD450E39
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240781AbhKOSNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:13:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240133AbhKOSFn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CB28632FD;
        Mon, 15 Nov 2021 17:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998170;
        bh=YsfQXydnnYVDsA8EUuw0r2UCfDO195lGpkkRTB6wsyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWRsPO2GAHU27QhIWR0/blTCf+JsSj5Ztq6SdT4ui5qYB8bhQGQ++8h20t3B1s7yY
         4x7Ts/Kh22TaN78WIShdcgqOk6CMgL7yTIneoFqCrg4u5nlwuNRR2DbDNfeSNf2AyH
         yrSDv9TdJREr18yXHvSNmhGDM+Wbc9dwvXTc/yqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Saravana Kannan <saravanak@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 413/575] driver core: Fix possible memory leak in device_link_add()
Date:   Mon, 15 Nov 2021 18:02:18 +0100
Message-Id: <20211115165358.043134263@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit df0a18149474c7e6b21f6367fbc6bc8d0f192444 ]

I got memory leak as follows:

unreferenced object 0xffff88801f0b2200 (size 64):
  comm "i2c-lis2hh12-21", pid 5455, jiffies 4294944606 (age 15.224s)
  hex dump (first 32 bytes):
    72 65 67 75 6c 61 74 6f 72 3a 72 65 67 75 6c 61  regulator:regula
    74 6f 72 2e 30 2d 2d 69 32 63 3a 31 2d 30 30 31  tor.0--i2c:1-001
  backtrace:
    [<00000000bf5b0c3b>] __kmalloc_track_caller+0x19f/0x3a0
    [<0000000050da42d9>] kvasprintf+0xb5/0x150
    [<000000004bbbed13>] kvasprintf_const+0x60/0x190
    [<00000000cdac7480>] kobject_set_name_vargs+0x56/0x150
    [<00000000bf83f8e8>] dev_set_name+0xc0/0x100
    [<00000000cc1cf7e3>] device_link_add+0x6b4/0x17c0
    [<000000009db9faed>] _regulator_get+0x297/0x680
    [<00000000845e7f2b>] _devm_regulator_get+0x5b/0xe0
    [<000000003958ee25>] st_sensors_power_enable+0x71/0x1b0 [st_sensors]
    [<000000005f450f52>] st_accel_i2c_probe+0xd9/0x150 [st_accel_i2c]
    [<00000000b5f2ab33>] i2c_device_probe+0x4d8/0xbe0
    [<0000000070fb977b>] really_probe+0x299/0xc30
    [<0000000088e226ce>] __driver_probe_device+0x357/0x500
    [<00000000c21dda32>] driver_probe_device+0x4e/0x140
    [<000000004e650441>] __device_attach_driver+0x257/0x340
    [<00000000cf1891b8>] bus_for_each_drv+0x166/0x1e0

When device_register() returns an error, the name allocated in dev_set_name()
will be leaked, the put_device() should be used instead of kfree() to give up
the device reference, then the name will be freed in kobject_cleanup() and the
references of consumer and supplier will be decreased in device_link_release_fn().

Fixes: 287905e68dd2 ("driver core: Expose device link details in sysfs")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20210930085714.2057460-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2bc4db5ffe445..389d13616d1df 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -668,9 +668,7 @@ struct device_link *device_link_add(struct device *consumer,
 		     dev_bus_name(supplier), dev_name(supplier),
 		     dev_bus_name(consumer), dev_name(consumer));
 	if (device_register(&link->link_dev)) {
-		put_device(consumer);
-		put_device(supplier);
-		kfree(link);
+		put_device(&link->link_dev);
 		link = NULL;
 		goto out;
 	}
-- 
2.33.0



