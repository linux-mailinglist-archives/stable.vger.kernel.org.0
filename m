Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7339B66CBFC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbjAPRVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:21:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbjAPRUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:20:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4772758669
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:59:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFE82B8108E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A07EC433EF;
        Mon, 16 Jan 2023 16:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888363;
        bh=HVzxMLyn3rcyoX8oN2/qx564qZ+DfW0ZR5/sOHVsmXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mZZFhb7Qz1JUrbr9vi+kfTuJT4bVryYiHi3U2KAUv1d1H0RUhVdvIzFTQXiEbhXcz
         ldfvdempbsXLOxA1TmKH/Yvb8fWwzQSg3D/YfeMoDOhuuYMSdoh9hFwo2ZW7SSOvLq
         z6j2gGM89VcG+ZhD4qHFpK8LzuuatGrHSk7XJj4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 4.19 501/521] x86/boot: Avoid using Intel mnemonics in AT&T syntax asm
Date:   Mon, 16 Jan 2023 16:52:43 +0100
Message-Id: <20230116154909.604392588@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
@@ -35,7 +35,7 @@ intcall:
 	movw	%dx, %si
 	movw	%sp, %di
 	movw	$11, %cx
-	rep; movsd
+	rep; movsl
 
 	/* Pop full state from the stack */
 	popal
@@ -70,7 +70,7 @@ intcall:
 	jz	4f
 	movw	%sp, %si
 	movw	$11, %cx
-	rep; movsd
+	rep; movsl
 4:	addw	$44, %sp
 
 	/* Restore state and return */


