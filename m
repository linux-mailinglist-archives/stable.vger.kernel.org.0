Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14FD4996FD
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446514AbiAXVIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:08:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53558 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445345AbiAXVCw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:02:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7486F61320;
        Mon, 24 Jan 2022 21:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F357C340E5;
        Mon, 24 Jan 2022 21:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058170;
        bh=c119dTtFJ/UsDiNJRoA+V53VfW8MDbBahmzYfXdX0aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0WUuNBlWta3mzI4mxH9Io1Q3rM2DbTuet8xmodACbe+Ud0fMJp3NSKJyuNtLUe17W
         0rnK+OYQdaoZpPGBbQlYFRM/5o4VjMYxOlJjydn05NEZfYmNWTQ3EWMWE9+QIkp3u1
         VJx9z5EQZ2NkWZ7j8XUPSy/pzF58NDokivxl8EtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eirik Fuller <efuller@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0203/1039] powerpc: Avoid discarding flags in system_call_exception()
Date:   Mon, 24 Jan 2022 19:33:12 +0100
Message-Id: <20220124184132.148938792@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 08b0af5b2affbe7419853e8dd1330e4b3fe27125 ]

Some thread flags can be set remotely, and so even when IRQs are disabled,
the flags can change under our feet. Thus, when setting flags we must use
an atomic operation rather than a plain read-modify-write sequence, as a
plain read-modify-write may discard flags which are concurrently set by a
remote thread, e.g.

	// task A			// task B
	tmp = A->thread_info.flags;
					set_tsk_thread_flag(A, NEWFLAG_B);
	tmp |= NEWFLAG_A;
	A->thread_info.flags = tmp;

arch/powerpc/kernel/interrupt.c's system_call_exception() sets
_TIF_RESTOREALL in the thread info flags with a read-modify-write, which
may result in other flags being discarded.

Elsewhere in the file it uses clear_bits() to atomically remove flag bits,
so use set_bits() here for consistency with those.

There may be reasons (e.g. instrumentation) that prevent the use of
set_thread_flag() and clear_thread_flag() here, which would otherwise be
preferable.

Fixes: ae7aaecc3f2f78b7 ("powerpc/64s: system call rfscv workaround for TM bugs")
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Eirik Fuller <efuller@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Link: https://lore.kernel.org/r/20211129130653.2037928-10-mark.rutland@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/interrupt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index 835b626cd4760..df048e331cbfe 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -148,7 +148,7 @@ notrace long system_call_exception(long r3, long r4, long r5,
 	 */
 	if (IS_ENABLED(CONFIG_PPC_TRANSACTIONAL_MEM) &&
 			unlikely(MSR_TM_TRANSACTIONAL(regs->msr)))
-		current_thread_info()->flags |= _TIF_RESTOREALL;
+		set_bits(_TIF_RESTOREALL, &current_thread_info()->flags);
 
 	/*
 	 * If the system call was made with a transaction active, doom it and
-- 
2.34.1



