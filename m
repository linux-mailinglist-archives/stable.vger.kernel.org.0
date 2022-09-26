Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C4B5EA42E
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238290AbiIZLln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238293AbiIZLk6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:40:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8154D268;
        Mon, 26 Sep 2022 03:45:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8C69BCE1101;
        Mon, 26 Sep 2022 10:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D39C433D6;
        Mon, 26 Sep 2022 10:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189042;
        bh=4OhIFTaTvw+Ay+oPVwGCPzJwcA7iAszt7mvg8/EjYfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wjSi6Q2T2Fg8kG5knXz8Ee7PD3txm6c6IZsEBSRHtT0y0Tgt9jx5gU9foYO7y+XOC
         aYIG8AqdC4YLL61Ru43epFm0AnP347hbSKaoNhwfuVNMOGKpNhTRakSVeCOaxIMsCi
         Vpiyf3BAec9JLBIy517fX+3RspT30cMcAXEwrtOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.19 054/207] riscv: fix a nasty sigreturn bug...
Date:   Mon, 26 Sep 2022 12:10:43 +0200
Message-Id: <20220926100809.036039036@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
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
@@ -124,6 +124,8 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	if (restore_altstack(&frame->uc.uc_stack))
 		goto badframe;
 
+	regs->cause = -1UL;
+
 	return regs->a0;
 
 badframe:


