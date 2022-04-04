Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F814F0FDB
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 09:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377613AbiDDHOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 03:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352972AbiDDHOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 03:14:39 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E78381BA;
        Mon,  4 Apr 2022 00:12:43 -0700 (PDT)
Received: from ip4d144895.dynamic.kabel-deutschland.de ([77.20.72.149] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nbGtF-0001hp-JK; Mon, 04 Apr 2022 09:12:41 +0200
Message-ID: <9fd4d3df-ef82-4a9b-1ba9-289181eb0d0a@leemhuis.info>
Date:   Mon, 4 Apr 2022 09:12:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Michele Ballabio <ballabio.m@gmail.com>,
        linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220403132152.23330380@darkstar.example.org>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: Possible regression in 5.16-stable
In-Reply-To: <20220403132152.23330380@darkstar.example.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1649056363;710e6f2d;
X-HE-SMSGID: 1nbGtF-0001hp-JK
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

On 03.04.22 13:22, Michele Ballabio wrote:
>
> 	I think I hit a regression in 5.16-stable.
> It is difficult to reproduce, and I'm not sure if it's
> still present in 5.17 and/or if it's caused by flaky hardware.
>
> The machine is a Ryzen 5 1600 with AMD graphics (RX 560).
> 
> Kernels 5.16.10 do not have the following regression, 5.16.11-16

5.16.11-16 sounds like this is a distro kernel that might or might not
be patched. Or is 11-16 just meant as a range. Could you clarify?

> do. My machine would freeze completely about once a week, no oops in
> the logs, sysrq won't work either. I managed to log only the
> following (and only once) with netconsole, while running kernel 5.16.16.
> I could not reproduce the problem since.

Hmmm. Of course ideally all regressions get fixed, but that beeing said:
5.16 will likely be EOL in round about two weeks anway and getting to
the root of this problem might take some time and effort. That's why I'm
not sure myself what's the best way forward here. Maybe testing 5.17 to
see if the problem still shows up would be good; bisection would help,
but I guess that will be hard here. But I guess there is one thing that
could help: could you maybe decode the panic you have as described in
this document:
https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html

Ciao, Thorsten

> ----------
> 4,1490,11865947234,-;ieee80211 phy0: rt2x00usb_watchdog_tx_dma: Warning - TX queue 2 DMA timed out, invoke forced reset
>  SUBSYSTEM=ieee80211
>  DEVICE=+ieee80211:phy0
> 4,1491,11872348272,-;ieee80211 phy0: rt2x00usb_watchdog_tx_dma: Warning - TX queue 2 DMA timed out, invoke forced reset
>  SUBSYSTEM=ieee80211
>  DEVICE=+ieee80211:phy0
> 0,1493,12767657117,-;traps: PANIC: double fault, error_code: 0x0
> 4,1494,12767657121,-;double fault: 0000 [#1] PREEMPT SMP NOPTI
> 4,1495,12767657123,-;CPU: 4 PID: 16786 Comm: MediaPD~der #12 Not tainted 5.16.16 #1
> 4,1496,12767657126,-;Hardware name: System manufacturer System Product Name/PRIME B350-PLUS, BIOS 4011 04/19/2018
> 4,1497,12767657127,-;RIP: 0010:entry_SYSCALL_64+0x3/0x29
> 4,1498,12767657133,-;Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 0f 01 f8 <65> 48 89 24 25 14 60 00 00 eb 12 0f 20 dc 0f 1f 44 00 00 48 81 e4
> 4,1499,12767657134,-;RSP: 0018:00007f2a8bcbd438 EFLAGS: 00010002
> 4,1500,12767657136,-;RAX: 00000000000000ca RBX: 000000000000005d RCX: 00007f2aa45e8aab
> 4,1501,12767657138,-;RDX: 0000000000000002 RSI: 0000000000000080 RDI: 00007f2aa4400018
> 4,1502,12767657139,-;RBP: 00007f2aa4400018 R08: 0000000000000000 R09: 00007f2a8ed00000
> 4,1503,12767657140,-;R10: 0000000000000000 R11: 0000000000000282 R12: 00000000000000a8
> 4,1504,12767657141,-;R13: 0000000000000003 R14: 0000000000000030 R15: 00007f2aa4400000
> 4,1505,12767657142,-;FS:  00007f2a8bcbe640(0000) GS:ffff8b110ed00000(0000) knlGS:0000000000000000
> 4,1506,12767657143,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> 4,1507,12767657144,-;CR2: 00007f2a8bcbd428 CR3: 00000002953f2000 CR4: 00000000003506e0
> 4,1508,12767657146,-;Call Trace:
> 4,1509,12767657146,-,ncfrag=0/986;Modules linked in: nfnetlink_queue nfnetlink_log nfnetlink bluetooth ecdh_generic ecc netconsole uas usb_storage snd_seq_dummy snd_hrtimer snd_seq snd_seq_device iptable_filter xt_tcpudp ip_tables
>  x_tables hwmon_vid 8021q garp mrp stp llc ipv6 fuse rt73usb rt2x00usb rt2x00lib mac80211 hid_logitech cfg80211 joydev hid_generic usbhid hid amdgpu intel_rapl_msr iommu_v2 intel_rapl_common gpu_sched eeepc_wmi asus_wmi drm_ttm_helper
>  ttm platform_profile battery drm_kms_helper sparse_keymap edac_mce_amd rfkill drm kvm_amd snd_hda_codec_realtek video snd_hda_codec_generic ledtrig_audio kvm snd_hda_codec_hdmi snd_hda_intel agpgart snd_intel_dspcfg snd_intel_sdw_acpi
>  wmi_bmof snd_hda_codec evdev i2c_algo_bit snd_hda_core fb_sys_fops syscopyarea sysfillrect sysimgblt snd_hwdep mfd_core snd_pcm r8169 irqbypass snd_timer realtek snd xhci_pci xhci_pci_renesas xhci_hcd mdio_devres crct10dif_pclmul
>  crc32_pclmul i2c_piix4 soundcore ccp libphy ghash_clmulni_intel i2c_co4,1509,12767657146,-,ncfrag=966/986;re rapl k10temp wmi
> 4,1510,12767657189,c; acpi_cpufreq gpio_amdpt button gpio_generic loop [last unloaded: netconsole]
> 4,1511,12767657207,-;------------[ cut here ]------------
> 4,1512,12767657207,-;WARNING: CPU: 4 PID: 16786 at kernel/softirq.c:362 __local_bh_enable_ip+0x43/0x70
> 4,1513,12767657212,-,ncfrag=0/986;Modules linked in: nfnetlink_queue nfnetlink_log nfnetlink bluetooth ecdh_generic ecc netconsole uas usb_storage snd_seq_dummy snd_hrtimer snd_seq snd_seq_device iptable_filter xt_tcpudp ip_tables
>  x_tables hwmon_vid 8021q garp mrp stp llc ipv6 fuse rt73usb rt2x00usb rt2x00lib mac80211 hid_logitech cfg80211 joydev hid_generic usbhid hid amdgpu intel_rapl_msr iommu_v2 intel_rapl_common gpu_sched eeepc_wmi asus_wmi drm_ttm_helper
>  ttm platform_profile battery drm_kms_helper sparse_keymap edac_mce_amd rfkill drm kvm_amd snd_hda_codec_realtek video snd_hda_codec_generic ledtrig_audio kvm snd_hda_codec_hdmi snd_hda_intel agpgart snd_intel_dspcfg snd_intel_sdw_acpi
>  wmi_bmof snd_hda_codec evdev i2c_algo_bit snd_hda_core fb_sys_fops syscopyarea sysfillrect sysimgblt snd_hwdep mfd_core snd_pcm r8169 irqbypass snd_timer realtek snd xhci_pci xhci_pci_renesas xhci_hcd mdio_devres crct10dif_pclmul
>  crc32_pclmul i2c_piix4 soundcore ccp libphy ghash_clmulni_intel i2c_co4,1513,12767657212,-,ncfrag=966/986;re rapl k10temp wmi
> 4,1514,12767657248,c; acpi_cpufreq gpio_amdpt button gpio_generic loop [last unloaded: netconsole]
> 4,1515,12767657252,-;CPU: 4 PID: 16786 Comm: MediaPD~der #12 Not tainted 5.16.16 #1
> 4,1516,12767657254,-;Hardware name: System manufacturer System Product Name/PRIME B350-PLUS, BIOS 4011 04/19/2018
> 4,1517,12767657255,-;RIP: 0010:__local_bh_enable_ip+0x43/0x70
> 4,1518,12767657257,-;Code: 01 35 61 1d f3 7d 65 8b 05 5a 1d f3 7d a9 00 ff ff 00 74 1a bf 01 00 00 00 e8 99 b5 02 00 65 8b 05 42 1d f3 7d 85 c0 74 25 c3 <0f> 0b eb cc 48 c7 c7 d9 53 42 83 e8 4d ec a6 00 65 66 8b 05 25 19
> 4,1519,12767657259,-;RSP: 0018:fffffe00000f69a0 EFLAGS: 00010006
> 4,1520,12767657260,-;RAX: 0000000080110203 RBX: ffff8b0e05bd2000 RCX: ffff8b0e05bd2000
> 4,1521,12767657261,-;RDX: ffff8b0e0ac28000 RSI: 0000000000000201 RDI: ffffffffc12f12c3
> 4,1522,12767657262,-;RBP: ffff8b0e0c977a30 R08: fffffe00000f69e8 R09: ffff8b0e0d085000
> 4,1523,12767657263,-;R10: ffff8b0e03234300 R11: 0000000000000fff R12: ffff8b0e0d0850d0
> 4,1524,12767657264,-;R13: fffffe00000f69e8 R14: ffff8b0e0ddfc980 R15: ffff8b0e0d085a58
> 4,1525,12767657265,-;FS:  00007f2a8bcbe640(0000) GS:ffff8b110ed00000(0000) knlGS:0000000000000000
> 4,1526,12767657266,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> ----------
> 
> 
