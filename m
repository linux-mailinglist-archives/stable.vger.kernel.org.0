Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A156AF596
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbjCGT1i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:27:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234096AbjCGT1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:27:16 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC1C9CFD1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:13:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C42D7CE1C5D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:12:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D3FC433D2;
        Tue,  7 Mar 2023 19:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216341;
        bh=OKiE9tVPGPFcx0mMq2uAw8ha8JljtyeAEkh11mHXPH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daecKXNCEZZzcTMhVIsblzm1zDCpAATjZqP/SQf4ZcNbCHz9CneTq6AJMw9qeAfWJ
         wGlceO4SwwUWqS+wGd7CIwKHSG+x83Sdz7XZBuPeNXy6f3KwRLh8o1zKrYo3slbDR2
         BufRMLhnaWBfd5o2OloAmdqzeCYat7k6lGObFo7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 553/567] riscv, mm: Perform BPF exhandler fixup on page fault
Date:   Tue,  7 Mar 2023 18:04:49 +0100
Message-Id: <20230307165929.920778387@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Björn Töpel <bjorn@rivosinc.com>

commit 416721ff05fddc58ca531b6f069de250301de6e5 upstream.

Commit 21855cac82d3 ("riscv/mm: Prevent kernel module to access user
memory without uaccess routines") added early exits/deaths for page
faults stemming from accesses to user-space without using proper
uaccess routines (where sstatus.SUM is set).

Unfortunatly, this is too strict for some BPF programs, which relies
on BPF exhandler fixups. These BPF programs loads "BTF pointers". A
BTF pointers could either be a valid kernel pointer or NULL, but not a
userspace address.

Resolve the problem by calling the fixup handler in the early exit
path.

Fixes: 21855cac82d3 ("riscv/mm: Prevent kernel module to access user memory without uaccess routines")
Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
Link: https://lore.kernel.org/r/20230214162515.184827-1-bjorn@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/fault.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -271,10 +271,12 @@ asmlinkage void do_page_fault(struct pt_
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 
-	if (!user_mode(regs) && addr < TASK_SIZE &&
-			unlikely(!(regs->status & SR_SUM)))
-		die_kernel_fault("access to user memory without uaccess routines",
-				addr, regs);
+	if (!user_mode(regs) && addr < TASK_SIZE && unlikely(!(regs->status & SR_SUM))) {
+		if (fixup_exception(regs))
+			return;
+
+		die_kernel_fault("access to user memory without uaccess routines", addr, regs);
+	}
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 


