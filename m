Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5336AED55
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjCGSD1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbjCGSC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:02:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA24EA6BE3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:56:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85523B819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0821C433D2;
        Tue,  7 Mar 2023 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211766;
        bh=RXXBY/6yfiWKShcR8orx+uf1enEGD2NB1ekCpIGH6os=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpcdOm7GbtRWLLDjP8ymd43hh+xPr9LOgMzwt7yTB3zHQHZ9RWo3zBWQbaqYpyLH0
         p7IZdFmwo2p70YNEQ++49tCnXI2ZjkCOXbE6JRjxQglnBoehcom2BKaXjTf/r34iGu
         AySPpg4RBi73qRRLqe8F867o9g34IweF5fNLI1aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mattias Nissler <mnissler@rivosinc.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.2 0970/1001] riscv: Avoid enabling interrupts in die()
Date:   Tue,  7 Mar 2023 18:02:22 +0100
Message-Id: <20230307170104.308025518@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Mattias Nissler <mnissler@rivosinc.com>

commit 130aee3fd9981297ff9354e5d5609cd59aafbbea upstream.

While working on something else, I noticed that the kernel would start
accepting interrupts again after crashing in an interrupt handler. Since
the kernel is already in inconsistent state, enabling interrupts is
dangerous and opens up risk of kernel state deteriorating further.
Interrupts do get enabled via what looks like an unintended side effect of
spin_unlock_irq, so switch to the more cautious
spin_lock_irqsave/spin_unlock_irqrestore instead.

Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code")
Signed-off-by: Mattias Nissler <mnissler@rivosinc.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/r/20230215144828.3370316-1-mnissler@rivosinc.com
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/traps.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -34,10 +34,11 @@ void die(struct pt_regs *regs, const cha
 	static int die_counter;
 	int ret;
 	long cause;
+	unsigned long flags;
 
 	oops_enter();
 
-	spin_lock_irq(&die_lock);
+	spin_lock_irqsave(&die_lock, flags);
 	console_verbose();
 	bust_spinlocks(1);
 
@@ -54,7 +55,7 @@ void die(struct pt_regs *regs, const cha
 
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	spin_unlock_irq(&die_lock);
+	spin_unlock_irqrestore(&die_lock, flags);
 	oops_exit();
 
 	if (in_interrupt())


