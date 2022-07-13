Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402B6573492
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 12:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbiGMKth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 06:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234640AbiGMKte (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 06:49:34 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C1CF54DF
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 03:49:33 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id sz17so19133032ejc.9
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 03:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=r82sZLPk4860cUIh5NofMI8eXCvpYvER6zpBYWjDvi8=;
        b=cD3YQ5v5QR4R6sm+vZWZd+pybrxu82Usvg9Iuud8NPX6r40CwJrfG+Ksadc16BS2ck
         Nj+8a/64drZr775iIPBSP8ZRY4CORmQryFL6TW6iveXQUGKhJvrZ41eol4ghD2PXlD4v
         a7cQpCLpfXG2kWeBqvQB/AEzkj6WC7l/3PUXtOedpwxmACdDJqzPysJzHdVAqBusMLgQ
         J+gX6t5j4GsxCoXGnUS+a50rLdzy/m6D2oqUC50N0nUFwpsAbxaazeTPSUMk4IiayxP1
         4w35iUN1HOMoVbqnBWvcxhjGoI5NLFBKzf/5duTIjObOzHJyi7Y4w+mV51x09PR9UnqF
         D1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=r82sZLPk4860cUIh5NofMI8eXCvpYvER6zpBYWjDvi8=;
        b=sY1lbUShUge0i7oLD0+O7dwA+DhKg86aMrMlrZ0hS1oqSF+WXbqmzyEyHYHaIcCwFT
         ftIkWNNrW1BNQRSF7bBRA/nrVB7vu71bdl/7Dh9Em42az4s3zInN0OmDy6mJOr0PQouA
         cOhCn6Wb9UxPQurFws+nfg2ZXUZ6YmVDUFyqHW9TMwYQc0t4hfFj+45o74XU2midVtj/
         ZsOoTaX9U/MvowTzhBnuretd4UI3cUPM+PEbCZwYY23N65iGd9B/+puQ1hbmgEEexU/s
         wm/IKMJ3mrvKHhAuZcejhRYx6s+caslizX+fcPfjacDTa77xVMv4UZyLqTrsyG/WFKrT
         cCww==
X-Gm-Message-State: AJIora9cL7jcaQm7iPp+cK4AebX3abJIehbfpbHXJ98NOO+Sj8MHSPzc
        Fh5LB+goHLU8Csb4ukr0vyn6OwBMf9ZvUoSzXNykTdFKm+sIjg==
X-Google-Smtp-Source: AGRyM1uxUH0CEZCFhwLVyxN6YvXL6LlHH1V0EBH9oBv8LDIC0cUpeFGOJkhla3KdZvuib4Ccxa6q6PpaSsnulS42OBA=
X-Received: by 2002:a17:906:9bdd:b0:72b:3cab:eade with SMTP id
 de29-20020a1709069bdd00b0072b3cabeademr2852492ejc.58.1657709371580; Wed, 13
 Jul 2022 03:49:31 -0700 (PDT)
MIME-Version: 1.0
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 13 Jul 2022 12:49:21 +0200
Message-ID: <CAMGffEm9y0wnn8LNS9Qo3obPhs0GD5iJZ0WejFzC4baGPDsYTw@mail.gmail.com>
Subject: 5.10.131-rc1 crash with int3: RIP 0010:xaddw_ax_dx+0x9/0x10 [kvm]
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, all,

When I test with 5.10.131-rc1 with kvm-uint-tests on Intel Broadwell
and Skylake server, it panic also immediately with following call
trace:

[ 1867.769328] APIC base relocation is unsupported by KVM
[ 1895.977424] kvm: emulating exchange as write
[ 1895.979316] int3: 0000 [#1] SMP
[ 1895.979317] CPU: 40 PID: 14811 Comm: qemu-6.1 Kdump: loaded
Tainted: G           O      5.10.131-pserver
#5.10.131-1+feature+linux+5.10.y+20220712.1850+30f4172c~deb11
[ 1895.979317] Hardware name: Supermicro SBI-7228R-T2F2/B10DRT-IBF2,
BIOS 3.0a 03/05/2018
[ 1895.979318] RIP: 0010:xaddw_ax_dx+0x9/0x10 [kvm]
[ 1895.979318] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc
cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc
cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3
cc cc
[ 1895.979319] RSP: 0018:ffffab6e63c6fd30 EFLAGS: 00000202
[ 1895.979320] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
[ 1895.979321] RDX: 0000000076543210 RSI: ffffffffc0f3e4a0 RDI: 0000000000000200
[ 1895.979321] RBP: ffff997c29c214e0 R08: ffff997c29c214e0 R09: 0000000000000002
[ 1895.979321] R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffc0f73540
[ 1895.979322] R13: 0000000000000000 R14: ffff997c29c214e0 R15: 0000000000000000
[ 1895.979322] FS:  00007fc44a5a3700(0000) GS:ffff999a7fc80000(0000)
knlGS:0000000000000000
[ 1895.979322] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1895.979323] CR2: 0000000000000000 CR3: 000000012bf16004 CR4: 00000000003726e0
[ 1895.979324] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1895.979324] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1895.979325] Call Trace:
[ 1895.979325]  ? fastop+0x59/0xa0 [kvm]
[ 1895.979326]  ? x86_emulate_insn+0x73a/0xe00 [kvm]
[ 1895.979326]  ? x86_emulate_instruction+0x2d0/0x750 [kvm]
[ 1895.979326]  ? vmx_vcpu_load+0x21/0x70 [kvm_intel]
[ 1895.979327]  ? complete_emulated_mmio+0x236/0x310 [kvm]
[ 1895.979327]  ? kvm_arch_vcpu_ioctl_run+0x1744/0x1920 [kvm]
[ 1895.979327]  ? kvm_vcpu_ioctl+0x211/0x5a0 [kvm]
[ 1895.979328]  ? __fget_files+0x79/0xb0
[ 1895.979328]  ? __fget_files+0x79/0xb0
[ 1895.979328]  ? __x64_sys_ioctl+0x8b/0xc0
[ 1895.979329]  ? do_syscall_64+0x33/0x40
[ 1895.979329]  ? entry_SYSCALL_64_after_hwframe+0x61/0xc6
[ 1895.979329] Modules linked in: nfnetlink_cttimeout nft_nat
nft_counter nft_chain_nat nft_meta_bridge bridge openvswitch nsh
nf_conncount nf_nat dummy nf_log_ipv6 nf_log_ipv4 nf_log_common
nft_log nft_limit rnbd_client(O) intel_rapl_msr rtrs_client(O)
intel_rapl_common rtrs_core(O) ib_ipoib rdma_ucm rdma_cm iw_cm ib_cm
ib_umad sb_edac x86_pkg_temp_thermal coretemp kvm_intel mlx4_ib nft_ct
kvm nf_conntrack ib_uverbs nf_defrag_ipv6 ib_core nf_defrag_ipv4
irqbypass crc32_pclmul aesni_intel sd_mod libaes t10_pi crypto_simd
crc_t10dif nf_tables crct10dif_generic cryptd glue_helper
crct10dif_pclmul crct10dif_common vhost_net sg rapl intel_cstate
nfnetlink tun(O) ethoip6_pmtud(O) vhost vhost_iotlb ahci tap iTCO_wdt
libahci input_leds mei_me libata iTCO_vendor_support mlx4_core ioatdma
scsi_mod led_class watchdog evdev acpi_ipmi mei ipmi_si 8021q garp stp
mrp llc ipmi_devintf ipmi_msghandler acpi_power_meter acpi_pad button
fuse ip_tables x_tables autofs4 loop raid10 raid456 async_raid6_recov
[ 1895.979349]  async_memcpy async_pq async_xor async_tx xor raid6_pq
libcrc32c raid1 raid0 linear md_mod crc32c_intel igb i2c_i801
i2c_algo_bit i2c_smbus xhci_pci dca lpc_ich ptp i2c_core mfd_core
pps_core xhci_hcd

Is this bug known, any hint how to fix it?

Thanks!
Jinpu Wang @ IONOS
