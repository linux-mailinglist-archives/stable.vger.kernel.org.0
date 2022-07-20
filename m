Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C59157ABEB
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241246AbiGTBRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241247AbiGTBRP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:17:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56BA4B0CD;
        Tue, 19 Jul 2022 18:14:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D74F7B81DE4;
        Wed, 20 Jul 2022 01:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75571C341CB;
        Wed, 20 Jul 2022 01:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279643;
        bh=nM8PtzPOJ+0hjcwU/v1RXurMGse6tyaGKiEUxBk+jXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpUiFay8wzGa42in5v7La9SX1TT47m6iVZMZebTkXajjYk7RRcD+YZRVekfDZYMAE
         aLVYcRobdZbONfn1iI84HwpRMjZIXWnguVegEu/kxdu0pGF93lKfbjysOXWAJcWjLP
         ZcgAeh6y52cwXazHrqrltTQXL49NA32UbfvdTtZM46igFphn+iOgH8RZaIqgVAXGE+
         4OIfV8chJ2kJBnZVp9uDA2/tf4m2Wv7/BuNNfPnQbrNKj0mLyWDPF+VjpSGva6D2lM
         ZYgaT2KM/1tNVgziyLP3rU86uveWoA8xey4SifQsvZ653uqTXF4febXlt/lkQt91Do
         zKny/0jSE92zg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, ndesaulniers@google.com
Subject: [PATCH AUTOSEL 5.15 05/42] x86/retpoline: Swizzle retpoline thunk
Date:   Tue, 19 Jul 2022 21:13:13 -0400
Message-Id: <20220720011350.1024134-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011350.1024134-1-sashal@kernel.org>
References: <20220720011350.1024134-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 00e1533325fd1fb5459229fe37f235462649f668 ]

Put the actual retpoline thunk as the original code so that it can
become more complicated. Specifically, it allows RET to be a JMP,
which can't be .altinstr_replacement since that doesn't do relocations
(except for the very first instruction).

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/retpoline.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/retpoline.S b/arch/x86/lib/retpoline.S
index 9556ff5f4773..43082df303eb 100644
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -32,9 +32,9 @@
 
 SYM_FUNC_START(__x86_indirect_thunk_\reg)
 
-	ALTERNATIVE_2 __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), \
-		      __stringify(RETPOLINE \reg), X86_FEATURE_RETPOLINE, \
-		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg; int3), X86_FEATURE_RETPOLINE_LFENCE
+	ALTERNATIVE_2 __stringify(RETPOLINE \reg), \
+		      __stringify(lfence; ANNOTATE_RETPOLINE_SAFE; jmp *%\reg; int3), X86_FEATURE_RETPOLINE_LFENCE, \
+		      __stringify(ANNOTATE_RETPOLINE_SAFE; jmp *%\reg), ALT_NOT(X86_FEATURE_RETPOLINE)
 
 SYM_FUNC_END(__x86_indirect_thunk_\reg)
 
-- 
2.35.1

