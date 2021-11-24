Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9FD545D060
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344274AbhKXWw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:52:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:46912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244982AbhKXWw4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:52:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F00836109D;
        Wed, 24 Nov 2021 22:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794186;
        bh=NjlJTL4ZPbEw5cQQxGAfRcs3xGB+WW5/cc/JT2onMMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nf/pYugWsHV01GAEUCFUW3riREi9efXfJPljDsMrhZvfJkTwLPDKUUh8AWiiTSKz2
         sdlrTk/Mq90uHqy0AzeLj3nSFwc7S16scSp0RtP0Vw3ReQd5zeg4K8gw6L3q5bbObf
         oRT12lqf5dhr3+Xk6XBnrSqbZ9PEc0c8AG7nOzG9SIpkuVtdxmun2SK4y8/23TIjbe
         NjsZ8CwMB4M73SxqoB7vCpHrJbJ7PG8Fyt5kZFXywqadR3+QMwlrH/9KhfWeLi8HVy
         VXQMjWYFHRks7EE4K4Hb03nv47+tMy6OjDCIcu0lKC0vOKO8vS2Gn/7DPssQpr94Ag
         ggCricpIsSUng==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 01/24] PCI: aardvark: Fix I/O space page leak
Date:   Wed, 24 Nov 2021 23:49:10 +0100
Message-Id: <20211124224933.24275-2-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
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
---
 drivers/pci/host/pci-aardvark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index a572b2fb7af8..fd605796b011 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -932,7 +932,7 @@ static int advk_pcie_parse_request_of_pci_ranges(struct advk_pcie *pcie)
 					     0,	0xF8000000, 0,
 					     lower_32_bits(res->start),
 					     OB_PCIE_IO);
-			err = pci_remap_iospace(res, iobase);
+			err = devm_pci_remap_iospace(dev, res, iobase);
 			if (err) {
 				dev_warn(dev, "error %d: failed to map resource %pR\n",
 					 err, res);
-- 
2.32.0

