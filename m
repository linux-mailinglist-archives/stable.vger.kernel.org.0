Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE7C126A7A
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfLSSro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:47:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729512AbfLSSrn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:47:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD02024672;
        Thu, 19 Dec 2019 18:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781262;
        bh=91XH1GDDOmrZSUmM+Gft43WB64RqaYf64kQ1SWB7K+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7sBTwDKELCs9Pq+ReAPwQAkHSQQ7K01CGaAaV8C+xv2QXsNZ7oRJWSFi75aEY+BI
         4KPAusTNnr6P1jUtjVompL95NWK1TYOJObGiWVx7exaPS1BtHlcOa8c9m8m7VK2jeu
         kTkxZzNR0XHbhWz4VZICyKUv5uhTlUiuFj4fnlvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 149/199] xhci: Fix memory leak in xhci_add_in_port()
Date:   Thu, 19 Dec 2019 19:33:51 +0100
Message-Id: <20191219183223.502477436@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit ce91f1a43b37463f517155bdfbd525eb43adbd1a ]

When xHCI is part of Alpine or Titan Ridge Thunderbolt controller and
the xHCI device is hot-removed as a result of unplugging a dock for
example, the driver leaks memory it allocates for xhci->usb3_rhub.psi
and xhci->usb2_rhub.psi in xhci_add_in_port() as reported by kmemleak:

unreferenced object 0xffff922c24ef42f0 (size 16):
  comm "kworker/u16:2", pid 178, jiffies 4294711640 (age 956.620s)
  hex dump (first 16 bytes):
    21 00 0c 00 12 00 dc 05 23 00 e0 01 00 00 00 00  !.......#.......
  backtrace:
    [<000000007ac80914>] xhci_mem_init+0xcf8/0xeb7
    [<0000000001b6d775>] xhci_init+0x7c/0x160
    [<00000000db443fe3>] xhci_gen_setup+0x214/0x340
    [<00000000fdffd320>] xhci_pci_setup+0x48/0x110
    [<00000000541e1e03>] usb_add_hcd.cold+0x265/0x747
    [<00000000ca47a56b>] usb_hcd_pci_probe+0x219/0x3b4
    [<0000000021043861>] xhci_pci_probe+0x24/0x1c0
    [<00000000b9231f25>] local_pci_probe+0x3d/0x70
    [<000000006385c9d7>] pci_device_probe+0xd0/0x150
    [<0000000070241068>] really_probe+0xf5/0x3c0
    [<0000000061f35c0a>] driver_probe_device+0x58/0x100
    [<000000009da11198>] bus_for_each_drv+0x79/0xc0
    [<000000009ce45f69>] __device_attach+0xda/0x160
    [<00000000df201aaf>] pci_bus_add_device+0x46/0x70
    [<0000000088a1bc48>] pci_bus_add_devices+0x27/0x60
    [<00000000ad9ee708>] pci_bus_add_devices+0x52/0x60
unreferenced object 0xffff922c24ef3318 (size 8):
  comm "kworker/u16:2", pid 178, jiffies 4294711640 (age 956.620s)
  hex dump (first 8 bytes):
    34 01 05 00 35 41 0a 00                          4...5A..
  backtrace:
    [<000000007ac80914>] xhci_mem_init+0xcf8/0xeb7
    [<0000000001b6d775>] xhci_init+0x7c/0x160
    [<00000000db443fe3>] xhci_gen_setup+0x214/0x340
    [<00000000fdffd320>] xhci_pci_setup+0x48/0x110
    [<00000000541e1e03>] usb_add_hcd.cold+0x265/0x747
    [<00000000ca47a56b>] usb_hcd_pci_probe+0x219/0x3b4
    [<0000000021043861>] xhci_pci_probe+0x24/0x1c0
    [<00000000b9231f25>] local_pci_probe+0x3d/0x70
    [<000000006385c9d7>] pci_device_probe+0xd0/0x150
    [<0000000070241068>] really_probe+0xf5/0x3c0
    [<0000000061f35c0a>] driver_probe_device+0x58/0x100
    [<000000009da11198>] bus_for_each_drv+0x79/0xc0
    [<000000009ce45f69>] __device_attach+0xda/0x160
    [<00000000df201aaf>] pci_bus_add_device+0x46/0x70
    [<0000000088a1bc48>] pci_bus_add_devices+0x27/0x60
    [<00000000ad9ee708>] pci_bus_add_devices+0x52/0x60

Fix this by calling kfree() for the both psi objects in
xhci_mem_cleanup().

Cc: <stable@vger.kernel.org> # 4.4+
Fixes: 47189098f8be ("xhci: parse xhci protocol speed ID list for usb 3.1 usage")
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20191211142007.8847-2-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-mem.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 7199e400fbace..19818367ff5c3 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1940,10 +1940,14 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	kfree(xhci->port_array);
 	kfree(xhci->rh_bw);
 	kfree(xhci->ext_caps);
+	kfree(xhci->usb2_rhub.psi);
+	kfree(xhci->usb3_rhub.psi);
 
 	xhci->usb2_ports = NULL;
 	xhci->usb3_ports = NULL;
 	xhci->port_array = NULL;
+	xhci->usb2_rhub.psi = NULL;
+	xhci->usb3_rhub.psi = NULL;
 	xhci->rh_bw = NULL;
 	xhci->ext_caps = NULL;
 
-- 
2.20.1



