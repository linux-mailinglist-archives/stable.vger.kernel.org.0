Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD40CE684C
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732172AbfJ0VWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732166AbfJ0VWa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:22:30 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25EC621726;
        Sun, 27 Oct 2019 21:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211349;
        bh=df4Y9A4zKSCoojkUKFKYOB6WZIW3Pesuoio2VX51KR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZpHXYmTK+ErPw3YKsbzXmYznO4gGIMEJFtz8Cnyt228b2/ELsJntCNewNG2oJeY5
         hNCFRTbjSe7pDYcjVgK1FDKue2GUUqyEj3UJN7Aij1RGru+UxtBsDbHtnFilDZwX76
         /Ixu8REfAnDm2XSaSr2tKm4EWKPk6FLw2dn52ebg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Garry <john.garry@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.3 119/197] ACPI: CPPC: Set pcc_data[pcc_ss_id] to NULL in acpi_cppc_processor_exit()
Date:   Sun, 27 Oct 2019 22:00:37 +0100
Message-Id: <20191027203358.152932208@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

commit 56a0b978d42f58c7e3ba715cf65af487d427524d upstream.

When enabling KASAN and DEBUG_TEST_DRIVER_REMOVE, I find this KASAN
warning:

[   20.872057] BUG: KASAN: use-after-free in pcc_data_alloc+0x40/0xb8
[   20.878226] Read of size 4 at addr ffff00236cdeb684 by task swapper/0/1
[   20.884826]
[   20.886309] CPU: 19 PID: 1 Comm: swapper/0 Not tainted 5.4.0-rc1-00009-ge7f7df3db5bf-dirty #289
[   20.894994] Hardware name: Huawei D06 /D06, BIOS Hisilicon D06 UEFI RC0 - V1.16.01 03/15/2019
[   20.903505] Call trace:
[   20.905942]  dump_backtrace+0x0/0x200
[   20.909593]  show_stack+0x14/0x20
[   20.912899]  dump_stack+0xd4/0x130
[   20.916291]  print_address_description.isra.9+0x6c/0x3b8
[   20.921592]  __kasan_report+0x12c/0x23c
[   20.925417]  kasan_report+0xc/0x18
[   20.928808]  __asan_load4+0x94/0xb8
[   20.932286]  pcc_data_alloc+0x40/0xb8
[   20.935938]  acpi_cppc_processor_probe+0x4e8/0xb08
[   20.940717]  __acpi_processor_start+0x48/0xb0
[   20.945062]  acpi_processor_start+0x40/0x60
[   20.949235]  really_probe+0x118/0x548
[   20.952887]  driver_probe_device+0x7c/0x148
[   20.957059]  device_driver_attach+0x94/0xa0
[   20.961231]  __driver_attach+0xa4/0x110
[   20.965055]  bus_for_each_dev+0xe8/0x158
[   20.968966]  driver_attach+0x30/0x40
[   20.972531]  bus_add_driver+0x234/0x2f0
[   20.976356]  driver_register+0xbc/0x1d0
[   20.980182]  acpi_processor_driver_init+0x40/0xe4
[   20.984875]  do_one_initcall+0xb4/0x254
[   20.988700]  kernel_init_freeable+0x24c/0x2f8
[   20.993047]  kernel_init+0x10/0x118
[   20.996524]  ret_from_fork+0x10/0x18
[   21.000087]
[   21.001567] Allocated by task 1:
[   21.004785]  save_stack+0x28/0xc8
[   21.008089]  __kasan_kmalloc.isra.9+0xbc/0xd8
[   21.012435]  kasan_kmalloc+0xc/0x18
[   21.015913]  pcc_data_alloc+0x94/0xb8
[   21.019564]  acpi_cppc_processor_probe+0x4e8/0xb08
[   21.024343]  __acpi_processor_start+0x48/0xb0
[   21.028689]  acpi_processor_start+0x40/0x60
[   21.032860]  really_probe+0x118/0x548
[   21.036512]  driver_probe_device+0x7c/0x148
[   21.040684]  device_driver_attach+0x94/0xa0
[   21.044855]  __driver_attach+0xa4/0x110
[   21.048680]  bus_for_each_dev+0xe8/0x158
[   21.052591]  driver_attach+0x30/0x40
[   21.056155]  bus_add_driver+0x234/0x2f0
[   21.059980]  driver_register+0xbc/0x1d0
[   21.063805]  acpi_processor_driver_init+0x40/0xe4
[   21.068497]  do_one_initcall+0xb4/0x254
[   21.072322]  kernel_init_freeable+0x24c/0x2f8
[   21.076667]  kernel_init+0x10/0x118
[   21.080144]  ret_from_fork+0x10/0x18
[   21.083707]
[   21.085186] Freed by task 1:
[   21.088056]  save_stack+0x28/0xc8
[   21.091360]  __kasan_slab_free+0x118/0x180
[   21.095445]  kasan_slab_free+0x10/0x18
[   21.099183]  kfree+0x80/0x268
[   21.102139]  acpi_cppc_processor_exit+0x1a8/0x1b8
[   21.106832]  acpi_processor_stop+0x70/0x80
[   21.110917]  really_probe+0x174/0x548
[   21.114568]  driver_probe_device+0x7c/0x148
[   21.118740]  device_driver_attach+0x94/0xa0
[   21.122912]  __driver_attach+0xa4/0x110
[   21.126736]  bus_for_each_dev+0xe8/0x158
[   21.130648]  driver_attach+0x30/0x40
[   21.134212]  bus_add_driver+0x234/0x2f0
[   21.0x10/0x18
[   21.161764]
[   21.163244] The buggy address belongs to the object at ffff00236cdeb600
[   21.163244]  which belongs to the cache kmalloc-256 of size 256
[   21.175750] The buggy address is located 132 bytes inside of
[   21.175750]  256-byte region [ffff00236cdeb600, ffff00236cdeb700)
[   21.187473] The buggy address belongs to the page:
[   21.192254] page:fffffe008d937a00 refcount:1 mapcount:0 mapping:ffff002370c0fa00 index:0x0 compound_mapcount: 0
[   21.202331] flags: 0x1ffff00000010200(slab|head)
[   21.206940] raw: 1ffff00000010200 dead000000000100 dead000000000122 ffff002370c0fa00
[   21.214671] raw: 0000000000000000 00000000802a002a 00000001ffffffff 0000000000000000
[   21.222400] page dumped because: kasan: bad access detected
[   21.227959]
[   21.229438] Memory state around the buggy address:
[   21.234218]  ffff00236cdeb580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   21.241427]  ffff00236cdeb600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   21.248637] >ffff00236cdeb680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   21.255845]                    ^
[   21.259062]  ffff00236cdeb700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   21.266272]  ffff00236cdeb780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[   21.273480] ==================================================================

It seems that global pcc_data[pcc_ss_id] can be freed in
acpi_cppc_processor_exit(), but we may later reference this value, so
NULLify it when freed.

Also remove the useless setting of data "pcc_channel_acquired", which
we're about to free.

Fixes: 85b1407bf6d2 ("ACPI / CPPC: Make CPPC ACPI driver aware of PCC subspace IDs")
Signed-off-by: John Garry <john.garry@huawei.com>
Cc: 4.15+ <stable@vger.kernel.org> # 4.15+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/cppc_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -905,8 +905,8 @@ void acpi_cppc_processor_exit(struct acp
 			pcc_data[pcc_ss_id]->refcount--;
 			if (!pcc_data[pcc_ss_id]->refcount) {
 				pcc_mbox_free_channel(pcc_data[pcc_ss_id]->pcc_channel);
-				pcc_data[pcc_ss_id]->pcc_channel_acquired = 0;
 				kfree(pcc_data[pcc_ss_id]);
+				pcc_data[pcc_ss_id] = NULL;
 			}
 		}
 	}


