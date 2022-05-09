Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00FE51F9E9
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 12:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiEIKft (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 06:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiEIKfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 06:35:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F2C2A4A35
        for <stable@vger.kernel.org>; Mon,  9 May 2022 03:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4554460F92
        for <stable@vger.kernel.org>; Mon,  9 May 2022 10:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B11C385BF;
        Mon,  9 May 2022 10:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652092269;
        bh=qJVT2VsMzIJQ9ec6gUl4J6b+SOE+eg7AGo0Eg1/J+WQ=;
        h=Subject:To:Cc:From:Date:From;
        b=AaP4eXVqK862/IthKpjhwYShoAUCuj3/PTu4Yf0+OSiqRIbEn+6NFQw3DOhKly9yG
         vQsLWX+CXE2o0L1Q7AQrPhoeOomNvaJPg3Yne8spdHkzBSReuvksbTjzc/JxXupkw9
         rxejPpcxF5aA/w5mk5mraYxzbvtQoLOL0KAvV7p4=
Subject: FAILED: patch "[PATCH] net/mlx5: Fix slab-out-of-bounds while reading resource dump" failed to apply to 5.10-stable tree
To:     ayal@nvidia.com, moshe@nvidia.com, saeedm@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 May 2022 12:31:06 +0200
Message-ID: <1652092266221218@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7ba2d9d8de96696c1451fee1b01da11f45bdc2b9 Mon Sep 17 00:00:00 2001
From: Aya Levin <ayal@nvidia.com>
Date: Thu, 3 Mar 2022 19:02:03 +0200
Subject: [PATCH] net/mlx5: Fix slab-out-of-bounds while reading resource dump
 menu

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

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
index 538adab6878b..c5b560a8b026 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
@@ -31,6 +31,7 @@ static const char *const mlx5_rsc_sgmt_name[] = {
 struct mlx5_rsc_dump {
 	u32 pdn;
 	u32 mkey;
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
 

