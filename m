Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842614D48E6
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241978AbiCJOOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243026AbiCJONK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:13:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24555156C51;
        Thu, 10 Mar 2022 06:11:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CF1EB8267E;
        Thu, 10 Mar 2022 14:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F634C340E8;
        Thu, 10 Mar 2022 14:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921480;
        bh=Nvdc0gNUxRVbba+YUAyiUFdp6t8kfz07OiJe+ke0X5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GAyjFOnGsxAmDaSlo5E0Xps+uHA0qKwKv6RDIZJXc99wBfQMAXLJrVcLrQoTW/BPF
         JZrCcOvUVN5TOkIcNTbEv6mNP9fTeEdeDpmBKQxMTI5T94q8vSdQuNiTV+JWU7sBzN
         KfGNBICKAiXuuIHH1YQAIE7GqUdjWXTi9ot78HkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 5.16 28/53] arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations
Date:   Thu, 10 Mar 2022 15:09:33 +0100
Message-Id: <20220310140812.645142786@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
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
@@ -649,10 +649,11 @@ alternative_else_nop_endif
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
@@ -740,6 +741,38 @@ SYM_DATA_END(__entry_tramp_data_start)
 #endif /* CONFIG_UNMAP_KERNEL_AT_EL0 */
 
 /*
+ * Exception vectors for spectre mitigations on entry from EL1 when
+ * kpti is not in use.
+ */
+	.macro generate_el1_vector
+.Lvector_start\@:
+	kernel_ventry	1, t, 64, sync		// Synchronous EL1t
+	kernel_ventry	1, t, 64, irq		// IRQ EL1t
+	kernel_ventry	1, t, 64, fiq		// FIQ EL1h
+	kernel_ventry	1, t, 64, error		// Error EL1t
+
+	kernel_ventry	1, h, 64, sync		// Synchronous EL1h
+	kernel_ventry	1, h, 64, irq		// IRQ EL1h
+	kernel_ventry	1, h, 64, fiq		// FIQ EL1h
+	kernel_ventry	1, h, 64, error		// Error EL1h
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


