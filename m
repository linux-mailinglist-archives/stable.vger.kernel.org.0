Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A141FA7019
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbfICQ0t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730105AbfICQ0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:26:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71CB1238C6;
        Tue,  3 Sep 2019 16:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528007;
        bh=REnPNTLrhxtJ3anH3iT9BiT+jJLrbT6d4WeR9kfmNM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TfXxUsdAOlM7lAddg++FEUOfV+TcIoRH4UeTb8DRRucBruYZ4G20bBfd/awpWBoa+
         NCHkaqwdGKBQWBb+1Jqez+NvSxvlvjxr5YYLc0IOgCMtPt+W3r9ptDNY9F4X2Jf9k8
         /gyjWKMb4SM1mWWrjThROWvUVlYNaMYzP9QQM008=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 050/167] ARC: mm: do_page_fault fixes #1: relinquish mmap_sem if signal arrives while handle_mm_fault
Date:   Tue,  3 Sep 2019 12:23:22 -0400
Message-Id: <20190903162519.7136-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

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
@@ -143,12 +143,17 @@ void do_page_fault(unsigned long address, struct pt_regs *regs)
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

