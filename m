Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722CB4A7379
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 15:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbiBBOod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Feb 2022 09:44:33 -0500
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:33376 "EHLO
        email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237621AbiBBOod (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Feb 2022 09:44:33 -0500
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4Jpl1q6t2TzRhSB;
        Wed,  2 Feb 2022 15:44:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1643813071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U0rEou0K3C7FT4URfkeUEDQTAMxDNCTfSO5f4cyUZRM=;
        b=HzPvSgj7VxVR0MjZIQRM6VAGhllrsyHvD5jDE7J/emmAk7OuSAaq9r2Y9s3EACH9+JppFL
        0+skBiSuRbJD5NOIKQzLbMcw96SmqyiCprHzei0bDEvuvS4ld7fCpagNBfK4AhwOIWPz9Q
        8ZoHE36B9of7uxBPWk6JTn5UJ9LrBTJOehlBNmCRQJmDdtMxCnjv1zbOGviUqM9biLwCzj
        qaCDq5A7q17/tA/FnLXzQJ4syX1W3rHqk0/d2QMFDu+Bdb837YS+ldxdKOnQdRtUztWL9w
        p6Z4L8ireydLOuZBRzjAC0AECVfxi0eVlYxzmjsjas431LwmW1HX3hgp2zOiRA==
MIME-Version: 1.0
Date:   Wed, 02 Feb 2022 15:44:48 +0100
From:   Wolfgang Walter <linux@stwm.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: 5.15.17: general protection fault when loading iwlwifi as module
 and no firmware available
In-Reply-To: <YflV56eA7Y7tr01u@kroah.com>
References: <099995b11936073c8d6b7a28c07ccd95@stwm.de>
 <YflV56eA7Y7tr01u@kroah.com>
Message-ID: <2a95df6a3e9c929f51cd1c7942a0ea03@stwm.de>
X-Sender: linux@stwm.de
Organization: =?UTF-8?Q?Studentenwerk_M=C3=BCnchen?=
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 2022-02-01 16:46, schrieb Greg KH:
> On Tue, Feb 01, 2022 at 04:31:29PM +0100, Wolfgang Walter wrote:
>> Hello,
>> 
>> we found a regression in 5.15.17. When iwlwifi is loaded as a module 
>> and it
>> cannot load a firmware it crashes:
>> 
>> ===================================================================
>> Jan 28 19:05:01 kistchen kernel: [    5.415151] Intel(R) Wireless WiFi
>> driver for Linux
>> Jan 28 19:05:01 kistchen kernel: [    5.425600] iwlwifi 0000:04:00.0: 
>> Direct
>> firmware load for iwlwifi-3160-17.ucode failed with error -2
>> Jan 28 19:05:01 kistchen kernel: [    5.425616] iwlwifi 0000:04:00.0: 
>> no
>> suitable firmware found!
>> Jan 28 19:05:01 kistchen kernel: [    5.425704] iwlwifi 0000:04:00.0:
>> iwlwifi-3160-17 is required
>> Jan 28 19:05:01 kistchen kernel: [    5.425786] iwlwifi 0000:04:00.0: 
>> check
>> git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
>> Jan 28 19:05:01 kistchen kernel: [    5.426226] general protection 
>> fault,
>> probably for non-canonical address 0xd8e6d895001008: 0000 [#1] PREEMPT 
>> SMP
>> PTI
>> Jan 28 19:05:01 kistchen kernel: [    5.426324] CPU: 1 PID: 45 Comm:
>> kworker/1:1 Not tainted 5.15.17-aladebian64.all+1.2 #1
>> Jan 28 19:05:01 kistchen kernel: [    5.426411] Hardware name: ZOTAC
>> XXXXXX/XXXXXX, BIOS B301P017 04/06/2016
>> Jan 28 19:05:01 kistchen kernel: [    5.426493] Workqueue: events
>> request_firmware_work_func
>> Jan 28 19:05:01 kistchen kernel: [    5.426587] RIP: 
>> 0010:kfree+0x61/0x170
>> Jan 28 19:05:01 kistchen kernel: [    5.426670] Code: 80 48 01 e8 0f 
>> 82 21
>> 01 00 00 48 c7 c2 00 00 00 80 48 2b 15 01 f8 ee 00 48 01 d0 48 c1 e8 
>> 0c 48
>> c1 e0 06 48 03 05 df f7 ee 00 <48> 8b 50 08 48 8d 4a ff 83 e2 01 48 0f 
>> 45 c1
>> 48 8b 48 08 48 8d 51
>> Jan 28 19:05:01 kistchen kernel: [    5.426772] RSP: 
>> 0018:ffffa54e002b3ce8
>> EFLAGS: 00010007
>> Jan 28 19:05:01 kistchen kernel: [    5.426853] RAX: 00d8e6d895001000 
>> RBX:
>> 0000000000000206 RCX: 0000000000000000
>> Jan 28 19:05:01 kistchen kernel: [    5.426937] RDX: 00007425c0000000 
>> RSI:
>> ffffffffc0fd6ea6 RDI: 36415f5f0004000f
>> Jan 28 19:05:01 kistchen kernel: [    5.427019] RBP: 36415f5f0004000f 
>> R08:
>> ffffffffa80427c0 R09: ffffa54e002b3be0
>> Jan 28 19:05:01 kistchen kernel: [    5.427102] R10: 0000000000000000 
>> R11:
>> 0000000000000000 R12: ffff8bdae10e6ab8
>> Jan 28 19:05:01 kistchen kernel: [    5.427184] R13: ffff8bdae10e6800 
>> R14:
>> ffff8bdac256c400 R15: ffff8bdc37cb5905
>> Jan 28 19:05:01 kistchen kernel: [    5.427267] FS:  
>> 0000000000000000(0000)
>> GS:ffff8bdc37c80000(0000) knlGS:0000000000000000
>> Jan 28 19:05:01 kistchen kernel: [    5.427354] CS:  0010 DS: 0000 ES: 
>> 0000
>> CR0: 0000000080050033
>> Jan 28 19:05:01 kistchen kernel: [    5.427446] CR2: 00007f934935c6f4 
>> CR3:
>> 00000001077e2000 CR4: 00000000001006e0
>> Jan 28 19:05:01 kistchen kernel: [    5.427541] Call Trace:
>> Jan 28 19:05:01 kistchen kernel: [    5.427630]  <TASK>
>> Jan 28 19:05:01 kistchen kernel: [    5.427727]
>> iwl_dealloc_ucode+0x36/0x110 [iwlwifi]
>> Jan 28 19:05:01 kistchen kernel: [    5.427873]
>> iwl_req_fw_callback+0x2d1/0x2330 [iwlwifi]
>> Jan 28 19:05:01 kistchen kernel: [    5.428006]  ? 
>> ___cache_free+0x31/0x4b0
>> Jan 28 19:05:01 kistchen kernel: [    5.428108]  ?
>> _request_firmware+0x3ff/0x780
>> Jan 28 19:05:01 kistchen kernel: [    5.428205]  ? kfree+0xa9/0x170
>> Jan 28 19:05:01 kistchen kernel: [    5.428298]  ?
>> _request_firmware+0x3ff/0x780
>> Jan 28 19:05:01 kistchen kernel: [    5.428391]
>> request_firmware_work_func+0x4d/0x90
>> Jan 28 19:05:01 kistchen kernel: [    5.428486]
>> process_one_work+0x1e8/0x3c0
>> Jan 28 19:05:01 kistchen kernel: [    5.428581]  
>> worker_thread+0x50/0x3b0
>> Jan 28 19:05:01 kistchen kernel: [    5.428672]  ?
>> process_one_work+0x3c0/0x3c0
>> Jan 28 19:05:01 kistchen kernel: [    5.428763]  kthread+0x141/0x170
>> Jan 28 19:05:01 kistchen kernel: [    5.428856]  ?
>> set_kthread_struct+0x40/0x40
>> Jan 28 19:05:01 kistchen kernel: [    5.428948]  
>> ret_from_fork+0x22/0x30
>> Jan 28 19:05:01 kistchen kernel: [    5.429044]  </TASK>
>> Jan 28 19:05:01 kistchen kernel: [    5.429130] Modules linked in:
>> ums_realtek(+) iwlwifi(+) snd_hda_intel uas usb_storage 
>> snd_intel_dspcfg
>> sha512_ssse3 ttm snd_intel_sdw_acpi snd_hda_codec snd_hda_core
>> sha512_generic aesni_intel(+) drm_kms_helper snd_hwdep crypto_simd
>> intel_xhci_usb_role_switch cryptd sg roles cec snd_pcm intel_cstate
>> snd_timer mei_txe at24 snd iTCO_wdt rc_core cfg80211 intel_pmc_bxt 
>> pcspkr
>> soundcore ctr iTCO_vendor_support mei i2c_algo_bit watchdog drbg 
>> ansi_cprng
>> ecdh_generic(+) rfkill ecc pwm_lpss_platform pwm_lpss 
>> intel_int0002_vgpio
>> button drm fuse configfs ip_tables x_tables autofs4 ext4 
>> crc32c_generic
>> crc16 mbcache jbd2 sd_mod t10_pi crc_t10dif crct10dif_generic ahci 
>> libahci
>> xhci_pci sdhci_pci cqhci crct10dif_pclmul crct10dif_common libata 
>> r8169
>> i2c_i801 crc32_pclmul xhci_hcd realtek mdio_devres crc32c_intel 
>> i2c_smbus
>> lpc_ich sdhci libphy scsi_mod usbcore usb_common scsi_common mmc_core 
>> fan
>> i2c_hid_acpi i2c_hid video hid
>> Jan 28 19:05:01 kistchen kernel: [    5.429595] ---[ end trace
>> aea59d2f4abcc392 ]---
>> Jan 28 19:05:01 kistchen kernel: [    5.429688] RIP: 
>> 0010:kfree+0x61/0x170
>> Jan 28 19:05:01 kistchen kernel: [    5.429783] Code: 80 48 01 e8 0f 
>> 82 21
>> 01 00 00 48 c7 c2 00 00 00 80 48 2b 15 01 f8 ee 00 48 01 d0 48 c1 e8 
>> 0c 48
>> c1 e0 06 48 03 05 df f7 ee 00 <48> 8b 50 08 48 8d 4a ff 83 e2 01 48 0f 
>> 45 c1
>> 48 8b 48 08 48 8d 51
>> Jan 28 19:05:01 kistchen kernel: [    5.429920] RSP: 
>> 0018:ffffa54e002b3ce8
>> EFLAGS: 00010007
>> Jan 28 19:05:01 kistchen kernel: [    5.430012] RAX: 00d8e6d895001000 
>> RBX:
>> 0000000000000206 RCX: 0000000000000000
>> Jan 28 19:05:01 kistchen kernel: [    5.430107] RDX: 00007425c0000000 
>> RSI:
>> ffffffffc0fd6ea6 RDI: 36415f5f0004000f
>> Jan 28 19:05:01 kistchen kernel: [    5.430201] RBP: 36415f5f0004000f 
>> R08:
>> ffffffffa80427c0 R09: ffffa54e002b3be0
>> Jan 28 19:05:01 kistchen kernel: [    5.430296] R10: 0000000000000000 
>> R11:
>> 0000000000000000 R12: ffff8bdae10e6ab8
>> Jan 28 19:05:01 kistchen kernel: [    5.430392] R13: ffff8bdae10e6800 
>> R14:
>> ffff8bdac256c400 R15: ffff8bdc37cb5905
>> Jan 28 19:05:01 kistchen kernel: [    5.430489] FS:  
>> 0000000000000000(0000)
>> GS:ffff8bdc37c80000(0000) knlGS:0000000000000000
>> Jan 28 19:05:01 kistchen kernel: [    5.430603] CS:  0010 DS: 0000 ES: 
>> 0000
>> CR0: 0000000080050033
>> Jan 28 19:05:01 kistchen kernel: [    5.430700] CR2: 00007f934935c6f4 
>> CR3:
>> 00000001077e2000 CR4: 00000000001006e0
>> ===================================================================
>> 
>> Providing a firmware file (or blacklisting iwlwifi of course) fixes 
>> ist.
>> 5.15.16 does not crash.
> 
> Can you do 'git bisect' to track down the offending commit?
> 
> And does 5.16.y work for you?  How about 5.17-rc2?
> 
> thanks,
> 
> greg k-h

I tested 5.17-rc2. It also shows the above general protection fault:


==================================================================================

[   54.627048] CPU: 2 PID: 61 Comm: kworker/2:1 Not tainted 5.17.0-rc2 
#11
[   54.627120] Hardware name: ZOTAC XXXXXX/XXXXXX, BIOS B301P017 
04/06/2016
[   54.627191] Workqueue: events request_firmware_work_func
[   54.627258] RIP: 0010:kfree+0x61/0x170
[   54.627305] Code: 80 48 01 e8 0f 82 14 01 00 00 48 c7 c2 00 00 00 80 
48 2b 15 81 d2 ee 00 48 01 d0 48 c1 e8 0c 48 c1 e0 06 48 03 05 5f d2 ee 
00 <48> 8b 50 08 48 8d 4a ff 83 e2 01 48 0f 45 c1 48 8b 10 80 e6 02 0f
[   54.627492] RSP: 0018:ffff97bb80337ce8 EFLAGS: 00010007
[   54.627549] RAX: 00d8e3f509001000 RBX: 0000000000000206 RCX: 
ffffdca084258d07
[   54.627624] RDX: 000075c2c0000000 RSI: ffffffffc12ba0a6 RDI: 
36415f5f0004000f
[   54.627698] RBP: 36415f5f0004000f R08: ffffffff96243740 R09: 
ffff97bb80337bf8
[   54.627772] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffff8a3dc3c622b8
[   54.627846] R13: ffff8a3f37d36900 R14: 0000000000000000 R15: 
ffff8a3dc3c62000
[   54.627920] FS:  0000000000000000(0000) GS:ffff8a3f37d00000(0000) 
knlGS:0000000000000000
[   54.628004] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   54.628066] CR2: 00007f202174e6f4 CR3: 00000001b3010000 CR4: 
00000000001006e0
[   54.628141] Call Trace:
[   54.628173]  <TASK>
[   54.628207]  iwl_dealloc_ucode+0x36/0x110 [iwlwifi]
[   54.628298]  iwl_req_fw_callback+0x2b9/0x2420 [iwlwifi]
[   54.628377]  ? ___cache_free+0x31/0x4d0
[   54.628429]  ? _request_firmware+0x514/0x760
[   54.628481]  ? kfree+0xa3/0x170
[   54.628520]  ? _request_firmware+0x514/0x760
[   54.628571]  request_firmware_work_func+0x4d/0x90
[   54.628628]  process_one_work+0x1e5/0x3b0
[   54.628678]  ? rescuer_thread+0x370/0x370
[   54.628724]  worker_thread+0x50/0x3a0
[   54.628768]  ? rescuer_thread+0x370/0x370
[   54.628814]  kthread+0xe7/0x110
[   54.628855]  ? kthread_complete_and_exit+0x20/0x20
[   54.628911]  ret_from_fork+0x22/0x30
[   54.628959]  </TASK>
[   54.628987] Modules linked in: iwlwifi cfg80211 snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio intel_rapl_msr 
intel_rapl_common intel_powerclamp coretemp kvm_intel ums_realtek kvm 
mei_pxp irqbypass mei_hdcp uas usb_storage intel_xhci_usb_role_switch 
roles ghash_clmulni_intel hci_uart btusb btqca btrtl btbcm btintel btmtk 
aesni_intel crypto_simd cryptd snd_hda_intel i915 snd_intel_dspcfg 
snd_intel_sdw_acpi bluetooth evdev intel_cstate snd_hda_codec at24 
snd_hda_core snd_hwdep iTCO_wdt snd_pcm ttm intel_pmc_bxt 
iTCO_vendor_support pcspkr watchdog drm_kms_helper mei_txe snd_timer snd 
jitterentropy_rng cec sg rc_core soundcore sha512_ssse3 i2c_algo_bit mei 
sha512_generic ctr drbg ansi_cprng pwm_lpss_platform pwm_lpss 
ecdh_generic intel_int0002_vgpio rfkill button ecc drm fuse configfs 
ip_tables x_tables autofs4 ext4 crc32c_generic crc16 mbcache jbd2 
hid_generic usbhid sd_mod t10_pi crc_t10dif crct10dif_generic xhci_pci 
r8169 xhci_hcd ahci crct10dif_pclmul
[   54.629118]  sdhci_pci crct10dif_common libahci realtek crc32_pclmul 
cqhci crc32c_intel mdio_devres libata sdhci scsi_mod scsi_common usbcore 
mmc_core usb_common fan libphy i2c_i801 i2c_smbus lpc_ich i2c_hid_acpi 
i2c_hid video hid
[   54.630194] ---[ end trace 0000000000000000 ]---
[   54.630246] RIP: 0010:kfree+0x61/0x170
[   54.630296] Code: 80 48 01 e8 0f 82 14 01 00 00 48 c7 c2 00 00 00 80 
48 2b 15 81 d2 ee 00 48 01 d0 48 c1 e8 0c 48 c1 e0 06 48 03 05 5f d2 ee 
00 <48> 8b 50 08 48 8d 4a ff 83 e2 01 48 0f 45 c1 48 8b 10 80 e6 02 0f
[   54.630484] RSP: 0018:ffff97bb80337ce8 EFLAGS: 00010007
[   54.630542] RAX: 00d8e3f509001000 RBX: 0000000000000206 RCX: 
ffffdca084258d07
[   54.630616] RDX: 000075c2c0000000 RSI: ffffffffc12ba0a6 RDI: 
36415f5f0004000f
[   54.630690] RBP: 36415f5f0004000f R08: ffffffff96243740 R09: 
ffff97bb80337bf8
[   54.630765] R10: 0000000000000000 R11: 0000000000000000 R12: 
ffff8a3dc3c622b8
[   54.630839] R13: ffff8a3f37d36900 R14: 0000000000000000 R15: 
ffff8a3dc3c62000
[   54.630914] FS:  0000000000000000(0000) GS:ffff8a3f37d00000(0000) 
knlGS:0000000000000000
[   54.630999] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   54.631059] CR2: 00007f202174e6f4 CR3: 00000001b3010000 CR4: 
00000000001006e0
==================================================================================


Regards
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
