Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DF733B90D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234755AbhCOOFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232345AbhCOOBJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 465AD64EEA;
        Mon, 15 Mar 2021 14:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816834;
        bh=zlkpxfTDPf612iSdQJZlqOyob7w9Pu8d0f5TZ2vUOoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jBK21IBbZy316eMg11c/H+nxKZl/pXglrOhVKvHKfWr7evuB3ZoXCt1cLglKjQ+i3
         TS1mNU29buZgdK3r2FH0BuMCHPfASHq+oAlx+B3uM8dtOG3oAw66TanERl8OFdB3qY
         TJoBIkwDqbM1rD6RBerRYCJ/vw7VYpiY/8oInF+Q=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 153/306] PCI: Fix pci_register_io_range() memory leak
Date:   Mon, 15 Mar 2021 14:53:36 +0100
Message-Id: <20210315135512.811790420@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f6bda644fa3a7070621c3bf12cd657f69a42f170 ]

Kmemleak reports:

  unreferenced object 0xc328de40 (size 64):
    comm "kworker/1:1", pid 21, jiffies 4294938212 (age 1484.670s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 e0 d8 fc eb 00 00 00 00  ................
      00 00 10 fe 00 00 00 00 00 00 00 00 00 00 00 00  ................

  backtrace:
    [<ad758d10>] pci_register_io_range+0x3c/0x80
    [<2c7f139e>] of_pci_range_to_resource+0x48/0xc0
    [<f079ecc8>] devm_of_pci_get_host_bridge_resources.constprop.0+0x2ac/0x3ac
    [<e999753b>] devm_of_pci_bridge_init+0x60/0x1b8
    [<a895b229>] devm_pci_alloc_host_bridge+0x54/0x64
    [<e451ddb0>] rcar_pcie_probe+0x2c/0x644

In case a PCI host driver's probe is deferred, the same I/O range may be
allocated again, and be ignored, causing a memory leak.

Fix this by (a) letting logic_pio_register_range() return -EEXIST if the
passed range already exists, so pci_register_io_range() will free it, and
by (b) making pci_register_io_range() not consider -EEXIST an error
condition.

Link: https://lore.kernel.org/r/20210202100332.829047-1-geert+renesas@glider.be
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 4 ++++
 lib/logic_pio.c   | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index ba791165ed19..9449dfde2841 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4029,6 +4029,10 @@ int pci_register_io_range(struct fwnode_handle *fwnode, phys_addr_t addr,
 	ret = logic_pio_register_range(range);
 	if (ret)
 		kfree(range);
+
+	/* Ignore duplicates due to deferred probing */
+	if (ret == -EEXIST)
+		ret = 0;
 #endif
 
 	return ret;
diff --git a/lib/logic_pio.c b/lib/logic_pio.c
index f32fe481b492..07b4b9a1f54b 100644
--- a/lib/logic_pio.c
+++ b/lib/logic_pio.c
@@ -28,6 +28,8 @@ static DEFINE_MUTEX(io_range_mutex);
  * @new_range: pointer to the IO range to be registered.
  *
  * Returns 0 on success, the error code in case of failure.
+ * If the range already exists, -EEXIST will be returned, which should be
+ * considered a success.
  *
  * Register a new IO range node in the IO range list.
  */
@@ -51,6 +53,7 @@ int logic_pio_register_range(struct logic_pio_hwaddr *new_range)
 	list_for_each_entry(range, &io_range_list, list) {
 		if (range->fwnode == new_range->fwnode) {
 			/* range already there */
+			ret = -EEXIST;
 			goto end_register;
 		}
 		if (range->flags == LOGIC_PIO_CPU_MMIO &&
-- 
2.30.1



