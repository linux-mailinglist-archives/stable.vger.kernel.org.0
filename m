Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B158966BF8E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 14:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbjAPNSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 08:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjAPNS0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 08:18:26 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9691F5CD;
        Mon, 16 Jan 2023 05:17:35 -0800 (PST)
Received: from [2a02:8108:963f:de38:4bc7:2566:28bd:b73c]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1pHPMj-0004pk-I5; Mon, 16 Jan 2023 14:17:33 +0100
Message-ID: <74347fe1-ac68-2661-500d-b87fab6994f7@leemhuis.info>
Date:   Mon, 16 Jan 2023 14:17:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US, de-DE
From:   "Linux kernel regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        io-uring@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux kernel regressions list <regressions@lists.linux.dev>,
        "Sergey V." <truesmb@gmail.com>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
To:     Jens Axboe <axboe@kernel.dk>
Subject: =?UTF-8?Q?=5bregression=5d_Bug=c2=a0216932_-_io=5furing_with_libvir?=
 =?UTF-8?Q?t_cause_kernel_NULL_pointer_dereference_since_6=2e1=2e5?=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1673875055;fa041deb;
X-HE-SMSGID: 1pHPMj-0004pk-I5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

I noticed a regression report in bugzilla.kernel.org. As many (most?)
kernel developer don't keep an eye on it, I decided to forward it by
mail. Quoting from https://bugzilla.kernel.org/show_bug.cgi?id=216932 :

>  Sergey V. 2023-01-15 06:41:03 UTC
> 
> Created attachment 303605 [details]
> My dmesg
> 
> After 6.1.5 kernel update my vm locks up at boot, and dmesg says "BUG: kernel NULL pointer dereference, address: 0000000000000005" (more details in attachment)
> 
> I have few drives attached to vm with io_uring
> 
> <driver name="qemu" type="raw" cache="none" io="io_uring" discard="unmap" detect_zeroes="off"/>
> 
> [reply] [−] Comment 1 Sergey V. 2023-01-15 06:51:54 UTC
> 
> After update from 6.1.4 to 6.1.5, rollback to 6.1.4 solve the problem
> 

From the attached dmesg:

> [   70.298276] vfio-pci 0000:04:00.0: vfio_ecap_init: hiding ecap 0x25@0x3a0
> [   90.429090] BUG: kernel NULL pointer dereference, address: 0000000000000005
> [   90.429097] #PF: supervisor write access in kernel mode
> [   90.429099] #PF: error_code(0x0002) - not-present page
> [   90.429101] PGD 0 P4D 0 
> [   90.429104] Oops: 0002 [#1] PREEMPT SMP NOPTI
> [   90.429106] CPU: 23 PID: 4674 Comm: qemu-system-x86 Tainted: P           OE      6.1.6-arch1-1 #1 7a22e7c094ebed7938b5cf37e842437a2188b39a
> [   90.429111] Hardware name: System manufacturer System Product Name/ROG STRIX X570-E GAMING, BIOS 4403 04/27/2022
> [   90.429113] RIP: 0010:__bio_split_to_limits+0x2a4/0x480
> [   90.429119] Code: 48 8b 5c 24 10 4c 8b 74 24 08 44 8b 7c 24 30 45 89 3e e9 29 ff ff ff c6 43 18 0c 48 89 df 49 c7 c4 f5 ff ff ff e8 4c 30 ff ff <41> 81 4c 24 10 00 40 00 00 45 8b 6c 24 28 49 be 00 00 00 00 00 00
> [   90.429122] RSP: 0018:ffffad8501857a30 EFLAGS: 00010202
> [   90.429124] RAX: ffff8e475e9a2001 RBX: ffff8e475e9a11c0 RCX: 0000000000002817
> [   90.429126] RDX: 0000000000002617 RSI: 2f0bdc6175ca72c6 RDI: 000000000003bae0
> [   90.429127] RBP: ffffad8501857ab8 R08: ffff8e4616989000 R09: 0000000000001000
> [   90.429128] R10: 0000000000001000 R11: 0000000000001000 R12: fffffffffffffff5
> [   90.429130] R13: 0000000000200000 R14: ffffad8501857acc R15: ffff8e4616989a80
> [   90.429132] FS:  00007fa9099b3e40(0000) GS:ffff8e64aefc0000(0000) knlGS:0000000000000000
> [   90.429134] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   90.429135] CR2: 0000000000000005 CR3: 0000000104526000 CR4: 0000000000750ee0
> [   90.429137] PKRU: 55555554
> [   90.429138] Call Trace:
> [   90.429139]  <TASK>
> [   90.429142]  blk_mq_submit_bio+0x9d/0x5e0
> [   90.429145]  ? bio_associate_blkg_from_css+0xcd/0x340
> [   90.429148]  __submit_bio+0xf5/0x180
> [   90.429150]  submit_bio_noacct_nocheck+0x20e/0x2c0
> [   90.429152]  __blkdev_direct_IO_async+0x104/0x1b0
> [   90.429155]  blkdev_read_iter+0x127/0x1e0
> [   90.429158]  io_read+0xe6/0x4e0
> [   90.429162]  io_issue_sqe+0x66/0x3c0
> [   90.429165]  ? io_prep_rw+0x5e/0x1c0
> [   90.429167]  io_submit_sqes+0x201/0x610
> [   90.429170]  __do_sys_io_uring_enter+0x3d0/0xa50
> [   90.429173]  do_syscall_64+0x5c/0x90
> [   90.429176]  ? syscall_exit_to_user_mode+0x1b/0x40
> [   90.429179]  ? do_syscall_64+0x6b/0x90
> [   90.429180]  ? exit_to_user_mode_prepare+0x16f/0x1d0
> [   90.429184]  ? syscall_exit_to_user_mode+0x1b/0x40
> [   90.429186]  ? do_syscall_64+0x6b/0x90
> [   90.429187]  ? do_syscall_64+0x6b/0x90
> [   90.429188]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> [   90.429192] RIP: 0033:0x7fa90ac10865
> [   90.429220] Code: 00 00 00 44 89 d0 41 b9 08 00 00 00 83 c8 10 f6 87 d0 00 00 00 01 8b bf cc 00 00 00 44 0f 45 d0 45 31 c0 b8 aa 01 00 00 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 41 83 e2 02 74 c2 f0 48 83 0c 24
> [   90.429223] RSP: 002b:00007ffd7b86b0d8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> [   90.429226] RAX: ffffffffffffffda RBX: 00005572c9a6a800 RCX: 00007fa90ac10865
> [   90.429227] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 000000000000000d
> [   90.429229] RBP: 00005572c9a6a808 R08: 0000000000000000 R09: 0000000000000008
> [   90.429230] R10: 0000000000000000 R11: 0000000000000246 R12: 00005572c9a6a8f0
> [   90.429231] R13: 00007ffd7b86b160 R14: 0000000000000001 R15: 0000000000000000
> [   90.429235]  </TASK>
> [   90.429236] Modules linked in: ip_vs_rr xt_ipvs ip_vs overlay
> rfcomm vhost_net vhost vhost_iotlb tap tun snd_seq_dummy snd_hrtimer
> snd_seq xt_nat vxlan ip6_udp_tunnel udp_tunnel xt_policy xt_mark xt_u32
> xt_CHECKSUM ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack
> ip6table_mangle ip6table_nat ip6table_filter xt_MASQUERADE ip6_tables
> nf_conntrack_netlink nfnetlink iptable_mangle xt_addrtype iptable_filter
> iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> br_netfilter cmac algif_hash veth algif_skcipher af_alg nct6775 bnep
> nct6775_core hwmon_vid scsi_transport_iscsi f2fs snd_usb_audio
> snd_usbmidi_lib crc32_generic lz4hc_compress snd_rawmidi hid_sony
> snd_seq_device ff_memless mc xfs intel_rapl_msr intel_rapl_common
> edac_mce_amd snd_hda_codec_realtek kvm_amd btusb btrtl
> snd_hda_codec_generic snd_hda_codec_hdmi btbcm snd_hda_intel kvm btintel
> snd_intel_dspcfg btmtk snd_intel_sdw_acpi joydev mousedev
> crct10dif_pclmul snd_hda_codec bluetooth crc32_pclmul dm_thin_pool
> polyval_clmulni
> [   90.429270]  polyval_generic dm_persistent_data gf128mul
> hid_apple
> ecdh_generic snd_hda_core dm_bio_prison crc16 asus_ec_sensors
> ghash_clmulni_intel dm_bufio bridge snd_hwdep eeepc_wmi sha512_ssse3
> snd_pcm asus_wmi aesni_intel stp llc snd_timer crypto_simd ledtrig_audio
> sp5100_tco sparse_keymap snd cryptd apple_mfi_fastcharge rapl usbhid
> platform_profile pcspkr igb ccp wmi_bmof k10temp i2c_piix4 soundcore
> vfat cfg80211 dca fat rfkill acpi_cpufreq mac_hid dm_multipath dm_mod sg
> crypto_user fuse bpf_preload ip_tables x_tables btrfs blake2b_generic
> libcrc32c crc32c_generic xor raid6_pq nvme crc32c_intel nvme_core
> xhci_pci xhci_pci_renesas nvme_common mxm_wmi video wmi vfio_pci
> vfio_pci_core irqbypass vfio_virqfd vfio_iommu_type1 vfio
> [   90.429308] Unloaded tainted modules: nvidia(POE):1 nvidia_uvm(POE):1 nvidia_modeset(POE):1 nvidia_drm(POE):1 [last unloaded: nvidia(POE)]
> [   90.429320] CR2: 0000000000000005
> [   90.429321] ---[ end trace 0000000000000000 ]---
> [   90.429323] RIP: 0010:__bio_split_to_limits+0x2a4/0x480
> [   90.429325] Code: 48 8b 5c 24 10 4c 8b 74 24 08 44 8b 7c 24 30 45 89 3e e9 29 ff ff ff c6 43 18 0c 48 89 df 49 c7 c4 f5 ff ff ff e8 4c 30 ff ff <41> 81 4c 24 10 00 40 00 00 45 8b 6c 24 28 49 be 00 00 00 00 00 00
> [   90.429328] RSP: 0018:ffffad8501857a30 EFLAGS: 00010202
> [   90.429329] RAX: ffff8e475e9a2001 RBX: ffff8e475e9a11c0 RCX: 0000000000002817
> [   90.429331] RDX: 0000000000002617 RSI: 2f0bdc6175ca72c6 RDI: 000000000003bae0
> [   90.429332] RBP: ffffad8501857ab8 R08: ffff8e4616989000 R09: 0000000000001000
> [   90.429334] R10: 0000000000001000 R11: 0000000000001000 R12: fffffffffffffff5
> [   90.429335] R13: 0000000000200000 R14: ffffad8501857acc R15: ffff8e4616989a80
> [   90.429337] FS:  00007fa9099b3e40(0000) GS:ffff8e64aefc0000(0000) knlGS:0000000000000000
> [   90.429338] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   90.429340] CR2: 0000000000000005 CR3: 0000000104526000 CR4: 0000000000750ee0
> [   90.429341] PKRU: 55555554

See the ticket for more details.

[TLDR for the rest of this mail: I'm adding this report to the list of
tracked Linux kernel regressions; the text you find below is based on a
few templates paragraphs you might have encountered already in similar
form.]

BTW, let me use this mail to also add the report to the list of tracked
regressions to ensure it's doesn't fall through the cracks:

#regzbot introduced: v6.1.4..v6.1.5
https://bugzilla.kernel.org/show_bug.cgi?id=216932
#regzbot title: io_uring: NULL pointer dereference
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply and tell me -- ideally
while also telling regzbot about it, as explained by the page listed in
the footer of this mail.

Developers: When fixing the issue, remember to add 'Link:' tags pointing
to the report (e.g. the buzgzilla ticket and maybe this mail as well, if
this thread sees some discussion). See page linked in footer for details.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
--
Everything you wanna know about Linux kernel regression tracking:
https://linux-regtracking.leemhuis.info/about/#tldr
If I did something stupid, please tell me, as explained on that page.
