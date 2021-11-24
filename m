Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510ED45BA57
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242465AbhKXMJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:09:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242466AbhKXMIX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:08:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38B326108D;
        Wed, 24 Nov 2021 12:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755490;
        bh=VfAnDFPrThSiozoB6PVltjzOrirtCzeL6GLWNPHDRxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/CE4tW4D4Vf1TPO7k6OOUwWuuEankfojgSKO1NyvYUSxq/9owXLrMWFgGHVO5fOa
         z0EM2RqbG+Klr9kup4P36gUojRbmfHd8PA20keTpRM7PW88WsttKB+Q+IAk5B7pbRN
         GGaJ3pGl3x+EMzN+OyRZOOI/awMA5HzjcyrTTT/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.4 114/162] parisc/entry: fix trace test in syscall exit path
Date:   Wed, 24 Nov 2021 12:56:57 +0100
Message-Id: <20211124115702.008509176@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@stackframe.org>

commit 3ec18fc7831e7d79e2d536dd1f3bc0d3ba425e8a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/entry.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1850,7 +1850,7 @@ syscall_restore:
 
 	/* Are we being ptraced? */
 	LDREG	TI_FLAGS-THREAD_SZ_ALGN-FRAME_SIZE(%r30),%r19
-	ldi	_TIF_SYSCALL_TRACE_MASK,%r2
+	ldi	_TIF_SINGLESTEP|_TIF_BLOCKSTEP,%r2
 	and,COND(=)	%r19,%r2,%r0
 	b,n	syscall_restore_rfi
 


