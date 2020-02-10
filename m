Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 632B3157A62
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgBJNW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:58972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbgBJMhY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:24 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A6E220873;
        Mon, 10 Feb 2020 12:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338243;
        bh=FOWCnvMdmttpPQGv2QmFi2SRVhZQ1BniZ8ZkWcVRhNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToOq7aMPG0yNzGXV1o/DVmlrwpXuVkPM9GcKrJ2LBfZnb6XtfNUgSp7K5tki+RdGX
         3z5ayFcouLdyk/aOueR/enw8N1beWMjH9ifJ9oA7bMrafu6gw4DdrHsu0eTMkD8cj3
         6+Tct4QLt1rayG6OhNJp46YsNjdSl3nxqvgSkm44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bitan Biswas <bbiswas@nvidia.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 5.4 100/309] nvmem: core: fix memory abort in cleanup path
Date:   Mon, 10 Feb 2020 04:30:56 -0800
Message-Id: <20200210122415.813230105@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bitan Biswas <bbiswas@nvidia.com>

commit 16bb7abc4a6b9defffa294e4dc28383e62a1dbcf upstream.

nvmem_cell_info_to_nvmem_cell implementation has static
allocation of name. nvmem_add_cells_from_of() call may
return error and kfree name results in memory abort. Use
kstrdup_const() and kfree_const calls for name alloc and free.

Unable to handle kernel paging request at virtual address ffffffffffe44888
Mem abort info:
  ESR = 0x96000006
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000006
  CM = 0, WnR = 0
swapper pgtable: 64k pages, 48-bit VAs, pgdp=00000000815d0000
[ffffffffffe44888] pgd=0000000081d30803, pud=0000000081d30803,
pmd=0000000000000000
Internal error: Oops: 96000006 [#1] PREEMPT SMP
Modules linked in:
CPU: 2 PID: 43 Comm: kworker/2:1 Tainted
Hardware name: quill (DT)
Workqueue: events deferred_probe_work_func
pstate: a0000005 (NzCv daif -PAN -UAO)
pc : kfree+0x38/0x278
lr : nvmem_cell_drop+0x68/0x80
sp : ffff80001284f9d0
x29: ffff80001284f9d0 x28: ffff0001f677e830
x27: ffff800011b0b000 x26: ffff0001c36e1008
x25: ffff8000112ad000 x24: ffff8000112c9000
x23: ffffffffffffffea x22: ffff800010adc7f0
x21: ffffffffffe44880 x20: ffff800011b0b068
x19: ffff80001122d380 x18: ffffffffffffffff
x17: 00000000d5cb4756 x16: 0000000070b193b8
x15: ffff8000119538c8 x14: 0720072007200720
x13: 07200720076e0772 x12: 07750762072d0765
x11: 0773077507660765 x10: 072f073007300730
x9 : 0730073207380733 x8 : 0000000000000151
x7 : 07660765072f0720 x6 : ffff0001c00e0f00
x5 : 0000000000000000 x4 : ffff0001c0b43800
x3 : ffff800011b0b068 x2 : 0000000000000000
x1 : 0000000000000000 x0 : ffffffdfffe00000
Call trace:
 kfree+0x38/0x278
 nvmem_cell_drop+0x68/0x80
 nvmem_device_remove_all_cells+0x2c/0x50
 nvmem_register.part.9+0x520/0x628
 devm_nvmem_register+0x48/0xa0
 tegra_fuse_probe+0x140/0x1f0
 platform_drv_probe+0x50/0xa0
 really_probe+0x108/0x348
 driver_probe_device+0x58/0x100
 __device_attach_driver+0x90/0xb0
 bus_for_each_drv+0x64/0xc8
 __device_attach+0xd8/0x138
 device_initial_probe+0x10/0x18
 bus_probe_device+0x90/0x98
 deferred_probe_work_func+0x74/0xb0
 process_one_work+0x1e0/0x358
 worker_thread+0x208/0x488
 kthread+0x118/0x120
 ret_from_fork+0x10/0x18
Code: d350feb5 f2dffbe0 aa1e03f6 8b151815 (f94006a0)
---[ end trace 49b1303c6b83198e ]---

Fixes: badcdff107cbf ("nvmem: Convert to using %pOFn instead of device_node.name")
Signed-off-by: Bitan Biswas <bbiswas@nvidia.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20200109104017.6249-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvmem/core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -110,7 +110,7 @@ static void nvmem_cell_drop(struct nvmem
 	list_del(&cell->node);
 	mutex_unlock(&nvmem_mutex);
 	of_node_put(cell->np);
-	kfree(cell->name);
+	kfree_const(cell->name);
 	kfree(cell);
 }
 
@@ -137,7 +137,9 @@ static int nvmem_cell_info_to_nvmem_cell
 	cell->nvmem = nvmem;
 	cell->offset = info->offset;
 	cell->bytes = info->bytes;
-	cell->name = info->name;
+	cell->name = kstrdup_const(info->name, GFP_KERNEL);
+	if (!cell->name)
+		return -ENOMEM;
 
 	cell->bit_offset = info->bit_offset;
 	cell->nbits = info->nbits;
@@ -327,7 +329,7 @@ static int nvmem_add_cells_from_of(struc
 			dev_err(dev, "cell %s unaligned to nvmem stride %d\n",
 				cell->name, nvmem->stride);
 			/* Cells already added will be freed later. */
-			kfree(cell->name);
+			kfree_const(cell->name);
 			kfree(cell);
 			return -EINVAL;
 		}


