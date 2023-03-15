Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC4E6BB0D8
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjCOMVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbjCOMVL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:21:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB8194A72
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:20:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B5A861D58
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A49C433EF;
        Wed, 15 Mar 2023 12:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678882846;
        bh=lU/T2C/MqTRg996k34ZalOliCYSKSXMm4SqZaSbzQOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSI2msYdyLx1whCgoj9YaCOaUOUzLuEUmAfT1HELJBSiKRW22v1ipmsLlJNsovSXk
         gu7LUrXpQeMg20i7UyOPiP8JBrlv5jpTuHM1aR16/XQLp11CqUqPG4aVp/YUm4z2DK
         K9QylPqZYEkQE6DGOmFAXqYhx+kA/4yQbIjmpLDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mattias Nissler <mnissler@rivosinc.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/104] riscv: Avoid enabling interrupts in die()
Date:   Wed, 15 Mar 2023 13:11:55 +0100
Message-Id: <20230315115733.065852664@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mattias Nissler <mnissler@rivosinc.com>

[ Upstream commit 130aee3fd9981297ff9354e5d5609cd59aafbbea ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index bc6b30f3add83..227253fde33c4 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -32,10 +32,11 @@ void die(struct pt_regs *regs, const char *str)
 	static int die_counter;
 	int ret;
 	long cause;
+	unsigned long flags;
 
 	oops_enter();
 
-	spin_lock_irq(&die_lock);
+	spin_lock_irqsave(&die_lock, flags);
 	console_verbose();
 	bust_spinlocks(1);
 
@@ -52,7 +53,7 @@ void die(struct pt_regs *regs, const char *str)
 
 	bust_spinlocks(0);
 	add_taint(TAINT_DIE, LOCKDEP_NOW_UNRELIABLE);
-	spin_unlock_irq(&die_lock);
+	spin_unlock_irqrestore(&die_lock, flags);
 	oops_exit();
 
 	if (in_interrupt())
-- 
2.39.2



