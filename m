Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C24A14D99
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfEFOxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbfEFOrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38C5F205ED;
        Mon,  6 May 2019 14:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154054;
        bh=3MntDR9kUmhFdar+ptPW4odvKho86UrhSYTPEEofWs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2SXarBdFxdIo/o9j8G+V+X09jdgtlAtDDK9YsqM61n2sQ32hadTMh+pWXij92TLkO
         zbscBVeSVAEAdywCFhnNjC30TUhYx5q+Zmfs2ru8SZ/4T0NNBPj4T+r3ypEhjpFX3F
         9f05rIqdbQkMxq9i761qXkBACHp7lTKlq9pCdKVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.9 20/62] arm64: mm: dont print out page table entries on EL0 faults
Date:   Mon,  6 May 2019 16:32:51 +0200
Message-Id: <20190506143052.802065560@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristina Martsenko <kristina.martsenko@arm.com>

commit bf396c09c2447a787d02af34cf167e953f85fa42 upstream.

When we take a fault from EL0 that can't be handled, we print out the
page table entries associated with the faulting address. This allows
userspace to print out any current page table entries, including kernel
(TTBR1) entries. Exposing kernel mappings like this could pose a
security risk, so don't print out page table information on EL0 faults.
(But still print it out for EL1 faults.) This also follows the same
behaviour as x86, printing out page table entries on kernel mode faults
but not user mode faults.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/mm/fault.c |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -231,7 +231,6 @@ static void __do_user_fault(struct task_
 		pr_info("%s[%d]: unhandled %s (%d) at 0x%08lx, esr 0x%03x\n",
 			tsk->comm, task_pid_nr(tsk), inf->name, sig,
 			addr, esr);
-		show_pte(addr);
 		show_regs(regs);
 	}
 


