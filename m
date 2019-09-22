Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6E7BAAFA
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390577AbfIVTdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:33:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:44412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390924AbfIVSru (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B497221479;
        Sun, 22 Sep 2019 18:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178069;
        bh=2et6kh5u9FLYVe88GeLbMKtsoeoF/CZr/Ah6IeVbid4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xVs0rNrG1X8f3caEDqiyQSCDlYJMhYYMwZrI6S5UXeTXdrJl0xiHVfMFNA9Vqa+vo
         CYVI9+bVdCQYtvFq95d9gEiFNeipnCi3vIO/qhiupYWi374MCZN3Fur9tL3/3kvz27
         FuFIdr7VmnNtKLCFDRdfc04m0osIq/71nywINIis=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 142/203] x86/mm/pti: Do not invoke PTI functions when PTI is disabled
Date:   Sun, 22 Sep 2019 14:42:48 -0400
Message-Id: <20190922184350.30563-142-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 990784b57731192b7d90c8d4049e6318d81e887d ]

When PTI is disabled at boot time either because the CPU is not affected or
PTI has been disabled on the command line, the boot code still calls into
pti_finalize() which then unconditionally invokes:

     pti_clone_entry_text()
     pti_clone_kernel_text()

pti_clone_kernel_text() was called unconditionally before the 32bit support
was added and 32bit added the call to pti_clone_entry_text().

The call has no side effects as cloning the page tables into the available
second one, which was allocated for PTI does not create damage. But it does
not make sense either and in case that this functionality would be extended
later this might actually lead to hard to diagnose issues.

Neither function should be called when PTI is runtime disabled. Make the
invocation conditional.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20190828143124.063353972@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/pti.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/mm/pti.c b/arch/x86/mm/pti.c
index b196524759ec5..ba22b50f4eca2 100644
--- a/arch/x86/mm/pti.c
+++ b/arch/x86/mm/pti.c
@@ -666,6 +666,8 @@ void __init pti_init(void)
  */
 void pti_finalize(void)
 {
+	if (!boot_cpu_has(X86_FEATURE_PTI))
+		return;
 	/*
 	 * We need to clone everything (again) that maps parts of the
 	 * kernel image.
-- 
2.20.1

