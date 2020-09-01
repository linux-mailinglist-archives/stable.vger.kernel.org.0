Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4B5259CCD
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgIARUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728834AbgIAPNA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:13:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7487F206FA;
        Tue,  1 Sep 2020 15:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973180;
        bh=Ddpwz/E5gUQcqcz8/r5+5asTNDcAsvUOCUgXTnJurOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKqjqPEJ18TBa0CW6mQQkJYJIYMJ0a760seSOohV4Jt3UsL4HfX5rsUl/uH9W2me5
         E/pstukz7iO/TKAXQcrcD56K7SC0UzRC6QRBi1dk638JZjFqvKfaL511Gk+o5wWxXH
         LJJPJT4Acaf/7UBtoVQ4rA4+YA3f3TirYRYBiy8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 39/62] powerpc/perf: Fix soft lockups due to missed interrupt accounting
Date:   Tue,  1 Sep 2020 17:10:22 +0200
Message-Id: <20200901150922.705693094@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150920.697676718@linuxfoundation.org>
References: <20200901150920.697676718@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Athira Rajeev <atrajeev@linux.vnet.ibm.com>

[ Upstream commit 17899eaf88d689529b866371344c8f269ba79b5f ]

Performance monitor interrupt handler checks if any counter has
overflown and calls record_and_restart() in core-book3s which invokes
perf_event_overflow() to record the sample information. Apart from
creating sample, perf_event_overflow() also does the interrupt and
period checks via perf_event_account_interrupt().

Currently we record information only if the SIAR (Sampled Instruction
Address Register) valid bit is set (using siar_valid() check) and
hence the interrupt check.

But it is possible that we do sampling for some events that are not
generating valid SIAR, and hence there is no chance to disable the
event if interrupts are more than max_samples_per_tick. This leads to
soft lockup.

Fix this by adding perf_event_account_interrupt() in the invalid SIAR
code path for a sampling event. ie if SIAR is invalid, just do
interrupt check and don't record the sample information.

Reported-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Tested-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1596717992-7321-1-git-send-email-atrajeev@linux.vnet.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/core-book3s.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -2040,6 +2040,10 @@ static void record_and_restart(struct pe
 
 		if (perf_event_overflow(event, &data, regs))
 			power_pmu_stop(event, 0);
+	} else if (period) {
+		/* Account for interrupt in case of invalid SIAR */
+		if (perf_event_account_interrupt(event))
+			power_pmu_stop(event, 0);
 	}
 }
 


