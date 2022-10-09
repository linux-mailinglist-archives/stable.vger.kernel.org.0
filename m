Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D565F8E00
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiJIUwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiJIUv5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:51:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE5D2AC58;
        Sun,  9 Oct 2022 13:51:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB75860C85;
        Sun,  9 Oct 2022 20:51:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B26C433D6;
        Sun,  9 Oct 2022 20:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348713;
        bh=VV1OpKp2yHPswDsQUvrr44yQuL620U4g+koU7ZS60sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDn49EfLCl+M7fu4dHeRmZooMyIsKYR7tZqBxRS9UaNcik9hsAHq/IGa3UqHM3FoG
         8+xNZpA8PZSGFrzHGSTxhad2DAoEGMA1YzjVBQN+b/yqdg3cpK4yJWMxNYebs5aktM
         W+kfp+MrplFP4hJo+nGaxL2oAOct98ks5vElaBXDLdnfusmF7h9NNe6jZvCz2YEOQI
         ofUJFLaMog0QOTxAgpBBLn1edP+qMWZ6ony1KbTnwzPqD7/vBZO/Clsn2tyttu38bi
         Y7V1EGwfB0zVaV98HXH2R1uTW2rUNwF85d+vmQOZSx2mKXisXXeO/8jwfFUtmRt5/F
         FLWcH9TGno8Lg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 09/18] ACPI: tables: FPDT: Don't call acpi_os_map_memory() on invalid phys address
Date:   Sun,  9 Oct 2022 16:51:26 -0400
Message-Id: <20221009205136.1201774-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205136.1201774-1-sashal@kernel.org>
References: <20221009205136.1201774-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 211391bf04b3c74e250c566eeff9cf808156c693 ]

On a Packard Bell Dot SC (Intel Atom N2600 model) there is a FPDT table
which contains invalid physical addresses, with high bits set which fall
outside the range of the CPU-s supported physical address range.

Calling acpi_os_map_memory() on such an invalid phys address leads to
the below WARN_ON in ioremap triggering resulting in an oops/stacktrace.

Add code to verify the physical address before calling acpi_os_map_memory()
to fix / avoid the oops.

[    1.226900] ioremap: invalid physical address 3001000000000000
[    1.226949] ------------[ cut here ]------------
[    1.226962] WARNING: CPU: 1 PID: 1 at arch/x86/mm/ioremap.c:200 __ioremap_caller.cold+0x43/0x5f
[    1.226996] Modules linked in:
[    1.227016] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc3+ #490
[    1.227029] Hardware name: Packard Bell dot s/SJE01_CT, BIOS V1.10 07/23/2013
[    1.227038] RIP: 0010:__ioremap_caller.cold+0x43/0x5f
[    1.227054] Code: 96 00 00 e9 f8 af 24 ff 89 c6 48 c7 c7 d8 0c 84 99 e8 6a 96 00 00 e9 76 af 24 ff 48 89 fe 48 c7 c7 a8 0c 84 99 e8 56 96 00 00 <0f> 0b e9 60 af 24 ff 48 8b 34 24 48 c7 c7 40 0d 84 99 e8 3f 96 00
[    1.227067] RSP: 0000:ffffb18c40033d60 EFLAGS: 00010286
[    1.227084] RAX: 0000000000000032 RBX: 3001000000000000 RCX: 0000000000000000
[    1.227095] RDX: 0000000000000001 RSI: 00000000ffffdfff RDI: 00000000ffffffff
[    1.227105] RBP: 3001000000000000 R08: 0000000000000000 R09: ffffb18c40033c18
[    1.227115] R10: 0000000000000003 R11: ffffffff99d62fe8 R12: 0000000000000008
[    1.227124] R13: 0003001000000000 R14: 0000000000001000 R15: 3001000000000000
[    1.227135] FS:  0000000000000000(0000) GS:ffff913a3c080000(0000) knlGS:0000000000000000
[    1.227146] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.227156] CR2: 0000000000000000 CR3: 0000000018c26000 CR4: 00000000000006e0
[    1.227167] Call Trace:
[    1.227176]  <TASK>
[    1.227185]  ? acpi_os_map_iomem+0x1c9/0x1e0
[    1.227215]  ? kmem_cache_alloc_trace+0x187/0x370
[    1.227254]  acpi_os_map_iomem+0x1c9/0x1e0
[    1.227288]  acpi_init_fpdt+0xa8/0x253
[    1.227308]  ? acpi_debugfs_init+0x1f/0x1f
[    1.227339]  do_one_initcall+0x5a/0x300
[    1.227406]  ? rcu_read_lock_sched_held+0x3f/0x80
[    1.227442]  kernel_init_freeable+0x28b/0x2cc
[    1.227512]  ? rest_init+0x170/0x170
[    1.227538]  kernel_init+0x16/0x140
[    1.227552]  ret_from_fork+0x1f/0x30
[    1.227639]  </TASK>
[    1.227647] irq event stamp: 186819
[    1.227656] hardirqs last  enabled at (186825): [<ffffffff98184a6e>] __up_console_sem+0x5e/0x70
[    1.227672] hardirqs last disabled at (186830): [<ffffffff98184a53>] __up_console_sem+0x43/0x70
[    1.227686] softirqs last  enabled at (186576): [<ffffffff980fbc9d>] __irq_exit_rcu+0xed/0x160
[    1.227701] softirqs last disabled at (186569): [<ffffffff980fbc9d>] __irq_exit_rcu+0xed/0x160
[    1.227715] ---[ end trace 0000000000000000 ]---

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_fpdt.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/acpi/acpi_fpdt.c b/drivers/acpi/acpi_fpdt.c
index 6922a44b3ce7..a2056c4c8cb7 100644
--- a/drivers/acpi/acpi_fpdt.c
+++ b/drivers/acpi/acpi_fpdt.c
@@ -143,6 +143,23 @@ static const struct attribute_group boot_attr_group = {
 
 static struct kobject *fpdt_kobj;
 
+#if defined CONFIG_X86 && defined CONFIG_PHYS_ADDR_T_64BIT
+#include <linux/processor.h>
+static bool fpdt_address_valid(u64 address)
+{
+	/*
+	 * On some systems the table contains invalid addresses
+	 * with unsuppored high address bits set, check for this.
+	 */
+	return !(address >> boot_cpu_data.x86_phys_bits);
+}
+#else
+static bool fpdt_address_valid(u64 address)
+{
+	return true;
+}
+#endif
+
 static int fpdt_process_subtable(u64 address, u32 subtable_type)
 {
 	struct fpdt_subtable_header *subtable_header;
@@ -151,6 +168,11 @@ static int fpdt_process_subtable(u64 address, u32 subtable_type)
 	u32 length, offset;
 	int result;
 
+	if (!fpdt_address_valid(address)) {
+		pr_info(FW_BUG "invalid physical address: 0x%llx!\n", address);
+		return -EINVAL;
+	}
+
 	subtable_header = acpi_os_map_memory(address, sizeof(*subtable_header));
 	if (!subtable_header)
 		return -ENOMEM;
-- 
2.35.1

