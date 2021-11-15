Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A97451E99
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349288AbhKPAgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343867AbhKOTWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 245506329D;
        Mon, 15 Nov 2021 18:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002062;
        bh=vPMz/5VMfVrv/JhrgRAhUPgIPq+gfRu4moruOfVYe3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPrxvQ5rcZeG0QMbunHhJgx+gU7nOvzbAEMDfgQZbRt09DnLatWtn4gyK1SiD+Y+t
         9trpe6dyRDZZqUFJr3y3JZxLSBV/IkH+Y2ZyKii/hJ5CekRdDwRQf6rMC5UhliKvS3
         nDoGpIv4Kyht9TNvmdVB/YPQBLVQUWbv+4O+rNH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 425/917] hwmon: Fix possible memleak in __hwmon_device_register()
Date:   Mon, 15 Nov 2021 17:58:40 +0100
Message-Id: <20211115165443.206688464@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit ada61aa0b1184a8fda1a89a340c7d6cc4e59aee5 ]

I got memory leak as follows when doing fault injection test:

unreferenced object 0xffff888102740438 (size 8):
  comm "27", pid 859, jiffies 4295031351 (age 143.992s)
  hex dump (first 8 bytes):
    68 77 6d 6f 6e 30 00 00                          hwmon0..
  backtrace:
    [<00000000544b5996>] __kmalloc_track_caller+0x1a6/0x300
    [<00000000df0d62b9>] kvasprintf+0xad/0x140
    [<00000000d3d2a3da>] kvasprintf_const+0x62/0x190
    [<000000005f8f0f29>] kobject_set_name_vargs+0x56/0x140
    [<00000000b739e4b9>] dev_set_name+0xb0/0xe0
    [<0000000095b69c25>] __hwmon_device_register+0xf19/0x1e50 [hwmon]
    [<00000000a7e65b52>] hwmon_device_register_with_info+0xcb/0x110 [hwmon]
    [<000000006f181e86>] devm_hwmon_device_register_with_info+0x85/0x100 [hwmon]
    [<0000000081bdc567>] tmp421_probe+0x2d2/0x465 [tmp421]
    [<00000000502cc3f8>] i2c_device_probe+0x4e1/0xbb0
    [<00000000f90bda3b>] really_probe+0x285/0xc30
    [<000000007eac7b77>] __driver_probe_device+0x35f/0x4f0
    [<000000004953d43d>] driver_probe_device+0x4f/0x140
    [<000000002ada2d41>] __device_attach_driver+0x24c/0x330
    [<00000000b3977977>] bus_for_each_drv+0x15d/0x1e0
    [<000000005bf2a8e3>] __device_attach+0x267/0x410

When device_register() returns an error, the name allocated in
dev_set_name() will be leaked, the put_device() should be used
instead of calling hwmon_dev_release() to give up the device
reference, then the name will be freed in kobject_cleanup().

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: bab2243ce189 ("hwmon: Introduce hwmon_device_register_with_groups")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20211012112758.2681084-1-yangyingliang@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/hwmon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index 8d3b1dae31df1..3501a3ead4ba6 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -796,8 +796,10 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 	dev_set_drvdata(hdev, drvdata);
 	dev_set_name(hdev, HWMON_ID_FORMAT, id);
 	err = device_register(hdev);
-	if (err)
-		goto free_hwmon;
+	if (err) {
+		put_device(hdev);
+		goto ida_remove;
+	}
 
 	INIT_LIST_HEAD(&hwdev->tzdata);
 
-- 
2.33.0



