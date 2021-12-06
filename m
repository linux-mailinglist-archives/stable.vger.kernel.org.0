Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C873D469AD2
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346414AbhLFPLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:11:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41684 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237740AbhLFPIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:08:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C565AB8111F;
        Mon,  6 Dec 2021 15:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44389C341C1;
        Mon,  6 Dec 2021 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803112;
        bh=lM9t4+btQgmQ1VE8i8udtcZC1Ih5XdMwq/qPWdLKVeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oWe+XVSOZeS/u04AHJdN0OK4IZriZ1j5uS2pqjcdGBcGbSXoJIM1+u7catnl0PQkd
         Lo2XZ57n2HgQHEOvfRgat6YsoRWypMIiWnm7GE+wLiIZTUOLHqv25qptmBwRiyOCkv
         E3E6bhzhX0EoZ5/AUqgOru+ovxDPox/UpiyRMUWI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 032/106] PCI: aardvark: Fix I/O space page leak
Date:   Mon,  6 Dec 2021 15:55:40 +0100
Message-Id: <20211206145556.468249434@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit 1df3e5b3feebf29a3ecfa0c0f06f79544ca573e4 upstream.

When testing the R-Car PCIe driver on the Condor board, if the PCIe PHY
driver was left disabled, the kernel crashed with this BUG:

  kernel BUG at lib/ioremap.c:72!
  Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
  Modules linked in:
  CPU: 0 PID: 39 Comm: kworker/0:1 Not tainted 4.17.0-dirty #1092
  Hardware name: Renesas Condor board based on r8a77980 (DT)
  Workqueue: events deferred_probe_work_func
  pstate: 80000005 (Nzcv daif -PAN -UAO)
  pc : ioremap_page_range+0x370/0x3c8
  lr : ioremap_page_range+0x40/0x3c8
  sp : ffff000008da39e0
  x29: ffff000008da39e0 x28: 00e8000000000f07
  x27: ffff7dfffee00000 x26: 0140000000000000
  x25: ffff7dfffef00000 x24: 00000000000fe100
  x23: ffff80007b906000 x22: ffff000008ab8000
  x21: ffff000008bb1d58 x20: ffff7dfffef00000
  x19: ffff800009c30fb8 x18: 0000000000000001
  x17: 00000000000152d0 x16: 00000000014012d0
  x15: 0000000000000000 x14: 0720072007200720
  x13: 0720072007200720 x12: 0720072007200720
  x11: 0720072007300730 x10: 00000000000000ae
  x9 : 0000000000000000 x8 : ffff7dffff000000
  x7 : 0000000000000000 x6 : 0000000000000100
  x5 : 0000000000000000 x4 : 000000007b906000
  x3 : ffff80007c61a880 x2 : ffff7dfffeefffff
  x1 : 0000000040000000 x0 : 00e80000fe100f07
  Process kworker/0:1 (pid: 39, stack limit = 0x        (ptrval))
  Call trace:
   ioremap_page_range+0x370/0x3c8
   pci_remap_iospace+0x7c/0xac
   pci_parse_request_of_pci_ranges+0x13c/0x190
   rcar_pcie_probe+0x4c/0xb04
   platform_drv_probe+0x50/0xbc
   driver_probe_device+0x21c/0x308
   __device_attach_driver+0x98/0xc8
   bus_for_each_drv+0x54/0x94
   __device_attach+0xc4/0x12c
   device_initial_probe+0x10/0x18
   bus_probe_device+0x90/0x98
   deferred_probe_work_func+0xb0/0x150
   process_one_work+0x12c/0x29c
   worker_thread+0x200/0x3fc
   kthread+0x108/0x134
   ret_from_fork+0x10/0x18
  Code: f9004ba2 54000080 aa0003fb 17ffff48 (d4210000)

It turned out that pci_remap_iospace() wasn't undone when the driver's
probe failed, and since devm_phy_optional_get() returned -EPROBE_DEFER,
the probe was retried, finally causing the BUG due to trying to remap
already remapped pages.

The Aardvark PCI controller driver has the same issue.
Replace pci_remap_iospace() with its devm_ managed version to fix the bug.

Fixes: 8c39d710363c ("PCI: aardvark: Add Aardvark PCI host controller driver")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
[lorenzo.pieralisi@arm.com: updated the commit log]
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/host/pci-aardvark.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -932,7 +932,7 @@ static int advk_pcie_parse_request_of_pc
 					     0,	0xF8000000, 0,
 					     lower_32_bits(res->start),
 					     OB_PCIE_IO);
-			err = pci_remap_iospace(res, iobase);
+			err = devm_pci_remap_iospace(dev, res, iobase);
 			if (err) {
 				dev_warn(dev, "error %d: failed to map resource %pR\n",
 					 err, res);


