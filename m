Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B524C521906
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244121AbiEJNla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245151AbiEJNie (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DDB24F0E7;
        Tue, 10 May 2022 06:27:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38405B81DA8;
        Tue, 10 May 2022 13:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41EAC385A6;
        Tue, 10 May 2022 13:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189249;
        bh=p02favSh34gZ7SnATdPQxE9+DHKE8XXIFTE9gvxO68Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHKX2HuTIZ/UV3VpS01BTipskumaM+m83M7CoCVH7iIPvt6pJ7CK2iUzkvhzk2gPU
         3xBYCHx973aHKTos6T4XfUoc1krcCWv19g1cEZEXqiDz9Pa1yCgVag6PMVHlA/wz+u
         OJccFUv3xeQ/AImuU+5Cu0msYVLIX8vIs+QavB58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 59/70] net/mlx5: Fix slab-out-of-bounds while reading resource dump menu
Date:   Tue, 10 May 2022 15:08:18 +0200
Message-Id: <20220510130734.595173339@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 7ba2d9d8de96696c1451fee1b01da11f45bdc2b9 ]

Resource dump menu may span over more than a single page, support it.
Otherwise, menu read may result in a memory access violation: reading
outside of the allocated page.
Note that page format of the first menu page contains menu headers while
the proceeding menu pages contain only records.

The KASAN logs are as follows:
BUG: KASAN: slab-out-of-bounds in strcmp+0x9b/0xb0
Read of size 1 at addr ffff88812b2e1fd0 by task systemd-udevd/496

CPU: 5 PID: 496 Comm: systemd-udevd Tainted: G    B  5.16.0_for_upstream_debug_2022_01_10_23_12 #1
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x57/0x7d
 print_address_description.constprop.0+0x1f/0x140
 ? strcmp+0x9b/0xb0
 ? strcmp+0x9b/0xb0
 kasan_report.cold+0x83/0xdf
 ? strcmp+0x9b/0xb0
 strcmp+0x9b/0xb0
 mlx5_rsc_dump_init+0x4ab/0x780 [mlx5_core]
 ? mlx5_rsc_dump_destroy+0x80/0x80 [mlx5_core]
 ? lockdep_hardirqs_on_prepare+0x286/0x400
 ? raw_spin_unlock_irqrestore+0x47/0x50
 ? aomic_notifier_chain_register+0x32/0x40
 mlx5_load+0x104/0x2e0 [mlx5_core]
 mlx5_init_one+0x41b/0x610 [mlx5_core]
 ....
The buggy address belongs to the object at ffff88812b2e0000
 which belongs to the cache kmalloc-4k of size 4096
The buggy address is located 4048 bytes to the right of
 4096-byte region [ffff88812b2e0000, ffff88812b2e1000)
The buggy address belongs to the page:
page:000000009d69807a refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88812b2e6000 pfn:0x12b2e0
head:000000009d69807a order:3 compound_mapcount:0 compound_pincount:0
flags: 0x8000000000010200(slab|head|zone=2)
raw: 8000000000010200 0000000000000000 dead000000000001 ffff888100043040
raw: ffff88812b2e6000 0000000080040000 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88812b2e1e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88812b2e1f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88812b2e1f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                 ^
 ffff88812b2e2000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88812b2e2080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Fixes: 12206b17235a ("net/mlx5: Add support for resource dump")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/diag/rsc_dump.c        | 31 +++++++++++++++----
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index ed4fb79b4db7..75b6060f7a9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -31,6 +31,7 @@ static const char *const mlx5_rsc_sgmt_name[] = {
 struct mlx5_rsc_dump {
 	u32 pdn;
 	struct mlx5_core_mkey mkey;
+	u32 number_of_menu_items;
 	u16 fw_segment_type[MLX5_SGMT_TYPE_NUM];
 };
 
@@ -50,21 +51,37 @@ static int mlx5_rsc_dump_sgmt_get_by_name(char *name)
 	return -EINVAL;
 }
 
-static void mlx5_rsc_dump_read_menu_sgmt(struct mlx5_rsc_dump *rsc_dump, struct page *page)
+#define MLX5_RSC_DUMP_MENU_HEADER_SIZE (MLX5_ST_SZ_BYTES(resource_dump_info_segment) + \
+					MLX5_ST_SZ_BYTES(resource_dump_command_segment) + \
+					MLX5_ST_SZ_BYTES(resource_dump_menu_segment))
+
+static int mlx5_rsc_dump_read_menu_sgmt(struct mlx5_rsc_dump *rsc_dump, struct page *page,
+					int read_size, int start_idx)
 {
 	void *data = page_address(page);
 	enum mlx5_sgmt_type sgmt_idx;
 	int num_of_items;
 	char *sgmt_name;
 	void *member;
+	int size = 0;
 	void *menu;
 	int i;
 
-	menu = MLX5_ADDR_OF(menu_resource_dump_response, data, menu);
-	num_of_items = MLX5_GET(resource_dump_menu_segment, menu, num_of_records);
+	if (!start_idx) {
+		menu = MLX5_ADDR_OF(menu_resource_dump_response, data, menu);
+		rsc_dump->number_of_menu_items = MLX5_GET(resource_dump_menu_segment, menu,
+							  num_of_records);
+		size = MLX5_RSC_DUMP_MENU_HEADER_SIZE;
+		data += size;
+	}
+	num_of_items = rsc_dump->number_of_menu_items;
+
+	for (i = 0; start_idx + i < num_of_items; i++) {
+		size += MLX5_ST_SZ_BYTES(resource_dump_menu_record);
+		if (size >= read_size)
+			return start_idx + i;
 
-	for (i = 0; i < num_of_items; i++) {
-		member = MLX5_ADDR_OF(resource_dump_menu_segment, menu, record[i]);
+		member = data + MLX5_ST_SZ_BYTES(resource_dump_menu_record) * i;
 		sgmt_name =  MLX5_ADDR_OF(resource_dump_menu_record, member, segment_name);
 		sgmt_idx = mlx5_rsc_dump_sgmt_get_by_name(sgmt_name);
 		if (sgmt_idx == -EINVAL)
@@ -72,6 +89,7 @@ static void mlx5_rsc_dump_read_menu_sgmt(struct mlx5_rsc_dump *rsc_dump, struct
 		rsc_dump->fw_segment_type[sgmt_idx] = MLX5_GET(resource_dump_menu_record,
 							       member, segment_type);
 	}
+	return 0;
 }
 
 static int mlx5_rsc_dump_trigger(struct mlx5_core_dev *dev, struct mlx5_rsc_dump_cmd *cmd,
@@ -168,6 +186,7 @@ static int mlx5_rsc_dump_menu(struct mlx5_core_dev *dev)
 	struct mlx5_rsc_dump_cmd *cmd = NULL;
 	struct mlx5_rsc_key key = {};
 	struct page *page;
+	int start_idx = 0;
 	int size;
 	int err;
 
@@ -189,7 +208,7 @@ static int mlx5_rsc_dump_menu(struct mlx5_core_dev *dev)
 		if (err < 0)
 			goto destroy_cmd;
 
-		mlx5_rsc_dump_read_menu_sgmt(dev->rsc_dump, page);
+		start_idx = mlx5_rsc_dump_read_menu_sgmt(dev->rsc_dump, page, size, start_idx);
 
 	} while (err > 0);
 
-- 
2.35.1



