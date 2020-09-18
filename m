Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADFA26F350
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgIRDFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727266AbgIRCET (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1C4823741;
        Fri, 18 Sep 2020 02:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394651;
        bh=+R+xvjpMnrvrQaA8wVr9Ow//OdvhlPzKzTcTOVCsLnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qrnf/GVczDOsF6ReZ1136N/MI7i+nVbcRGZpHMiGYCbV/b4Z2w6Erm3gregFuyypA
         kbr7lQpgXXWDZBoqxm8AFSJ4qSnUGEK4WEINaUsdCclRIdmFoBTEjYk/lQCIAUAmub
         dH2G/ssRjvPq2UJ/MYYjv9bqm8faseKQWOE9h2XY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>, Wei Xu <xuwei5@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 148/330] bus: hisi_lpc: Fixup IO ports addresses to avoid use-after-free in host removal
Date:   Thu, 17 Sep 2020 21:58:08 -0400
Message-Id: <20200918020110.2063155-148-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit a6dd255bdd7d00bbdbf78ba00bde9fc64f86c3a7 ]

Some released ACPI FW for Huawei boards describes incorrect the port IO
address range for child devices, in that it tells us the IO port max range
is 0x3fff for each child device, which is not correct. The address range
should be [e4:e8) or similar. With this incorrect upper range, the child
device IO port resources overlap.

As such, the kernel thinks that the LPC host serial device is a child of
the IPMI device:

root@(none)$ more /proc/ioports
[...]
00ffc0e3-00ffffff : hisi-lpc-ipmi.0.auto
  00ffc0e3-00ffc0e3 : ipmi_si
  00ffc0e4-00ffc0e4 : ipmi_si
  00ffc0e5-00ffc0e5 : ipmi_si
  00ffc2f7-00ffffff : serial8250.1.auto
    00ffc2f7-00ffc2fe : serial
root@(none)$

They should both be siblings. Note that these are logical PIO addresses,
which have a direct mapping from the FW IO port ranges.

This shows up as a real issue when we enable CONFIG_KASAN and
CONFIG_DEBUG_TEST_DRIVER_REMOVE - we see use-after-free warnings in the
host removal path:

==================================================================
BUG: KASAN: use-after-free in release_resource+0x38/0xc8
Read of size 8 at addr ffff0026accdbc38 by task swapper/0/1

CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.5.0-rc6-00001-g68e186e77b5c-dirty #1593
Hardware name: Huawei Taishan 2180 /D03, BIOS Hisilicon D03 IT20 Nemo 2.0 RC0 03/30/2018
Call trace:
dump_backtrace+0x0/0x290
show_stack+0x14/0x20
dump_stack+0xf0/0x14c
print_address_description.isra.9+0x6c/0x3b8
__kasan_report+0x12c/0x23c
kasan_report+0xc/0x18
__asan_load8+0x94/0xb8
release_resource+0x38/0xc8
platform_device_del.part.10+0x80/0xe0
platform_device_unregister+0x20/0x38
hisi_lpc_acpi_remove_subdev+0x10/0x20
device_for_each_child+0xc8/0x128
hisi_lpc_acpi_remove+0x4c/0xa8
hisi_lpc_remove+0xbc/0xc0
platform_drv_remove+0x3c/0x68
really_probe+0x174/0x548
driver_probe_device+0x7c/0x148
device_driver_attach+0x94/0xa0
__driver_attach+0xa4/0x110
bus_for_each_dev+0xe8/0x158
driver_attach+0x30/0x40
bus_add_driver+0x234/0x2f0
driver_register+0xbc/0x1d0
__platform_driver_register+0x7c/0x88
hisi_lpc_driver_init+0x18/0x20
do_one_initcall+0xb4/0x258
kernel_init_freeable+0x248/0x2c0
kernel_init+0x10/0x118
ret_from_fork+0x10/0x1c

...

The issue here is that the kernel created an incorrect parent-child
resource dependency between two devices, and references the false parent
node when deleting the second child device, when it had been deleted
already.

Fix up the child device resources from FW to create proper IO port
resource relationships for broken FW.

With this, the IO port layout looks more healthy:

root@(none)$ more /proc/ioports
[...]
00ffc0e3-00ffc0e7 : hisi-lpc-ipmi.0.auto
  00ffc0e3-00ffc0e3 : ipmi_si
  00ffc0e4-00ffc0e4 : ipmi_si
  00ffc0e5-00ffc0e5 : ipmi_si
00ffc2f7-00ffc2ff : serial8250.1.auto
  00ffc2f7-00ffc2fe : serial

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/hisi_lpc.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/hisi_lpc.c b/drivers/bus/hisi_lpc.c
index 20c957185af20..2e9252d37a18f 100644
--- a/drivers/bus/hisi_lpc.c
+++ b/drivers/bus/hisi_lpc.c
@@ -358,6 +358,26 @@ static int hisi_lpc_acpi_xlat_io_res(struct acpi_device *adev,
 	return 0;
 }
 
+/*
+ * Released firmware describes the IO port max address as 0x3fff, which is
+ * the max host bus address. Fixup to a proper range. This will probably
+ * never be fixed in firmware.
+ */
+static void hisi_lpc_acpi_fixup_child_resource(struct device *hostdev,
+					       struct resource *r)
+{
+	if (r->end != 0x3fff)
+		return;
+
+	if (r->start == 0xe4)
+		r->end = 0xe4 + 0x04 - 1;
+	else if (r->start == 0x2f8)
+		r->end = 0x2f8 + 0x08 - 1;
+	else
+		dev_warn(hostdev, "unrecognised resource %pR to fixup, ignoring\n",
+			 r);
+}
+
 /*
  * hisi_lpc_acpi_set_io_res - set the resources for a child
  * @child: the device node to be updated the I/O resource
@@ -419,8 +439,11 @@ static int hisi_lpc_acpi_set_io_res(struct device *child,
 		return -ENOMEM;
 	}
 	count = 0;
-	list_for_each_entry(rentry, &resource_list, node)
-		resources[count++] = *rentry->res;
+	list_for_each_entry(rentry, &resource_list, node) {
+		resources[count] = *rentry->res;
+		hisi_lpc_acpi_fixup_child_resource(hostdev, &resources[count]);
+		count++;
+	}
 
 	acpi_dev_free_resource_list(&resource_list);
 
-- 
2.25.1

