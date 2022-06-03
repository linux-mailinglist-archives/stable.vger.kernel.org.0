Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C8953D033
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346335AbiFCSBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346435AbiFCSAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125B558E55;
        Fri,  3 Jun 2022 10:56:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 863906147E;
        Fri,  3 Jun 2022 17:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760DDC385B8;
        Fri,  3 Jun 2022 17:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278984;
        bh=4s/qfcd7m36IGhRpyGgRTOHB6EW2VRul4AL6adni7zI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8rKOks9ARihWwoIMGzT0Av5nQilYwO0tVw4of3hBJuqqHrsNP8mpcxcrZncuTRrd
         iusKVatUolkK+/ErrjgMjNa6MwybGH0JHVD8eq8TTitYfMkqZHmL6risbqnrHHz0b1
         JPVUvFNhOwZv70X39d9ezSFBrV1uSN9GkinDgPow=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zdenek Kaspar <zkaspar82@gmail.com>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.18 16/67] x86/fpu: KVM: Set the base guest FPU uABI size to sizeof(struct kvm_xsave)
Date:   Fri,  3 Jun 2022 19:43:17 +0200
Message-Id: <20220603173821.199192719@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit d187ba5312307d51818beafaad87d28a7d939adf upstream.

Set the starting uABI size of KVM's guest FPU to 'struct kvm_xsave',
i.e. to KVM's historical uABI size.  When saving FPU state for usersapce,
KVM (well, now the FPU) sets the FP+SSE bits in the XSAVE header even if
the host doesn't support XSAVE.  Setting the XSAVE header allows the VM
to be migrated to a host that does support XSAVE without the new host
having to handle FPU state that may or may not be compatible with XSAVE.

Setting the uABI size to the host's default size results in out-of-bounds
writes (setting the FP+SSE bits) and data corruption (that is thankfully
caught by KASAN) when running on hosts without XSAVE, e.g. on Core2 CPUs.

WARN if the default size is larger than KVM's historical uABI size; all
features that can push the FPU size beyond the historical size must be
opt-in.

  ==================================================================
  BUG: KASAN: slab-out-of-bounds in fpu_copy_uabi_to_guest_fpstate+0x86/0x130
  Read of size 8 at addr ffff888011e33a00 by task qemu-build/681
  CPU: 1 PID: 681 Comm: qemu-build Not tainted 5.18.0-rc5-KASAN-amd64 #1
  Hardware name:  /DG35EC, BIOS ECG3510M.86A.0118.2010.0113.1426 01/13/2010
  Call Trace:
   <TASK>
   dump_stack_lvl+0x34/0x45
   print_report.cold+0x45/0x575
   kasan_report+0x9b/0xd0
   fpu_copy_uabi_to_guest_fpstate+0x86/0x130
   kvm_arch_vcpu_ioctl+0x72a/0x1c50 [kvm]
   kvm_vcpu_ioctl+0x47f/0x7b0 [kvm]
   __x64_sys_ioctl+0x5de/0xc90
   do_syscall_64+0x31/0x50
   entry_SYSCALL_64_after_hwframe+0x44/0xae
   </TASK>
  Allocated by task 0:
  (stack is not available)
  The buggy address belongs to the object at ffff888011e33800
   which belongs to the cache kmalloc-512 of size 512
  The buggy address is located 0 bytes to the right of
   512-byte region [ffff888011e33800, ffff888011e33a00)
  The buggy address belongs to the physical page:
  page:0000000089cd4adb refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x11e30
  head:0000000089cd4adb order:2 compound_mapcount:0 compound_pincount:0
  flags: 0x4000000000010200(slab|head|zone=1)
  raw: 4000000000010200 dead000000000100 dead000000000122 ffff888001041c80
  raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
  page dumped because: kasan: bad access detected
  Memory state around the buggy address:
   ffff888011e33900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   ffff888011e33980: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >ffff888011e33a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                     ^
   ffff888011e33a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
   ffff888011e33b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ==================================================================
  Disabling lock debugging due to kernel taint

Fixes: be50b2065dfa ("kvm: x86: Add support for getting/setting expanded xstate buffer")
Fixes: c60427dd50ba ("x86/fpu: Add uabi_size to guest_fpu")
Reported-by: Zdenek Kaspar <zkaspar82@gmail.com>
Cc: Maciej S. Szmigiero <mail@maciej.szmigiero.name>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Zdenek Kaspar <zkaspar82@gmail.com>
Message-Id: <20220504001219.983513-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/core.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -14,6 +14,8 @@
 #include <asm/traps.h>
 #include <asm/irq_regs.h>
 
+#include <uapi/asm/kvm.h>
+
 #include <linux/hardirq.h>
 #include <linux/pkeys.h>
 #include <linux/vmalloc.h>
@@ -232,7 +234,20 @@ bool fpu_alloc_guest_fpstate(struct fpu_
 	gfpu->fpstate		= fpstate;
 	gfpu->xfeatures		= fpu_user_cfg.default_features;
 	gfpu->perm		= fpu_user_cfg.default_features;
-	gfpu->uabi_size		= fpu_user_cfg.default_size;
+
+	/*
+	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
+	 * to userspace, even when XSAVE is unsupported, so that restoring FPU
+	 * state on a different CPU that does support XSAVE can cleanly load
+	 * the incoming state using its natural XSAVE.  In other words, KVM's
+	 * uABI size may be larger than this host's default size.  Conversely,
+	 * the default size should never be larger than KVM's base uABI size;
+	 * all features that can expand the uABI size must be opt-in.
+	 */
+	gfpu->uabi_size		= sizeof(struct kvm_xsave);
+	if (WARN_ON_ONCE(fpu_user_cfg.default_size > gfpu->uabi_size))
+		gfpu->uabi_size = fpu_user_cfg.default_size;
+
 	fpu_init_guest_permissions(gfpu);
 
 	return true;


