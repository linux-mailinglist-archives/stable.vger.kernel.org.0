Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083B4450A90
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbhKORLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:11:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:37120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232387AbhKORLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:11:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00B8C61B5E;
        Mon, 15 Nov 2021 17:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996093;
        bh=IIsW6wAy0SALIeIWLH4qoOBu7RkiSSi8fyC8KamsJXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vN+HnisPBH6dIWfPk2oQaHNxE2vxaK4S/47A2jncPLxNhrZFGm8yxyg8HVllcFm45
         vpIx45jWy3R5bbDVndSShq1ziN1MAsQw7lRn33aLGtrC1yq9hIVy6f6RECLIebq0Pw
         xZapQxzr7OVn/SEfQKkke8xPBAnYmNmmuUJhjXq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Kyle McMartin <kyle@mcmartin.ca>
Subject: [PATCH 5.4 014/355] parisc: Fix ptrace check on syscall return
Date:   Mon, 15 Nov 2021 17:58:58 +0100
Message-Id: <20211115165314.015030463@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 8779e05ba8aaffec1829872ef9774a71f44f6580 upstream.

The TIF_XXX flags are stored in the flags field in the thread_info
struct (TI_FLAGS), not in the flags field of the task_struct structure
(TASK_FLAGS).

It seems this bug didn't generate any important side-effects, otherwise it
wouldn't have went unnoticed for 12 years (since v2.6.32).

Signed-off-by: Helge Deller <deller@gmx.de>
Fixes: ecd3d4bc06e48 ("parisc: stop using task->ptrace for {single,block}step flags")
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1841,7 +1841,7 @@ syscall_restore:
 	LDREG	TI_TASK-THREAD_SZ_ALGN-FRAME_SIZE(%r30),%r1
 
 	/* Are we being ptraced? */
-	ldw	TASK_FLAGS(%r1),%r19
+	LDREG	TI_FLAGS-THREAD_SZ_ALGN-FRAME_SIZE(%r30),%r19
 	ldi	_TIF_SYSCALL_TRACE_MASK,%r2
 	and,COND(=)	%r19,%r2,%r0
 	b,n	syscall_restore_rfi


