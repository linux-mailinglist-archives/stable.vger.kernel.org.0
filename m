Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7E659F4AB
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 10:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbiHXIDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 04:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiHXIDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 04:03:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C743B83F2D;
        Wed, 24 Aug 2022 01:03:08 -0700 (PDT)
Date:   Wed, 24 Aug 2022 08:03:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661328186;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=fMC31QZsCePHeMFSj02/iaLnOUX/ksL6PNDDb0owKtk=;
        b=4sREGs+pM/62fkI9etbbxv+De/Xn9nvUBdFl3JEvqBAkbpIm+xJNzaFe4kZXvIpL5rRqc3
        BF/vjddSMe+2w7KKt7VIY/agVU1bQ6ceIWcFrG6SMCa+cRK3eo66I7pKikOho+3Ix7AqP0
        ntZ28AWygR7B2vlTFSBmG7iEemtmMKaqslZGApI3uQxctgQPkhzASFsq35INl/SYMIRY6u
        cydaUGiKWZtJSTuXUlOYWySq57xryeicG62I1btde+fjbO4rdOTqqzhk27P/roP9/B/pKs
        WUN++MAYmZnzaJfEZrWAAMdI5+6AqCXpFlvwPoZawA0ZRIQ5UdlkoTik3AS0vw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661328186;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:  content-transfer-encoding:content-transfer-encoding;
        bh=fMC31QZsCePHeMFSj02/iaLnOUX/ksL6PNDDb0owKtk=;
        b=9SqbUNAuzCynmZnB625IQhoJepipy3sqE5BW62BJE1ZApvSFoYGI6WU5iM18Bvgl8WhY/Z
        47knitLqjLEOBYDA==
From:   "tip-bot2 for Tom Lendacky" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/sev: Don't use cc_platform_has() for early
 SEV-SNP calls
Cc:     Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-ID: <166132818542.401.9222834659601554463.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     cdaa0a407f1acd3a44861e3aea6e3c7349e668f1
Gitweb:        https://git.kernel.org/tip/cdaa0a407f1acd3a44861e3aea6e3c7349e668f1
Author:        Tom Lendacky <thomas.lendacky@amd.com>
AuthorDate:    Tue, 23 Aug 2022 16:55:51 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 24 Aug 2022 09:54:32 +02:00

x86/sev: Don't use cc_platform_has() for early SEV-SNP calls

When running identity-mapped and depending on the kernel configuration,
it is possible that the compiler uses jump tables when generating code
for cc_platform_has().

This causes a boot failure because the jump table uses un-mapped kernel
virtual addresses, not identity-mapped addresses. This has been seen
with CONFIG_RETPOLINE=n.

Similar to sme_encrypt_kernel(), use an open-coded direct check for the
status of SNP rather than trying to eliminate the jump table. This
preserves any code optimization in cc_platform_has() that can be useful
post boot. It also limits the changes to SEV-specific files so that
future compiler features won't necessarily require possible build changes
just because they are not compatible with running identity-mapped.

  [ bp: Massage commit message. ]

Fixes: 5e5ccff60a29 ("x86/sev: Add helper for validating pages in early enc attribute changes")
Reported-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> # 5.19.x
Link: https://lore.kernel.org/all/YqfabnTRxFSM+LoX@google.com/
---
 arch/x86/kernel/sev.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 63dc626..4f84c3f 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -701,7 +701,13 @@ e_term:
 void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
 					 unsigned int npages)
 {
-	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+	/*
+	 * This can be invoked in early boot while running identity mapped, so
+	 * use an open coded check for SNP instead of using cc_platform_has().
+	 * This eliminates worries about jump tables or checking boot_cpu_data
+	 * in the cc_platform_has() function.
+	 */
+	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
 		return;
 
 	 /*
@@ -717,7 +723,13 @@ void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long padd
 void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
 					unsigned int npages)
 {
-	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
+	/*
+	 * This can be invoked in early boot while running identity mapped, so
+	 * use an open coded check for SNP instead of using cc_platform_has().
+	 * This eliminates worries about jump tables or checking boot_cpu_data
+	 * in the cc_platform_has() function.
+	 */
+	if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
 		return;
 
 	/* Invalidate the memory pages before they are marked shared in the RMP table. */
