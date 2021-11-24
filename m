Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFA845BCA3
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243461AbhKXMbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:31:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343893AbhKXMaN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:30:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3A8F61263;
        Wed, 24 Nov 2021 12:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756299;
        bh=W7clbzk2TqdlQG6wymm8tiM+yeZ12j0sOGD7kyLqbWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SfkyPm0RRuaNnpvh1Z/6C6mzvdiMxQfuUhAduOG6Cg8CgkHwhTQPraVkSOUnyi3XC
         enmZ3ze13Ya65mcJfqTLHQmZfr72I7cqOQUZPKxq4Zh3oVjb3moWEpgeu4sCPpcQyf
         Caf08oY7+GEDyycj8RJXq5xj5zLuWZUwbgBv/wdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Kyle McMartin <kyle@mcmartin.ca>
Subject: [PATCH 4.14 009/251] parisc: Fix ptrace check on syscall return
Date:   Wed, 24 Nov 2021 12:54:11 +0100
Message-Id: <20211124115710.536976895@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
@@ -1849,7 +1849,7 @@ syscall_restore:
 	LDREG	TI_TASK-THREAD_SZ_ALGN-FRAME_SIZE(%r30),%r1
 
 	/* Are we being ptraced? */
-	ldw	TASK_FLAGS(%r1),%r19
+	LDREG	TI_FLAGS-THREAD_SZ_ALGN-FRAME_SIZE(%r30),%r19
 	ldi	_TIF_SYSCALL_TRACE_MASK,%r2
 	and,COND(=)	%r19,%r2,%r0
 	b,n	syscall_restore_rfi


