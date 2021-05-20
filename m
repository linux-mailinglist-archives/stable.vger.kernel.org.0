Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD8638AB82
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbhETLZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239734AbhETLWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 07:22:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDAEC613E9;
        Thu, 20 May 2021 10:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621505496;
        bh=IcjHdlf9KxllRu2dQjiU+p5/Nicq0fCb64u7Ewrsj1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UoPOCzsBbSI3oJWpmVqW6kGQDgro+cBdOqXFANSwt1Qo5GSIqCbZ1mtZCHyhOFOe/
         i9rDF0T8C0tJz8G9ZUQkI+NazxfXm3aKxBsX0tSMtv3ELAToGpBSiqhsC1GT/Lx9Tp
         4FZrfIKzaG17M++ONz0vbS22E9MRPILvBmHtof2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shahab Vahedi <shahab@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 4.4 162/190] ARC: entry: fix off-by-one error in syscall number validation
Date:   Thu, 20 May 2021 11:23:46 +0200
Message-Id: <20210520092107.524217122@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092102.149300807@linuxfoundation.org>
References: <20210520092102.149300807@linuxfoundation.org>
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
@@ -181,7 +181,7 @@ tracesys:
 
 	; Do the Sys Call as we normally would.
 	; Validate the Sys Call number
-	cmp     r8,  NR_syscalls
+	cmp     r8,  NR_syscalls - 1
 	mov.hi  r0, -ENOSYS
 	bhi     tracesys_exit
 
@@ -264,7 +264,7 @@ ENTRY(EV_Trap)
 	;============ Normal syscall case
 
 	; syscall num shd not exceed the total system calls avail
-	cmp     r8,  NR_syscalls
+	cmp     r8,  NR_syscalls - 1
 	mov.hi  r0, -ENOSYS
 	bhi     ret_from_system_call
 


