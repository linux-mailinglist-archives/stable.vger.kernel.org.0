Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B20732AF4D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhCCAQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:16:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:46392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350241AbhCBMOU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:14:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F22D164F75;
        Tue,  2 Mar 2021 11:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686252;
        bh=/psRUJrzF/+lIPENVTGRXA5EbFyUi4ZN6AnumT3lG7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyBKvYQmp6fBCOKo5StCAdJO+WIuU3mOoYRQYMRSK1XGuXfB8vSYAxajFbIMQkUGS
         UiL7ucYsgdhKlSgt+/hW7vi2dnKqqX5sBYwOas8UHHayjdyXGdlhmqdvt1thhkrBKb
         GDI/aiONeZ0DLkD2F1z5BTI99TRqIkij9ZQ0vRsuxsGHu/I5EYLHG+UY0Q9xmHg0TN
         4E9kn4nJYds0Nb6EVT0JPBXb3fG8kPvzqOyZ8ThQK1q+EMT9Mf3GyAormUoZMZXZAL
         gSAmWcB7hVJYh5iuPDWHrqcjYjvmCRO2qVdhf4XsUtsCCCwsGr/eXJynkiq/dugmzP
         CKVRSuCrY6Xxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 37/47] PCI: Fix pci_register_io_range() memory leak
Date:   Tue,  2 Mar 2021 06:56:36 -0500
Message-Id: <20210302115646.62291-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115646.62291-1-sashal@kernel.org>
References: <20210302115646.62291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 6427cbd0a5be..a13b5ea987f6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4003,6 +4003,10 @@ int pci_register_io_range(struct fwnode_handle *fwnode, phys_addr_t addr,
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

