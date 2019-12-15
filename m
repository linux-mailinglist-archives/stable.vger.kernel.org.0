Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 259D811F6F6
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 10:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfLOJZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 04:25:36 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:54965 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726081AbfLOJZg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Dec 2019 04:25:36 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 07A2A6A5;
        Sun, 15 Dec 2019 04:25:34 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 15 Dec 2019 04:25:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PmdUgx
        xmR2EB/IZPk6EOY5fh3a29DdoI/GTANESjrDc=; b=HTb4+RjMc+/lnyiu3vAFzV
        R3h3Tt2pfceBRoWJpD2ecFFMX07UJapMUzjjeHdDUlvhb1J96cRAprL4Qw+BoLdQ
        U6GpZHWkWIARTUnyn7v/eLjkHg8aFVtAzgT7KJ7g/I+giFlHZ5+OPdboP7faOxrC
        KWSgH+1IAg5GpVTyJ0nUYZxIWdzm8pgVUTZce+KQF2TNvKJaETfbuenJ7qK/ynj4
        bofDZBfOSmKt0M8cU35vxcO4SGOrewzNlD8UOL5qeaxI86rZ44VW5JcjU23KvMZC
        I1O1roh3mbdtSpAwatZEVIlQKDYznaSxHrzvscMc/+fA4B/BRoR0LuVwF57Z51ig
        ==
X-ME-Sender: <xms:Dvz1XWQTnTXDI_hnXXTOeL5dY72mT7hrVFN3VDRK9nG4iiRgsG7dPA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddtfedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:Dvz1XZLxmufu8unnyLnjpWjYsyvPdDqD9tmu9twWyjjWWB1Hbt5b8A>
    <xmx:Dvz1XbJ-nPloMNaefLNu4_uWnnyuHVrNEGHla1-lMuRp1vkf0-Xi4A>
    <xmx:Dvz1XchGTp0ao3FVS1tkkFEcoexwXGDdpKq3xy48RLdOOYebcRDMaA>
    <xmx:Dvz1XfLykJGnGW51DrytNdLOz8MWfCBGgJh0mHw6jHVxVaoNIJHDsA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 21F0680059;
        Sun, 15 Dec 2019 04:25:34 -0500 (EST)
Subject: FAILED: patch "[PATCH] xhci: Fix memory leak in xhci_add_in_port()" failed to apply to 4.4-stable tree
To:     mika.westerberg@linux.intel.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Dec 2019 10:25:32 +0100
Message-ID: <157640193266237@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ce91f1a43b37463f517155bdfbd525eb43adbd1a Mon Sep 17 00:00:00 2001
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Wed, 11 Dec 2019 16:20:02 +0200
Subject: [PATCH] xhci: Fix memory leak in xhci_add_in_port()

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

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index e16eda6e2b8b..3b1388fa2f36 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1909,13 +1909,17 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->usb3_rhub.num_ports = 0;
 	xhci->num_active_eps = 0;
 	kfree(xhci->usb2_rhub.ports);
+	kfree(xhci->usb2_rhub.psi);
 	kfree(xhci->usb3_rhub.ports);
+	kfree(xhci->usb3_rhub.psi);
 	kfree(xhci->hw_ports);
 	kfree(xhci->rh_bw);
 	kfree(xhci->ext_caps);
 
 	xhci->usb2_rhub.ports = NULL;
+	xhci->usb2_rhub.psi = NULL;
 	xhci->usb3_rhub.ports = NULL;
+	xhci->usb3_rhub.psi = NULL;
 	xhci->hw_ports = NULL;
 	xhci->rh_bw = NULL;
 	xhci->ext_caps = NULL;

