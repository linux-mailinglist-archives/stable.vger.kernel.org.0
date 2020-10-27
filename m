Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A6229BC9A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810168AbgJ0QeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802461AbgJ0Psv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:48:51 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C374822265;
        Tue, 27 Oct 2020 15:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813729;
        bh=lCZKQ7KGG1SLMxrz/BobWDhhT068d+17W29g9IlqiF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivlwTxGueFAE+TH1Yuq6qnfKpMozSNCn93lXeYETpIHgc2bUm+gJw1hUr/O9dD+sr
         JwDPDn26jDCF4ugK2f22RB65IcjKq3R+DXsRpSoGf6I8dRuECyOc72nS3se2DYnhl4
         QiOqpO0JgvTEoCQz/RPGkVaA+sRIGSGA8yl85oMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Mossberg <mark.mossberg@gmail.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 643/757] x86/dumpstack: Fix misleading instruction pointer error message
Date:   Tue, 27 Oct 2020 14:54:53 +0100
Message-Id: <20201027135520.731919820@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Mossberg <mark.mossberg@gmail.com>

[ Upstream commit 238c91115cd05c71447ea071624a4c9fe661f970 ]

Printing "Bad RIP value" if copy_code() fails can be misleading for
userspace pointers, since copy_code() can fail if the instruction
pointer is valid but the code is paged out. This is because copy_code()
calls copy_from_user_nmi() for userspace pointers, which disables page
fault handling.

This is reproducible in OOM situations, where it's plausible that the
code may be reclaimed in the time between entry into the kernel and when
this message is printed. This leaves a misleading log in dmesg that
suggests instruction pointer corruption has occurred, which may alarm
users.

Change the message to state the error condition more precisely.

 [ bp: Massage a bit. ]

Signed-off-by: Mark Mossberg <mark.mossberg@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20201002042915.403558-1-mark.mossberg@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/dumpstack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 48ce44576947c..ea8d51ec251bb 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -115,7 +115,8 @@ void show_opcodes(struct pt_regs *regs, const char *loglvl)
 	unsigned long prologue = regs->ip - PROLOGUE_SIZE;
 
 	if (copy_code(regs, opcodes, prologue, sizeof(opcodes))) {
-		printk("%sCode: Bad RIP value.\n", loglvl);
+		printk("%sCode: Unable to access opcode bytes at RIP 0x%lx.\n",
+		       loglvl, prologue);
 	} else {
 		printk("%sCode: %" __stringify(PROLOGUE_SIZE) "ph <%02x> %"
 		       __stringify(EPILOGUE_SIZE) "ph\n", loglvl, opcodes,
-- 
2.25.1



