Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E55616BFF22
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 03:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCSCs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 22:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjCSCsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 22:48:25 -0400
Received: from mail.manjaro.org (mail.manjaro.org [116.203.91.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9940511E9C
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 19:48:22 -0700 (PDT)
Message-ID: <8a1bbe56-4463-d18d-d5a9-d249171a569d@manjaro.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=2021;
        t=1679194100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9njCKGyyQmc3+WiFweipJaJN1P25jjSgCTki7yOXZo4=;
        b=y6PXtsixBFWZp2TN+umsSTMqS//AUt5gRvrzxWvXnqMC/2m0/gigKXmMpfewIrV3MOxUXl
        2Zqp6a5KtAcd4n8yyRp91SdLR8swca0x5WE2xNZf9ZfApHWpGUTngvxnTPwUN+Ikpihjx8
        TWyjAvmX1G5vg7LbLlCU8c/kBtFUYdS8Loh5eUqYpE5Kap59UwTzwXnY8AC3UOVBkwnCOT
        H8RSTiM6uSJIG2WKRtUyWQihOo1k9awBtOyCChkhR7ZgkCo7pU/I1JBVg7TCPq7BcUSByn
        2yI+6ZDg8eVtxo07sZHJA/LI091AmKl2zwObfagoew000vvo7RNJhTDJAn//Bw==
Date:   Sun, 19 Mar 2023 09:48:13 +0700
MIME-Version: 1.0
Content-Language: en-US
To:     John Harrison <John.C.Harrison@Intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable@vger.kernel.org
From:   =?UTF-8?Q?Philip_M=c3=bcller?= <philm@manjaro.org>
Subject: [Regression] drm/i915: Don't use BAR mappings for ring buffers with
 LLC alone creates issues in stable kernels
Organization: Manjaro Community
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=philm@manjaro.org smtp.mailfrom=philm@manjaro.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi there,

similar to the last patch breaking i915 in stable kernels now also this 
patch creates unbootable systems on Intel GFX:

"kernel: [drm:drm_mode_config_cleanup.cold [drm]] *ERROR* connector DP-3 
leaked!"

mrt 18 16:01:23 imac kernel: WARN_ON(({ void *__mptr = (void *)(state); 
do { extern void __compiletime_assert_262(void) 
__attribute__((error("pointer type mismatch in container_of()"))); if 
(!(!(!__builtin_types_compatible_p(typeof(*(state)), typeof(((>
mrt 18 16:01:23 imac kernel: WARNING: CPU: 0 PID: 153 at 
drivers/gpu/drm/i915/intel_atomic_plane.c:105 
intel_plane_destroy_state+0x37/0x50 [i915]
mrt 18 16:01:23 imac kernel: Modules linked in: i915(+) kvmgt vfio_mdev 
sd_mod mdev vfio_iommu_type1 vfio kvm irqbypass intel_gtt i2c_algo_bit 
ahci drm_kms_helper libahci syscopyarea sdhci_pci libata xhci_pci cqhci 
sysfillrect sysimgblt fb_sys_fops xhc>
mrt 18 16:01:23 imac kernel: CPU: 0 PID: 153 Comm: (udev-worker) 
Tainted: G        W         4.19.278-1-MANJARO #1
mrt 18 16:01:23 imac kernel: Hardware name: Apple Inc. 
iMac16,2/Mac-FFE5EF870D7BA81A, BIOS 428.60.3.0.0 10/27/2021
mrt 18 16:01:23 imac kernel: RIP: 
0010:intel_plane_destroy_state+0x37/0x50 [i915]
mrt 18 16:01:23 imac kernel: Code: 90 00 00 00 00 48 89 f3 75 0d 48 89 
de 48 89 ef 5b 5d e9 ac 6c e3 ff 48 c7 c6 28 38 7b c0 48 c7 c7 11 f1 79 
c0 e8 4e d3 57 e3 <0f> 0b 48 89 de 48 89 ef 5b 5d e9 8a 6c e3 ff 66 2e 
0f 1f 84 00 00
mrt 18 16:01:23 imac kernel: RSP: 0018:ffffb0d0011bbb38 EFLAGS: 00010282
mrt 18 16:01:23 imac kernel: RAX: 0000000000000000 RBX: ffffa0ad21eba600 
RCX: 0000000000000000
mrt 18 16:01:23 imac kernel: RDX: 00000000000001d7 RSI: ffffffffa4ceb497 
RDI: 0000000000000246
mrt 18 16:01:23 imac kernel: RBP: ffffa0ad21490400 R08: 0000000000000002 
R09: ffffffffa4ceb2bf
mrt 18 16:01:23 imac kernel: R10: 0000000000000001 R11: 0000000000000000 
R12: ffffa0ad21b38000
mrt 18 16:01:23 imac kernel: R13: ffffa0ad21b3c9e8 R14: 00000000fffffffa 
R15: ffffa0ad24e05000
mrt 18 16:01:23 imac kernel: FS:  00007f86e003b080(0000) 
GS:ffffa0ad26a00000(0000) knlGS:0000000000000000
mrt 18 16:01:23 imac kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
mrt 18 16:01:23 imac kernel: CR2: 00007f8026f80000 CR3: 000000026193a002 
CR4: 00000000003606f0
mrt 18 16:01:23 imac kernel: DR0: 0000000000000000 DR1: 0000000000000000 
DR2: 0000000000000000
mrt 18 16:01:23 imac kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 
DR7: 0000000000000400
mrt 18 16:01:23 imac kernel: Call Trace:
mrt 18 16:01:23 imac kernel:  drm_plane_cleanup+0xad/0xf0 [drm]
mrt 18 16:01:23 imac kernel:  intel_plane_destroy+0xe/0x20 [i915]
mrt 18 16:01:23 imac kernel:  drm_mode_config_cleanup+0x104/0x280 [drm]
mrt 18 16:01:23 imac kernel:  intel_modeset_cleanup+0xbc/0x130 [i915]
mrt 18 16:01:23 imac kernel:  i915_driver_load+0xbad/0xdc0 [i915]
mrt 18 16:01:23 imac kernel:  ? acpi_dev_found+0x5f/0x70
mrt 18 16:01:23 imac kernel:  local_pci_probe+0x3e/0x80
mrt 18 16:01:23 imac kernel:  pci_device_probe+0x102/0x1a0
mrt 18 16:01:23 imac kernel:  really_probe+0x245/0x3c0
mrt 18 16:01:23 imac kernel:  driver_probe_device+0xb3/0xf0
mrt 18 16:01:23 imac kernel:  __driver_attach+0x104/0x110
mrt 18 16:01:23 imac kernel:  ? driver_probe_device+0xf0/0xf0
mrt 18 16:01:23 imac kernel:  bus_for_each_dev+0x71/0xb0
mrt 18 16:01:23 imac kernel:  bus_add_driver+0x16a/0x220
mrt 18 16:01:23 imac kernel:  driver_register+0x89/0xd0
mrt 18 16:01:23 imac kernel:  ? 0xffffffffc0871000
mrt 18 16:01:23 imac kernel:  do_one_initcall+0x46/0x1d0
mrt 18 16:01:23 imac kernel:  ? kmem_cache_alloc_trace+0x2f/0x1b0
mrt 18 16:01:23 imac kernel:  do_init_module+0x4c/0x260
mrt 18 16:01:23 imac kernel:  __se_sys_finit_module+0xb1/0x110
mrt 18 16:01:23 imac kernel:  do_syscall_64+0x4e/0x110
mrt 18 16:01:23 imac kernel:  entry_SYSCALL_64_after_hwframe+0x5c/0xc1
mrt 18 16:01:23 imac kernel: RIP: 0033:0x7f86e0b660dd
mrt 18 16:01:23 imac kernel: Code: 5d c3 66 2e 0f 1f 84 00 00 00 00 00 
90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 
8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 63 7c 0d 00 f7 
d8 64 89 01 48
mrt 18 16:01:23 imac kernel: RSP: 002b:00007fff34b17fc8 EFLAGS: 00000246 
ORIG_RAX: 0000000000000139
mrt 18 16:01:23 imac kernel: RAX: ffffffffffffffda RBX: 00005566daeded40 
RCX: 00007f86e0b660dd
mrt 18 16:01:23 imac kernel: RDX: 0000000000000000 RSI: 00007f86e0cb9343 
RDI: 000000000000001b
mrt 18 16:01:23 imac kernel: RBP: 00007f86e0cb9343 R08: 0000000000000000 
R09: 0000000000000000
mrt 18 16:01:23 imac kernel: R10: 000000000000001b R11: 0000000000000246 
R12: 0000000000020000
mrt 18 16:01:23 imac kernel: R13: 00005566daece520 R14: 00005566daeded40 
R15: 00005566daee28f0
mrt 18 16:01:23 imac kernel: ---[ end trace 07e565c61a1cf4c3 ]---

We have again a full house of broken stable kernels, as this patch got 
applied to the following releases: 4.14.310, 4.19.278, 5.4.237, 
5.10.175, 5.15.103, 6.1.20, 6.2.7

It wouild be good to check which patch-set is needed to get the issue 
tried to been fixed here solved and re-apply them in a working set to 
stable kernel series next time, instead of let them trickerling down the 
stream one-by-one and constantly break i915 driver due this.

A revert of the named patch fixed the "regression".


-- 
Best, Philip
