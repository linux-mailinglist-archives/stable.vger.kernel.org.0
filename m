Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE6F3835FB
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244175AbhEQP1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245192AbhEQPZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:25:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8CBD61C9D;
        Mon, 17 May 2021 14:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262160;
        bh=9/deoVy0/tN1by8qL0WOlNlc4En/IMSnzchfO2hrlYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VZ2j8jKyrkb4Sh9BsXVpj14couFRlYp3g91RA4/eH5fL6+AA+yCH2WTnSRXQ5Zo0U
         Ydy4WvkjpMivuIQcsgVWnmf8YXlkIhBDyIRk4S3GElBYgxU4vYawXPaiOgdj7T/mcK
         di6No5W2ySyFhDYF0MK+63+tmuSyN7JuyGo2szDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shahab Vahedi <shahab@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.11 229/329] ARC: entry: fix off-by-one error in syscall number validation
Date:   Mon, 17 May 2021 16:02:20 +0200
Message-Id: <20210517140309.861621685@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

commit 3433adc8bd09fc9f29b8baddf33b4ecd1ecd2cdc upstream.

We have NR_syscall syscalls from [0 .. NR_syscall-1].
However the check for invalid syscall number is "> NR_syscall" as
opposed to >=. This off-by-one error erronesously allows "NR_syscall"
to be treated as valid syscall causeing out-of-bounds access into
syscall-call table ensuing a crash (holes within syscall table have a
invalid-entry handler but this is beyond the array implementing the
table).

This problem showed up on v5.6 kernel when testing glibc 2.33 (v5.10
kernel capable, includng faccessat2 syscall 439). The v5.6 kernel has
NR_syscalls=439 (0 to 438). Due to the bug, 439 passed by glibc was
not handled as -ENOSYS but processed leading to a crash.

Link: https://github.com/foss-for-synopsys-dwc-arc-processors/linux/issues/48
Reported-by: Shahab Vahedi <shahab@synopsys.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arc/kernel/entry.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arc/kernel/entry.S
+++ b/arch/arc/kernel/entry.S
@@ -177,7 +177,7 @@ tracesys:
 
 	; Do the Sys Call as we normally would.
 	; Validate the Sys Call number
-	cmp     r8,  NR_syscalls
+	cmp     r8,  NR_syscalls - 1
 	mov.hi  r0, -ENOSYS
 	bhi     tracesys_exit
 
@@ -255,7 +255,7 @@ ENTRY(EV_Trap)
 	;============ Normal syscall case
 
 	; syscall num shd not exceed the total system calls avail
-	cmp     r8,  NR_syscalls
+	cmp     r8,  NR_syscalls - 1
 	mov.hi  r0, -ENOSYS
 	bhi     .Lret_from_system_call
 


