Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE52E4A604D
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 16:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240102AbiBAPk0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 10:40:26 -0500
Received: from mailin.studentenwerk.mhn.de ([141.84.225.229]:33316 "EHLO
        email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234655AbiBAPk0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 10:40:26 -0500
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Feb 2022 10:40:25 EST
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4Jp86D3pYmzRhSb
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 16:31:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1643729476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6oZJQFlmhYhEHL5jef4RtYx+FcVZc5NJA1nV3gCEu/o=;
        b=k5lAh3tJm7IundgSjMbM3jBdIIyJPqghUIefBs/G8HcoX58f1ImGkx5PHeYToJgex5yB23
        pT9KA1r1BOcm8NwsuZBwmO1PppJxKVCk5x2A5LJmPg4KWWKoSFpKrHO5ui9ntYnR8Nwtm2
        yFndHou6JwDA+DVw5AoSa2Mf5FlOQXs9pQ76hJT76MHb6txa3dc8gpVTGOP0TcUYLQgNGD
        bTE8nAT0dsAylF4W4X7K3/OabvWW+C9TOFAjipqYwWkirclw6HhGd7Mq5/9kiin99G3NiO
        Np43rx2+rfR1M3tn3CFois26E+bPMCidS4VQA9XZ3CVaaz/p15kYo5Rc9GrTKQ==
MIME-Version: 1.0
Date:   Tue, 01 Feb 2022 16:31:29 +0100
From:   Wolfgang Walter <linux@stwm.de>
To:     stable@vger.kernel.org
Subject: 5.15.17: general protection fault when loading iwlwifi as module and
 no firmware available
Message-ID: <099995b11936073c8d6b7a28c07ccd95@stwm.de>
X-Sender: linux@stwm.de
Organization: =?UTF-8?Q?Studentenwerk_M=C3=BCnchen?=
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

we found a regression in 5.15.17. When iwlwifi is loaded as a module and 
it cannot load a firmware it crashes:

===================================================================
Jan 28 19:05:01 kistchen kernel: [    5.415151] Intel(R) Wireless WiFi 
driver for Linux
Jan 28 19:05:01 kistchen kernel: [    5.425600] iwlwifi 0000:04:00.0: 
Direct firmware load for iwlwifi-3160-17.ucode failed with error -2
Jan 28 19:05:01 kistchen kernel: [    5.425616] iwlwifi 0000:04:00.0: no 
suitable firmware found!
Jan 28 19:05:01 kistchen kernel: [    5.425704] iwlwifi 0000:04:00.0: 
iwlwifi-3160-17 is required
Jan 28 19:05:01 kistchen kernel: [    5.425786] iwlwifi 0000:04:00.0: 
check 
git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
Jan 28 19:05:01 kistchen kernel: [    5.426226] general protection 
fault, probably for non-canonical address 0xd8e6d895001008: 0000 [#1] 
PREEMPT SMP PTI
Jan 28 19:05:01 kistchen kernel: [    5.426324] CPU: 1 PID: 45 Comm: 
kworker/1:1 Not tainted 5.15.17-aladebian64.all+1.2 #1
Jan 28 19:05:01 kistchen kernel: [    5.426411] Hardware name: ZOTAC 
XXXXXX/XXXXXX, BIOS B301P017 04/06/2016
Jan 28 19:05:01 kistchen kernel: [    5.426493] Workqueue: events 
request_firmware_work_func
Jan 28 19:05:01 kistchen kernel: [    5.426587] RIP: 
0010:kfree+0x61/0x170
Jan 28 19:05:01 kistchen kernel: [    5.426670] Code: 80 48 01 e8 0f 82 
21 01 00 00 48 c7 c2 00 00 00 80 48 2b 15 01 f8 ee 00 48 01 d0 48 c1 e8 
0c 48 c1 e0 06 48 03 05 df f7 ee 00 <48> 8b 50 08 48 8d 4a ff 83 e2 01 
48 0f 45 c1 48 8b 48 08 48 8d 51
Jan 28 19:05:01 kistchen kernel: [    5.426772] RSP: 
0018:ffffa54e002b3ce8 EFLAGS: 00010007
Jan 28 19:05:01 kistchen kernel: [    5.426853] RAX: 00d8e6d895001000 
RBX: 0000000000000206 RCX: 0000000000000000
Jan 28 19:05:01 kistchen kernel: [    5.426937] RDX: 00007425c0000000 
RSI: ffffffffc0fd6ea6 RDI: 36415f5f0004000f
Jan 28 19:05:01 kistchen kernel: [    5.427019] RBP: 36415f5f0004000f 
R08: ffffffffa80427c0 R09: ffffa54e002b3be0
Jan 28 19:05:01 kistchen kernel: [    5.427102] R10: 0000000000000000 
R11: 0000000000000000 R12: ffff8bdae10e6ab8
Jan 28 19:05:01 kistchen kernel: [    5.427184] R13: ffff8bdae10e6800 
R14: ffff8bdac256c400 R15: ffff8bdc37cb5905
Jan 28 19:05:01 kistchen kernel: [    5.427267] FS:  
0000000000000000(0000) GS:ffff8bdc37c80000(0000) knlGS:0000000000000000
Jan 28 19:05:01 kistchen kernel: [    5.427354] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Jan 28 19:05:01 kistchen kernel: [    5.427446] CR2: 00007f934935c6f4 
CR3: 00000001077e2000 CR4: 00000000001006e0
Jan 28 19:05:01 kistchen kernel: [    5.427541] Call Trace:
Jan 28 19:05:01 kistchen kernel: [    5.427630]  <TASK>
Jan 28 19:05:01 kistchen kernel: [    5.427727]  
iwl_dealloc_ucode+0x36/0x110 [iwlwifi]
Jan 28 19:05:01 kistchen kernel: [    5.427873]  
iwl_req_fw_callback+0x2d1/0x2330 [iwlwifi]
Jan 28 19:05:01 kistchen kernel: [    5.428006]  ? 
___cache_free+0x31/0x4b0
Jan 28 19:05:01 kistchen kernel: [    5.428108]  ? 
_request_firmware+0x3ff/0x780
Jan 28 19:05:01 kistchen kernel: [    5.428205]  ? kfree+0xa9/0x170
Jan 28 19:05:01 kistchen kernel: [    5.428298]  ? 
_request_firmware+0x3ff/0x780
Jan 28 19:05:01 kistchen kernel: [    5.428391]  
request_firmware_work_func+0x4d/0x90
Jan 28 19:05:01 kistchen kernel: [    5.428486]  
process_one_work+0x1e8/0x3c0
Jan 28 19:05:01 kistchen kernel: [    5.428581]  
worker_thread+0x50/0x3b0
Jan 28 19:05:01 kistchen kernel: [    5.428672]  ? 
process_one_work+0x3c0/0x3c0
Jan 28 19:05:01 kistchen kernel: [    5.428763]  kthread+0x141/0x170
Jan 28 19:05:01 kistchen kernel: [    5.428856]  ? 
set_kthread_struct+0x40/0x40
Jan 28 19:05:01 kistchen kernel: [    5.428948]  ret_from_fork+0x22/0x30
Jan 28 19:05:01 kistchen kernel: [    5.429044]  </TASK>
Jan 28 19:05:01 kistchen kernel: [    5.429130] Modules linked in: 
ums_realtek(+) iwlwifi(+) snd_hda_intel uas usb_storage snd_intel_dspcfg 
sha512_ssse3 ttm snd_intel_sdw_acpi snd_hda_codec snd_hda_core 
sha512_generic aesni_intel(+) drm_kms_helper snd_hwdep crypto_simd 
intel_xhci_usb_role_switch cryptd sg roles cec snd_pcm intel_cstate 
snd_timer mei_txe at24 snd iTCO_wdt rc_core cfg80211 intel_pmc_bxt 
pcspkr soundcore ctr iTCO_vendor_support mei i2c_algo_bit watchdog drbg 
ansi_cprng ecdh_generic(+) rfkill ecc pwm_lpss_platform pwm_lpss 
intel_int0002_vgpio button drm fuse configfs ip_tables x_tables autofs4 
ext4 crc32c_generic crc16 mbcache jbd2 sd_mod t10_pi crc_t10dif 
crct10dif_generic ahci libahci xhci_pci sdhci_pci cqhci crct10dif_pclmul 
crct10dif_common libata r8169 i2c_i801 crc32_pclmul xhci_hcd realtek 
mdio_devres crc32c_intel i2c_smbus lpc_ich sdhci libphy scsi_mod usbcore 
usb_common scsi_common mmc_core fan i2c_hid_acpi i2c_hid video hid
Jan 28 19:05:01 kistchen kernel: [    5.429595] ---[ end trace 
aea59d2f4abcc392 ]---
Jan 28 19:05:01 kistchen kernel: [    5.429688] RIP: 
0010:kfree+0x61/0x170
Jan 28 19:05:01 kistchen kernel: [    5.429783] Code: 80 48 01 e8 0f 82 
21 01 00 00 48 c7 c2 00 00 00 80 48 2b 15 01 f8 ee 00 48 01 d0 48 c1 e8 
0c 48 c1 e0 06 48 03 05 df f7 ee 00 <48> 8b 50 08 48 8d 4a ff 83 e2 01 
48 0f 45 c1 48 8b 48 08 48 8d 51
Jan 28 19:05:01 kistchen kernel: [    5.429920] RSP: 
0018:ffffa54e002b3ce8 EFLAGS: 00010007
Jan 28 19:05:01 kistchen kernel: [    5.430012] RAX: 00d8e6d895001000 
RBX: 0000000000000206 RCX: 0000000000000000
Jan 28 19:05:01 kistchen kernel: [    5.430107] RDX: 00007425c0000000 
RSI: ffffffffc0fd6ea6 RDI: 36415f5f0004000f
Jan 28 19:05:01 kistchen kernel: [    5.430201] RBP: 36415f5f0004000f 
R08: ffffffffa80427c0 R09: ffffa54e002b3be0
Jan 28 19:05:01 kistchen kernel: [    5.430296] R10: 0000000000000000 
R11: 0000000000000000 R12: ffff8bdae10e6ab8
Jan 28 19:05:01 kistchen kernel: [    5.430392] R13: ffff8bdae10e6800 
R14: ffff8bdac256c400 R15: ffff8bdc37cb5905
Jan 28 19:05:01 kistchen kernel: [    5.430489] FS:  
0000000000000000(0000) GS:ffff8bdc37c80000(0000) knlGS:0000000000000000
Jan 28 19:05:01 kistchen kernel: [    5.430603] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Jan 28 19:05:01 kistchen kernel: [    5.430700] CR2: 00007f934935c6f4 
CR3: 00000001077e2000 CR4: 00000000001006e0
===================================================================

Providing a firmware file (or blacklisting iwlwifi of course) fixes ist. 
5.15.16 does not crash.


Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
