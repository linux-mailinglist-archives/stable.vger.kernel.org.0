Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0780813F3CB
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389943AbgAPRKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:10:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389994AbgAPRK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:10:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD102205F4;
        Thu, 16 Jan 2020 17:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194628;
        bh=o0erbUaUC7pqEF0OLj1K39f99PeV1BHjzKAV8TVCTN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KDsHcC52UVSu1dMyc4YEJzUtYEVJjkbwSBh2uuA8cJun31aQpQr1TD5KowSLnQCrr
         ZVSLdtF82hJkXuEycmR7c7AUEnXCuIz5Rykvk5Ws/lzpwfO4+ROBNGIoYsyO3SYL9d
         jU3DnAl6yT80dxOdf3YtbrFXFMC2PIGhWntTj1J4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xi Wang <wangxi11@huawei.com>, Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 488/671] RDMA/hns: Bugfix for slab-out-of-bounds when unloading hip08 driver
Date:   Thu, 16 Jan 2020 12:02:06 -0500
Message-Id: <20200116170509.12787-225-sashal@kernel.org>
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

[ Upstream commit 9bba3f0cbfc8abf2e1549ea03c0128186081d7a8 ]

kasan will report a BUG when run command 'rmmod hns_roce_hw_v2', the calltrace
is as follows:

==================================================================
BUG: KASAN: slab-out-of-bounds in hns_roce_table_mhop_put+0x584/0x828
[hns_roce]
Read of size 8 at addr ffff802185e08300 by task rmmod/270

Call trace:
dump_backtrace+0x0/0x1e8
show_stack+0x14/0x20
dump_stack+0xc4/0xfc
print_address_description+0x60/0x270
__kasan_report+0x164/0x1b8
kasan_report+0xc/0x18
__asan_load8+0x84/0xa8
hns_roce_table_mhop_put+0x584/0x828 [hns_roce]
hns_roce_table_put+0x174/0x1a0 [hns_roce]
hns_roce_mr_free+0x124/0x210 [hns_roce]
hns_roce_dereg_mr+0x90/0xb8 [hns_roce]
ib_dealloc_pd_user+0x60/0xf0
ib_mad_port_close+0x128/0x1d8
ib_mad_remove_device+0x94/0x118
remove_client_context+0xa0/0xe0
disable_device+0xfc/0x1c0
__ib_unregister_device+0x60/0xe0
ib_unregister_device+0x24/0x38
hns_roce_exit+0x3c/0x138 [hns_roce]
__hns_roce_hw_v2_uninit_instance.isra.30+0x28/0x50 [hns_roce_hw_v2]
hns_roce_hw_v2_uninit_instance+0x44/0x60 [hns_roce_hw_v2]
hclge_uninit_client_instance+0x15c/0x238 [hclge]
hnae3_uninit_client_instance+0x84/0xa8 [hnae3]
hnae3_unregister_client+0x84/0x158 [hnae3]
hns_roce_hw_v2_exit+0x14/0x20 [hns_roce_hw_v2]
__arm64_sys_delete_module+0x20c/0x308
el0_svc_handler+0xbc/0x210
el0_svc+0x8/0xc

Allocated by task 255:
__kasan_kmalloc.isra.0+0xd0/0x180
kasan_kmalloc+0xc/0x18
__kmalloc+0x16c/0x328
hns_roce_init_hem_table+0x20c/0x428 [hns_roce]
hns_roce_init+0x214/0xfe0 [hns_roce]
__hns_roce_hw_v2_init_instance+0x284/0x330 [hns_roce_hw_v2]
hns_roce_hw_v2_init_instance+0xd0/0x1b8 [hns_roce_hw_v2]
hclge_init_roce_client_instance+0x180/0x310 [hclge]
hclge_init_client_instance+0xcc/0x508 [hclge]
hnae3_init_client_instance.part.3+0x3c/0x80 [hnae3]
hnae3_register_client+0x134/0x1a8 [hnae3]
0xffff200009c00014
do_one_initcall+0x9c/0x3e0
do_init_module+0xd4/0x2d8
load_module+0x3284/0x3690
__se_sys_init_module+0x274/0x308
__arm64_sys_init_module+0x40/0x50
el0_svc_handler+0xbc/0x210
el0_svc+0x8/0xc

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff802185e06300
which belongs to the cache kmalloc-8k of size 8192
The buggy address is located 0 bytes to the right of
8192-byte region [ffff802185e06300, ffff802185e08300)
The buggy address belongs to the page:
page:ffff7fe008617800 refcount:1 mapcount:0 mapping:ffff802340020e00 index:0x0
compound_mapcount: 0
flags: 0x5fffe00000010200(slab|head)
raw: 5fffe00000010200 dead000000000100 dead000000000200 ffff802340020e00
raw: 0000000000000000 00000000803e003e 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
ffff802185e08200: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
ffff802185e08280: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff802185e08300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
^
ffff802185e08380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff802185e08400: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================
Disabling lock debugging due to kernel taint

Fixes: a25d13cbe816 ("RDMA/hns: Add the interfaces to support multi hop addressing for the contexts in hip08")

Signed-off-by: Xi Wang <wangxi11@huawei.com>
Link: https://lore.kernel.org/r/1565343666-73193-6-git-send-email-oulijun@huawei.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index a73d388b7093..31b9b99f81cb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -54,12 +54,13 @@ bool hns_roce_check_whether_mhop(struct hns_roce_dev *hr_dev, u32 type)
 EXPORT_SYMBOL_GPL(hns_roce_check_whether_mhop);
 
 static bool hns_roce_check_hem_null(struct hns_roce_hem **hem, u64 start_idx,
-			    u32 bt_chunk_num)
+			    u32 bt_chunk_num, u64 hem_max_num)
 {
-	int i;
+	u64 check_max_num = start_idx + bt_chunk_num;
+	u64 i;
 
-	for (i = 0; i < bt_chunk_num; i++)
-		if (hem[start_idx + i])
+	for (i = start_idx; (i < check_max_num) && (i < hem_max_num); i++)
+		if (hem[i])
 			return false;
 
 	return true;
@@ -413,6 +414,12 @@ static int hns_roce_table_mhop_get(struct hns_roce_dev *hr_dev,
 		return -EINVAL;
 	}
 
+	if (unlikely(hem_idx >= table->num_hem)) {
+		dev_err(dev, "Table %d exceed hem limt idx = %llu,max = %lu!\n",
+			     table->type, hem_idx, table->num_hem);
+		return -EINVAL;
+	}
+
 	mutex_lock(&table->mutex);
 
 	if (table->hem[hem_idx]) {
@@ -649,7 +656,7 @@ static void hns_roce_table_mhop_put(struct hns_roce_dev *hr_dev,
 	if (check_whether_bt_num_2(table->type, hop_num)) {
 		start_idx = mhop.l0_idx * chunk_ba_num;
 		if (hns_roce_check_hem_null(table->hem, start_idx,
-					    chunk_ba_num)) {
+					    chunk_ba_num, table->num_hem)) {
 			if (table->type < HEM_TYPE_MTT &&
 			    hr_dev->hw->clear_hem(hr_dev, table, obj, 0))
 				dev_warn(dev, "Clear HEM base address failed.\n");
@@ -663,7 +670,7 @@ static void hns_roce_table_mhop_put(struct hns_roce_dev *hr_dev,
 		start_idx = mhop.l0_idx * chunk_ba_num * chunk_ba_num +
 			    mhop.l1_idx * chunk_ba_num;
 		if (hns_roce_check_hem_null(table->hem, start_idx,
-					    chunk_ba_num)) {
+					    chunk_ba_num, table->num_hem)) {
 			if (hr_dev->hw->clear_hem(hr_dev, table, obj, 1))
 				dev_warn(dev, "Clear HEM base address failed.\n");
 
-- 
2.20.1

