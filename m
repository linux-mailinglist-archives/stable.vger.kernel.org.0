Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E50B92A4
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391690AbfITOe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:34:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36306 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388228AbfITOZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqL-00051J-0v; Fri, 20 Sep 2019 15:25:05 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007zL-Lz; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jian Luo" <luojian5@huawei.com>,
        "Jason Yan" <yanaijie@huawei.com>,
        "John Garry" <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.708070718@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 126/132] scsi: libsas: delete sas port if expander
 discover failed
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Yan <yanaijie@huawei.com>

commit 3b0541791453fbe7f42867e310e0c9eb6295364d upstream.

The sas_port(phy->port) allocated in sas_ex_discover_expander() will not be
deleted when the expander failed to discover. This will cause resource leak
and a further issue of kernel BUG like below:

[159785.843156]  port-2:17:29: trying to add phy phy-2:17:29 fails: it's
already part of another port
[159785.852144] ------------[ cut here  ]------------
[159785.856833] kernel BUG at drivers/scsi/scsi_transport_sas.c:1086!
[159785.863000] Internal error: Oops - BUG: 0 [#1] SMP
[159785.867866] CPU: 39 PID: 16993 Comm: kworker/u96:2 Tainted: G
W  OE     4.19.25-vhulk1901.1.0.h111.aarch64 #1
[159785.878458] Hardware name: Huawei Technologies Co., Ltd.
Hi1620EVBCS/Hi1620EVBCS, BIOS Hi1620 CS B070 1P TA 03/21/2019
[159785.889231] Workqueue: 0000:74:02.0_disco_q sas_discover_domain
[159785.895224] pstate: 40c00009 (nZcv daif +PAN +UAO)
[159785.900094] pc : sas_port_add_phy+0x188/0x1b8
[159785.904524] lr : sas_port_add_phy+0x188/0x1b8
[159785.908952] sp : ffff0001120e3b80
[159785.912341] x29: ffff0001120e3b80 x28: 0000000000000000
[159785.917727] x27: ffff802ade8f5400 x26: ffff0000681b7560
[159785.923111] x25: ffff802adf11a800 x24: ffff0000680e8000
[159785.928496] x23: ffff802ade8f5728 x22: ffff802ade8f5708
[159785.933880] x21: ffff802adea2db40 x20: ffff802ade8f5400
[159785.939264] x19: ffff802adea2d800 x18: 0000000000000010
[159785.944649] x17: 00000000821bf734 x16: ffff00006714faa0
[159785.950033] x15: ffff0000e8ab4ecf x14: 7261702079646165
[159785.955417] x13: 726c612073277469 x12: ffff00006887b830
[159785.960802] x11: ffff00006773eaa0 x10: 7968702079687020
[159785.966186] x9 : 0000000000002453 x8 : 726f702072656874
[159785.971570] x7 : 6f6e6120666f2074 x6 : ffff802bcfb21290
[159785.976955] x5 : ffff802bcfb21290 x4 : 0000000000000000
[159785.982339] x3 : ffff802bcfb298c8 x2 : 337752b234c2ab00
[159785.987723] x1 : 337752b234c2ab00 x0 : 0000000000000000
[159785.993108] Process kworker/u96:2 (pid: 16993, stack limit =
0x0000000072dae094)
[159786.000576] Call trace:
[159786.003097]  sas_port_add_phy+0x188/0x1b8
[159786.007179]  sas_ex_get_linkrate.isra.5+0x134/0x140
[159786.012130]  sas_ex_discover_expander+0x128/0x408
[159786.016906]  sas_ex_discover_dev+0x218/0x4c8
[159786.021249]  sas_ex_discover_devices+0x9c/0x1a8
[159786.025852]  sas_discover_root_expander+0x134/0x160
[159786.030802]  sas_discover_domain+0x1b8/0x1e8
[159786.035148]  process_one_work+0x1b4/0x3f8
[159786.039230]  worker_thread+0x54/0x470
[159786.042967]  kthread+0x134/0x138
[159786.046269]  ret_from_fork+0x10/0x18
[159786.049918] Code: 91322300 f0004402 91178042 97fe4c9b (d4210000)
[159786.056083] Modules linked in: hns3_enet_ut(OE) hclge(OE) hnae3(OE)
hisi_sas_test_hw(OE) hisi_sas_test_main(OE) serdes(OE)
[159786.067202] ---[ end trace 03622b9e2d99e196  ]---
[159786.071893] Kernel panic - not syncing: Fatal exception
[159786.077190] SMP: stopping secondary CPUs
[159786.081192] Kernel Offset: disabled
[159786.084753] CPU features: 0x2,a2a00a38

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Reported-by: Jian Luo <luojian5@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/libsas/sas_expander.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -977,6 +977,8 @@ static struct domain_device *sas_ex_disc
 		list_del(&child->dev_list_node);
 		spin_unlock_irq(&parent->port->dev_list_lock);
 		sas_put_device(child);
+		sas_port_delete(phy->port);
+		phy->port = NULL;
 		return NULL;
 	}
 	list_add_tail(&child->siblings, &parent->ex_dev.children);

