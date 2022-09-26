Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120085E9FB8
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbiIZK3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbiIZK1l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:27:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E71D14DF30;
        Mon, 26 Sep 2022 03:18:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AF349CE10E7;
        Mon, 26 Sep 2022 10:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D9FC433C1;
        Mon, 26 Sep 2022 10:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187513;
        bh=pbT2fg2QOVi6U/rK8F+6R/wuL+JzTs9OXgQB/IY9PK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cB0izfC79FybZE3P4Ec3pU+Cg0bCwYKdDmqZWDkWe9FGtzFGW2xpqS7sai91vgyCA
         Rs47hYdDwi9K+sY9VkLfS39Y2ka4nj0EQuua4eKCI5byGX5Gw2uY1OrTPtw6//0bDu
         fIXkmmxY+JBUWlmy/EMrEL/KxDMr/bZ+bxZaCZ5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 4.19 32/58] riscv: fix a nasty sigreturn bug...
Date:   Mon, 26 Sep 2022 12:11:51 +0200
Message-Id: <20220926100742.656986719@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 762df359aa5849e010ef04c3ed79d57588ce17d9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/signal.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -105,6 +105,8 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	if (restore_altstack(&frame->uc.uc_stack))
 		goto badframe;
 
+	regs->cause = -1UL;
+
 	return regs->a0;
 
 badframe:


