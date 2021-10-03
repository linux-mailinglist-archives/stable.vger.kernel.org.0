Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED5A420450
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 00:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhJCWgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 18:36:38 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:37372 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231778AbhJCWgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Oct 2021 18:36:38 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 193FvtIf025125;
        Sun, 3 Oct 2021 22:34:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2021-07-09; bh=9/bmkIjzduZXiB+7RoX+2SgnLr3nnvi8diAzfkXMQHw=;
 b=CVTmh6OMz21tnvsLAW4tuwtzoM79PpGAHvyl6pGYUTBwI46ulwozXUrydTQNLds5u+My
 Pms3wNcs+oeWn6GKEtWUtqi/Kdc07KHOTPaeGqLXwiMDi9li5a+be2ccc7/cBtwdweeQ
 rK5YrsYRb+Ijg6jRPIWLNBiy9+NsmvIr+NKivxXO7E7AbH0Fr4tLGnLmJgRIzd6ZiK4h
 5pDDKyYvjHpcqH2eVIj3vPDC2hJsc08p/UvNVseTNzwVGObcEfleJVztpqWZFqB65Q7m
 J3JnQJpnHRBi5LAxdrPA54GaNwgZbmS5fyDaAS9z2ramwCy2jNpca6BePawQeQ0Y7+N0 CA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bfabhrya3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 03 Oct 2021 22:34:30 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 193MUD27073415;
        Sun, 3 Oct 2021 22:34:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3bev8ue3v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sun, 03 Oct 2021 22:34:30 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 193MYTKa079611;
        Sun, 3 Oct 2021 22:34:29 GMT
Received: from t460.home (dhcp-10-175-60-72.vpn.oracle.com [10.175.60.72])
        by aserp3020.oracle.com with ESMTP id 3bev8ue3us-1;
        Sun, 03 Oct 2021 22:34:29 +0000
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] x86/entry: fix AC assertion when !CONFIG_X86_SMAP
Date:   Mon,  4 Oct 2021 00:34:23 +0200
Message-Id: <20211003223423.8666-1-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.23.0.718.g5ad94255a8
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: UGvhJWtm3cinUVPML5n3fCqrHKJGQ7uF
X-Proofpoint-ORIG-GUID: UGvhJWtm3cinUVPML5n3fCqrHKJGQ7uF
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 3c73b81a9164 ("x86/entry, selftests: Further improve user entry
sanity checks") added a warning if AC is set when in the kernel.

Commit 662a0221893a3d ("x86/entry: Fix AC assertion") changed the warning
to only fire if the CPU supports SMAP.

However, the warning can still trigger on a machine that supports SMAP but
where it's disabled in the kernel config:

    [   T49] ------------[ cut here ]------------
    [   T49] WARNING: CPU: 0 PID: 49 at irqentry_enter_from_user_mode+0x88/0xc0
    [   T49] CPU: 0 PID: 49 Comm: init Tainted: G                T 5.15.0-rc4+ #98 e6202628ee053b4f310759978284bd8bb0ce6905
    [   T49] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1ubuntu1 04/01/2014
    [   T49] RIP: 0010:irqentry_enter_from_user_mode+0x88/0xc0
    [   T49] Code: eb 11 eb 03 90 90 c3 bf 01 00 00 00 e8 91 02 00 00 eb f1 eb 06 90 0f 0b 90 eb e7 65 8b 05 d8 22 b3 7e 83 f8 01 75 ee eb d9 90 <0f> 0b 90 f6 87 88 00 00 00 03 75 9b 90 0f 0b 90 eb 95 90 0f 0b 90
    [   T49] RSP: 0000:ffff888004267eb0 EFLAGS: 00050006
    [   T49] RAX: 0000000000044400 RBX: 0000000000000000 RCX: 0000000000000000
    [   T49] RDX: 0000000000040006 RSI: 0000000000000008 RDI: ffff888004267f58
    [   T49] RBP: ffff888004267f58 R08: ffff888004267f58 R09: 0000000000000000
    [   T49] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81600a15
    [   T49] R13: 0000000000000000 R14: 0000000000000008 R15: 0000000000000000
    [   T49] FS:  0000000000800000(0000) GS:ffff88803ec00000(0000) knlGS:0000000000000000
    [   T49] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    [   T49] CR2: 00000000414bd008 CR3: 000000000426e003 CR4: 00000000001706f0
    [   T49] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    [   T49] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
    [   T49] Call Trace:
    [   T49]  ? irqentry_enter+0x27/0x40
    [   T49]  ? exc_general_protection+0x2b/0x2c0
    [   T49]  ? asm_exc_general_protection+0x5/0x20
    [   T49]  ? asm_exc_general_protection+0x1b/0x20
    [   T49] ---[ end trace 9345e3548045cf79 ]---

We could add IS_ENABLED(CONFIG_X86_SMAP) to the warning condition, but
even this would not be enough in case SMAP is disabled at boot time with
the "nosmap" parameter.

To be consistent with "nosmap" behaviour, let's clear X86_FEATURE_SMAP
when !CONFIG_X86_SMAP.

I'm not sure if we should clear X86_CR4_SMAP when !CONFIG_X86_SMAP --
that's what the code currently does, so I've preserved that behaviour,
even though it seems a bit odd.

Found using entry-fuzz + satrandconfig.

Fixes: 3c73b81a9164 ("x86/entry, selftests: Further improve user entry sanity checks")
Fixes: 662a0221893a ("x86/entry: Fix AC assertion")
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 arch/x86/kernel/cpu/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0f8885949e8c4..b3410f1ac2175 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -326,6 +326,7 @@ static __always_inline void setup_smap(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_SMAP
 		cr4_set_bits(X86_CR4_SMAP);
 #else
+		clear_cpu_cap(c, X86_FEATURE_SMAP);
 		cr4_clear_bits(X86_CR4_SMAP);
 #endif
 	}
-- 
2.23.0.718.g5ad94255a8

