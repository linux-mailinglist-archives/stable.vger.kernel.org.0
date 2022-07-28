Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49845583ECF
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 14:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237432AbiG1M06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 08:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236466AbiG1M05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 08:26:57 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B509C624A6;
        Thu, 28 Jul 2022 05:26:55 -0700 (PDT)
Received: from localhost.localdomain (1.general.cascardo.us.vpn [10.172.70.58])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 2F79B3F3D6;
        Thu, 28 Jul 2022 12:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1659011213;
        bh=3YguuAB/X8ckcd+04VYa5sKPEcurgJW87IzZTHhsAT0=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=ugYP8PLwshERy+tN+kgqCV4lvDM/JmvZol1LSHjlnDGzPlWlH3O2BhA5xX9M1Vk3Z
         yFJ7C10bUymlSILBwHcSq4md/ErZQHAoABTEaCBGJc8yh7yS9zUBmh100eCEtveNHo
         Uimp4w8Sl1zne5nBy9m3/kHhHgUOKzyevrTx4Gz+F9EcEkQX6PKfDZJke5PgszAIkm
         gZag/XcRfE4g2i7we7nVbdsno+DW2uf6YnYT8txECq494xAD9t4ePS4gSO3h9SIF39
         PsOSUy9NDNTYh32bb0eVv1W8DlClWijqfkhbS3CqXo9xbu1xOVxqjviVlKTooSdwe/
         tNjgmgac1eNpA==
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     linux-kernel@vger.kernel.org
Cc:     x86@kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org
Subject: [PATCH] x86/bugs: Do not enable IBPB at firmware entry when IBPB is not available
Date:   Thu, 28 Jul 2022 09:26:02 -0300
Message-Id: <20220728122602.2500509-1-cascardo@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some cloud hypervisors do not provide IBPB on very recent CPU processors,
including AMD processors affected by Retbleed.

Using IBPB before firmware calls on such systems would cause a GPF at boot
like the one below. Do not enable such calls when IBPB support is not
present.

[    0.997530] EFI Variables Facility v0.08 2004-May-17
[    0.998866] general protection fault, maybe for address 0x1: 0000 [#1] PREEMPT SMP NOPTI
[    1.000393] CPU: 0 PID: 24 Comm: kworker/u2:1 Not tainted 5.19.0-rc8+ #7
[    1.000393] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[    1.000393] Workqueue: efi_rts_wq efi_call_rts
[    1.000393] RIP: 0010:efi_call_rts+0x66e/0x8a0
[    1.000393] Code: e8 37 33 58 ff 41 bf 48 00 00 00 49 89 c0 44 89 f9 48 83 c8 01 4c 89 c2 48 c1 ea 20 66 90 b9 49 00 00 00 b8 01 00 00 00 31 d2 <0f> 30 e8 7b 9f 5d ff e8 f6 f8 ff ff 4c 89 f1 4c 89 ea 4c 89 e6 48
[    1.000393] RSP: 0018:ffffb373800d7e38 EFLAGS: 00010246
[    1.000393] RAX: 0000000000000001 RBX: 0000000000000006 RCX: 0000000000000049
[    1.000393] RDX: 0000000000000000 RSI: ffff94fbc19d8fe0 RDI: ffff94fbc1b2b300
[    1.000393] RBP: ffffb373800d7e70 R08: 0000000000000000 R09: 0000000000000000
[    1.000393] R10: 000000000000000b R11: 000000000000000b R12: ffffb3738001fd78
[    1.000393] R13: ffff94fbc2fcfc00 R14: ffffb3738001fd80 R15: 0000000000000048
[    1.000393] FS:  0000000000000000(0000) GS:ffff94fc3da00000(0000) knlGS:0000000000000000
[    1.000393] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.000393] CR2: ffff94fc30201000 CR3: 000000006f610000 CR4: 00000000000406f0
[    1.000393] Call Trace:
[    1.000393]  <TASK>
[    1.000393]  ? __wake_up+0x13/0x20
[    1.000393]  process_one_work+0x21f/0x3f0
[    1.000393]  worker_thread+0x50/0x3e0
[    1.000393]  ? rescuer_thread+0x3a0/0x3a0
[    1.000393]  kthread+0xee/0x120
[    1.000393]  ? kthread_complete_and_exit+0x20/0x20
[    1.000393]  ret_from_fork+0x22/0x30
[    1.000393]  </TASK>
[    1.000393] Modules linked in:
[    1.037117] ---[ end trace 0000000000000000 ]---
[    1.038324] RIP: 0010:efi_call_rts+0x66e/0x8a0
[    1.039650] Code: e8 37 33 58 ff 41 bf 48 00 00 00 49 89 c0 44 89 f9 48 83 c8 01 4c 89 c2 48 c1 ea 20 66 90 b9 49 00 00 00 b8 01 00 00 00 31 d2 <0f> 30 e8 7b 9f 5d ff e8 f6 f8 ff ff 4c 89 f1 4c 89 ea 4c 89 e6 48
[    1.044235] RSP: 0018:ffffb373800d7e38 EFLAGS: 00010246
[    1.045513] RAX: 0000000000000001 RBX: 0000000000000006 RCX: 0000000000000049
[    1.047260] RDX: 0000000000000000 RSI: ffff94fbc19d8fe0 RDI: ffff94fbc1b2b300
[    1.049014] RBP: ffffb373800d7e70 R08: 0000000000000000 R09: 0000000000000000
[    1.050762] R10: 000000000000000b R11: 000000000000000b R12: ffffb3738001fd78
[    1.052521] R13: ffff94fbc2fcfc00 R14: ffffb3738001fd80 R15: 0000000000000048
[    1.054243] FS:  0000000000000000(0000) GS:ffff94fc3da00000(0000) knlGS:0000000000000000
[    1.056228] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.057632] CR2: ffff94fc30201000 CR3: 000000006f610000 CR4: 00000000000406f0
[    1.059393] note: kworker/u2:1[24] exited with preempt_count 2

Fixes: 28a99e95f55c ("x86/amd: Use IBPB for firmware calls")
Reported-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6454bc767f0f..6761668100b9 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1520,6 +1520,7 @@ static void __init spectre_v2_select_mitigation(void)
 	 * enable IBRS around firmware calls.
 	 */
 	if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+	    boot_cpu_has(X86_FEATURE_IBPB) &&
 	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
 	     boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)) {
 
-- 
2.34.1

