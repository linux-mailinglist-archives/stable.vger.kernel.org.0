Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A374D452F73
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 11:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhKPKtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 05:49:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234292AbhKPKtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Nov 2021 05:49:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B335C61BFE;
        Tue, 16 Nov 2021 10:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637059610;
        bh=2xoMwNexT1s1a9zAYUjbQqS/YBLAEX8zI7PfrVyB/gI=;
        h=Subject:To:Cc:From:Date:From;
        b=FXPcmvtscUy9ygWGDfphBsoygwzcaEMZ1VseRtpELTl6CdM3DG7LvCib3ciAzw6HR
         Dn1KLICdUp/P81y2pcOyH1yyqlfiThL77IxOq5STUHBX0938inipe3pTVh9BSqhOL5
         uX8q+U2NBeF1LuQUlcVREOOotvxqmrgAR7eNrHkI=
Subject: FAILED: patch "[PATCH] parisc/entry: fix trace test in syscall exit path" failed to apply to 4.19-stable tree
To:     svens@stackframe.org, deller@gmx.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 16 Nov 2021 11:46:47 +0100
Message-ID: <163705960760205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3ec18fc7831e7d79e2d536dd1f3bc0d3ba425e8a Mon Sep 17 00:00:00 2001
From: Sven Schnelle <svens@stackframe.org>
Date: Sat, 13 Nov 2021 20:41:17 +0100
Subject: [PATCH] parisc/entry: fix trace test in syscall exit path

commit 8779e05ba8aa ("parisc: Fix ptrace check on syscall return")
fixed testing of TI_FLAGS. This uncovered a bug in the test mask.
syscall_restore_rfi is only used when the kernel needs to exit to
usespace with single or block stepping and the recovery counter
enabled. The test however used _TIF_SYSCALL_TRACE_MASK, which
includes a lot of bits that shouldn't be tested here.

Fix this by using TIF_SINGLESTEP and TIF_BLOCKSTEP directly.

I encountered this bug by enabling syscall tracepoints. Both in qemu and
on real hardware. As soon as i enabled the tracepoint (sys_exit_read,
but i guess it doesn't really matter which one), i got random page
faults in userspace almost immediately.

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/parisc/kernel/entry.S b/arch/parisc/kernel/entry.S
index 57944d6f9ebb..88c188a965d8 100644
--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1805,7 +1805,7 @@ syscall_restore:
 
 	/* Are we being ptraced? */
 	LDREG	TASK_TI_FLAGS(%r1),%r19
-	ldi	_TIF_SYSCALL_TRACE_MASK,%r2
+	ldi	_TIF_SINGLESTEP|_TIF_BLOCKSTEP,%r2
 	and,COND(=)	%r19,%r2,%r0
 	b,n	syscall_restore_rfi
 

