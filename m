Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14FB42A350F
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 21:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725809AbgKBUZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 15:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgKBUZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 15:25:19 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078DBC0617A6
        for <stable@vger.kernel.org>; Mon,  2 Nov 2020 12:25:18 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id d142so2034778wmd.4
        for <stable@vger.kernel.org>; Mon, 02 Nov 2020 12:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z20y1ekSURStQtxbZgRXH7SvO7IBDGeu9Ky2szxjYqI=;
        b=HKrEhcvt8jrNo+feS7Npj6HR132ee4nvCyjX4HnqPPNwxo/Lru0r5tZN99fexMgxmd
         BJrerkXwSzRs7HqaLI3phAmzWMbCrkdu7zYZ/70XX+NPRSzkf/9TcAT4aZVWX3JOkcTm
         ok+sIHdedFeLImFk9sHhTvOFUc6h/kKbZn1LoH1mxus03xynbQVuYYdRmgJFRGVbNQVB
         lEp05rpq7YFL2sdf5qj1JHU9MwNhQy9ug+EkyTf4GuS++7w3KUHBN+ubvPI9YCWqXifH
         uFlNcHcsigvH93SMfPB4UqpvULZg/aHRx0H5x35nu3I6lAX2dugBkfE4CHdZfhfH8TcK
         RfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=z20y1ekSURStQtxbZgRXH7SvO7IBDGeu9Ky2szxjYqI=;
        b=JxT0cuI4FBSZeG4NBoL9642+SWQ2AvGKVOdlXdKl7n/54o2fSvCAapgNsqHHO/zTFY
         NVNXOEiWEHZ5gNjhndynvEi0N5K2Aop47CqzVugBbxFwr5adi1Yt+85dyD+NgqgaELZw
         soShPHLPjCQaAP5z2P6GdQJ2m0t5gOD6f+6FNYcg26Ny0LLmEKjjJocxzUnZr1JCLymr
         BhsIvB58vDEmXMKPVQLpy7eDIITz+PdBxwRK+vSc1gWmyVeTgUS3pXQNf+kveJDBHx89
         lOAE1lA4/DMYjXymp1IXEw2yNNq52CNhmCV6npNmk/vyTbBENLID1Q/GiDkdnW5DTZQa
         w8cw==
X-Gm-Message-State: AOAM530b6gv/qKFIewUHDWQCyDjqAwww/qw8tKfa0g3i+E/6QiN4qBUd
        3Yjame95h2a3bkRNNqJlljDdgwOiIANIfg==
X-Google-Smtp-Source: ABdhPJxZIhrrweAOJKNgHxUHZ3fzkFyl7Da6DhOS31ZDEbitU7btN/3ppJk3LSe11MW6WXyiQZSYWQ==
X-Received: by 2002:a1c:f414:: with SMTP id z20mr19666839wma.110.1604348717692;
        Mon, 02 Nov 2020 12:25:17 -0800 (PST)
Received: from localhost.localdomain (123.red-83-39-246.dynamicip.rima-tde.net. [83.39.246.123])
        by smtp.gmail.com with ESMTPSA id m8sm23089840wrw.17.2020.11.02.12.25.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:25:16 -0800 (PST)
From:   Sergio Paracuellos <sergio.paracuellos@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     gregkh@linuxfoundation.org, neil@brown.name, stable@vger.kernel.org
Subject: [PATCH] staging: mt7621-pci: avoid to request pci bus resources
Date:   Mon,  2 Nov 2020 21:25:15 +0100
Message-Id: <20201102202515.19073-1-sergio.paracuellos@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org#5.9.x-
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
---
 drivers/staging/mt7621-pci/pci-mt7621.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
index f961b353c22e..8831db383fad 100644
--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -653,16 +653,11 @@ static int mt7621_pcie_init_virtual_bridges(struct mt7621_pcie *pcie)
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
@@ -738,11 +733,7 @@ static int mt7621_pci_probe(struct platform_device *pdev)
 
 	setup_cm_memory_region(pcie);
 
-	err = mt7621_pcie_request_resources(pcie, &res);
-	if (err) {
-		dev_err(dev, "Error requesting resources\n");
-		return err;
-	}
+	mt7621_pcie_add_resources(pcie, &res);
 
 	err = mt7621_pcie_register_host(bridge, &res);
 	if (err) {
-- 
2.25.1

