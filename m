Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A9C36AE0D
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbhDZHl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233471AbhDZHjj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4FE3613C8;
        Mon, 26 Apr 2021 07:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422655;
        bh=Fouv3NN5oEBL/d/ydlB7DSZrNlu0Mmi8aw+PNHYn5uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBZZJwGKjjM6JqjAJ1KT7XqTUwsqX4FmeXb8FMMBJIYP/cJ47ePe8cqxPe3do6xer
         Emby8KlBwfV4dwD6wIJOajP5r1MG9twVmFogq5o8jW/UMH7f9zVnADR2WaRARBrpT8
         hVe2ZsluDh6r60wkTnFHzP5Irv9Bx3fqClxLe32A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 52/57] s390/entry: save the caller of psw_idle
Date:   Mon, 26 Apr 2021 09:29:49 +0200
Message-Id: <20210426072822.332964862@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
References: <20210426072820.568997499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

[ Upstream commit a994eddb947ea9ebb7b14d9a1267001699f0a136 ]

Currently psw_idle does not allocate a stack frame and does not
save its r14 and r15 into the save area. Even though this is valid from
call ABI point of view, because psw_idle does not make any calls
explicitly, in reality psw_idle is an entry point for controlled
transition into serving interrupts. So, in practice, psw_idle stack
frame is analyzed during stack unwinding. Depending on build options
that r14 slot in the save area of psw_idle might either contain a value
saved by previous sibling call or complete garbage.

  [task    0000038000003c28] do_ext_irq+0xd6/0x160
  [task    0000038000003c78] ext_int_handler+0xba/0xe8
  [task   *0000038000003dd8] psw_idle_exit+0x0/0x8 <-- pt_regs
 ([task    0000038000003dd8] 0x0)
  [task    0000038000003e10] default_idle_call+0x42/0x148
  [task    0000038000003e30] do_idle+0xce/0x160
  [task    0000038000003e70] cpu_startup_entry+0x36/0x40
  [task    0000038000003ea0] arch_call_rest_init+0x76/0x80

So, to make a stacktrace nicer and actually point for the real caller of
psw_idle in this frequently occurring case, make psw_idle save its r14.

  [task    0000038000003c28] do_ext_irq+0xd6/0x160
  [task    0000038000003c78] ext_int_handler+0xba/0xe8
  [task   *0000038000003dd8] psw_idle_exit+0x0/0x6 <-- pt_regs
 ([task    0000038000003dd8] arch_cpu_idle+0x3c/0xd0)
  [task    0000038000003e10] default_idle_call+0x42/0x148
  [task    0000038000003e30] do_idle+0xce/0x160
  [task    0000038000003e70] cpu_startup_entry+0x36/0x40
  [task    0000038000003ea0] arch_call_rest_init+0x76/0x80

Reviewed-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/entry.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 150130c897c3..7e6a9cf863c7 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -949,6 +949,7 @@ ENTRY(ext_int_handler)
  * Load idle PSW. The second "half" of this function is in .Lcleanup_idle.
  */
 ENTRY(psw_idle)
+	stg	%r14,(__SF_GPRS+8*8)(%r15)
 	stg	%r3,__SF_EMPTY(%r15)
 	larl	%r1,.Lpsw_idle_lpsw+4
 	stg	%r1,__SF_EMPTY+8(%r15)
-- 
2.30.2



