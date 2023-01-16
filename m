Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9AC66C4C1
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbjAPP6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjAPP5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:57:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A6A23335
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:57:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C73A261031
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA77EC433F0;
        Mon, 16 Jan 2023 15:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884665;
        bh=YSSrCbG6ZPmoS6q3hGb9luYPWyVKiRq+7nPNcO9wHYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bvf5Q+6D3Wiz13AcMyO17y8GU7+Vye3+o4EQWQFced+ssGI5Ah4i7sRF51WSI0FOU
         8jI3X8w03A9AXOqfOBxgtD0lcRA9nnhRklIIA7BM00RWboc+70/XR2SVlv6UwD+ZJt
         bW1JQq5WfYBATt5VOuBb1gOnDu5Y8MQthd9Xh40E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 092/183] x86/boot: Avoid using Intel mnemonics in AT&T syntax asm
Date:   Mon, 16 Jan 2023 16:50:15 +0100
Message-Id: <20230116154807.307818998@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 7c6dd961d0c8e7e8f9fdc65071fb09ece702e18d upstream.

With 'GNU assembler (GNU Binutils for Debian) 2.39.90.20221231' the
build now reports:

  arch/x86/realmode/rm/../../boot/bioscall.S: Assembler messages:
  arch/x86/realmode/rm/../../boot/bioscall.S:35: Warning: found `movsd'; assuming `movsl' was meant
  arch/x86/realmode/rm/../../boot/bioscall.S:70: Warning: found `movsd'; assuming `movsl' was meant

  arch/x86/boot/bioscall.S: Assembler messages:
  arch/x86/boot/bioscall.S:35: Warning: found `movsd'; assuming `movsl' was meant
  arch/x86/boot/bioscall.S:70: Warning: found `movsd'; assuming `movsl' was meant

Which is due to:

  PR gas/29525

  Note that with the dropped CMPSD and MOVSD Intel Syntax string insn
  templates taking operands, mixed IsString/non-IsString template groups
  (with memory operands) cannot occur anymore. With that
  maybe_adjust_templates() becomes unnecessary (and is hence being
  removed).

More details: https://sourceware.org/bugzilla/show_bug.cgi?id=29525

Borislav Petkov further explains:

  " the particular problem here is is that the 'd' suffix is
    "conflicting" in the sense that you can have SSE mnemonics like movsD %xmm...
    and the same thing also for string ops (which is the case here) so apparently
    the agreement in binutils land is to use the always accepted suffixes 'l' or 'q'
    and phase out 'd' slowly... "

Fixes: 7a734e7dd93b ("x86, setup: "glove box" BIOS calls -- infrastructure")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/Y71I3Ex2pvIxMpsP@hirez.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/bioscall.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/boot/bioscall.S
+++ b/arch/x86/boot/bioscall.S
@@ -32,7 +32,7 @@ intcall:
 	movw	%dx, %si
 	movw	%sp, %di
 	movw	$11, %cx
-	rep; movsd
+	rep; movsl
 
 	/* Pop full state from the stack */
 	popal
@@ -67,7 +67,7 @@ intcall:
 	jz	4f
 	movw	%sp, %si
 	movw	$11, %cx
-	rep; movsd
+	rep; movsl
 4:	addw	$44, %sp
 
 	/* Restore state and return */


