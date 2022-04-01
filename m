Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5954EE860
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 08:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245542AbiDAGjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 02:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245610AbiDAGjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 02:39:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF594193160;
        Thu, 31 Mar 2022 23:37:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7858160FE9;
        Fri,  1 Apr 2022 06:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B8FC2BBE4;
        Fri,  1 Apr 2022 06:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648795028;
        bh=kx1OiyQEgo8QAB6SIzA78UgCXTT4mjs2t1lG4rJyQuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=casmsgpKwAD4BDeMoeh1hVl2hiY35O+MiAsdxtTVPR38UDVoHf7q66sO8wKnDvKqB
         szEdw9ACok7VF/c0qbLYo5LbO5lu271Ma1LQTHBOPqpq8qcdWioRX+EtMK0OU/7XyZ
         eU1RxMq53+KIuGLxcFbxUYJcSaSxNx6X/h4+BGmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: [PATCH 4.14 18/27] arm64: entry: Add non-kpti __bp_harden_el1_vectors for mitigations
Date:   Fri,  1 Apr 2022 08:36:28 +0200
Message-Id: <20220401063624.749044293@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220401063624.232282121@linuxfoundation.org>
References: <20220401063624.232282121@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/arm64/kernel/entry.S |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -1025,10 +1025,11 @@ alternative_else_nop_endif
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
@@ -1112,6 +1113,37 @@ __entry_tramp_data_start:
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
+	kernel_ventry	1, error_invalid		// Error EL1h
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
+ENTRY(__bp_harden_el1_vectors)
+	generate_el1_vector
+END(__bp_harden_el1_vectors)
+	.popsection
+
+/*
  * Special system call wrappers.
  */
 ENTRY(sys_rt_sigreturn_wrapper)


