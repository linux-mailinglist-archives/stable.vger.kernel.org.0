Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218E54998D9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:39:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453543AbiAXVaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:30:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38794 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450358AbiAXVUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:20:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95021B81188;
        Mon, 24 Jan 2022 21:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2258AC340E4;
        Mon, 24 Jan 2022 21:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059218;
        bh=KgD6qxy+fP2fvSM/3e8PrWESYFntT/ISgWQqCE2FJS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dtQziMlkN1DA1sQX3v5vYrP8o3b5jNuuGHhWUe+hoo2Opw/aF8hmNApSfRaau6+6c
         yhsn+WTGaBHqcJeUrkbborYVSmzGtDzuLLudrOMIh8Lsqj6RWZxCWLMt83xvfQxmoE
         zyAlgB3oL2OFgbTHRSJGurzBukFVMe8CdLuV8fZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Yongjun <weiyongjun1@huawei.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0541/1039] Bluetooth: Fix memory leak of hci device
Date:   Mon, 24 Jan 2022 19:38:50 +0100
Message-Id: <20220124184143.466693673@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 75d9b8559ac36e059238ee4f8e33cd86086586ba ]

Fault injection test reported memory leak of hci device as follows:

unreferenced object 0xffff88800b858000 (size 8192):
  comm "kworker/0:2", pid 167, jiffies 4294955747 (age 557.148s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 ad 4e ad de  .............N..
  backtrace:
    [<0000000070eb1059>] kmem_cache_alloc_trace mm/slub.c:3208
    [<00000000015eb521>] hci_alloc_dev_priv include/linux/slab.h:591
    [<00000000dcfc1e21>] bpa10x_probe include/net/bluetooth/hci_core.h:1240
    [<000000005d3028c7>] usb_probe_interface drivers/usb/core/driver.c:397
    [<00000000cbac9243>] really_probe drivers/base/dd.c:517
    [<0000000024cab3f0>] __driver_probe_device drivers/base/dd.c:751
    [<00000000202135cb>] driver_probe_device drivers/base/dd.c:782
    [<000000000761f2bc>] __device_attach_driver drivers/base/dd.c:899
    [<00000000f7d63134>] bus_for_each_drv drivers/base/bus.c:427
    [<00000000c9551f0b>] __device_attach drivers/base/dd.c:971
    [<000000007f79bd16>] bus_probe_device drivers/base/bus.c:487
    [<000000007bb8b95a>] device_add drivers/base/core.c:3364
    [<000000009564d9ea>] usb_set_configuration drivers/usb/core/message.c:2171
    [<00000000e4657087>] usb_generic_driver_probe drivers/usb/core/generic.c:239
    [<0000000071ede518>] usb_probe_device drivers/usb/core/driver.c:294
    [<00000000cbac9243>] really_probe drivers/base/dd.c:517

hci_alloc_dev() do not init the device's flag. And hci_free_dev()
using put_device() to free the memory allocated for this device,
but it calls just put_device(dev) only in case of HCI_UNREGISTER
flag is set, So any error handing before hci_register_dev() success
will cause memory leak.

To avoid this behaviour we can using kfree() to release dev before
hci_register_dev() success.

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 7827639ecf5c3..4e3e0451b08c1 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -86,6 +86,8 @@ static void bt_host_release(struct device *dev)
 
 	if (hci_dev_test_flag(hdev, HCI_UNREGISTER))
 		hci_release_dev(hdev);
+	else
+		kfree(hdev);
 	module_put(THIS_MODULE);
 }
 
-- 
2.34.1



