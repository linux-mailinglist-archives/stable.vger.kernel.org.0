Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8502C446A7B
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 22:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbhKEVVn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 17:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbhKEVVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 17:21:42 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F618C061570
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 14:19:02 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id i6so19452551uae.6
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 14:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=fIaAjXCsWKfp8LL8sut/igPErxzqAxUxI62yV4aN1d4=;
        b=Yv4XkO59/R4ALH4jnb/nexBomKdQhVYPIC1y5q9AyjY6qpeWFVqPSrwzWBS4OSgWKo
         7+amQ9+WvSOYlzfZydDVpEZigkxBRnYbcCxPCK2Rz+BD5py0z9snnubah6Fgd6inqfkK
         IjGSZAtRMLAwMHxATUPxeFCcXGhJSuRWIReBCKGRvxEn73Hb8B1wFIRS33mhAooAFFoy
         0uhCb7QnkvUHSr/UJHnr4KVTljX84AABdf+sA+1Ev3QQdaQEockrLkVD3uaLn8ZLy9lK
         FmhXpJBjnGAsPa08A7L/CuXxtA7BAkXcICrCpCgCA2G4NbZ74IDPs2dcByxFbIHCw1yZ
         qBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=fIaAjXCsWKfp8LL8sut/igPErxzqAxUxI62yV4aN1d4=;
        b=ZErp6wKjsavkIorLo389srjKFXr7nmWGoBFr0yHCheIgbrVRTR9yah4vRCVy6yorL3
         c3nO4dB87jIYRTHx+B+tOuc+173LklfoAASzoh1p5GVU3MayKOKBV/btNeyPmOmJgcKk
         WhJWYEoTPvsy60FKKTDQilsBH+JT5Bhe19N0vbR9OU4Hnl4nJ0sLR7ZwaaS7WBtKEiQZ
         i9sXYaeGosYPhWTFbCni3yzskSJVHm5JL/NPNiWx+WAPkCFLf4MRgyCCjrG3owxglMQC
         cJEzLczrpqwOsBOsyAh2LPBx/OzctnN8IB4wQJL8aYFjRzNs6Djg6shfsoL8UcppW3Pb
         U1gg==
X-Gm-Message-State: AOAM5331Ve8BXaRRtl4I/xTr3asUhpHzuSj98hIr4AW4jt8uPp5rdNoP
        U2+xhg1w74YFWWT8wq1ZJfJQN6sWoDWab+Xaj5g=
X-Google-Smtp-Source: ABdhPJwnPuZGLi5zl/1qKjBmyRePeLZyV3Cp2CgcVprkkEHZf/zBv+yH74/qMNP4Mwmv6WP8A1JZd+6GbC3rbSZ1dyQ=
X-Received: by 2002:a67:1983:: with SMTP id 125mr76741755vsz.31.1636147141709;
 Fri, 05 Nov 2021 14:19:01 -0700 (PDT)
MIME-Version: 1.0
From:   Benjamin Chaney <chaneybenjamini@gmail.com>
Date:   Fri, 5 Nov 2021 17:18:50 -0400
Message-ID: <CAMnhuqRsvOn4zubPb5gQjj4_=FxQZHdccBDk7NxBajsoe3Yffg@mail.gmail.com>
Subject: Regression in 5.10.77: Kernel Oops in amdgpu
To:     christian.koenig@amd.com, ray.huang@amd.com,
        gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,
      I am encountering kernel oops shortly after boot (10-15 minutes)
when running the latest kernel in the 5.10.y series. Git bisect
suggests that c21b4002214c is the commit that introduced the issue.
The machine has a AMD Ryzen 7 4800H processor and a Navi 10 graphics
card. I am happy to provide more information if needed. An excerpt of
syslog containing the panic is included below.
Thank you,
     Ben

Nov  3 19:08:23 bchaney_laptop kernel: BUG: kernel NULL pointer
dereference, address: 0000000000000020
Nov  3 19:08:23 bchaney_laptop kernel: #PF: supervisor read access in
kernel mode
Nov  3 19:08:23 bchaney_laptop kernel: #PF: error_code(0x0000) -
not-present page
Nov  3 19:08:23 bchaney_laptop kernel: PGD 0 P4D 0
Nov  3 19:08:23 bchaney_laptop kernel: Oops: 0000 [#1] SMP NOPTI
Nov  3 19:08:23 bchaney_laptop kernel: CPU: 1 PID: 7127 Comm: X Not
tainted 5.10.77-x86_64 #1
Nov  3 19:08:23 bchaney_laptop kernel: Hardware name: Dell Inc. G5
5505/06WDJ9, BIOS 1.1.1 04/09/2020
Nov  3 19:08:23 bchaney_laptop kernel: RIP:
0010:amdgpu_sa_bo_try_free+0x3e/0x80 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel: Code: 47 20 48 8b 28 4c 39 ed
74 35 48 8b 5d 00 49 39 ed 74 2c 4c 8b 65 30 4d 85 e4 74 23 49 8b 44
24 30 a8 01 75 29 49 8b 44 24 08 <48> 8b 40 20 48 85
c0 74 0c 4c 89 e7 e8 c1 dd 18 cb 84 c0 75 07 5b
Nov  3 19:08:23 bchaney_laptop kernel: RSP: 0018:ffffb4e00196f8b0
EFLAGS: 00010246
Nov  3 19:08:23 bchaney_laptop kernel: RAX: 0000000000000000 RBX:
ffff9fae4a09e040 RCX: 0000000080400031
Nov  3 19:08:23 bchaney_laptop kernel: RDX: 0000000080400032 RSI:
0000000080400031 RDI: ffff9fae40043b00
Nov  3 19:08:23 bchaney_laptop kernel: RBP: ffff9fae4a09ef00 R08:
0000000000000001 R09: 0000000000000000
Nov  3 19:08:23 bchaney_laptop kernel: R10: ffff9fae4a09ea00 R11:
0000000000000001 R12: ffff9fb096c1eac0
Nov  3 19:08:23 bchaney_laptop kernel: R13: ffff9fae52946228 R14:
ffff9fae52946000 R15: ffff9fae7c67e438
Nov  3 19:08:23 bchaney_laptop kernel: FS:  00007fd79acfd8c0(0000)
GS:ffff9fb13f440000(0000) knlGS:0000000000000000
Nov  3 19:08:23 bchaney_laptop kernel: CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
Nov  3 19:08:23 bchaney_laptop kernel: CR2: 0000000000000020 CR3:
000000012857e000 CR4: 0000000000350ee0
Nov  3 19:08:23 bchaney_laptop kernel: Call Trace:
Nov  3 19:08:23 bchaney_laptop kernel:  amdgpu_sa_bo_new+0xd7/0x530 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel:  ? amdgpu_sa_bo_new+0x6b/0x530 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel:  ? kmem_cache_alloc_trace+0xff/0x210
Nov  3 19:08:23 bchaney_laptop kernel:  ? ___slab_alloc+0x149/0x5d0
Nov  3 19:08:23 bchaney_laptop kernel:  ? amdgpu_job_alloc+0x37/0xc0 [amdgpu]
Nov  3 19:08:23 bchaney_laptop last message buffered 1 times
Nov  3 19:08:23 bchaney_laptop kernel:  ? __kmalloc+0x11b/0x260
Nov  3 19:08:23 bchaney_laptop kernel:  amdgpu_ib_get+0x3b/0x90 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel:
amdgpu_job_alloc_with_ib+0x53/0x80 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel:
amdgpu_vm_sdma_prepare+0x28/0x60 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel:
amdgpu_vm_bo_update_mapping.constprop.0+0x156/0x230 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel:  ? ttm_bo_add_mem_to_lru+0x75/0x100 [ttm]
Nov  3 19:08:23 bchaney_laptop kernel:  amdgpu_vm_bo_update+0x2b0/0x6e0 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel:  amdgpu_gem_va_ioctl+0x58d/0x5c0 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel:  ?
amdgpu_gem_va_map_flags+0x70/0x70 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel:  drm_ioctl_kernel+0xaa/0xf0 [drm]
Nov  3 19:08:23 bchaney_laptop kernel:  drm_ioctl+0x220/0x3e0 [drm]
Nov  3 19:08:23 bchaney_laptop kernel:  ?
amdgpu_gem_va_map_flags+0x70/0x70 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel:  ? selinux_file_ioctl+0x144/0x250
Nov  3 19:08:23 bchaney_laptop kernel:  amdgpu_drm_ioctl+0x49/0x80 [amdgpu]
Nov  3 19:08:23 bchaney_laptop kernel:  __x64_sys_ioctl+0x82/0xb0
Nov  3 19:08:23 bchaney_laptop kernel:  do_syscall_64+0x33/0x80
Nov  3 19:08:23 bchaney_laptop kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov  3 19:08:23 bchaney_laptop kernel: RIP: 0033:0x7fd79b2a67b7
Nov  3 19:08:23 bchaney_laptop kernel: Code: 3c 1c e8 2c ff ff ff 85
c0 79 97 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00
00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d
89 66 0c 00 f7 d8 64 89 01 48
Nov  3 19:08:23 bchaney_laptop kernel: RSP: 002b:00007ffc84a519c8
EFLAGS: 00000246 ORIG_RAX: 0000000000000010
Nov  3 19:08:23 bchaney_laptop kernel: RAX: ffffffffffffffda RBX:
00007ffc84a51a10 RCX: 00007fd79b2a67b7
Nov  3 19:08:23 bchaney_laptop kernel: RDX: 00007ffc84a51a10 RSI:
00000000c0286448 RDI: 000000000000000d
Nov  3 19:08:23 bchaney_laptop kernel: RBP: 00000000c0286448 R08:
ffff800105e00000 R09: 000000000000000e
Nov  3 19:08:23 bchaney_laptop kernel: R10: 00007fd79b36dba0 R11:
0000000000000246 R12: 000055ae0026e220
Nov  3 19:08:23 bchaney_laptop kernel: R13: 000000000000000d R14:
0000000000200000 R15: 0000000000880000
Nov  3 19:08:23 bchaney_laptop kernel: Modules linked in: tun 8021q
garp mrp stp llc ccm ipv6 crc_ccitt dm_crypt btusb btrtl btbcm btintel
bluetooth ecdh_generic ecc uvcvideo videobuf2_vmallo
c videobuf2_memops videobuf2_v4l2 videobuf2_common videodev mc
hid_multitouch dell_laptop dell_wmi dell_smbios dcdbas alienware_wmi
wmi_bmof sparse_keymap dell_wmi_descriptor dm_mod edac_mce_
amd snd_hda_codec_realtek snd_hda_codec_generic iwlmvm kvm_amd
ledtrig_audio snd_hda_codec_hdmi amdgpu mac80211 snd_hda_intel i2c_hid
kvm snd_intel_dspcfg soundwire_intel soundwire_generic_al
location irqbypass crct10dif_pclmul libarc4 ghash_clmulni_intel
snd_soc_core rapl snd_compress snd_pcm_dmaengine mfd_core
soundwire_cadence iommu_v2 gpu_sched snd_hda_codec iwlwifi joydev i2c
_algo_bit snd_hda_core pcspkr ttm ac97_bus efi_pstore k10temp
serio_raw snd_hwdep soundwire_bus drm_kms_helper snd_pcm cec rc_core
snd_timer cfg80211 snd drm soundcore snd_pci_acp3x ccp sp510
0_tco i2c_piix4 ucsi_acpi typec_ucsi typec wmi mac_hid
Nov  3 19:08:23 bchaney_laptop kernel:  i2c_designware_platform video
i2c_designware_core backlight dell_rbtn i2c_core rfkill pinctrl_amd
acpi_tad acpi_cpufreq efivarfs ext4 mbcache jbd2 crc3
2_pclmul crc32c_intel r8169 xhci_pci realtek nvme xhci_pci_renesas
ahci mdio_devres nvme_core libahci xhci_hcd libphy t10_pi
Nov  3 19:08:23 bchaney_laptop kernel: CR2: 0000000000000020
Nov  3 19:08:23 bchaney_laptop kernel: ---[ end trace 08ee0b6e6629fdaa ]---
Nov  3 19:08:24 bchaney_laptop kernel: RIP:
0010:amdgpu_sa_bo_try_free+0x3e/0x80 [amdgpu]
Nov  3 19:08:24 bchaney_laptop kernel: Code: 47 20 48 8b 28 4c 39 ed
74 35 48 8b 5d 00 49 39 ed 74 2c 4c 8b 65 30 4d 85 e4 74 23 49 8b 44
24 30 a8 01 75 29 49 8b 44 24 08 <48> 8b 40 20 48 85
c0 74 0c 4c 89 e7 e8 c1 dd 18 cb 84 c0 75 07 5b
Nov  3 19:08:24 bchaney_laptop kernel: RSP: 0018:ffffb4e00196f8b0
EFLAGS: 00010246
Nov  3 19:08:24 bchaney_laptop kernel: RAX: 0000000000000000 RBX:
ffff9fae4a09e040 RCX: 0000000080400031
Nov  3 19:08:24 bchaney_laptop kernel: RDX: 0000000080400032 RSI:
0000000080400031 RDI: ffff9fae40043b00
Nov  3 19:08:24 bchaney_laptop kernel: RBP: ffff9fae4a09ef00 R08:
0000000000000001 R09: 0000000000000000
Nov  3 19:08:24 bchaney_laptop kernel: R10: ffff9fae4a09ea00 R11:
0000000000000001 R12: ffff9fb096c1eac0
Nov  3 19:08:24 bchaney_laptop kernel: R13: ffff9fae52946228 R14:
ffff9fae52946000 R15: ffff9fae7c67e438
Nov  3 19:08:24 bchaney_laptop kernel: FS:  00007fd79acfd8c0(0000)
GS:ffff9fb13f440000(0000) knlGS:0000000000000000
Nov  3 19:08:24 bchaney_laptop kernel: CS:  0010 DS: 0000 ES: 0000
CR0: 0000000080050033
Nov  3 19:08:24 bchaney_laptop kernel: CR2: 0000000000000020 CR3:
000000012857e000 CR4: 0000000000350ee0
Nov  3 19:08:39 bchaney_laptop shutdown[18919]: shutting down for system halt
