Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89CFF2A165C
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgJaLot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:44:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728191AbgJaLor (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:44:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD46820731;
        Sat, 31 Oct 2020 11:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144686;
        bh=wVWm2VifxePr2HWpxnkCetUTc4lBQunCUQUjTCKM6Tg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Blvd3gQS9XkUqRB20seAYrvZLAS45C9GPBIbJKPyd5GH096ws+z5hvdh7ICjJSHKn
         7lLfZukHScp5eAn8xWMoep0jhW5BKwTR49wchw83X+0eQcemc0VXRwaa2hSII85kzr
         mVZv3DyJxWW+8U0VKkwAhFTxmVgzDDrx1Y5VO9Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 42/74] net: hns3: Clear the CMDQ registers before unmapping BAR region
Date:   Sat, 31 Oct 2020 12:36:24 +0100
Message-Id: <20201031113502.060276944@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit e3364c5ff3ff975b943a7bf47e21a2a4bf20f3fe ]

When unbinding the hns3 driver with the HNS3 VF, I got the following
kernel panic:

[  265.709989] Unable to handle kernel paging request at virtual address ffff800054627000
[  265.717928] Mem abort info:
[  265.720740]   ESR = 0x96000047
[  265.723810]   EC = 0x25: DABT (current EL), IL = 32 bits
[  265.729126]   SET = 0, FnV = 0
[  265.732195]   EA = 0, S1PTW = 0
[  265.735351] Data abort info:
[  265.738227]   ISV = 0, ISS = 0x00000047
[  265.742071]   CM = 0, WnR = 1
[  265.745055] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000009b54000
[  265.751753] [ffff800054627000] pgd=0000202ffffff003, p4d=0000202ffffff003, pud=00002020020eb003, pmd=00000020a0dfc003, pte=0000000000000000
[  265.764314] Internal error: Oops: 96000047 [#1] SMP
[  265.830357] CPU: 61 PID: 20319 Comm: bash Not tainted 5.9.0+ #206
[  265.836423] Hardware name: Huawei TaiShan 2280 V2/BC82AMDDA, BIOS 1.05 09/18/2019
[  265.843873] pstate: 80400009 (Nzcv daif +PAN -UAO -TCO BTYPE=--)
[  265.843890] pc : hclgevf_cmd_uninit+0xbc/0x300
[  265.861988] lr : hclgevf_cmd_uninit+0xb0/0x300
[  265.861992] sp : ffff80004c983b50
[  265.881411] pmr_save: 000000e0
[  265.884453] x29: ffff80004c983b50 x28: ffff20280bbce500
[  265.889744] x27: 0000000000000000 x26: 0000000000000000
[  265.895034] x25: ffff800011a1f000 x24: ffff800011a1fe90
[  265.900325] x23: ffff0020ce9b00d8 x22: ffff0020ce9b0150
[  265.905616] x21: ffff800010d70e90 x20: ffff800010d70e90
[  265.910906] x19: ffff0020ce9b0080 x18: 0000000000000004
[  265.916198] x17: 0000000000000000 x16: ffff800011ae32e8
[  265.916201] x15: 0000000000000028 x14: 0000000000000002
[  265.916204] x13: ffff800011ae32e8 x12: 0000000000012ad8
[  265.946619] x11: ffff80004c983b50 x10: 0000000000000000
[  265.951911] x9 : ffff8000115d0888 x8 : 0000000000000000
[  265.951914] x7 : ffff800011890b20 x6 : c0000000ffff7fff
[  265.951917] x5 : ffff80004c983930 x4 : 0000000000000001
[  265.951919] x3 : ffffa027eec1b000 x2 : 2b78ccbbff369100
[  265.964487] x1 : 0000000000000000 x0 : ffff800054627000
[  265.964491] Call trace:
[  265.964494]  hclgevf_cmd_uninit+0xbc/0x300
[  265.964496]  hclgevf_uninit_ae_dev+0x9c/0xe8
[  265.964501]  hnae3_unregister_ae_dev+0xb0/0x130
[  265.964516]  hns3_remove+0x34/0x88 [hns3]
[  266.009683]  pci_device_remove+0x48/0xf0
[  266.009692]  device_release_driver_internal+0x114/0x1e8
[  266.030058]  device_driver_detach+0x28/0x38
[  266.034224]  unbind_store+0xd4/0x108
[  266.037784]  drv_attr_store+0x40/0x58
[  266.041435]  sysfs_kf_write+0x54/0x80
[  266.045081]  kernfs_fop_write+0x12c/0x250
[  266.049076]  vfs_write+0xc4/0x248
[  266.052378]  ksys_write+0x74/0xf8
[  266.055677]  __arm64_sys_write+0x24/0x30
[  266.059584]  el0_svc_common.constprop.3+0x84/0x270
[  266.064354]  do_el0_svc+0x34/0xa0
[  266.067658]  el0_svc+0x38/0x40
[  266.070700]  el0_sync_handler+0x8c/0xb0
[  266.074519]  el0_sync+0x140/0x180

It looks like the BAR memory region had already been unmapped before we
start clearing CMDQ registers in it, which is pretty bad and the kernel
happily kills itself because of a Current EL Data Abort (on arm64).

Moving the CMDQ uninitialization a bit early fixes the issue for me.

Fixes: 862d969a3a4d ("net: hns3: do VF's pci re-initialization while PF doing FLR")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/r/20201023051550.793-1-yuzenghui@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -3146,8 +3146,8 @@ static void hclgevf_uninit_hdev(struct h
 		hclgevf_uninit_msi(hdev);
 	}
 
-	hclgevf_pci_uninit(hdev);
 	hclgevf_cmd_uninit(hdev);
+	hclgevf_pci_uninit(hdev);
 	hclgevf_uninit_mac_list(hdev);
 }
 


