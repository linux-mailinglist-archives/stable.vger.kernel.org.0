Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 147C110BBF0
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbfK0VNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:13:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:44558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387406AbfK0VM7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:12:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF0A021556;
        Wed, 27 Nov 2019 21:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574889179;
        bh=0mfKnqG4mH4LuWb2SZO7gF8jbUWaMBscu09hSclwSsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAypsqOk5WxDPXlmIf2PwbNW4j9e9J9GCEDi8ez7W5RoVMGvnoQtxXE3XXFGx9632
         bWJjNPhmC/iCKa1izW+1XQI/XlhMJDoPWm9Vu9BDPDGp3Xp6QwOag5dCOqtqMA1hT+
         ewm4FVgUm7MdSjyOoNslDG35ffa8C4KXbETlpiz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>, stable@kernel.org
Subject: [PATCH 5.4 19/66] x86/entry/32: Fix IRET exception
Date:   Wed, 27 Nov 2019 21:32:14 +0100
Message-Id: <20191127202654.282045144@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202632.536277063@linuxfoundation.org>
References: <20191127202632.536277063@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

commit 40ad2199580e248dce2a2ebb722854180c334b9e upstream.

As reported by Lai, the commit 3c88c692c287 ("x86/stackframe/32:
Provide consistent pt_regs") wrecked the IRET EXTABLE entry by making
.Lirq_return not point at IRET.

Fix this by placing IRET_FRAME in RESTORE_REGS, to mirror how
FIXUP_FRAME is part of SAVE_ALL.

Fixes: 3c88c692c287 ("x86/stackframe/32: Provide consistent pt_regs")
Reported-by: Lai Jiangshan <laijs@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Andy Lutomirski <luto@kernel.org>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/entry/entry_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -357,6 +357,7 @@
 2:	popl	%es
 3:	popl	%fs
 	POP_GS \pop
+	IRET_FRAME
 .pushsection .fixup, "ax"
 4:	movl	$0, (%esp)
 	jmp	1b
@@ -1075,7 +1076,6 @@ restore_all:
 	/* Restore user state */
 	RESTORE_REGS pop=4			# skip orig_eax/error_code
 .Lirq_return:
-	IRET_FRAME
 	/*
 	 * ARCH_HAS_MEMBARRIER_SYNC_CORE rely on IRET core serialization
 	 * when returning from IPI handler and when returning from


