Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1848B2A59A1
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbgKCUkD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:40:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730127AbgKCUj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:39:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 983932224E;
        Tue,  3 Nov 2020 20:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604435999;
        bh=+2fPEDkeuBa0U3jZ0ahFGPzrljTJ2aqNeor3jcAZEDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sp3rn0eSoKksPvvqKqI9QYtfAqDFJhX16TdIQFmWrJgZuy6x+XZvw3k95U4Ay3/o+
         XbLul5me7hAt0keTfQNq8mrETUFBQPtvlqidsyBvHQpB/9ILx5QaE6wHBU8nilLQdy
         cmFL4jDZeF6KwZeAUd3BKmwN1DwaTzhiUnWd4rn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 021/391] x86/alternative: Dont call text_poke() in lazy TLB mode
Date:   Tue,  3 Nov 2020 21:31:12 +0100
Message-Id: <20201103203349.326507694@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit abee7c494d8c41bb388839bccc47e06247f0d7de ]

When running in lazy TLB mode the currently active page tables might
be the ones of a previous process, e.g. when running a kernel thread.

This can be problematic in case kernel code is being modified via
text_poke() in a kernel thread, and on another processor exit_mmap()
is active for the process which was running on the first cpu before
the kernel thread.

As text_poke() is using a temporary address space and the former
address space (obtained via cpu_tlbstate.loaded_mm) is restored
afterwards, there is a race possible in case the cpu on which
exit_mmap() is running wants to make sure there are no stale
references to that address space on any cpu active (this e.g. is
required when running as a Xen PV guest, where this problem has been
observed and analyzed).

In order to avoid that, drop off TLB lazy mode before switching to the
temporary address space.

Fixes: cefa929c034eb5d ("x86/mm: Introduce temporary mm structs")
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201009144225.12019-1-jgross@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/alternative.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index cdaab30880b91..cd6be6f143e85 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -807,6 +807,15 @@ static inline temp_mm_state_t use_temporary_mm(struct mm_struct *mm)
 	temp_mm_state_t temp_state;
 
 	lockdep_assert_irqs_disabled();
+
+	/*
+	 * Make sure not to be in TLB lazy mode, as otherwise we'll end up
+	 * with a stale address space WITHOUT being in lazy mode after
+	 * restoring the previous mm.
+	 */
+	if (this_cpu_read(cpu_tlbstate.is_lazy))
+		leave_mm(smp_processor_id());
+
 	temp_state.mm = this_cpu_read(cpu_tlbstate.loaded_mm);
 	switch_mm_irqs_off(NULL, mm, current);
 
-- 
2.27.0



