Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E1F45BF3F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345956AbhKXM4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:56:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346811AbhKXMyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:54:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09E4D615A3;
        Wed, 24 Nov 2021 12:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757078;
        bh=ad0HyHzocW+OI9M0S60lUuHeOOO9DHxCOge34ueMxBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZWCAaEPaz2Zj7B8ivckFJLE+S54Ew72CM0cPJfFp4Z7GbXnik67c8nm7R8wrebjox
         zwrd2ItxcmWfEpLY9oXK1/G2Ej8bZScEKaRDOPoUoUw7b+amH0ebYHlcwftxKxAccn
         n2Wg6R/O1/LzaSOyVKLTLdt65fwEMq1vuiHFyzeI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Kyle McMartin <kyle@mcmartin.ca>
Subject: [PATCH 4.19 009/323] parisc: Fix ptrace check on syscall return
Date:   Wed, 24 Nov 2021 12:53:19 +0100
Message-Id: <20211124115719.145637033@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
@@ -1851,7 +1851,7 @@ syscall_restore:
 	LDREG	TI_TASK-THREAD_SZ_ALGN-FRAME_SIZE(%r30),%r1
 
 	/* Are we being ptraced? */
-	ldw	TASK_FLAGS(%r1),%r19
+	LDREG	TI_FLAGS-THREAD_SZ_ALGN-FRAME_SIZE(%r30),%r19
 	ldi	_TIF_SYSCALL_TRACE_MASK,%r2
 	and,COND(=)	%r19,%r2,%r0
 	b,n	syscall_restore_rfi


