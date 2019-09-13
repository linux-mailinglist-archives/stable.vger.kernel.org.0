Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F79B1EF9
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388978AbfIMNOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:14:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388983AbfIMNOf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:14:35 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B539E21734;
        Fri, 13 Sep 2019 13:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380474;
        bh=UDR+5hImiLzYx7LmLJEvKFLTLIW+pBVxrLeNRlnantY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wp4pWSbGeQRQLNNTjuVral8rt1vd9Or8TuyiFIgtQB2XMNmxCQ9mjATu240zXZx/d
         VqyvYKOv7LqJKBv2KHs6IfvFHsT43vfBRBuc4dk1t5m1xX3kR11OYiSusi900MIHyU
         P7V/+E2+jnjRSOvvESLJV/0H0FRI8jXKLWRjI1xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 077/190] ARC: mm: do_page_fault fixes #1: relinquish mmap_sem if signal arrives while handle_mm_fault
Date:   Fri, 13 Sep 2019 14:05:32 +0100
Message-Id: <20190913130605.678955806@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4d447455e73b47c43dd35fcc38ed823d3182a474 ]

do_page_fault() forgot to relinquish mmap_sem if a signal came while
handling handle_mm_fault() - due to say a ctl+c or oom etc.
This would later cause a deadlock by acquiring it twice.

This came to light when running libc testsuite tst-tls3-malloc test but
is likely also the cause for prior seen LTP failures. Using lockdep
clearly showed what the issue was.

| # while true; do ./tst-tls3-malloc ; done
| Didn't expect signal from child: got `Segmentation fault'
| ^C
| ============================================
| WARNING: possible recursive locking detected
| 4.17.0+ #25 Not tainted
| --------------------------------------------
| tst-tls3-malloc/510 is trying to acquire lock:
| 606c7728 (&mm->mmap_sem){++++}, at: __might_fault+0x28/0x5c
|
|but task is already holding lock:
|606c7728 (&mm->mmap_sem){++++}, at: do_page_fault+0x9c/0x2a0
|
| other info that might help us debug this:
|  Possible unsafe locking scenario:
|
|       CPU0
|       ----
|  lock(&mm->mmap_sem);
|  lock(&mm->mmap_sem);
|
| *** DEADLOCK ***
|

------------------------------------------------------------
What the change does is not obvious (note to myself)

prior code was

| do_page_fault
|
|   down_read()		<-- lock taken
|   handle_mm_fault	<-- signal pending as this runs
|   if fatal_signal_pending
|       if VM_FAULT_ERROR
|           up_read
|       if user_mode
|          return	<-- lock still held, this was the BUG

New code

| do_page_fault
|
|   down_read()		<-- lock taken
|   handle_mm_fault	<-- signal pending as this runs
|   if fatal_signal_pending
|       if VM_FAULT_RETRY
|          return       <-- not same case as above, but still OK since
|                           core mm already relinq lock for FAULT_RETRY
|    ...
|
|   < Now falls through for bug case above >
|
|   up_read()		<-- lock relinquished

Cc: stable@vger.kernel.org
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/mm/fault.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arc/mm/fault.c b/arch/arc/mm/fault.c
index db6913094be3c..f28db0b112a30 100644
--- a/arch/arc/mm/fault.c
+++ b/arch/arc/mm/fault.c
@@ -143,12 +143,17 @@ good_area:
 	 */
 	fault = handle_mm_fault(vma, address, flags);
 
-	/* If Pagefault was interrupted by SIGKILL, exit page fault "early" */
 	if (unlikely(fatal_signal_pending(current))) {
-		if ((fault & VM_FAULT_ERROR) && !(fault & VM_FAULT_RETRY))
-			up_read(&mm->mmap_sem);
-		if (user_mode(regs))
+
+		/*
+		 * if fault retry, mmap_sem already relinquished by core mm
+		 * so OK to return to user mode (with signal handled first)
+		 */
+		if (fault & VM_FAULT_RETRY) {
+			if (!user_mode(regs))
+				goto no_context;
 			return;
+		}
 	}
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, address);
-- 
2.20.1



