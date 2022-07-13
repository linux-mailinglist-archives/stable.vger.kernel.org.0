Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCDCD573BCD
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 19:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiGMRM7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 13:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236345AbiGMRMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 13:12:55 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A832F65D;
        Wed, 13 Jul 2022 10:12:54 -0700 (PDT)
Received: from quatroqueijos.. (unknown [179.93.156.216])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id DFC1F3F385;
        Wed, 13 Jul 2022 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1657732371;
        bh=6aF1y0Ps5+U+iZkdLgqjZ0So6bSc3NpmqBAxYJ6qaDw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=sziUqM0rjOh/i9YN9farNvi+GPG9RKU28waqTJuTWt+OFVXETq0nBWuv9/a8z+lWN
         20Sinc9ZOC0Og7CslZ8CYfLGUQn7SykDpm/i8MyK8eytZo/hSQRVIf+nZbaLzJ7p9w
         IBViHk96y0l35Wp4M1uQNLqsIOa/flijnn4z5whYNWxld9WWubyMPGTGMwozbRbFv5
         jGdYg2Ic5u274UfGIv9xZeg1WYYeHJ1WiiCoqAObkhNZ5X0KdCjT8xS1c/9X3dbso4
         0uC55nUSt/voSKdfKvhh/a2Dh1KEN/vclxNX4hLpLam6vlsQjTYJ41eR9uTuQ5ObzU
         Yf0QBnbcTN9xQ==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH] x86/kvm: fix FASTOP_SIZE when return thunks are enabled
Date:   Wed, 13 Jul 2022 14:12:41 -0300
Message-Id: <20220713171241.184026-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The return thunk call makes the fastop functions larger, just like IBT
does. Consider a 16-byte FASTOP_SIZE when CONFIG_RETHUNK is enabled.

Otherwise, functions will be incorrectly aligned and when computing their
position for differently sized operators, they will executed in the middle
or end of a function, which may as well be an int3, leading to a crash
like:

[   36.091116] int3: 0000 [#1] SMP NOPTI
[   36.091119] CPU: 3 PID: 1371 Comm: qemu-system-x86 Not tainted 5.15.0-41-generic #44
[   36.091120] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
[   36.091121] RIP: 0010:xaddw_ax_dx+0x9/0x10 [kvm]
[   36.091185] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3 cc cc
[   36.091186] RSP: 0018:ffffb1f541143c98 EFLAGS: 00000202
[   36.091188] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
[   36.091188] RDX: 0000000076543210 RSI: ffffffffc073c6d0 RDI: 0000000000000200
[   36.091189] RBP: ffffb1f541143ca0 R08: ffff9f1803350a70 R09: 0000000000000002
[   36.091190] R10: ffff9f1803350a70 R11: 0000000000000000 R12: ffff9f1803350a70
[   36.091190] R13: ffffffffc077fee0 R14: 0000000000000000 R15: 0000000000000000
[   36.091191] FS:  00007efdfce8d640(0000) GS:ffff9f187dd80000(0000) knlGS:0000000000000000
[   36.091192] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.091192] CR2: 0000000000000000 CR3: 0000000009b62002 CR4: 0000000000772ee0
[   36.091195] PKRU: 55555554
[   36.091195] Call Trace:
[   36.091197]  <TASK>
[   36.091198]  ? fastop+0x5a/0xa0 [kvm]
[   36.091222]  x86_emulate_insn+0x7b8/0xe90 [kvm]
[   36.091244]  x86_emulate_instruction+0x2f4/0x630 [kvm]
[   36.091263]  ? kvm_arch_vcpu_load+0x7c/0x230 [kvm]
[   36.091283]  ? vmx_prepare_switch_to_host+0xf7/0x190 [kvm_intel]
[   36.091290]  complete_emulated_mmio+0x297/0x320 [kvm]
[   36.091310]  kvm_arch_vcpu_ioctl_run+0x32f/0x550 [kvm]
[   36.091330]  kvm_vcpu_ioctl+0x29e/0x6d0 [kvm]
[   36.091344]  ? kvm_vcpu_ioctl+0x120/0x6d0 [kvm]
[   36.091357]  ? __fget_files+0x86/0xc0
[   36.091362]  ? __fget_files+0x86/0xc0
[   36.091363]  __x64_sys_ioctl+0x92/0xd0
[   36.091366]  do_syscall_64+0x59/0xc0
[   36.091369]  ? syscall_exit_to_user_mode+0x27/0x50
[   36.091370]  ? do_syscall_64+0x69/0xc0
[   36.091371]  ? syscall_exit_to_user_mode+0x27/0x50
[   36.091372]  ? __x64_sys_writev+0x1c/0x30
[   36.091374]  ? do_syscall_64+0x69/0xc0
[   36.091374]  ? exit_to_user_mode_prepare+0x37/0xb0
[   36.091378]  ? syscall_exit_to_user_mode+0x27/0x50
[   36.091379]  ? do_syscall_64+0x69/0xc0
[   36.091379]  ? do_syscall_64+0x69/0xc0
[   36.091380]  ? do_syscall_64+0x69/0xc0
[   36.091381]  ? do_syscall_64+0x69/0xc0
[   36.091381]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[   36.091384] RIP: 0033:0x7efdfe6d1aff
[   36.091390] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <41> 89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25 28 00
[   36.091391] RSP: 002b:00007efdfce8c460 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   36.091393] RAX: ffffffffffffffda RBX: 000000000000ae80 RCX: 00007efdfe6d1aff
[   36.091393] RDX: 0000000000000000 RSI: 000000000000ae80 RDI: 000000000000000c
[   36.091394] RBP: 0000558f1609e220 R08: 0000558f13fb8190 R09: 00000000ffffffff
[   36.091394] R10: 0000558f16b5e950 R11: 0000000000000246 R12: 0000000000000000
[   36.091394] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[   36.091396]  </TASK>
[   36.091397] Modules linked in: isofs nls_iso8859_1 kvm_intel joydev kvm input_leds serio_raw sch_fq_codel dm_multipath scsi_dh_rdac scsi_dh_emc scsi_dh_alua ipmi_devintf ipmi_msghandler drm msr ip_tables x_tables autofs4 btrfs blake2b_generic zstd_compress raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath linear crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel virtio_net net_failover crypto_simd ahci xhci_pci cryptd psmouse virtio_blk libahci xhci_pci_renesas failover
[   36.123271] ---[ end trace db3c0ab5a48fabcc ]---
[   36.123272] RIP: 0010:xaddw_ax_dx+0x9/0x10 [kvm]
[   36.123319] Code: 00 0f bb d0 c3 cc cc cc cc 48 0f bb d0 c3 cc cc cc cc 0f 1f 80 00 00 00 00 0f c0 d0 c3 cc cc cc cc 66 0f c1 d0 c3 cc cc cc cc <0f> 1f 80 00 00 00 00 0f c1 d0 c3 cc cc cc cc 48 0f c1 d0 c3 cc cc
[   36.123320] RSP: 0018:ffffb1f541143c98 EFLAGS: 00000202
[   36.123321] RAX: 0000000089abcdef RBX: 0000000000000001 RCX: 0000000000000000
[   36.123321] RDX: 0000000076543210 RSI: ffffffffc073c6d0 RDI: 0000000000000200
[   36.123322] RBP: ffffb1f541143ca0 R08: ffff9f1803350a70 R09: 0000000000000002
[   36.123322] R10: ffff9f1803350a70 R11: 0000000000000000 R12: ffff9f1803350a70
[   36.123323] R13: ffffffffc077fee0 R14: 0000000000000000 R15: 0000000000000000
[   36.123323] FS:  00007efdfce8d640(0000) GS:ffff9f187dd80000(0000) knlGS:0000000000000000
[   36.123324] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.123325] CR2: 0000000000000000 CR3: 0000000009b62002 CR4: 0000000000772ee0
[   36.123327] PKRU: 55555554
[   36.123328] Kernel panic - not syncing: Fatal exception in interrupt
[   36.123410] Kernel Offset: 0x1400000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   36.135305] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Fixes: aa3d480315ba ("x86: Use return-thunk in asm code")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index db96bf7d1122..d779eea1052e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -190,7 +190,7 @@
 #define X16(x...) X8(x), X8(x)
 
 #define NR_FASTOP (ilog2(sizeof(ulong)) + 1)
-#define FASTOP_SIZE (8 * (1 + HAS_KERNEL_IBT))
+#define FASTOP_SIZE (8 * (1 + (HAS_KERNEL_IBT | IS_ENABLED(CONFIG_RETHUNK))))
 
 struct opcode {
 	u64 flags;
-- 
2.34.1

