Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D824D5DA
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfFTSBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727284AbfFTSBk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:01:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BAC62084A;
        Thu, 20 Jun 2019 18:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053699;
        bh=i4ORBx3pCH7xpGHnTrBVfT/x9fmtCRJMMQ65Zulqjy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rRyRoXQiUO68uWHHdAidu4toTa8KUYewF2LVVb+u53LDqkw/o9PBKuX3iQlKmiJ6k
         NTdhu45oS9m+VrchjNLyfKmXZyjFdGSo1QEeyLEws9Bsl9JEQlD4MfJuFjk4ZNzXTw
         1b8DP5djh1ShLIeWcQ425P9MEbKCb8DVAUAg6eto=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jian Luo <luojian5@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 81/84] scsi: libsas: delete sas port if expander discover failed
Date:   Thu, 20 Jun 2019 19:57:18 +0200
Message-Id: <20190620174349.055087498@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174337.538228162@linuxfoundation.org>
References: <20190620174337.538228162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3b0541791453fbe7f42867e310e0c9eb6295364d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index ee1f9ee995e5..400eee9d7783 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -978,6 +978,8 @@ static struct domain_device *sas_ex_discover_expander(
 		list_del(&child->dev_list_node);
 		spin_unlock_irq(&parent->port->dev_list_lock);
 		sas_put_device(child);
+		sas_port_delete(phy->port);
+		phy->port = NULL;
 		return NULL;
 	}
 	list_add_tail(&child->siblings, &parent->ex_dev.children);
-- 
2.20.1



