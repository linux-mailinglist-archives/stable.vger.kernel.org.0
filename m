Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43F412D0D3
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 15:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbfL3OhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 09:37:03 -0500
Received: from mga18.intel.com ([134.134.136.126]:39952 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727445AbfL3OhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 09:37:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Dec 2019 06:37:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,375,1571727600"; 
   d="scan'208";a="209027737"
Received: from anhtuanb-mobl.ccr.corp.intel.com (HELO M5530.gar.corp.intel.com) ([10.255.175.157])
  by orsmga007.jf.intel.com with ESMTP; 30 Dec 2019 06:36:59 -0800
From:   Harry Pan <harry.pan@intel.com>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     gs0622@gmail.com, Harry Pan <harry.pan@intel.com>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org
Subject: [PATCH] powercap/intel_rapl: refine RAPL error handling to respect initial CPU matching
Date:   Mon, 30 Dec 2019 22:36:56 +0800
Message-Id: <20191230223645.1.I79ea8bb1c5a70c04c810d8305f5f7dee4ebed577@changeid>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RAPL MMIO support depends on RAPL common driver, in case a new generation
of CPU is booting but not in the RAPL support list, the processor_thermal
driver invokes CPU hotplug API to enforce RAPL common driver adding new
RAPL domain which would cause kernel crash by null pointer dereference
because the internal RAPL domain resource mapping is not initialized after
the common init.

Add error handling to detect non initialized RAPL domain resource mapping
and return error code to the caller; such that, it avoids early crash for
new CPU and leave error messages through processor_thermal driver.

Before:
[    4.188566] BUG: kernel NULL pointer dereference, address: 0000000000000020
...snip...
[    4.189555] RIP: 0010:rapl_add_package+0x223/0x574
[    4.189555] Code: b5 a0 31 c0 49 8b 4d 78 48 01 d9 48 8b 0c c1 49 89 4c c6 10 48 ff c0 48 83 f8 05 75 e7 49 83 ff 03 75 15 48 8b 05 09 bc 18 01 <8b> 70 20 41 89 b6 0c 05 00 00 85 f6 75 1a 49 81 c6 18 9
[    4.189555] RSP: 0000:ffffb3adc00b3d90 EFLAGS: 00010246
[    4.189555] RAX: 0000000000000000 RBX: 0000000000000098 RCX: 0000000000000000
[    4.267161] usb 1-1: New USB device found, idVendor=2109, idProduct=2812, bcdDevice= b.e0
[    4.189555] RDX: 0000000000001000 RSI: 0000000000000000 RDI: ffff9340caafd000
[    4.189555] RBP: ffffb3adc00b3df8 R08: ffffffffa0246e28 R09: ffff9340caafc000
[    4.189555] R10: 000000000000024a R11: ffffffff9ff1f6f2 R12: 00000000ffffffed
[    4.189555] R13: ffff9340caa94800 R14: ffff9340caafc518 R15: 0000000000000003
[    4.189555] FS:  0000000000000000(0000) GS:ffff9340ce200000(0000) knlGS:0000000000000000
[    4.189555] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.189555] CR2: 0000000000000020 CR3: 0000000302c14001 CR4: 00000000003606f0
[    4.189555] Call Trace:
[    4.189555]  ? __switch_to_asm+0x40/0x70
[    4.189555]  rapl_mmio_cpu_online+0x47/0x64
[    4.189555]  ? rapl_mmio_write_raw+0x33/0x33
[    4.281059] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.189555]  cpuhp_invoke_callback+0x29f/0x66f
[    4.189555]  ? __schedule+0x46d/0x6a0
[    4.189555]  cpuhp_thread_fun+0xb9/0x11c
[    4.189555]  smpboot_thread_fn+0x17d/0x22f
[    4.297006] usb 1-1: Product: USB2.0 Hub
[    4.189555]  ? cpu_report_death+0x43/0x43
[    4.189555]  kthread+0x137/0x13f
[    4.189555]  ? cpu_report_death+0x43/0x43
[    4.189555]  ? kthread_blkcg+0x2e/0x2e
[    4.312951] usb 1-1: Manufacturer: VIA Labs, Inc.
[    4.189555]  ret_from_fork+0x1f/0x40
[    4.189555] Modules linked in:
[    4.189555] CR2: 0000000000000020
[    4.189555] ---[ end trace 01bb812aabc791f4 ]---

After:
[    0.787125] intel_rapl_common: driver does not support CPU family 6 model 166
...snip...
[    4.245273] proc_thermal 0000:00:04.0: failed to add RAPL MMIO interface

Note:
This example above is on a v5.4 branch without below two CML commits yet:
commit f84fdcbc8ec0 ("powercap/intel_rapl: add support for Cometlake desktop")
commit cae478114fbe ("powercap/intel_rapl: add support for CometLake Mobile")

Fixes: 555c45fe0d04 ("int340X/processor_thermal_device: add support for MMIO RAPL")

Cc: <stable@vger.kernel.org> # v5.3+
Signed-off-by: Harry Pan <harry.pan@intel.com>

---

 drivers/powercap/intel_rapl_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 318d023a6a11..aa0a8de413b1 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -1294,6 +1294,9 @@ struct rapl_package *rapl_add_package(int cpu, struct rapl_if_priv *priv)
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	int ret;
 
+	if (!rapl_defaults)
+		return ERR_PTR(-ENODEV);
+
 	rp = kzalloc(sizeof(struct rapl_package), GFP_KERNEL);
 	if (!rp)
 		return ERR_PTR(-ENOMEM);
-- 
2.24.1

