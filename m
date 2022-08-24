Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7C3659F49C
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 09:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbiHXHz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 03:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiHXHz4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 03:55:56 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8464884ECB;
        Wed, 24 Aug 2022 00:55:52 -0700 (PDT)
Date:   Wed, 24 Aug 2022 07:55:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661327750;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RqO7cPBchLBpZJwMWF5WuJhfv0vBB4rQmXh3A6TUueo=;
        b=NPw5GD31FlHYtyCGbO+Rl1Vmj3IFxDhxZ+uGgNNri9Yx1a8wha+dHnTAuehc/ySLH71Onv
        JZn9bwvh50YItOcJ0zE/jficatsUNeUkzylVs6GXXs7NKnd/+0XlASVlz800s2Mnrcxv+S
        OR3pN3vMWuhVBjO33uKWihA4LkzEiovDX+Cuuk1NnKaJnpbX2yAQ2/7UPJMzyrw6vpAxUk
        ND4zndEJReccqSBG1YgkjPmH/zj7ewt+RJUOvvOx66NCtI5xBmO4jWAZQQ0K66UTLlhNWc
        mgimHnjZIxAc+y88pozeFWIuonNlsJ+n+Y/4ysbnxtY38X3Ah8uwjyDopu5TyA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661327750;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RqO7cPBchLBpZJwMWF5WuJhfv0vBB4rQmXh3A6TUueo=;
        b=E/HyooXtINpkPP91QrjafI7AQgUiiPP0OK1K1KH2bJoUgq+KpL1N3LYxpupOoOO25VTajh
        lz9btSPcQSYILsBA==
From:   "tip-bot2 for Michael Roth" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/boot: Don't propagate uninitialized
 boot_params->cc_blob_address
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        watnuss@gmx.de, Michael Roth <michael.roth@amd.com>,
        Borislav Petkov <bp@suse.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20220823160734.89036-1-michael.roth@amd.com>
References: <20220823160734.89036-1-michael.roth@amd.com>
MIME-Version: 1.0
Message-ID: <166132774791.401.13991431396549405975.tip-bot2@tip-bot2>
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

Commit-ID:     4b1c742407571eff58b6de9881889f7ca7c4b4dc
Gitweb:        https://git.kernel.org/tip/4b1c742407571eff58b6de9881889f7ca7c4b4dc
Author:        Michael Roth <michael.roth@amd.com>
AuthorDate:    Tue, 23 Aug 2022 11:07:34 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 24 Aug 2022 09:03:04 +02:00

x86/boot: Don't propagate uninitialized boot_params->cc_blob_address

In some cases, bootloaders will leave boot_params->cc_blob_address
uninitialized rather than zeroing it out. This field is only meant to be
set by the boot/compressed kernel in order to pass information to the
uncompressed kernel when SEV-SNP support is enabled.

Therefore, there are no cases where the bootloader-provided values
should be treated as anything other than garbage. Otherwise, the
uncompressed kernel may attempt to access this bogus address, leading to
a crash during early boot.

Normally, sanitize_boot_params() would be used to clear out such fields
but that happens too late: sev_enable() may have already initialized
it to a valid value that should not be zeroed out. Instead, have
sev_enable() zero it out unconditionally beforehand.

Also ensure this happens for !CONFIG_AMD_MEM_ENCRYPT as well by also
including this handling in the sev_enable() stub function.

  [ bp: Massage commit message and comments. ]

Fixes: b190a043c49a ("x86/sev: Add SEV-SNP feature detection/setup")
Reported-by: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Reported-by: watnuss@gmx.de
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216387
Link: https://lore.kernel.org/r/20220823160734.89036-1-michael.roth@amd.com
---
 arch/x86/boot/compressed/misc.h | 12 +++++++++++-
 arch/x86/boot/compressed/sev.c  |  8 ++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 4910bf2..62208ec 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -132,7 +132,17 @@ void snp_set_page_private(unsigned long paddr);
 void snp_set_page_shared(unsigned long paddr);
 void sev_prep_identity_maps(unsigned long top_level_pgt);
 #else
-static inline void sev_enable(struct boot_params *bp) { }
+static inline void sev_enable(struct boot_params *bp)
+{
+	/*
+	 * bp->cc_blob_address should only be set by boot/compressed kernel.
+	 * Initialize it to 0 unconditionally (thus here in this stub too) to
+	 * ensure that uninitialized values from buggy bootloaders aren't
+	 * propagated.
+	 */
+	if (bp)
+		bp->cc_blob_address = 0;
+}
 static inline void sev_es_shutdown_ghcb(void) { }
 static inline bool sev_es_check_ghcb_fault(unsigned long address)
 {
diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 52f989f..c93930d 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -277,6 +277,14 @@ void sev_enable(struct boot_params *bp)
 	bool snp;
 
 	/*
+	 * bp->cc_blob_address should only be set by boot/compressed kernel.
+	 * Initialize it to 0 to ensure that uninitialized values from
+	 * buggy bootloaders aren't propagated.
+	 */
+	if (bp)
+		bp->cc_blob_address = 0;
+
+	/*
 	 * Setup/preliminary detection of SNP. This will be sanity-checked
 	 * against CPUID/MSR values later.
 	 */
