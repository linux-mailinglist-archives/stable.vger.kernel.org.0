Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFEB4A6071
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 16:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240520AbiBAPqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 10:46:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48538 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240521AbiBAPqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 10:46:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EFD2B82D51
        for <stable@vger.kernel.org>; Tue,  1 Feb 2022 15:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A29DC340EB;
        Tue,  1 Feb 2022 15:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643730411;
        bh=JqjvU1UP++Z+7Jtvj/tBX3SONtrWonIA0mNO91TDdRY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kAQCdKpSDYXcyco20zjcIJJveEZ9xQOnLoLcg7Hge50P0rRhfw0+tnx5noGWZTtvl
         j7ywssYUZl9v5zZZaIgULUgcY9pycVb+4+PdQdzfNLIMh68WEigOwjCLutmnpk28eq
         FYtsDyAqTfeqhRUxhZ/7jr93tE438+zrDRnq2Bik=
Date:   Tue, 1 Feb 2022 16:46:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wolfgang Walter <linux@stwm.de>
Cc:     stable@vger.kernel.org
Subject: Re: 5.15.17: general protection fault when loading iwlwifi as module
 and no firmware available
Message-ID: <YflV56eA7Y7tr01u@kroah.com>
References: <099995b11936073c8d6b7a28c07ccd95@stwm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <099995b11936073c8d6b7a28c07ccd95@stwm.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 01, 2022 at 04:31:29PM +0100, Wolfgang Walter wrote:
> Hello,
> 
> we found a regression in 5.15.17. When iwlwifi is loaded as a module and it
> cannot load a firmware it crashes:
> 
> ===================================================================
> Jan 28 19:05:01 kistchen kernel: [    5.415151] Intel(R) Wireless WiFi
> driver for Linux
> Jan 28 19:05:01 kistchen kernel: [    5.425600] iwlwifi 0000:04:00.0: Direct
> firmware load for iwlwifi-3160-17.ucode failed with error -2
> Jan 28 19:05:01 kistchen kernel: [    5.425616] iwlwifi 0000:04:00.0: no
> suitable firmware found!
> Jan 28 19:05:01 kistchen kernel: [    5.425704] iwlwifi 0000:04:00.0:
> iwlwifi-3160-17 is required
> Jan 28 19:05:01 kistchen kernel: [    5.425786] iwlwifi 0000:04:00.0: check
> git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
> Jan 28 19:05:01 kistchen kernel: [    5.426226] general protection fault,
> probably for non-canonical address 0xd8e6d895001008: 0000 [#1] PREEMPT SMP
> PTI
> Jan 28 19:05:01 kistchen kernel: [    5.426324] CPU: 1 PID: 45 Comm:
> kworker/1:1 Not tainted 5.15.17-aladebian64.all+1.2 #1
> Jan 28 19:05:01 kistchen kernel: [    5.426411] Hardware name: ZOTAC
> XXXXXX/XXXXXX, BIOS B301P017 04/06/2016
> Jan 28 19:05:01 kistchen kernel: [    5.426493] Workqueue: events
> request_firmware_work_func
> Jan 28 19:05:01 kistchen kernel: [    5.426587] RIP: 0010:kfree+0x61/0x170
> Jan 28 19:05:01 kistchen kernel: [    5.426670] Code: 80 48 01 e8 0f 82 21
> 01 00 00 48 c7 c2 00 00 00 80 48 2b 15 01 f8 ee 00 48 01 d0 48 c1 e8 0c 48
> c1 e0 06 48 03 05 df f7 ee 00 <48> 8b 50 08 48 8d 4a ff 83 e2 01 48 0f 45 c1
> 48 8b 48 08 48 8d 51
> Jan 28 19:05:01 kistchen kernel: [    5.426772] RSP: 0018:ffffa54e002b3ce8
> EFLAGS: 00010007
> Jan 28 19:05:01 kistchen kernel: [    5.426853] RAX: 00d8e6d895001000 RBX:
> 0000000000000206 RCX: 0000000000000000
> Jan 28 19:05:01 kistchen kernel: [    5.426937] RDX: 00007425c0000000 RSI:
> ffffffffc0fd6ea6 RDI: 36415f5f0004000f
> Jan 28 19:05:01 kistchen kernel: [    5.427019] RBP: 36415f5f0004000f R08:
> ffffffffa80427c0 R09: ffffa54e002b3be0
> Jan 28 19:05:01 kistchen kernel: [    5.427102] R10: 0000000000000000 R11:
> 0000000000000000 R12: ffff8bdae10e6ab8
> Jan 28 19:05:01 kistchen kernel: [    5.427184] R13: ffff8bdae10e6800 R14:
> ffff8bdac256c400 R15: ffff8bdc37cb5905
> Jan 28 19:05:01 kistchen kernel: [    5.427267] FS:  0000000000000000(0000)
> GS:ffff8bdc37c80000(0000) knlGS:0000000000000000
> Jan 28 19:05:01 kistchen kernel: [    5.427354] CS:  0010 DS: 0000 ES: 0000
> CR0: 0000000080050033
> Jan 28 19:05:01 kistchen kernel: [    5.427446] CR2: 00007f934935c6f4 CR3:
> 00000001077e2000 CR4: 00000000001006e0
> Jan 28 19:05:01 kistchen kernel: [    5.427541] Call Trace:
> Jan 28 19:05:01 kistchen kernel: [    5.427630]  <TASK>
> Jan 28 19:05:01 kistchen kernel: [    5.427727]
> iwl_dealloc_ucode+0x36/0x110 [iwlwifi]
> Jan 28 19:05:01 kistchen kernel: [    5.427873]
> iwl_req_fw_callback+0x2d1/0x2330 [iwlwifi]
> Jan 28 19:05:01 kistchen kernel: [    5.428006]  ? ___cache_free+0x31/0x4b0
> Jan 28 19:05:01 kistchen kernel: [    5.428108]  ?
> _request_firmware+0x3ff/0x780
> Jan 28 19:05:01 kistchen kernel: [    5.428205]  ? kfree+0xa9/0x170
> Jan 28 19:05:01 kistchen kernel: [    5.428298]  ?
> _request_firmware+0x3ff/0x780
> Jan 28 19:05:01 kistchen kernel: [    5.428391]
> request_firmware_work_func+0x4d/0x90
> Jan 28 19:05:01 kistchen kernel: [    5.428486]
> process_one_work+0x1e8/0x3c0
> Jan 28 19:05:01 kistchen kernel: [    5.428581]  worker_thread+0x50/0x3b0
> Jan 28 19:05:01 kistchen kernel: [    5.428672]  ?
> process_one_work+0x3c0/0x3c0
> Jan 28 19:05:01 kistchen kernel: [    5.428763]  kthread+0x141/0x170
> Jan 28 19:05:01 kistchen kernel: [    5.428856]  ?
> set_kthread_struct+0x40/0x40
> Jan 28 19:05:01 kistchen kernel: [    5.428948]  ret_from_fork+0x22/0x30
> Jan 28 19:05:01 kistchen kernel: [    5.429044]  </TASK>
> Jan 28 19:05:01 kistchen kernel: [    5.429130] Modules linked in:
> ums_realtek(+) iwlwifi(+) snd_hda_intel uas usb_storage snd_intel_dspcfg
> sha512_ssse3 ttm snd_intel_sdw_acpi snd_hda_codec snd_hda_core
> sha512_generic aesni_intel(+) drm_kms_helper snd_hwdep crypto_simd
> intel_xhci_usb_role_switch cryptd sg roles cec snd_pcm intel_cstate
> snd_timer mei_txe at24 snd iTCO_wdt rc_core cfg80211 intel_pmc_bxt pcspkr
> soundcore ctr iTCO_vendor_support mei i2c_algo_bit watchdog drbg ansi_cprng
> ecdh_generic(+) rfkill ecc pwm_lpss_platform pwm_lpss intel_int0002_vgpio
> button drm fuse configfs ip_tables x_tables autofs4 ext4 crc32c_generic
> crc16 mbcache jbd2 sd_mod t10_pi crc_t10dif crct10dif_generic ahci libahci
> xhci_pci sdhci_pci cqhci crct10dif_pclmul crct10dif_common libata r8169
> i2c_i801 crc32_pclmul xhci_hcd realtek mdio_devres crc32c_intel i2c_smbus
> lpc_ich sdhci libphy scsi_mod usbcore usb_common scsi_common mmc_core fan
> i2c_hid_acpi i2c_hid video hid
> Jan 28 19:05:01 kistchen kernel: [    5.429595] ---[ end trace
> aea59d2f4abcc392 ]---
> Jan 28 19:05:01 kistchen kernel: [    5.429688] RIP: 0010:kfree+0x61/0x170
> Jan 28 19:05:01 kistchen kernel: [    5.429783] Code: 80 48 01 e8 0f 82 21
> 01 00 00 48 c7 c2 00 00 00 80 48 2b 15 01 f8 ee 00 48 01 d0 48 c1 e8 0c 48
> c1 e0 06 48 03 05 df f7 ee 00 <48> 8b 50 08 48 8d 4a ff 83 e2 01 48 0f 45 c1
> 48 8b 48 08 48 8d 51
> Jan 28 19:05:01 kistchen kernel: [    5.429920] RSP: 0018:ffffa54e002b3ce8
> EFLAGS: 00010007
> Jan 28 19:05:01 kistchen kernel: [    5.430012] RAX: 00d8e6d895001000 RBX:
> 0000000000000206 RCX: 0000000000000000
> Jan 28 19:05:01 kistchen kernel: [    5.430107] RDX: 00007425c0000000 RSI:
> ffffffffc0fd6ea6 RDI: 36415f5f0004000f
> Jan 28 19:05:01 kistchen kernel: [    5.430201] RBP: 36415f5f0004000f R08:
> ffffffffa80427c0 R09: ffffa54e002b3be0
> Jan 28 19:05:01 kistchen kernel: [    5.430296] R10: 0000000000000000 R11:
> 0000000000000000 R12: ffff8bdae10e6ab8
> Jan 28 19:05:01 kistchen kernel: [    5.430392] R13: ffff8bdae10e6800 R14:
> ffff8bdac256c400 R15: ffff8bdc37cb5905
> Jan 28 19:05:01 kistchen kernel: [    5.430489] FS:  0000000000000000(0000)
> GS:ffff8bdc37c80000(0000) knlGS:0000000000000000
> Jan 28 19:05:01 kistchen kernel: [    5.430603] CS:  0010 DS: 0000 ES: 0000
> CR0: 0000000080050033
> Jan 28 19:05:01 kistchen kernel: [    5.430700] CR2: 00007f934935c6f4 CR3:
> 00000001077e2000 CR4: 00000000001006e0
> ===================================================================
> 
> Providing a firmware file (or blacklisting iwlwifi of course) fixes ist.
> 5.15.16 does not crash.

Can you do 'git bisect' to track down the offending commit?

And does 5.16.y work for you?  How about 5.17-rc2?

thanks,

greg k-h
