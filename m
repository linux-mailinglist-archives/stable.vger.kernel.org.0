Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5A22C0944
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388010AbgKWNFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:05:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:35044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387538AbgKWMuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:10 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D837204EF;
        Mon, 23 Nov 2020 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135808;
        bh=UgaWaxvzL2NwzXmYeeHXKHpeoq81OvYQoHkC06GMWSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvgx1nKprHiUiJaugDPPDBuROm+ONzCiXSbalpJh88xPAMH7nLlMXtuRB3lIIZtUP
         YVJvtHfz/w9oUnSfn+bMUf+kKBrXI7EGYP1XozeI4/KGWZKPhTzqIaMSGOpwUfR3Q6
         gmu+RnhFPYmwhCnlzAbEeNZ0CiMAE7sHcX/N1mkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: [PATCH 5.9 203/252] staging: mt7621-pci: avoid to request pci bus resources
Date:   Mon, 23 Nov 2020 13:22:33 +0100
Message-Id: <20201123121845.370888123@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

commit e2b2e4386cb7a5e935dff388cf8961317daf39ce upstream.

After upgrading kernel to version 5.9.x the driver was not
working anymore showing the following kernel trace:

...
mt7621-pci 1e140000.pcie: resource collision:
[mem 0x60000000-0x6fffffff] conflicts with pcie@1e140000 [mem 0x60000000-0x6fffffff]
------------[ cut here ]------------
WARNING: CPU: 2 PID: 73 at kernel/resource.c:1400
devm_request_resource+0xfc/0x10c
Modules linked in:
CPU: 2 PID: 73 Comm: kworker/2:1 Not tainted 5.9.2 #0
Workqueue: events deferred_probe_work_func
Stack : 00000000 81590000 807d0a1c 808a0000 8fd49080
        807d0000 00000009 808ac820
        00000001 808338d0 7fff0001 800839dc 00000049
        00000001 8fe51b00 367204ab
        00000000 00000000 807d0a1c 807c0000 00000001
        80082358 8fe50000 00559000
        00000000 8fe519f1 ffffffff 00000005 00000000
        00000001 00000000 807d0000
        00000009 808ac820 00000001 808338d0 00000001
        803bf1b0 00000008 81390008

Call Trace:
[<8000d018>] show_stack+0x30/0x100
[<8032e66c>] dump_stack+0xa4/0xd4
[<8002db1c>] __warn+0xc0/0x134
[<8002dbec>] warn_slowpath_fmt+0x5c/0xac
[<80033b34>] devm_request_resource+0xfc/0x10c
[<80365ff8>] devm_request_pci_bus_resources+0x58/0xdc
[<8048e13c>] mt7621_pci_probe+0x8dc/0xe48
[<803d2140>] platform_drv_probe+0x40/0x94
[<803cfd94>] really_probe+0x108/0x4ec
[<803cd958>] bus_for_each_drv+0x70/0xb0
[<803d0388>] __device_attach+0xec/0x164
[<803cec8c>] bus_probe_device+0xa4/0xc0
[<803cf1c4>] deferred_probe_work_func+0x80/0xc4
[<80048444>] process_one_work+0x260/0x510
[<80048a4c>] worker_thread+0x358/0x5cc
[<8004f7d0>] kthread+0x134/0x13c
[<80007478>] ret_from_kernel_thread+0x14/0x1c
---[ end trace a9dd2e37537510d3 ]---
mt7621-pci 1e140000.pcie: Error requesting resources
mt7621-pci: probe of 1e140000.pcie failed with error -16
...

With commit 669cbc708122 ("PCI: Move DT resource setup into
devm_pci_alloc_host_bridge()"), the DT 'ranges' is parsed and populated
into resources when the host bridge is allocated. The resources are
requested as well, but that happens a 2nd time for this driver in
mt7621_pcie_request_resources(). Hence we should avoid this second
request.

Also, the bus ranges was also populated by default, so we can remove
it from mt7621_pcie_request_resources() to avoid the following trace
if we don't avoid it:

pci_bus 0000:00: busn_res: can not insert [bus 00-ff]
under domain [bus 00-ff] (conflicts with (null) [bus 00-ff])

Function 'mt7621_pcie_request_resources' has been renamed into
'mt7621_pcie_add_resources' which now is a more accurate name
for this function.

Cc: stable@vger.kernel.org #5.9.x-
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20201102202515.19073-1-sergio.paracuellos@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/mt7621-pci/pci-mt7621.c |   15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -653,16 +653,11 @@ static int mt7621_pcie_init_virtual_brid
 	return 0;
 }
 
-static int mt7621_pcie_request_resources(struct mt7621_pcie *pcie,
-					 struct list_head *res)
+static void mt7621_pcie_add_resources(struct mt7621_pcie *pcie,
+				      struct list_head *res)
 {
-	struct device *dev = pcie->dev;
-
 	pci_add_resource_offset(res, &pcie->io, pcie->offset.io);
 	pci_add_resource_offset(res, &pcie->mem, pcie->offset.mem);
-	pci_add_resource(res, &pcie->busn);
-
-	return devm_request_pci_bus_resources(dev, res);
 }
 
 static int mt7621_pcie_register_host(struct pci_host_bridge *host,
@@ -738,11 +733,7 @@ static int mt7621_pci_probe(struct platf
 
 	setup_cm_memory_region(pcie);
 
-	err = mt7621_pcie_request_resources(pcie, &res);
-	if (err) {
-		dev_err(dev, "Error requesting resources\n");
-		return err;
-	}
+	mt7621_pcie_add_resources(pcie, &res);
 
 	err = mt7621_pcie_register_host(bridge, &res);
 	if (err) {


