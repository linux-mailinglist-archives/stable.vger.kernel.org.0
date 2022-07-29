Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1CD584D30
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 10:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiG2IMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 04:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiG2IMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 04:12:02 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C517FE58;
        Fri, 29 Jul 2022 01:12:01 -0700 (PDT)
Date:   Fri, 29 Jul 2022 08:11:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1659082319;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S6OXLj5CsWOBodkRXT3i4CgKhOtLFQplhD7nAMNeuq8=;
        b=IXMSLSFqCwyyFh6aU4jMKAmR7MTyD/sG84Sa7lM7CXjLmtR1upxdGWz4BkMYF+GV4m32EA
        jMv9K29KRTf6HmYabi8UHlP30D6Q8RWd3PE332UhiP6xHENK9XrwEef2ynhufTwgObO57g
        v1HaR8MelonrubY33krXdKB8VuaxEX1WEspidbmLE4PLq4Vl4iaCUUwWX7qFjuRDVB44YK
        kPjD+SB8I08uVpf1jIYupE2oMvkwbu6oypKnh1IabV1OMtXuEnYhr2tj61qvg6WKU9YczJ
        vW5KzL7iSVsNLNducgMkZswnJQDidFgG+1U3JDqeCkG+8dYNJOzDbGzcHnOKkQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1659082319;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S6OXLj5CsWOBodkRXT3i4CgKhOtLFQplhD7nAMNeuq8=;
        b=97SmYFkWOoJ9ee+C/AkWZ3hHU/cU1TvhnUE/4LM5wp7y4IOnuipXIZpLLM+6cK+/rTJl9U
        JaJolThG2RPaqRDg==
From:   "tip-bot2 for Thadeu Lima de Souza Cascardo" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/bugs: Do not enable IBPB at firmware entry when
 IBPB is not available
Cc:     Dimitri John Ledkov <dimitri.ledkov@canonical.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220728122602.2500509-1-cascardo@canonical.com>
References: <20220728122602.2500509-1-cascardo@canonical.com>
MIME-Version: 1.0
Message-ID: <165908231771.15455.910099609203096597.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     571c30b1a88465a1c85a6f7762609939b9085a15
Gitweb:        https://git.kernel.org/tip/571c30b1a88465a1c85a6f7762609939b9085a15
Author:        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
AuthorDate:    Thu, 28 Jul 2022 09:26:02 -03:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 29 Jul 2022 10:02:35 +02:00

x86/bugs: Do not enable IBPB at firmware entry when IBPB is not available

Some cloud hypervisors do not provide IBPB on very recent CPU processors,
including AMD processors affected by Retbleed.

Using IBPB before firmware calls on such systems would cause a GPF at boot
like the one below. Do not enable such calls when IBPB support is not
present.

  EFI Variables Facility v0.08 2004-May-17
  general protection fault, maybe for address 0x1: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 0 PID: 24 Comm: kworker/u2:1 Not tainted 5.19.0-rc8+ #7
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
  Workqueue: efi_rts_wq efi_call_rts
  RIP: 0010:efi_call_rts
  Code: e8 37 33 58 ff 41 bf 48 00 00 00 49 89 c0 44 89 f9 48 83 c8 01 4c 89 c2 48 c1 ea 20 66 90 b9 49 00 00 00 b8 01 00 00 00 31 d2 <0f> 30 e8 7b 9f 5d ff e8 f6 f8 ff ff 4c 89 f1 4c 89 ea 4c 89 e6 48
  RSP: 0018:ffffb373800d7e38 EFLAGS: 00010246
  RAX: 0000000000000001 RBX: 0000000000000006 RCX: 0000000000000049
  RDX: 0000000000000000 RSI: ffff94fbc19d8fe0 RDI: ffff94fbc1b2b300
  RBP: ffffb373800d7e70 R08: 0000000000000000 R09: 0000000000000000
  R10: 000000000000000b R11: 000000000000000b R12: ffffb3738001fd78
  R13: ffff94fbc2fcfc00 R14: ffffb3738001fd80 R15: 0000000000000048
  FS:  0000000000000000(0000) GS:ffff94fc3da00000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: ffff94fc30201000 CR3: 000000006f610000 CR4: 00000000000406f0
  Call Trace:
   <TASK>
   ? __wake_up
   process_one_work
   worker_thread
   ? rescuer_thread
   kthread
   ? kthread_complete_and_exit
   ret_from_fork
   </TASK>
  Modules linked in:

Fixes: 28a99e95f55c ("x86/amd: Use IBPB for firmware calls")
Reported-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220728122602.2500509-1-cascardo@canonical.com
---
 arch/x86/kernel/cpu/bugs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6454bc7..6761668 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1520,6 +1520,7 @@ static void __init spectre_v2_select_mitigation(void)
 	 * enable IBRS around firmware calls.
 	 */
 	if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+	    boot_cpu_has(X86_FEATURE_IBPB) &&
 	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
 	     boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)) {
 
