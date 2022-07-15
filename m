Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BA35767AE
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 21:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiGOTqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 15:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiGOTqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 15:46:10 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7442713F49;
        Fri, 15 Jul 2022 12:46:07 -0700 (PDT)
Received: from quatroqueijos.. (unknown [177.9.88.15])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 2F4A83F3AB;
        Fri, 15 Jul 2022 19:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1657914363;
        bh=gOoU6lhNd2+UwFEOIILQPZbvvGv83XEaWg2pezutJDQ=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=eLxLt9KSO4h07w9XauIoy7MB7wKXP56vYtoItloGTFcm0B426aQeLSGyCEhrHgsNY
         Mwz4MQGME1EGI0wvAcY0GEk7/Rv+ak1rdhjYmC1vXn/7DZ02G1Q6oGkNXf7feKHgWN
         dXgeQq8xUC0o3jvSuO3PJlLBZU+1I3zKSvmRySRxKwjOATLxy3GHBTFKPptaJqe/a2
         2ackDgK+Fg9iqFF8b+Od8PjszcNXpnK9ApSvLuwnym0iEXSAFEdQq7qv7Y7UFfqwFh
         gZGR6mCbu+6YSvYC7x0BYzX5UA9xubWyx4B95zI3omWSPhHsTuHVlAZMwECA6EkDG2
         7PYwIwH/6qhHg==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     linux-kernel@vger.kernel.org
Cc:     linux-efi@vger.kernel.org, x86@kernel.org, ardb@kernel.org,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        torvalds@linux-foundation.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] efi/x86: use naked RET on mixed mode call wrapper
Date:   Fri, 15 Jul 2022 16:45:50 -0300
Message-Id: <20220715194550.793957-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When running with return thunks enabled under 32-bit EFI, the system
crashes with:

[    0.137688] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[    0.138136] BUG: unable to handle page fault for address: 000000005bc02900
[    0.138136] #PF: supervisor instruction fetch in kernel mode
[    0.138136] #PF: error_code(0x0011) - permissions violation
[    0.138136] PGD 18f7063 P4D 18f7063 PUD 18ff063 PMD 190e063 PTE 800000005bc02063
[    0.138136] Oops: 0011 [#1] PREEMPT SMP PTI
[    0.138136] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.19.0-rc6+ #166
[    0.138136] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[    0.138136] RIP: 0010:0x5bc02900
[    0.138136] Code: Unable to access opcode bytes at RIP 0x5bc028d6.
[    0.138136] RSP: 0018:ffffffffb3203e10 EFLAGS: 00010046
[    0.138136] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000048
[    0.138136] RDX: 000000000190dfac RSI: 0000000000001710 RDI: 000000007eae823b
[    0.138136] RBP: ffffffffb3203e70 R08: 0000000001970000 R09: ffffffffb3203e28
[    0.138136] R10: 747563657865206c R11: 6c6977203a696665 R12: 0000000000001710
[    0.138136] R13: 0000000000000030 R14: 0000000001970000 R15: 0000000000000001
[    0.138136] FS:  0000000000000000(0000) GS:ffff8e013ca00000(0000) knlGS:0000000000000000
[    0.138136] CS:  0010 DS: 0018 ES: 0018 CR0: 0000000080050033
[    0.138136] CR2: 000000005bc02900 CR3: 0000000001930000 CR4: 00000000000006f0
[    0.138136] Call Trace:
[    0.138136]  <TASK>
[    0.138136]  ? efi_set_virtual_address_map+0x9c/0x175
[    0.138136]  efi_enter_virtual_mode+0x4a6/0x53e
[    0.138136]  start_kernel+0x67c/0x71e
[    0.138136]  x86_64_start_reservations+0x24/0x2a
[    0.138136]  x86_64_start_kernel+0xe9/0xf4
[    0.138136]  secondary_startup_64_no_verify+0xe5/0xeb
[    0.138136]  </TASK>

That's because it cannot jump to the return thunk from the 32-bit code.
Using a naked RET and marking it as safe allows the system to proceed
booting.

Fixes: aa3d480315ba ("x86: Use return-thunk in asm code")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: <stable@vger.kernel.org>
---

Does this leave one potential attack vector open? Perhaps, since this is
running under a different mapping (AFAIU), the risk is reduced? Or rather, the
attacker could attack using the firmware RETs anyway?

Alternatively, we could use IBPB when available when using the wrapper.

Thoughts?

---
 arch/x86/platform/efi/efi_thunk_64.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi_thunk_64.S b/arch/x86/platform/efi/efi_thunk_64.S
index 9ffe2bad27d5..4e5257a4811b 100644
--- a/arch/x86/platform/efi/efi_thunk_64.S
+++ b/arch/x86/platform/efi/efi_thunk_64.S
@@ -23,6 +23,7 @@
 #include <linux/objtool.h>
 #include <asm/page_types.h>
 #include <asm/segment.h>
+#include <asm/nospec-branch.h>
 
 	.text
 	.code64
@@ -75,7 +76,9 @@ STACK_FRAME_NON_STANDARD __efi64_thunk
 1:	movq	0x20(%rsp), %rsp
 	pop	%rbx
 	pop	%rbp
-	RET
+	ANNOTATE_UNRET_SAFE
+	ret
+	int3
 
 	.code32
 2:	pushl	$__KERNEL_CS
-- 
2.34.1

