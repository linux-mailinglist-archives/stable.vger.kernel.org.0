Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC7CE13F3D8
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389457AbgAPSp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:45:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:48726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389591AbgAPRKa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E262124684;
        Thu, 16 Jan 2020 17:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194629;
        bh=1/ASeynZUsqLzaSrvpUafd5MSqbFUwvfVuXSWvidvbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iyBFDEHXj3K07bs1OxzWXxyJqK7vlB/S9jwBqjV3IbjSYXAPW9xVq+NMiSkObDlo1
         s/LYCQn8scvxbWAx54fhhQ5GGa5nR77SURi+2m7AGHVVhEUWEBoviZKDn/L21LXJ5F
         Eb/FjtT1ozur9CLuoRgoxXYqXZyrADwZX/hgjnpA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xi Wang <wangxi11@huawei.com>, Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 489/671] RDMA/hns: bugfix for slab-out-of-bounds when loading hip08 driver
Date:   Thu, 16 Jan 2020 12:02:07 -0500
Message-Id: <20200116170509.12787-226-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit bf8c02f961c89e5ccae5987b7ab28f5592a35101 ]

kasan will report a BUG when run command 'insmod hns_roce_hw_v2.ko', the
calltrace is as follows:

==================================================================
BUG: KASAN: slab-out-of-bounds in hns_roce_v2_init_eq_table+0x1324/0x1948
[hns_roce_hw_v2]
Read of size 8 at addr ffff8020e7a10608 by task insmod/256

CPU: 0 PID: 256 Comm: insmod Tainted: G           O      5.2.0-rc4 #1
Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI RC0
Call trace:
dump_backtrace+0x0/0x1e8
show_stack+0x14/0x20
dump_stack+0xc4/0xfc
print_address_description+0x60/0x270
__kasan_report+0x164/0x1b8
kasan_report+0xc/0x18
__asan_load8+0x84/0xa8
hns_roce_v2_init_eq_table+0x1324/0x1948 [hns_roce_hw_v2]
hns_roce_init+0xf8/0xfe0 [hns_roce]
__hns_roce_hw_v2_init_instance+0x284/0x330 [hns_roce_hw_v2]
hns_roce_hw_v2_init_instance+0xd0/0x1b8 [hns_roce_hw_v2]
hclge_init_roce_client_instance+0x180/0x310 [hclge]
hclge_init_client_instance+0xcc/0x508 [hclge]
hnae3_init_client_instance.part.3+0x3c/0x80 [hnae3]
hnae3_register_client+0x134/0x1a8 [hnae3]
hns_roce_hw_v2_init+0x14/0x10000 [hns_roce_hw_v2]
do_one_initcall+0x9c/0x3e0
do_init_module+0xd4/0x2d8
load_module+0x3284/0x3690
__se_sys_init_module+0x274/0x308
__arm64_sys_init_module+0x40/0x50
el0_svc_handler+0xbc/0x210
el0_svc+0x8/0xc

Allocated by task 256:
__kasan_kmalloc.isra.0+0xd0/0x180
kasan_kmalloc+0xc/0x18
__kmalloc+0x16c/0x328
hns_roce_v2_init_eq_table+0x764/0x1948 [hns_roce_hw_v2]
hns_roce_init+0xf8/0xfe0 [hns_roce]
__hns_roce_hw_v2_init_instance+0x284/0x330 [hns_roce_hw_v2]
hns_roce_hw_v2_init_instance+0xd0/0x1b8 [hns_roce_hw_v2]
hclge_init_roce_client_instance+0x180/0x310 [hclge]
hclge_init_client_instance+0xcc/0x508 [hclge]
hnae3_init_client_instance.part.3+0x3c/0x80 [hnae3]
hnae3_register_client+0x134/0x1a8 [hnae3]
hns_roce_hw_v2_init+0x14/0x10000 [hns_roce_hw_v2]
do_one_initcall+0x9c/0x3e0
do_init_module+0xd4/0x2d8
load_module+0x3284/0x3690
__se_sys_init_module+0x274/0x308
__arm64_sys_init_module+0x40/0x50
el0_svc_handler+0xbc/0x210
el0_svc+0x8/0xc

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff8020e7a10600
which belongs to the cache kmalloc-128 of size 128
The buggy address is located 8 bytes inside of
128-byte region [ffff8020e7a10600, ffff8020e7a10680)
The buggy address belongs to the page:
page:ffff7fe00839e840 refcount:1 mapcount:0 mapping:ffff802340020200 index:0x0
flags: 0x5fffe00000000200(slab)
raw: 5fffe00000000200 dead000000000100 dead000000000200 ffff802340020200
raw: 0000000000000000 0000000081000100 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
ffff8020e7a10500: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
ffff8020e7a10580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8020e7a10600: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
^
ffff8020e7a10680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff8020e7a10700: 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================
Disabling lock debugging due to kernel taint

Fixes: a5073d6054f7 ("RDMA/hns: Add eq support of hip08")

Signed-off-by: Xi Wang <wangxi11@huawei.com>
Link: https://lore.kernel.org/r/1565343666-73193-7-git-send-email-oulijun@huawei.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 7021444f18b4..417de7ac0d5e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4833,7 +4833,8 @@ static int hns_roce_mhop_alloc_eq(struct hns_roce_dev *hr_dev,
 				break;
 		}
 		eq->cur_eqe_ba = eq->buf_dma[0];
-		eq->nxt_eqe_ba = eq->buf_dma[1];
+		if (ba_num > 1)
+			eq->nxt_eqe_ba = eq->buf_dma[1];
 
 	} else if (mhop_num == 2) {
 		/* alloc L1 BT and buf */
@@ -4875,7 +4876,8 @@ static int hns_roce_mhop_alloc_eq(struct hns_roce_dev *hr_dev,
 				break;
 		}
 		eq->cur_eqe_ba = eq->buf_dma[0];
-		eq->nxt_eqe_ba = eq->buf_dma[1];
+		if (ba_num > 1)
+			eq->nxt_eqe_ba = eq->buf_dma[1];
 	}
 
 	eq->l0_last_num = i + 1;
-- 
2.20.1

