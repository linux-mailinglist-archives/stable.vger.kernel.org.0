Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFD457AB60
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 03:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbiGTBLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 21:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240391AbiGTBLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 21:11:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E5D64E04;
        Tue, 19 Jul 2022 18:11:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 059FF616F0;
        Wed, 20 Jul 2022 01:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23634C385A9;
        Wed, 20 Jul 2022 01:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279471;
        bh=WXdrFZOXceROsZm8n4HSd8OiAlCYb1jd9+1Sqz04V6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bbreMiBrX6RI1SyL2EYbwHz2CmkbBVJtYLNUhlOb5jw68p66oROnsdfK2LdwULy36
         KoopZbIOl+uGR7luHJNG761B6aTdxVj2HssyhAyCScFDhmImaMbcOYGDUxHsgQWWyK
         mGreUOpMe1fmTwxufDNp/w4fzf6e5y3Gk31s/d3p4AaqOM+JmJ9jkFnxEipHzLdVHP
         ZGZLMLV3X6o948mSYkvwRgQIdIEy2KPraiLejFERlD2mDdwpTyRKuobHhT+zntg076
         qvsVXhzhbPUjFpkYxFJ7z1bVRYHRJMkRucoKvmDgkLRFHG/dDJ8MCIRSS0CmEEQEfK
         Nkz6NjN8J61Fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kim Phillips <kim.phillips@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dave.hansen@linux.intel.com,
        luto@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org
Subject: [PATCH AUTOSEL 5.18 11/54] x86/sev: Avoid using __x86_return_thunk
Date:   Tue, 19 Jul 2022 21:09:48 -0400
Message-Id: <20220720011031.1023305-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
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

From: Kim Phillips <kim.phillips@amd.com>

[ Upstream commit 0ee9073000e8791f8b134a8ded31bcc767f7f232 ]

Specifically, it's because __enc_copy() encrypts the kernel after
being relocated outside the kernel in sme_encrypt_execute(), and the
RET macro's jmp offset isn't amended prior to execution.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/mem_encrypt_boot.S | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt_boot.S b/arch/x86/mm/mem_encrypt_boot.S
index 3d1dba05fce4..d94dea450fa6 100644
--- a/arch/x86/mm/mem_encrypt_boot.S
+++ b/arch/x86/mm/mem_encrypt_boot.S
@@ -65,7 +65,9 @@ SYM_FUNC_START(sme_encrypt_execute)
 	movq	%rbp, %rsp		/* Restore original stack pointer */
 	pop	%rbp
 
-	RET
+	/* Offset to __x86_return_thunk would be wrong here */
+	ret
+	int3
 SYM_FUNC_END(sme_encrypt_execute)
 
 SYM_FUNC_START(__enc_copy)
@@ -151,6 +153,8 @@ SYM_FUNC_START(__enc_copy)
 	pop	%r12
 	pop	%r15
 
-	RET
+	/* Offset to __x86_return_thunk would be wrong here */
+	ret
+	int3
 .L__enc_copy_end:
 SYM_FUNC_END(__enc_copy)
-- 
2.35.1

