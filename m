Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B97E114B99E
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731535AbgA1OYy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:24:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730246AbgA1OYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:24:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF81924699;
        Tue, 28 Jan 2020 14:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221492;
        bh=DVCDE0C3uPlaTr0kFjim1TFu6hOp8YaOTgtX+v4fjKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtImCgTzgIvJ0IIGguYCKAwd/ifBiUvWa6QmFwRUX+L1PBBnMxd/KrVqndxvqu5r3
         631wGclaey84DEO3toDtSCtGv/1ZvN1dVlRKKlTvEeoEht8IeV5FJkhk/gCTjPPwLP
         QVrLpcwRso7/ysQkL/uyXjZGf26ohCLjCLD4Iut0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 246/271] hwmon: (core) Fix double-free in __hwmon_device_register()
Date:   Tue, 28 Jan 2020 15:06:35 +0100
Message-Id: <20200128135910.831096550@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 74e3512731bd5c9673176425a76a7cc5efa8ddb6 upstream.

Fix double-free that happens when thermal zone setup fails, see KASAN log
below.

==================================================================
BUG: KASAN: double-free or invalid-free in __hwmon_device_register+0x5dc/0xa7c

CPU: 0 PID: 132 Comm: kworker/0:2 Tainted: G    B             4.19.0-rc8-next-20181016-00042-gb52cd80401e9-dirty #41
Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
Workqueue: events deferred_probe_work_func
Backtrace:
[<c0110540>] (dump_backtrace) from [<c0110944>] (show_stack+0x20/0x24)
[<c0110924>] (show_stack) from [<c105cb08>] (dump_stack+0x9c/0xb0)
[<c105ca6c>] (dump_stack) from [<c02fdaec>] (print_address_description+0x68/0x250)
[<c02fda84>] (print_address_description) from [<c02fd4ac>] (kasan_report_invalid_free+0x68/0x88)
[<c02fd444>] (kasan_report_invalid_free) from [<c02fc85c>] (__kasan_slab_free+0x1f4/0x200)
[<c02fc668>] (__kasan_slab_free) from [<c02fd0c0>] (kasan_slab_free+0x14/0x18)
[<c02fd0ac>] (kasan_slab_free) from [<c02f9c6c>] (kfree+0x90/0x294)
[<c02f9bdc>] (kfree) from [<c0b41bbc>] (__hwmon_device_register+0x5dc/0xa7c)
[<c0b415e0>] (__hwmon_device_register) from [<c0b421e8>] (hwmon_device_register_with_info+0xa0/0xa8)
[<c0b42148>] (hwmon_device_register_with_info) from [<c0b42324>] (devm_hwmon_device_register_with_info+0x74/0xb4)
[<c0b422b0>] (devm_hwmon_device_register_with_info) from [<c0b4481c>] (lm90_probe+0x414/0x578)
[<c0b44408>] (lm90_probe) from [<c0aeeff4>] (i2c_device_probe+0x35c/0x384)
[<c0aeec98>] (i2c_device_probe) from [<c08776cc>] (really_probe+0x290/0x3e4)
[<c087743c>] (really_probe) from [<c0877a2c>] (driver_probe_device+0x80/0x1c4)
[<c08779ac>] (driver_probe_device) from [<c0877da8>] (__device_attach_driver+0x104/0x11c)
[<c0877ca4>] (__device_attach_driver) from [<c0874dd8>] (bus_for_each_drv+0xa4/0xc8)
[<c0874d34>] (bus_for_each_drv) from [<c08773b0>] (__device_attach+0xf0/0x15c)
[<c08772c0>] (__device_attach) from [<c0877e24>] (device_initial_probe+0x1c/0x20)
[<c0877e08>] (device_initial_probe) from [<c08762f4>] (bus_probe_device+0xdc/0xec)
[<c0876218>] (bus_probe_device) from [<c0876a08>] (deferred_probe_work_func+0xa8/0xd4)
[<c0876960>] (deferred_probe_work_func) from [<c01527c4>] (process_one_work+0x3dc/0x96c)
[<c01523e8>] (process_one_work) from [<c01541e0>] (worker_thread+0x4ec/0x8bc)
[<c0153cf4>] (worker_thread) from [<c015b238>] (kthread+0x230/0x240)
[<c015b008>] (kthread) from [<c01010bc>] (ret_from_fork+0x14/0x38)
Exception stack(0xcf743fb0 to 0xcf743ff8)
3fa0:                                     00000000 00000000 00000000 00000000
3fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
3fe0: 00000000 00000000 00000000 00000000 00000013 00000000

Allocated by task 132:
 kasan_kmalloc.part.1+0x58/0xf4
 kasan_kmalloc+0x90/0xa4
 kmem_cache_alloc_trace+0x90/0x2a0
 __hwmon_device_register+0xbc/0xa7c
 hwmon_device_register_with_info+0xa0/0xa8
 devm_hwmon_device_register_with_info+0x74/0xb4
 lm90_probe+0x414/0x578
 i2c_device_probe+0x35c/0x384
 really_probe+0x290/0x3e4
 driver_probe_device+0x80/0x1c4
 __device_attach_driver+0x104/0x11c
 bus_for_each_drv+0xa4/0xc8
 __device_attach+0xf0/0x15c
 device_initial_probe+0x1c/0x20
 bus_probe_device+0xdc/0xec
 deferred_probe_work_func+0xa8/0xd4
 process_one_work+0x3dc/0x96c
 worker_thread+0x4ec/0x8bc
 kthread+0x230/0x240
 ret_from_fork+0x14/0x38
   (null)

Freed by task 132:
 __kasan_slab_free+0x12c/0x200
 kasan_slab_free+0x14/0x18
 kfree+0x90/0x294
 hwmon_dev_release+0x1c/0x20
 device_release+0x4c/0xe8
 kobject_put+0xac/0x11c
 device_unregister+0x2c/0x30
 __hwmon_device_register+0xa58/0xa7c
 hwmon_device_register_with_info+0xa0/0xa8
 devm_hwmon_device_register_with_info+0x74/0xb4
 lm90_probe+0x414/0x578
 i2c_device_probe+0x35c/0x384
 really_probe+0x290/0x3e4
 driver_probe_device+0x80/0x1c4
 __device_attach_driver+0x104/0x11c
 bus_for_each_drv+0xa4/0xc8
 __device_attach+0xf0/0x15c
 device_initial_probe+0x1c/0x20
 bus_probe_device+0xdc/0xec
 deferred_probe_work_func+0xa8/0xd4
 process_one_work+0x3dc/0x96c
 worker_thread+0x4ec/0x8bc
 kthread+0x230/0x240
 ret_from_fork+0x14/0x38
   (null)

Cc: <stable@vger.kernel.org> # v4.15+
Fixes: 47c332deb8e8 ("hwmon: Deal with errors from the thermal subsystem")
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/hwmon.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -596,8 +596,10 @@ __hwmon_device_register(struct device *d
 				if (info[i]->config[j] & HWMON_T_INPUT) {
 					err = hwmon_thermal_add_sensor(dev,
 								hwdev, j);
-					if (err)
-						goto free_device;
+					if (err) {
+						device_unregister(hdev);
+						goto ida_remove;
+					}
 				}
 			}
 		}
@@ -605,8 +607,6 @@ __hwmon_device_register(struct device *d
 
 	return hdev;
 
-free_device:
-	device_unregister(hdev);
 free_hwmon:
 	kfree(hwdev);
 ida_remove:


