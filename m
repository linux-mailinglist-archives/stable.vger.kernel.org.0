Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB96A116E21
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 14:46:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbfLINqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 08:46:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:52814 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727665AbfLINqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 08:46:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 05:45:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,294,1571727600"; 
   d="scan'208";a="414073956"
Received: from otc-lr-04.jf.intel.com ([10.54.39.104])
  by fmsmga006.fm.intel.com with ESMTP; 09 Dec 2019 05:45:58 -0800
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     like.xu@linux.intel.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel/uncore: Fix missing marker for snr_uncore_imc_freerunning_events
Date:   Mon,  9 Dec 2019 05:42:33 -0800
Message-Id: <1575898953-85496-1-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

An Oops during the boot is found on some SNR machines.

[   15.795410] BUG: unable to handle page fault for address:
00000000000022b0
[   15.795412] #PF: supervisor read access in kernel mode
[   15.795413] #PF: error_code(0x0000) - not-present page
[   15.795414] PGD 0 P4D 0
[   15.795418] Oops: 0000 [#1] SMP NOPTI
[   15.795420] CPU: 6 PID: 941 Comm: systemd-udevd Not tainted
5.3.0-snr-v5.3 #292
[   15.795421] Hardware name: Intel Corporation JACOBSVILLE/JACOBSVILLE,
BIOS JBVLCRB1.86B.0011.D44.1909191126 09/19/2019
[   15.795428] RIP: 0010:strlen+0x0/0x20
[   15.795431] Code: 48 89 f9 74 09 48 83 c1 01 80 39 00 75 f7 31 d2 44
0f
b6 04 16 44 88 04 11 48 83 c2 01 45 84 c0 75 ee c3 0f 1f 80 00 00 00 00
<80> 3f 00 74 10 48 89 f8 48 83 c0 01 80 38 00 75 f7 48 29 f8 c3 31
[   15.855395] i801_smbus 0000:00:1f.4: SPD Write Disable is set
[   15.858351] RSP: 0018:ffffaeb4812039c8 EFLAGS: 00010202
[   15.858353] RAX: 0000000000000000 RBX: ffff9fec99c71300 RCX:
0000000000008000
[   15.858354] RDX: 00000000000022b0 RSI: 0000000000000cc0 RDI:
00000000000022b0
[   15.858355] RBP: 00000000000022b0 R08: 0000000000000000 R09:
0000000000000000
[   15.858356] R10: 0000000000000000 R11: 0000000000000000 R12:
ffff9fec8583a800
[   15.858357] R13: 0000000000000cc0 R14: ffff9fec94015648 R15:
ffff9fec81f291a8
[   15.858358] FS:  00007f89e7160940(0000) GS:ffff9fec9dc00000(0000)
knlGS:0000000000000000
[   15.858361] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   15.864343] i801_smbus 0000:00:1f.4: SMBus using polling
[   15.869998] CR2: 00000000000022b0 CR3: 0000000842ca2000 CR4:
0000000000340ee0
[   15.870000] Call Trace:
[   15.870006]  kstrdup+0x1a/0x60
[   15.870012]  __kernfs_new_node+0x41/0x1f0
[   15.870018]  ? __mutex_unlock_slowpath+0x4d/0x2a0
[   15.895135] ioatdma 0000:00:01.3: enabling device (0004 -> 0006)
[   15.899395]  kernfs_new_node+0x36/0x60
[   15.899400]  __kernfs_create_file+0x2c/0xf3
[   15.961374]  sysfs_add_file_mode_ns+0xa4/0x1a0
[   15.961379]  internal_create_group+0x117/0x370
[   15.972133]  ? sysfs_add_file_mode_ns+0xa4/0x1a0
[   15.972138]  internal_create_groups.part.0+0x3d/0xa0
[   15.982656]  device_add+0x625/0x690
[   15.982662]  pmu_dev_alloc+0x93/0xf0
[   15.982664]  perf_pmu_register+0x292/0x3e0
[   15.982674]  uncore_pmu_register+0x76/0x120 [intel_uncore]
[   15.982681]  intel_uncore_init+0x1fd/0xe2c [intel_uncore]
[   15.982688]  ? uncore_types_init+0x1d4/0x1d4 [intel_uncore]
[   16.013580]  do_one_initcall+0x5d/0x2e4
[   16.013584]  ? do_init_module+0x23/0x230
[   16.013586]  ? rcu_read_lock_sched_held+0x6b/0x80
[   16.013589]  ? kmem_cache_alloc_trace+0x2c4/0x2f0
[   16.013591]  ? do_init_module+0x23/0x230
[   16.013594]  do_init_module+0x5c/0x230
[   16.013597]  load_module+0x2779/0x2a90
[   16.013605]  ? ima_post_read_file+0xfd/0x110
[   16.026926] ioatdma 0000:00:01.4: enabling device (0004 -> 0006)
[   16.028808]  ? __do_sys_finit_module+0xaa/0x110
[   16.060527]  __do_sys_finit_module+0xaa/0x110
[   16.060536]  do_syscall_64+0x5c/0xb0
[   16.060540]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

This snr_uncore_imc_freerunning_events array was missing an end-marker.

Fixes: ee49532b38dd ("perf/x86/intel/uncore: Add IMC uncore support for Snow Ridge")
Reported-by: Like Xu <like.xu@linux.intel.com>
Tested-by: Like Xu <like.xu@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/uncore_snbep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index b10a5ec..0116448 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -4536,6 +4536,7 @@ static struct uncore_event_desc snr_uncore_imc_freerunning_events[] = {
 	INTEL_UNCORE_EVENT_DESC(write,		"event=0xff,umask=0x21"),
 	INTEL_UNCORE_EVENT_DESC(write.scale,	"3.814697266e-6"),
 	INTEL_UNCORE_EVENT_DESC(write.unit,	"MiB"),
+	{ /* end: all zeroes */ },
 };
 
 static struct intel_uncore_ops snr_uncore_imc_freerunning_ops = {
-- 
2.7.4

