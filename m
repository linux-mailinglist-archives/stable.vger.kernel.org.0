Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628614DC618
	for <lists+stable@lfdr.de>; Thu, 17 Mar 2022 13:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbiCQMsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Mar 2022 08:48:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233756AbiCQMsX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Mar 2022 08:48:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055EF1EE8C0;
        Thu, 17 Mar 2022 05:47:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4E0C5CE233E;
        Thu, 17 Mar 2022 12:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 446EBC340E9;
        Thu, 17 Mar 2022 12:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647521219;
        bh=DdX9fc9eDAsyXVIvUg6+PXF/0PqogdqzNK9nwd96cuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hHOc3fjjbLwls6XiJZpBNcd23Qtjz3/8fzOeMIcT/kT3ULRD2d7mDtnf4fkOGXh+i
         71wPHUVqsC7b0R/6rCY6KkbwTJXMs8gB35aJ+ojJU+9wMD2ZTGE8KfYh2Wm032hf+V
         9WJ1F9uvQ2IR6zx22MhboP9EHyzQV8PywD/iqJzY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/43] arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations
Date:   Thu, 17 Mar 2022 13:45:27 +0100
Message-Id: <20220317124528.126415802@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220317124527.672236844@linuxfoundation.org>
References: <20220317124527.672236844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit aff65393fa1401e034656e349abd655cfe272de0 upstream.

kpti is an optional feature, for systems not using kpti a set of
vectors for the spectre-bhb mitigations is needed.

Add another set of vectors, __bp_harden_el1_vectors, that will be
used if a mitigation is needed and kpti is not in use.

The EL1 ventries are repeated verbatim as there is no additional
work needed for entry from EL1.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/entry.S | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index c1cebaf68e0c..1bc33f506bb1 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1066,10 +1066,11 @@ alternative_else_nop_endif
 	.macro tramp_ventry, vector_start, regsize, kpti
 	.align	7
 1:
-	.if	\kpti == 1
 	.if	\regsize == 64
 	msr	tpidrro_el0, x30	// Restored in kernel_ventry
 	.endif
+
+	.if	\kpti == 1
 	/*
 	 * Defend against branch aliasing attacks by pushing a dummy
 	 * entry onto the return stack and using a RET instruction to
@@ -1156,6 +1157,38 @@ __entry_tramp_data_start:
 #endif /* CONFIG_RANDOMIZE_BASE */
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
+/*
+ * Exception vectors for spectre mitigations on entry from EL1 when
+ * kpti is not in use.
+ */
+	.macro generate_el1_vector
+.Lvector_start\@:
+	kernel_ventry	1, sync_invalid			// Synchronous EL1t
+	kernel_ventry	1, irq_invalid			// IRQ EL1t
+	kernel_ventry	1, fiq_invalid			// FIQ EL1t
+	kernel_ventry	1, error_invalid		// Error EL1t
+
+	kernel_ventry	1, sync				// Synchronous EL1h
+	kernel_ventry	1, irq				// IRQ EL1h
+	kernel_ventry	1, fiq_invalid			// FIQ EL1h
+	kernel_ventry	1, error			// Error EL1h
+
+	.rept	4
+	tramp_ventry	.Lvector_start\@, 64, kpti=0
+	.endr
+	.rept 4
+	tramp_ventry	.Lvector_start\@, 32, kpti=0
+	.endr
+	.endm
+
+	.pushsection ".entry.text", "ax"
+	.align	11
+SYM_CODE_START(__bp_harden_el1_vectors)
+	generate_el1_vector
+SYM_CODE_END(__bp_harden_el1_vectors)
+	.popsection
+
+
 /*
  * Register switch for AArch64. The callee-saved registers need to be saved
  * and restored. On entry:
-- 
2.34.1



