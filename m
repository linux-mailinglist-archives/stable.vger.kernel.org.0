Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17244D4AB7
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244157AbiCJOc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244973AbiCJO3m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:29:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CB5158794;
        Thu, 10 Mar 2022 06:25:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4A7F61D7D;
        Thu, 10 Mar 2022 14:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D4FC340E8;
        Thu, 10 Mar 2022 14:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922299;
        bh=rxrVtqzt8KzhHd7aJFQSaUe6TCVXuDiXrwAXtG1xse4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Iw/L+d4qL9xwlXYgqxofvJkticlbl0p76vrqLO4GoNnoDjOZfLHSEXKYp2B+TzBlC
         v/YmsDFmUTYp3s4wrgJW0fsBlzYRVGcE9F3W1DebuxbK8EMZ7j5NtPtvzBnZP8Lffo
         qgusHYZgd/fAuFy4tYefORNgqIMxOmgtUgPc1Zy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.10 33/58] arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations
Date:   Thu, 10 Mar 2022 15:18:53 +0100
Message-Id: <20220310140813.817865923@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140812.869208747@linuxfoundation.org>
References: <20220310140812.869208747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/entry.S |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -819,10 +819,11 @@ alternative_else_nop_endif
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
@@ -910,6 +911,38 @@ SYM_DATA_END(__entry_tramp_data_start)
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
 /*
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
+/*
  * Register switch for AArch64. The callee-saved registers need to be saved
  * and restored. On entry:
  *   x0 = previous task_struct (must be preserved across the switch)


