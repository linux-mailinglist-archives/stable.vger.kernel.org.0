Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9795EA2C0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbiIZLOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237371AbiIZLNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:13:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F7461D5C;
        Mon, 26 Sep 2022 03:36:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E7E4B802C7;
        Mon, 26 Sep 2022 10:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D43C433B5;
        Mon, 26 Sep 2022 10:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188559;
        bh=zRrMrRABLsN3WrZIDEo2465rJQHnOyEX8cPMpJTlbZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jr8Ix8qgPaKZN1PyAkxirZMRGGrFRWR+7MGcAECPoGOCTEQIUXhQ1wLOuW4Q2b0/x
         v3uCGLZWjJm193HAv27w8hMr//Oood/e0+rtWfB6hcOngw/kVCXL7hoWHrDQBYiEFo
         FmNV+28i2XZc2egySxUZdDMaQjZhrAuyfC6kdc8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 046/148] riscv: fix a nasty sigreturn bug...
Date:   Mon, 26 Sep 2022 12:11:20 +0200
Message-Id: <20220926100757.736026480@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
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
@@ -121,6 +121,8 @@ SYSCALL_DEFINE0(rt_sigreturn)
 	if (restore_altstack(&frame->uc.uc_stack))
 		goto badframe;
 
+	regs->cause = -1UL;
+
 	return regs->a0;
 
 badframe:


