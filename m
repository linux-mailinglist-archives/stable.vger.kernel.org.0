Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD7A5EADB7
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 19:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiIZRLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 13:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbiIZRLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 13:11:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F14205C6
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 09:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3B75B80B1C
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 16:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0EBC433D6;
        Mon, 26 Sep 2022 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664209219;
        bh=iOAsqaL2CErjudgqYy1+ea1a5f6GbnEHiDFNuuTyQpA=;
        h=Subject:To:Cc:From:Date:From;
        b=aq8MB07ZWHYwSlFKako8ddKu8lDU9XnqTKjfjOef7YfZ3jm47Xo4H7OAdiBN30auN
         DJWKQNRyo2Vq/6dfKbeeve4u+WMbCWNdwNvjhVivVFosAfT+77VYYYO87McyNvrVCr
         I4SvNBrPGqVgNkjUi35a8VTekVW1K55fcvtXMYPc=
Subject: FAILED: patch "[PATCH] riscv: fix a nasty sigreturn bug..." failed to apply to 4.19-stable tree
To:     viro@zeniv.linux.org.uk, palmer@rivosinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Sep 2022 18:20:16 +0200
Message-ID: <166420921614576@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

762df359aa58 ("riscv: fix a nasty sigreturn bug...")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 762df359aa5849e010ef04c3ed79d57588ce17d9 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Fri, 24 Sep 2021 01:55:27 +0000
Subject: [PATCH] riscv: fix a nasty sigreturn bug...

riscv has an equivalent of arm bug fixed by 653d48b22166 ("arm: fix
really nasty sigreturn bug"); if signal gets caught by an interrupt that
hits when we have the right value in a0 (-513), *and* another signal
gets delivered upon sigreturn() (e.g. included into the blocked mask for
the first signal and posted while the handler had been running), the
syscall restart logics will see regs->cause equal to EXC_SYSCALL (we are
in a syscall, after all) and a0 already restored to its original value
(-513, which happens to be -ERESTARTNOINTR) and assume that we need to
apply the usual syscall restart logics.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Fixes: e2c0cdfba7f6 ("RISC-V: User-facing API")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/YxJEiSq%2FCGaL6Gm9@ZenIV/
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index 5a2de6b6f882..5c591123c440 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -124,6 +124,8 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	if (restore_altstack(&frame->uc.uc_stack))
 		goto badframe;
 
+	regs->cause = -1UL;
+
 	return regs->a0;
 
 badframe:

