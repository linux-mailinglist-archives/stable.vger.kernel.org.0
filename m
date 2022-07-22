Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9B957DE14
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbiGVJ1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236304AbiGVJ12 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:27:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930ECCBD2E;
        Fri, 22 Jul 2022 02:17:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30162B827BE;
        Fri, 22 Jul 2022 09:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFD0C341C6;
        Fri, 22 Jul 2022 09:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481432;
        bh=afUNIL8EugqzhYqa1lgD+Lbf2agMvsyXkNXYavc+OXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w04p5x50lorEEctT2ZqTMZaDXOygE2QJm/xmiIE0A6IKUBoXoDg83Pb/6HxqTrRqA
         HH6M5cScCi/bX1ILQ46JBtO14XgjMblwTLdc2Hc1xNvuPyStgyAWRYDIX0Lij6Hux9
         zVmZxkTCnozx495MDeNQNbwcgOXY7APB4Oh9P6P8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 63/89] x86/speculation: Remove x86_spec_ctrl_mask
Date:   Fri, 22 Jul 2022 11:11:37 +0200
Message-Id: <20220722091136.880314551@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722091133.320803732@linuxfoundation.org>
References: <20220722091133.320803732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@kernel.org>

commit acac5e98ef8d638a411cfa2ee676c87e1973f126 upstream.

This mask has been made redundant by kvm_spec_ctrl_test_value().  And it
doesn't even work when MSR interception is disabled, as the guest can
just write to SPEC_CTRL directly.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |   31 +------------------------------
 1 file changed, 1 insertion(+), 30 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -86,12 +86,6 @@ u64 spec_ctrl_current(void)
 EXPORT_SYMBOL_GPL(spec_ctrl_current);
 
 /*
- * The vendor and possibly platform specific bits which can be modified in
- * x86_spec_ctrl_base.
- */
-static u64 __ro_after_init x86_spec_ctrl_mask = SPEC_CTRL_IBRS;
-
-/*
  * AMD specific MSR info for Speculative Store Bypass control.
  * x86_amd_ls_cfg_ssbd_mask is initialized in identify_boot_cpu().
  */
@@ -146,10 +140,6 @@ void __init check_bugs(void)
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
 		rdmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
 
-	/* Allow STIBP in MSR_SPEC_CTRL if supported */
-	if (boot_cpu_has(X86_FEATURE_STIBP))
-		x86_spec_ctrl_mask |= SPEC_CTRL_STIBP;
-
 	/* Select the proper CPU mitigations before patching alternatives: */
 	spectre_v1_select_mitigation();
 	spectre_v2_select_mitigation();
@@ -208,19 +198,10 @@ void __init check_bugs(void)
 void
 x86_virt_spec_ctrl(u64 guest_spec_ctrl, u64 guest_virt_spec_ctrl, bool setguest)
 {
-	u64 msrval, guestval, hostval = spec_ctrl_current();
+	u64 msrval, guestval = guest_spec_ctrl, hostval = spec_ctrl_current();
 	struct thread_info *ti = current_thread_info();
 
-	/* Is MSR_SPEC_CTRL implemented ? */
 	if (static_cpu_has(X86_FEATURE_MSR_SPEC_CTRL)) {
-		/*
-		 * Restrict guest_spec_ctrl to supported values. Clear the
-		 * modifiable bits in the host base value and or the
-		 * modifiable bits from the guest value.
-		 */
-		guestval = hostval & ~x86_spec_ctrl_mask;
-		guestval |= guest_spec_ctrl & x86_spec_ctrl_mask;
-
 		if (hostval != guestval) {
 			msrval = setguest ? guestval : hostval;
 			wrmsrl(MSR_IA32_SPEC_CTRL, msrval);
@@ -1659,16 +1640,6 @@ static enum ssb_mitigation __init __ssb_
 	}
 
 	/*
-	 * If SSBD is controlled by the SPEC_CTRL MSR, then set the proper
-	 * bit in the mask to allow guests to use the mitigation even in the
-	 * case where the host does not enable it.
-	 */
-	if (static_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) ||
-	    static_cpu_has(X86_FEATURE_AMD_SSBD)) {
-		x86_spec_ctrl_mask |= SPEC_CTRL_SSBD;
-	}
-
-	/*
 	 * We have three CPU feature flags that are in play here:
 	 *  - X86_BUG_SPEC_STORE_BYPASS - CPU is susceptible.
 	 *  - X86_FEATURE_SSBD - CPU is able to turn off speculative store bypass


