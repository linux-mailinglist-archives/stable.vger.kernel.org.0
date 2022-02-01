Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3BE4A6707
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 22:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiBAVZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 16:25:14 -0500
Received: from dresden.studentenwerk.mhn.de ([141.84.225.229]:33322 "EHLO
        email.studentenwerk.mhn.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231670AbiBAVZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 16:25:10 -0500
Received: from mailhub.studentenwerk.mhn.de (mailhub.studentenwerk.mhn.de [127.0.0.1])
        by email.studentenwerk.mhn.de (Postfix) with ESMTPS id 4JpHyX3xhdzRhSB;
        Tue,  1 Feb 2022 22:25:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stwm.de; s=stwm-20170627;
        t=1643750708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nqWRRSu0fDCGH3oPeUBmNJ80j4he6zy+fJd3Tpmnn5s=;
        b=B98qWBMaQgGtSgXiMj0670gHDbpu85a3k6RqYpMDbnqB9zIrxksv3sZAJc98rH1Mk2NALC
        BwqGZ7NWZR5J0Sh0PVmyBnIX+U5ohYTqGMsqQW4hM0d6ko5IpuxuBLonZ3qTFHsdf2sKis
        ehbentjw+Yv+ZWzpvElk2A/eP6lN1P0DKLa91VZ9JiaODPDD88LY1RLaZCEaUSUc8bvuVz
        YmaAzIh/VxoTw2Y5Ye/HEBdyUjqKwBHT3G5Q8ibeDnNmu2p+PmD5rUuI/+FCvldMM72T0V
        1P2Fe5iZWWtpzffGmf7p6rlzM7XuC2YAoSHHguIOMzeXChBOT77lZBW9qD6Smg==
MIME-Version: 1.0
Date:   Tue, 01 Feb 2022 22:25:22 +0100
From:   Wolfgang Walter <linux@stwm.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: 5.15.17: general protection fault when loading iwlwifi as module
 and no firmware available
In-Reply-To: <YflV56eA7Y7tr01u@kroah.com>
References: <099995b11936073c8d6b7a28c07ccd95@stwm.de>
 <YflV56eA7Y7tr01u@kroah.com>
Message-ID: <167f0d3e006f3b45a93e5352ef99d817@stwm.de>
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

I bisected it down to e23f075d77987de4215c8e0696f28bcc707506f7:

e23f075d77987de4215c8e0696f28bcc707506f7 is the first bad commit
commit e23f075d77987de4215c8e0696f28bcc707506f7
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Dec 10 11:12:42 2021 +0200

     iwlwifi: fix leaks/bad data after failed firmware load

     [ Upstream commit ab07506b0454bea606095951e19e72c282bfbb42 ]

     If firmware load fails after having loaded some parts of the
     firmware, e.g. the IML image, then this would leak. For the
     host command list we'd end up running into a WARN on the next
     attempt to load another firmware image.

     Fix this by calling iwl_dealloc_ucode() on failures, and make
     that also clear the data so we start fresh on the next round.

     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
     Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
     Link: 
https://lore.kernel.org/r/iwlwifi.20211210110539.1f742f0eb58a.I1315f22f6aa632d94ae2069f85e1bca5e734dce0@changeid
     Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
     Signed-off-by: Sasha Levin <sashal@kernel.org>

  drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 8 ++++++++
  1 file changed, 8 insertions(+)


I reverted this patch (and also the following one, 
58d53fe49a5dfbd9204c6d605bff4c99f7549256, so the blamed patch reverted 
cleanly) in 5.15.17. The general protection fault then disappeared.

I did not hat time yet to test 5.16 or 5.17-rc2.

Regards,
-- 
Wolfgang Walter
Studentenwerk München
Anstalt des öffentlichen Rechts
