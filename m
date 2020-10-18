Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BD5291F8C
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 22:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgJRTSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727326AbgJRTSM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F181322282;
        Sun, 18 Oct 2020 19:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048691;
        bh=lCZKQ7KGG1SLMxrz/BobWDhhT068d+17W29g9IlqiF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SLSfiWbvmPDLzneNjApmzG3wb+404D6EoMvA82jL3UDZ3sKHMvoKTdXmsWWOGjuZB
         YIYThbO5BXyWC7ujKXsWXRNVtVTBjYaeQoxP4HWZgbFiS2d180TZVxWbsgIuvXfT8F
         blRAIfCqcxW9++quH+ktsxJ/fGCBmYKByLRtC3rA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Mossberg <mark.mossberg@gmail.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.9 003/111] x86/dumpstack: Fix misleading instruction pointer error message
Date:   Sun, 18 Oct 2020 15:16:19 -0400
Message-Id: <20201018191807.4052726-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

