Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F154018ED
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 11:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240491AbhIFJgG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 05:36:06 -0400
Received: from x127130.tudelft.net ([131.180.127.130]:34940 "EHLO
        djo.tudelft.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S241112AbhIFJgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 05:36:05 -0400
Received: by djo.tudelft.nl (Postfix, from userid 2001)
        id 0935C1C42C4; Mon,  6 Sep 2021 11:36:11 +0200 (CEST)
Date:   Mon, 6 Sep 2021 11:36:11 +0200
From:   wim <wim@djo.tudelft.nl>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        wim <wim@djo.tudelft.nl>
Subject: Re: kernel-4.9.270 crash
Message-ID: <20210906093611.GA20123@djo.tudelft.nl>
Reply-To: wim@djo.tudelft.nl
References: <20210904235231.GA31607@djo.tudelft.nl>
 <20210905190045.GA10991@djo.tudelft.nl>
 <YTWgKo4idyocDuCD@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTWgKo4idyocDuCD@kroah.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 06:59:22AM +0200, Greg KH wrote:
> On Sun, Sep 05, 2021 at 09:00:45PM +0200, wim wrote:
> > On Sun, Sep 05, 2021 at 01:52:31AM +0200, wim wrote:
> > > 
> > > Hello Greg,
> > > 
> > > from kernel-4.9.270 up until now (4.9.282) I experience kernel crashes upon
> > > loading a GPU module.
> > > It happens on two out of at least six different machines.
> > > I can't believe that I'm the only one where that happens, but since the bug
> > > is still there twelve versions later, I need to report this.
> > > ...
> 
> Do you have any kernel log messages when these crashes happen?

On the AMD machine:

Aug  1 20:51:24 djo kernel: [drm] Initialized
Aug  1 20:51:24 djo kernel: checking generic (a0000 10000) vs hw (e0000000 8000000)
Aug  1 20:51:24 djo kernel: checking generic (a0000 10000) vs hw (ea000000 1000000)
Aug  1 20:51:24 djo kernel: fb: switching to nouveaufb from VGA16 VGA
Aug  1 20:51:24 djo kernel: divide error: 0000 [#1] SMP
Aug  1 20:51:24 djo kernel: Modules linked in: nouveau(+) video drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm agpgart i2c_algo_bit tun lirc_serial(C) lirc_dev arc4 binfmt_misc snd_pcm_oss snd_mixer_oss fbcon bitblit softcursor font tileblit ath9k_htc ath9k_common ath9k_hw ath mac80211 cfg80211 uvcvideo rfkill firmware_class snd_usb_audio sr9700 videobuf2_vmalloc videobuf2_memops snd_usbmidi_lib videobuf2_v4l2 dm9601 videobuf2_core usbnet snd_rawmidi mii usb_storage snd_hda_codec_generic kvm snd_hda_intel irqbypass snd_hda_codec gpio_ich ppdev snd_hwdep pcspkr snd_hda_core snd_pcm uhci_hcd ohci_pci snd_timer ohci_hcd lpc_ich ehci_pci snd ehci_hcd wmi mfd_core usbcore soundcore parport_pc floppy usb_common parport acpi_cpufreq button processor
Aug  1 20:51:24 djo kernel: CPU: 0 PID: 2791 Comm: modprobe Tainted: G         C      4.9.277 #1
Aug  1 20:51:24 djo kernel: Hardware name: Hewlett-Packard HP xw4300 Workstation/0A00h, BIOS 786D3 v01.08 03/10/2006
Aug  1 20:51:24 djo kernel: task: f6317080 task.stack: f4058000
Aug  1 20:51:24 djo kernel: EIP: 0060:[<c02f789d>] EFLAGS: 00010206 CPU: 0
Aug  1 20:51:24 djo kernel: EAX: 00000190 EBX: ffffffea ECX: 00000019 EDX: 00000000
Aug  1 20:51:24 djo kernel: ESI: f52db800 EDI: 00000050 EBP: c02f7838 ESP: f4059c10
Aug  1 20:51:24 djo kernel:  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Aug  1 20:51:24 djo kernel: CR0: 80050033 CR2: 080a1a54 CR3: 35234000 CR4: 00000690
Aug  1 20:51:24 djo kernel: Stack:
Aug  1 20:51:24 djo kernel:  00000050 f52db800 00000019 c0340732 00000000 000000a0 000000a0 00000fa0
Aug  1 20:51:24 djo kernel:  f62f4000 0000001e 00000000 00000000 f5a63800 00000000 00000000 00000000
Aug  1 20:51:24 djo kernel:  00000000 00000000 f6024000 00000000 f52db800 00000001 00000000 00000000
Aug  1 20:51:24 djo kernel: Call Trace:
Aug  1 20:51:24 djo kernel:  [<c0340732>] ? 0xc0340732
Aug  1 20:51:24 djo kernel:  [<c0340988>] ? 0xc0340988
Aug  1 20:51:24 djo kernel:  [<c02f734a>] ? 0xc02f734a
Aug  1 20:51:24 djo kernel:  [<c033f780>] ? 0xc033f780
Aug  1 20:51:24 djo kernel:  [<c0340b32>] ? 0xc0340b32
Aug  1 20:51:24 djo kernel:  [<c0340d20>] ? 0xc0340d20
Aug  1 20:51:24 djo kernel:  [<f8bc4ef7>] ? 0xf8bc4ef7
Aug  1 20:51:24 djo kernel:  [<c0163715>] ? 0xc0163715
Aug  1 20:51:24 djo kernel:  [<f8bc4c82>] ? 0xf8bc4c82
Aug  1 20:51:24 djo kernel:  [<c014aac4>] ? 0xc014aac4
Aug  1 20:51:24 djo kernel:  [<c014ad8a>] ? 0xc014ad8a
Aug  1 20:51:24 djo kernel:  [<c014ada6>] ? 0xc014ada6
Aug  1 20:51:24 djo kernel:  [<c02f9aa4>] ? 0xc02f9aa4
Aug  1 20:51:24 djo kernel:  [<c0168c32>] ? 0xc0168c32
Aug  1 20:51:24 djo kernel:  [<c02fa294>] ? 0xc02fa294
Aug  1 20:51:24 djo kernel:  [<c02fa47e>] ? 0xc02fa47e
Aug  1 20:51:24 djo kernel:  [<c02fa4f5>] ? 0xc02fa4f5
Aug  1 20:51:24 djo kernel:  [<f90a5c94>] ? 0xf90a5c94
Aug  1 20:51:24 djo kernel:  [<f90a5b88>] ? 0xf90a5b88
Aug  1 20:51:24 djo kernel:  [<c02e82de>] ? 0xc02e82de
Aug  1 20:51:24 djo kernel:  [<c03545f8>] ? 0xc03545f8
Aug  1 20:51:24 djo kernel:  [<c035475d>] ? 0xc035475d
Aug  1 20:51:24 djo kernel:  [<c03533a9>] ? 0xc03533a9
Aug  1 20:51:24 djo kernel:  [<c035424a>] ? 0xc035424a
Aug  1 20:51:24 djo kernel:  [<c0354705>] ? 0xc0354705
Aug  1 20:51:24 djo kernel:  [<c0353f3d>] ? 0xc0353f3d
Aug  1 20:51:24 djo kernel:  [<c0354e44>] ? 0xc0354e44
Aug  1 20:51:24 djo kernel:  [<f9124000>] ? 0xf9124000
Aug  1 20:51:24 djo kernel:  [<c01003df>] ? 0xc01003df
Aug  1 20:51:24 djo kernel:  [<c01dbb22>] ? 0xc01dbb22
Aug  1 20:51:24 djo kernel:  [<c04ba42d>] ? 0xc04ba42d
Aug  1 20:51:24 djo kernel:  [<c04ba45c>] ? 0xc04ba45c
Aug  1 20:51:24 djo kernel:  [<c01889d5>] ? 0xc01889d5
Aug  1 20:51:24 djo kernel:  [<c01e45e4>] ? 0xc01e45e4
Aug  1 20:51:24 djo kernel:  [<c0188c2b>] ? 0xc0188c2b
Aug  1 20:51:24 djo kernel:  [<c0101211>] ? 0xc0101211
Aug  1 20:51:24 djo kernel:  [<c04c0579>] ? 0xc04c0579
Aug  1 20:51:24 djo kernel: Code: 63 c0 eb 53 f6 04 24 01 bb ea ff ff ff 75 4a 0f b6 05 07 c5 6c c0 3b 04 24 72 3e 0f b6 05 0e c5 6c c0 31 d2 0f af 05 08 cc 63 c0 <f7> b6 ec 00 00 00 39 c8 72 24 8b 86 24 02 00 00 31 db 3b 30 75
Aug  1 20:51:24 djo kernel: EIP: [<c02f789d>] 
Aug  1 20:51:24 djo kernel:  SS:ESP 0068:f4059c10
Aug  1 20:51:24 djo kernel: ---[ end trace 307fdb439b21cfc0 ]---


On the Intel machine:

Sep  5 00:20:26 asusUX410U kernel: Adding 2097148k swap on /dev/sda2.  Priority:-1 extents:1 across:2097148k FS
Sep  5 00:20:38 asusUX410U kernel: [drm] Memory usable by graphics device = 4096M
Sep  5 00:20:38 asusUX410U kernel: fb: switching to inteldrmfb from VGA16 VGA
Sep  5 00:20:38 asusUX410U kernel: divide error: 0000 [#1] SMP
Sep  5 00:20:38 asusUX410U kernel: Modules linked in: i915(+) intel_gtt cmac uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core arc4 iwlmvm mac80211 nouveau drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm agpgart btusb btrtl btbcm btintel bluetooth hid_multitouch iwlwifi i2c_designware_platform mxm_wmi i2c_designware_core cfg80211 x86_pkg_temp_thermal intel_powerclamp pcspkr nvidiafb i2c_algo_bit fb_ddc rfkill firmware_class thermal i2c_hid xhci_pci xhci_hcd usbcore battery int3403_thermal wmi video ac int3400_thermal acpi_thermal_rel acpi_pad asus_wireless intel_lpss_pci intel_lpss button processor_thermal_device i2c_i801 intel_soc_dts_iosf i2c_smbus intel_pch_thermal usb_common mfd_core int340x_thermal_zone binfmt_misc snd_hda_codec_generic snd_pcm_oss snd_mixer_oss snd_hda_intel
Sep  5 00:20:38 asusUX410U kernel:  snd_hda_codec snd_hwdep snd_hda_core snd_pcm snd_timer snd soundcore fbcon bitblit softcursor font tileblit
Sep  5 00:20:38 asusUX410U kernel: CPU: 2 PID: 2601 Comm: modprobe Not tainted 4.9.282 #1
Sep  5 00:20:38 asusUX410U kernel: Hardware name: ASUSTeK COMPUTER INC. UX410UQK/UX410UQK, BIOS UX410UQK.301 12/12/2016
Sep  5 00:20:38 asusUX410U kernel: task: ffff880264ac8000 task.stack: ffffc90003ee0000
Sep  5 00:20:38 asusUX410U kernel: RIP: 0010:[<ffffffff8044b341>]  [<ffffffff8044b341>] 0xffffffff8044b341
Sep  5 00:20:38 asusUX410U kernel: RSP: 0018:ffffc90003ee38e8  EFLAGS: 00010246
Sep  5 00:20:38 asusUX410U kernel: RAX: 0000000000000190 RBX: 00000000000000a0 RCX: 0000000000000000
Sep  5 00:20:38 asusUX410U kernel: RDX: 0000000000000000 RSI: 0000000000000050 RDI: ffff880256b9b800
Sep  5 00:20:38 asusUX410U kernel: RBP: 0000000000000019 R08: 0000000000000019 R09: 00000000000000a0
Sep  5 00:20:38 asusUX410U kernel: R10: 000000000000001e R11: 0000000000000001 R12: 00000000ffffffea
Sep  5 00:20:38 asusUX410U kernel: R13: ffff880256b9b800 R14: 0000000000000fa0 R15: 0000000000000000
Sep  5 00:20:38 asusUX410U kernel: FS:  00007fb959a4cc00(0000) GS:ffff88026ed00000(0000) knlGS:0000000000000000
Sep  5 00:20:38 asusUX410U kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Sep  5 00:20:38 asusUX410U kernel: CR2: 000056515c106000 CR3: 0000000259500000 CR4: 0000000000360670
Sep  5 00:20:38 asusUX410U kernel: Stack:
Sep  5 00:20:38 asusUX410U kernel:  0000000000000050 ffffffff804a8d05 ffff880259667000 0000000000000000
Sep  5 00:20:38 asusUX410U kernel:  ffff88020000001e 000000a000000fa0 00000000000000a0 00000000000000a0
Sep  5 00:20:38 asusUX410U kernel:  0190000000500019 ffff880256b9b800 ffff880256b9b800 0000000000000000
Sep  5 00:20:38 asusUX410U kernel: Call Trace:
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff804a8d05>] ? 0xffffffff804a8d05
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff8044adee>] ? 0xffffffff8044adee
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff804a79dd>] ? 0xffffffff804a79dd
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff804a9160>] ? 0xffffffff804a9160
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff804a9395>] ? 0xffffffff804a9395
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffffa000c549>] ? 0xffffffffa000c549
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff80257d40>] ? 0xffffffff80257d40
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff80258077>] ? 0xffffffff80258077
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff8044d551>] ? 0xffffffff8044d551
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff8044e213>] ? 0xffffffff8044e213
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff8044e457>] ? 0xffffffff8044e457
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff8044e4de>] ? 0xffffffff8044e4de
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffffa05cb585>] ? 0xffffffffa05cb585
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff80439f8a>] ? 0xffffffff80439f8a
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff804c0d1e>] ? 0xffffffff804c0d1e
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff804c0eda>] ? 0xffffffff804c0eda
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff804c0e72>] ? 0xffffffff804c0e72
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff804bf59b>] ? 0xffffffff804bf59b
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff804c04c9>] ? 0xffffffff804c04c9
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffffa06ab000>] ? 0xffffffffa06ab000
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff804c1738>] ? 0xffffffff804c1738
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff80200341>] ? 0xffffffff80200341
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff802962fc>] ? 0xffffffff802962fc
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff80297a24>] ? 0xffffffff80297a24
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff80297e0e>] ? 0xffffffff80297e0e
Sep  5 00:20:38 asusUX410U last message buffered 1 times
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff802014fd>] ? 0xffffffff802014fd
Sep  5 00:20:38 asusUX410U kernel:  [<ffffffff80645a3e>] ? 0xffffffff80645a3e
Sep  5 00:20:38 asusUX410U kernel: Code: 65 00 eb 57 41 bc ea ff ff ff 40 f6 c6 01 75 4e 0f b6 05 da 22 75 00 39 f0 72 43 0f b6 05 d6 22 75 00 0f af 05 e9 6d 65 00 31 d2 <f7> b7 7c 01 00 00 44 39 c0 72 28 48 8b 87 00 03 00 00 45 31 e4 
Sep  5 00:20:38 asusUX410U kernel:  RSP <ffffc90003ee38e8>
Sep  5 00:20:38 asusUX410U kernel: ---[ end trace a46f8400460cdde1 ]---



> Can you use 'git bisect' to track down the offending commit?

If I would know how to do that

> And why are you stuck on 4.9.y for these machines?  Why not use 5.10 or
> newer?

Because in 4.10 they dropped lirc-serial and I need that. The new ir-serial
is no replacement. (The last working version of LIRC is 0.9.6. After that
they destroyed transmitter support.)

(I believe irda support got dropped too, which I need for my old nokia.)


Wim.
