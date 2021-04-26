Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6121C36AEA8
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbhDZHqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234136AbhDZHov (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B09360D07;
        Mon, 26 Apr 2021 07:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422894;
        bh=YlKAKyKIsnMUVvz5L53H8DTYTlwH5RuaUg2xCn3wFPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i46F1wY1FykLPUEbbyXsXdt37GYs/9KPRA2/s8ax2YU8KnQzygTAC47dLmmd/Poaa
         yRhH538MNjSR0hUSCVO9Puo4CtbkuwOyG9PdeB0BZTQH+tUAEOfKZR/+WrGBevVG3g
         QSm1Vloh6vsO/dAgrTkBVFEZN5U675XQ1OcqLnNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 34/41] s390/entry: save the caller of psw_idle
Date:   Mon, 26 Apr 2021 09:30:21 +0200
Message-Id: <20210426072820.850679542@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
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
index f1ba197b10c0..f0a215cf010c 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -976,6 +976,7 @@ ENDPROC(ext_int_handler)
  * Load idle PSW.
  */
 ENTRY(psw_idle)
+	stg	%r14,(__SF_GPRS+8*8)(%r15)
 	stg	%r3,__SF_EMPTY(%r15)
 	larl	%r1,.Lpsw_idle_exit
 	stg	%r1,__SF_EMPTY+8(%r15)
-- 
2.30.2



