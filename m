Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3574512D7
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347508AbhKOTkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:40:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245102AbhKOTTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:19:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 021D8632CE;
        Mon, 15 Nov 2021 18:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000914;
        bh=cxZbC6Kf5oarzP6hG/PPzTeF+T7Xk4LAtg+8GzFPaiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y/4AYj9HX/xn3cyBIEEuk73R3HFsElqUUKEJt9gQIAbwr1AVfu9wjElx7mEM0dG5J
         VcUw5cq4yNlXYpMPFokPGYpI5/ka7g+/HdcrKIWuuPQI/UAR1bFr32312eOnHV+hIv
         NhvjvUOP1mGi3MLZJnwVtV/YAMX8iRS/gMu9TMCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.14 840/849] powerpc/64s/interrupt: Fix check_return_regs_valid() false positive
Date:   Mon, 15 Nov 2021 18:05:23 +0100
Message-Id: <20211115165448.662623750@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 4a5cb51f3db4be547225a4bce7a43d41b231382b upstream.

The check_return_regs_valid() can cause a false positive if the return
regs are marked as norestart and they are an HSRR type interrupt,
because the low bit in the bottom of regs->trap causes interrupt type
matching to fail.

This can occcur for example on bare metal with a HV privileged doorbell
interrupt that causes a signal, but do_signal returns early because
get_signal() fails, and takes the "No signal to deliver" path. In this
case no signal was delivered so the return location is not changed so
return SRRs are not invalidated, yet set_trap_norestart is called, which
messes up the match. Building go-1.16.6 is known to reproduce this.

Fix it by using the TRAP() accessor which masks out the low bit.

Fixes: 6eaaf9de3599 ("powerpc/64s/interrupt: Check and fix srr_valid without crashing")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211026122531.3599918-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/interrupt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -268,7 +268,7 @@ static void check_return_regs_valid(stru
 	if (trap_is_scv(regs))
 		return;
 
-	trap = regs->trap;
+	trap = TRAP(regs);
 	// EE in HV mode sets HSRRs like 0xea0
 	if (cpu_has_feature(CPU_FTR_HVMODE) && trap == INTERRUPT_EXTERNAL)
 		trap = 0xea0;


