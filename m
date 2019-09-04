Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C2CA9131
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389749AbfIDSOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:14:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390680AbfIDSOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:14:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B43A52087E;
        Wed,  4 Sep 2019 18:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620841;
        bh=8nwAokFfIT1by3nyndFKb0KCCuuMpr3W2dZs8lyiYzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y1YjtPehk01KdNfQLdZE9PomsY1sR/40Kmj9OPfeI6jp/NcQqDyWoDQN4O8WvuTNo
         AA8FM1mB9nZPAy6pvFo/z9hIQd2ByZ+rb6u0YfMl2N8mGHAz8XEXNnjpOYJ4mV5t5B
         7QA/qQcbfpXec5RVYOrlDQZGwkp3zn78GLZUzhM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>
Subject: [PATCH 5.2 116/143] bus: hisi_lpc: Add .remove method to avoid driver unbind crash
Date:   Wed,  4 Sep 2019 19:54:19 +0200
Message-Id: <20190904175318.935451583@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175314.206239922@linuxfoundation.org>
References: <20190904175314.206239922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

commit 10e62b47973b0b0ceda076255bcb147b83e20517 upstream.

The original driver author seemed to be under the impression that a driver
cannot be removed if it does not have a .remove method. Or maybe if it is
a built-in platform driver.

This is not true. This crash can be created:

root@ubuntu:/sys/bus/platform/drivers/hisi-lpc# echo HISI0191\:00 > unbind
root@ubuntu:/sys/bus/platform/drivers/hisi-lpc# ipmitool raw 6 1
 Unable to handle kernel paging request at virtual address ffff000010035010
 Mem abort info:
   ESR = 0x96000047
   Exception class = DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000047
   CM = 0, WnR = 1
 swapper pgtable: 4k pages, 48-bit VAs, pgdp=000000000118b000
 [ffff000010035010] pgd=0000041ffbfff003, pud=0000041ffbffe003, pmd=0000041ffbffd003, pte=0000000000000000
 Internal error: Oops: 96000047 [#1] PREEMPT SMP
 Modules linked in:
 CPU: 17 PID: 1473 Comm: ipmitool Not tainted 5.2.0-rc5-00003-gf68c53b414a3-dirty #198
 Hardware name: Huawei Taishan 2280 /D05, BIOS Hisilicon D05 IT21 Nemo 2.0 RC0 04/18/2018
 pstate: 20000085 (nzCv daIf -PAN -UAO)
 pc : hisi_lpc_target_in+0x7c/0x120
 lr : hisi_lpc_target_in+0x70/0x120
 sp : ffff00001efe3930
 x29: ffff00001efe3930 x28: ffff841f9f599200
 x27: 0000000000000002 x26: 0000000000000000
 x25: 0000000000000080 x24: 00000000000000e4
 x23: 0000000000000000 x22: 0000000000000064
 x21: ffff801fb667d280 x20: 0000000000000001
 x19: ffff00001efe39ac x18: 0000000000000000
 x17: 0000000000000000 x16: 0000000000000000
 x15: 0000000000000000 x14: 0000000000000000
 x13: 0000000000000000 x12: 0000000000000000
 x11: 0000000000000000 x10: 0000000000000000
 x9 : 0000000000000000 x8 : ffff841febe60340
 x7 : ffff801fb55c52e8 x6 : 0000000000000000
 x5 : 0000000000ffc0e3 x4 : 0000000000000001
 x3 : ffff801fb667d280 x2 : 0000000000000001
 x1 : ffff000010035010 x0 : ffff000010035000
 Call trace:
  hisi_lpc_target_in+0x7c/0x120
  hisi_lpc_comm_in+0x88/0x98
  logic_inb+0x5c/0xb8
  port_inb+0x18/0x20
  bt_event+0x38/0x808
  smi_event_handler+0x4c/0x5a0
  check_start_timer_thread.part.4+0x40/0x58
  sender+0x78/0x88
  smi_send.isra.6+0x94/0x108
  i_ipmi_request+0x2c4/0x8f8
  ipmi_request_settime+0x124/0x160
  handle_send_req+0x19c/0x208
  ipmi_ioctl+0x2c0/0x990
  do_vfs_ioctl+0xb8/0x8f8
  ksys_ioctl+0x80/0xb8
  __arm64_sys_ioctl+0x1c/0x28
  el0_svc_common.constprop.0+0x64/0x160
  el0_svc_handler+0x28/0x78
  el0_svc+0x8/0xc
 Code: 941d1511 aa0003f9 f94006a0 91004001 (b9000034)
 ---[ end trace aa842b86af7069e4 ]---

The problem here is that the host goes away but the associated logical PIO
region remains registered, as do the children devices.

Fix by adding a .remove method to tidy-up by removing the child devices
and unregistering the logical PIO region.

Cc: stable@vger.kernel.org
Fixes: adf38bb0b595 ("HISI LPC: Support the LPC host on Hip06/Hip07 with DT bindings")
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bus/hisi_lpc.c |   38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

--- a/drivers/bus/hisi_lpc.c
+++ b/drivers/bus/hisi_lpc.c
@@ -456,6 +456,17 @@ struct hisi_lpc_acpi_cell {
 	size_t pdata_size;
 };
 
+static void hisi_lpc_acpi_remove(struct device *hostdev)
+{
+	struct acpi_device *adev = ACPI_COMPANION(hostdev);
+	struct acpi_device *child;
+
+	device_for_each_child(hostdev, NULL, hisi_lpc_acpi_remove_subdev);
+
+	list_for_each_entry(child, &adev->children, node)
+		acpi_device_clear_enumerated(child);
+}
+
 /*
  * hisi_lpc_acpi_probe - probe children for ACPI FW
  * @hostdev: LPC host device pointer
@@ -555,8 +566,7 @@ static int hisi_lpc_acpi_probe(struct de
 	return 0;
 
 fail:
-	device_for_each_child(hostdev, NULL,
-			      hisi_lpc_acpi_remove_subdev);
+	hisi_lpc_acpi_remove(hostdev);
 	return ret;
 }
 
@@ -569,6 +579,10 @@ static int hisi_lpc_acpi_probe(struct de
 {
 	return -ENODEV;
 }
+
+static void hisi_lpc_acpi_remove(struct device *hostdev)
+{
+}
 #endif // CONFIG_ACPI
 
 /*
@@ -626,6 +640,8 @@ static int hisi_lpc_probe(struct platfor
 		return ret;
 	}
 
+	dev_set_drvdata(dev, lpcdev);
+
 	io_end = lpcdev->io_host->io_start + lpcdev->io_host->size;
 	dev_info(dev, "registered range [%pa - %pa]\n",
 		 &lpcdev->io_host->io_start, &io_end);
@@ -633,6 +649,23 @@ static int hisi_lpc_probe(struct platfor
 	return ret;
 }
 
+static int hisi_lpc_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct acpi_device *acpi_device = ACPI_COMPANION(dev);
+	struct hisi_lpc_dev *lpcdev = dev_get_drvdata(dev);
+	struct logic_pio_hwaddr *range = lpcdev->io_host;
+
+	if (acpi_device)
+		hisi_lpc_acpi_remove(dev);
+	else
+		of_platform_depopulate(dev);
+
+	logic_pio_unregister_range(range);
+
+	return 0;
+}
+
 static const struct of_device_id hisi_lpc_of_match[] = {
 	{ .compatible = "hisilicon,hip06-lpc", },
 	{ .compatible = "hisilicon,hip07-lpc", },
@@ -646,5 +679,6 @@ static struct platform_driver hisi_lpc_d
 		.acpi_match_table = ACPI_PTR(hisi_lpc_acpi_match),
 	},
 	.probe = hisi_lpc_probe,
+	.remove = hisi_lpc_remove,
 };
 builtin_platform_driver(hisi_lpc_driver);


