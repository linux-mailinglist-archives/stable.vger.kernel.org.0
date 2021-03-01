Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B1D3290FA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243081AbhCAUSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:18:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242887AbhCAUIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:08:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E77C64F6B;
        Mon,  1 Mar 2021 17:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621592;
        bh=upBw5AdhJq8rnQs+7k6VyJ4fcKb+oB1WjUncSlyNNPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1D4RWl8HKW/6T6jxDyPwy0ptgbLX578tucL+cIzeDZgsND6qZEHppomXV9Qov2VU
         tsa1Tt+PDRhhZ+qsnerq5Y0Ce37URnkOK31CJDm6eM/sp1LYsUHTgQIoshVFqE2qaA
         aVLuvAOe6oFQazg/clTSMx/GWWssaOgJshblWblw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marcin=20=C5=9Alusarz?= <marcin.slusarz@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.11 573/775] soundwire: intel: fix possible crash when no device is detected
Date:   Mon,  1 Mar 2021 17:12:21 +0100
Message-Id: <20210301161229.771857266@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcin Ślusarz <marcin.slusarz@intel.com>

commit 957e3f797917b36355766807b1d8a54a1ba0cfc9 upstream.

acpi_walk_namespace can return success without executing our
callback which initializes info->handle.
If the random value in this structure is a valid address (which
is on the stack, so it's quite possible), then nothing bad will
happen, because:
sdw_intel_scan_controller
 -> acpi_bus_get_device
 -> acpi_get_device_data
 -> acpi_get_data_full
 -> acpi_ns_validate_handle
will reject this handle.

However, if the value from the stack doesn't point to a valid
address, we get this:

BUG: kernel NULL pointer dereference, address: 0000000000000050
PGD 0 P4D 0
Oops: 0000 [#1] SMP NOPTI
CPU: 6 PID: 472 Comm: systemd-udevd Tainted: G        W         5.10.0-1-amd64 #1 Debian 5.10.4-1
Hardware name: HP HP Pavilion Laptop 15-cs3xxx/86E2, BIOS F.05 01/01/2020
RIP: 0010:acpi_ns_validate_handle+0x1a/0x23
Code: 00 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 0f 1f 44 00 00 48 8d 57 ff 48 89 f8 48 83 fa fd 76 08 48 8b 05 0c b8 67 01 c3 <80> 7f 08 0f 74 02 31 c0 c3 0f 1f 44 00 00 48 8b 3d f6 b7 67 01 e8
RSP: 0000:ffffc388807c7b20 EFLAGS: 00010213
RAX: 0000000000000048 RBX: ffffc388807c7b70 RCX: 0000000000000000
RDX: 0000000000000047 RSI: 0000000000000246 RDI: 0000000000000048
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffffc0f5f4d1 R11: ffffffff8f0cb268 R12: 0000000000001001
R13: ffffffff8e33b160 R14: 0000000000000048 R15: 0000000000000000
FS:  00007f24548288c0(0000) GS:ffff9f781fb80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000050 CR3: 0000000106158004 CR4: 0000000000770ee0
PKRU: 55555554
Call Trace:
 acpi_get_data_full+0x4d/0x92
 acpi_bus_get_device+0x1f/0x40
 sdw_intel_acpi_scan+0x59/0x230 [soundwire_intel]
 ? strstr+0x22/0x60
 ? dmi_matches+0x76/0xe0
 snd_intel_dsp_driver_probe.cold+0xaf/0x163 [snd_intel_dspcfg]
 azx_probe+0x7a/0x970 [snd_hda_intel]
 local_pci_probe+0x42/0x80
 ? _cond_resched+0x16/0x40
 pci_device_probe+0xfd/0x1b0
 really_probe+0x205/0x460
 driver_probe_device+0xe1/0x150
 device_driver_attach+0xa1/0xb0
 __driver_attach+0x8a/0x150
 ? device_driver_attach+0xb0/0xb0
 ? device_driver_attach+0xb0/0xb0
 bus_for_each_dev+0x78/0xc0
 bus_add_driver+0x12b/0x1e0
 driver_register+0x8b/0xe0
 ? 0xffffffffc0f65000
 do_one_initcall+0x44/0x1d0
 ? do_init_module+0x23/0x250
 ? kmem_cache_alloc_trace+0xf5/0x200
 do_init_module+0x5c/0x250
 __do_sys_finit_module+0xb1/0x110
 do_syscall_64+0x33/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Signed-off-by: Marcin Ślusarz <marcin.slusarz@intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210208120104.204761-1-marcin.slusarz@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soundwire/intel_init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/soundwire/intel_init.c
+++ b/drivers/soundwire/intel_init.c
@@ -405,11 +405,12 @@ int sdw_intel_acpi_scan(acpi_handle *par
 {
 	acpi_status status;
 
+	info->handle = NULL;
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE,
 				     parent_handle, 1,
 				     sdw_intel_acpi_cb,
 				     NULL, info, NULL);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status) || info->handle == NULL)
 		return -ENODEV;
 
 	return sdw_intel_scan_controller(info);


