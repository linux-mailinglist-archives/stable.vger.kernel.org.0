Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834755955BC
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 11:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbiHPJCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 05:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiHPJBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 05:01:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784ABD020D;
        Tue, 16 Aug 2022 00:11:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0BE7534BCC;
        Tue, 16 Aug 2022 07:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660633900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=h6M793SMY2ynvWE6o2wfHm041bnCM3HfZCKa0vLCTLw=;
        b=Mnw1d5F8tJcd+2r4BZoh0xSWKXDiI7+4lg4EXt0O0JeuEibB9/ttLcmvqnCvzkQjQlsIfq
        cPQBqndN4J06ZB89+uOr1tOMexHZu+bnr/pcckpzdReiYrI3/3W8a1mPM1ePMASQ73nmRN
        4hOH/RWI+ptWU2HuqYTQwWApTd3Hm34=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AD685139B7;
        Tue, 16 Aug 2022 07:11:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TFETKStD+2IqPQAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 16 Aug 2022 07:11:39 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: [PATCH] x86/entry: fix entry_INT80_compat for Xen PV guests
Date:   Tue, 16 Aug 2022 09:11:37 +0200
Message-Id: <20220816071137.4893-1-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c89191ce67ef ("x86/entry: Convert SWAPGS to swapgs and remove
the definition of SWAPGS") missed one use case of SWAPGS in
entry_INT80_compat. Removing of the SWAPGS macro led to asm just
using "swapgs", as it is accepting instructions in capital letters,
too.

This in turn leads to splats in Xen PV guests like:

[   36.145223] general protection fault, maybe for address 0x2d: 0000 [#1] PREEMPT SMP NOPTI
[   36.145794] CPU: 2 PID: 1847 Comm: ld-linux.so.2 Not tainted 5.19.1-1-default #1 openSUSE Tumbleweed f3b44bfb672cdb9f235aff53b57724eba8b9411b
[   36.146608] Hardware name: HP ProLiant ML350p Gen8, BIOS P72 11/14/2013
[   36.148126] RIP: e030:entry_INT80_compat+0x3/0xa3

Fix that by open coding this single instance of the SWAPGS macro.

Cc: <stable@vger.kernel.org> # 5.19
Fixes: c89191ce67ef ("x86/entry: Convert SWAPGS to swapgs and remove the definition of SWAPGS")
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/entry/entry_64_compat.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
index 682338e7e2a3..4dd19819053a 100644
--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -311,7 +311,7 @@ SYM_CODE_START(entry_INT80_compat)
 	 * Interrupts are off on entry.
 	 */
 	ASM_CLAC			/* Do this early to minimize exposure */
-	SWAPGS
+	ALTERNATIVE "swapgs", "", X86_FEATURE_XENPV
 
 	/*
 	 * User tracing code (ptrace or signal handlers) might assume that
-- 
2.35.3

