Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C94513A5CC
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 11:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgANKDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 05:03:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:58148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726169AbgANKDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jan 2020 05:03:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C21324672;
        Tue, 14 Jan 2020 10:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578996200;
        bh=EFZlAOTzpRSZzHfnBw9QEClgtVYX7mSMVZ075LYuiTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpSD+3KuJDWQw11+eorR689CRIL5qGg/aqtrob7U+BRBUTOH2phpzAxcqoYrWvxqF
         kTdl02qCATLJ4fx70OlIZeGA1RwoY0K13BwNWv7HBHiA/qYC5smcREbtuzMfFLHiK3
         s2G+IZHl3xP/HiRKWWZdXMqgvNtW0SrPSEIVJIdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Pan <harry.pan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 03/78] powercap: intel_rapl: add NULL pointer check to rapl_mmio_cpu_online()
Date:   Tue, 14 Jan 2020 11:00:37 +0100
Message-Id: <20200114094352.971460553@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114094352.428808181@linuxfoundation.org>
References: <20200114094352.428808181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Pan <harry.pan@intel.com>

commit 3aa3c5882e4fb2274448908aaed605a3ed7dd15d upstream.

RAPL MMIO support depends on the RAPL common driver.  During CPU
initialization rapl_mmio_cpu_online() is called via CPU hotplug
to initialize the MMIO RAPL for the new CPU, but if that CPU is
not present in the common RAPL driver's support list, rapl_defaults
is NULL and the kernel crashes on an attempt to dereference it:

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

To avoid that problem, check rapl_defaults NULL upfront and return an
error code if it is NULL.  [Note that it does not make sense to even
try to allocate memory in that case, because it is not going to be
used anyway.]

Fixes: 555c45fe0d04 ("int340X/processor_thermal_device: add support for MMIO RAPL")
Cc: 5.3+ <stable@vger.kernel.org> # 5.3+
Signed-off-by: Harry Pan <harry.pan@intel.com>
[ rjw: Subject & changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/powercap/intel_rapl_common.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -1293,6 +1293,9 @@ struct rapl_package *rapl_add_package(in
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	int ret;
 
+	if (!rapl_defaults)
+		return ERR_PTR(-ENODEV);
+
 	rp = kzalloc(sizeof(struct rapl_package), GFP_KERNEL);
 	if (!rp)
 		return ERR_PTR(-ENOMEM);


