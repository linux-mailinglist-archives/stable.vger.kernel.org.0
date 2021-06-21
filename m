Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60AA73AF08D
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhFUQuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231193AbhFUQr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:47:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9F6A613D5;
        Mon, 21 Jun 2021 16:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293230;
        bh=DK0jrc9aLqjY4uS0DncI2NlQJ1L/JxTz08f1emlc+Fo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m+btn0xMTzljSzlii3SGUh1qRcjGadd3kXLnmNbu6Jnhob9IEu2JMFiVfvkEPuVIC
         0rzQX9eAJw5XovUBMABmY8sggR9uSrypwFBQX0LlVHYkJ1JoGcTRCVAoBvu6cpKXcE
         e+AgcgHISpt9aXClRUxH1JgX7Yh+ofS7jChn0Ryg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.12 147/178] powerpc/perf: Fix crash in perf_instruction_pointer() when ppmu is not set
Date:   Mon, 21 Jun 2021 18:16:01 +0200
Message-Id: <20210621154927.773646088@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

commit 60b7ed54a41b550d50caf7f2418db4a7e75b5bdc upstream.

On systems without any specific PMU driver support registered, running
perf record causes Oops.

The relevant portion from call trace:

  BUG: Kernel NULL pointer dereference on read at 0x00000040
  Faulting instruction address: 0xc0021f0c
  Oops: Kernel access of bad area, sig: 11 [#1]
  BE PAGE_SIZE=4K PREEMPT CMPCPRO
  SAF3000 DIE NOTIFICATION
  CPU: 0 PID: 442 Comm: null_syscall Not tainted 5.13.0-rc6-s3k-dev-01645-g7649ee3d2957 #5164
  NIP:  c0021f0c LR: c00e8ad8 CTR: c00d8a5c
  NIP perf_instruction_pointer+0x10/0x60
  LR  perf_prepare_sample+0x344/0x674
  Call Trace:
    perf_prepare_sample+0x7c/0x674 (unreliable)
    perf_event_output_forward+0x3c/0x94
    __perf_event_overflow+0x74/0x14c
    perf_swevent_hrtimer+0xf8/0x170
    __hrtimer_run_queues.constprop.0+0x160/0x318
    hrtimer_interrupt+0x148/0x3b0
    timer_interrupt+0xc4/0x22c
    Decrementer_virt+0xb8/0xbc

During perf record session, perf_instruction_pointer() is called to
capture the sample IP. This function in core-book3s accesses
ppmu->flags. If a platform specific PMU driver is not registered, ppmu
is set to NULL and accessing its members results in a crash. Fix this
crash by checking if ppmu is set.

Fixes: 2ca13a4cc56c ("powerpc/perf: Use regs->nip when SIAR is zero")
Cc: stable@vger.kernel.org # v5.11+
Reported-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Tested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1623952506-1431-1-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/perf/core-book3s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -2242,7 +2242,7 @@ unsigned long perf_instruction_pointer(s
 	bool use_siar = regs_use_siar(regs);
 	unsigned long siar = mfspr(SPRN_SIAR);
 
-	if (ppmu->flags & PPMU_P10_DD1) {
+	if (ppmu && (ppmu->flags & PPMU_P10_DD1)) {
 		if (siar)
 			return siar;
 		else


