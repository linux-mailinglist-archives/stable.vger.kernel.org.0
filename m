Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643C36B45FD
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:39:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbjCJOjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjCJOjA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:39:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C727420F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:38:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA54A616F0
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DABD1C4339E;
        Fri, 10 Mar 2023 14:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459133;
        bh=HE5Ibmt1HgqCO8v1OICBoka3GgC3KgJnt2cx1UBasg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srSgvsmQVaSZsbsK5z//XWSU9sseoWny12wvnhwMZDvJZi/U6lhOCu8EL4GU3D91g
         d/US8NC3+NbQG90Cdm1lj/HiBGryOmSyJoIJdNuX/NIyQVWtGlwgQnK2oZaYt27RSP
         rLdvmQvKv8qvtrXsBjbEStD3PfuUywFB4s4AQ+0g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Richard Henderson <rth@twiddle.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.4 260/357] alpha: fix FEN fault handling
Date:   Fri, 10 Mar 2023 14:39:09 +0100
Message-Id: <20230310133746.207748496@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 977a3009547dad4a5bc95d91be4a58c9f7eedac0 upstream.

Type 3 instruction fault (FPU insn with FPU disabled) is handled
by quietly enabling FPU and returning.  Which is fine, except that
we need to do that both for fault in userland and in the kernel;
the latter *can* legitimately happen - all it takes is this:

.global _start
_start:
        call_pal 0xae
	lda $0, 0
	ldq $0, 0($0)

- call_pal CLRFEN to clear "FPU enabled" flag and arrange for
a signal delivery (SIGSEGV in this case).

Fixed by moving the handling of type 3 into the common part of
do_entIF(), before we check for kernel vs. user mode.

Incidentally, the check for kernel mode is unidiomatic; the normal
way to do that is !user_mode(regs).  The difference is that
the open-coded variant treats any of bits 63..3 of regs->ps being
set as "it's user mode" while the normal approach is to check just
the bit 3.  PS is a 4-bit register and regs->ps always will have
bits 63..4 clear, so the open-coded variant here is actually equivalent
to !user_mode(regs).  Harder to follow, though...

Cc: stable@vger.kernel.org
Reviewed-by: Richard Henderson <rth@twiddle.net>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/alpha/kernel/traps.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -235,7 +235,21 @@ do_entIF(unsigned long type, struct pt_r
 {
 	int signo, code;
 
-	if ((regs->ps & ~IPL_MAX) == 0) {
+	if (type == 3) { /* FEN fault */
+		/* Irritating users can call PAL_clrfen to disable the
+		   FPU for the process.  The kernel will then trap in
+		   do_switch_stack and undo_switch_stack when we try
+		   to save and restore the FP registers.
+
+		   Given that GCC by default generates code that uses the
+		   FP registers, PAL_clrfen is not useful except for DoS
+		   attacks.  So turn the bleeding FPU back on and be done
+		   with it.  */
+		current_thread_info()->pcb.flags |= 1;
+		__reload_thread(&current_thread_info()->pcb);
+		return;
+	}
+	if (!user_mode(regs)) {
 		if (type == 1) {
 			const unsigned int *data
 			  = (const unsigned int *) regs->pc;
@@ -368,20 +382,6 @@ do_entIF(unsigned long type, struct pt_r
 		}
 		break;
 
-	      case 3: /* FEN fault */
-		/* Irritating users can call PAL_clrfen to disable the
-		   FPU for the process.  The kernel will then trap in
-		   do_switch_stack and undo_switch_stack when we try
-		   to save and restore the FP registers.
-
-		   Given that GCC by default generates code that uses the
-		   FP registers, PAL_clrfen is not useful except for DoS
-		   attacks.  So turn the bleeding FPU back on and be done
-		   with it.  */
-		current_thread_info()->pcb.flags |= 1;
-		__reload_thread(&current_thread_info()->pcb);
-		return;
-
 	      case 5: /* illoc */
 	      default: /* unexpected instruction-fault type */
 		      ;


