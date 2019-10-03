Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C375BCAAB4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392330AbfJCRLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:37808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403803AbfJCQbI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:31:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C588120865;
        Thu,  3 Oct 2019 16:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120268;
        bh=2et6kh5u9FLYVe88GeLbMKtsoeoF/CZr/Ah6IeVbid4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OwFmk8nMoSBRRZMu6bJfnUxbir7MjHKAFtzbX5hCPx9IU0STzq1poqPD4e74Clsv
         jDen2+aWi4d7IMogItKV2f6kyL97fqI87alzNdJjQeNqqVHUD47bYHYsg4Z5mceRTV
         zszV/ck5DGwbmniF/dfBJUQylyV7ltqKZGNGogMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 157/313] x86/mm/pti: Do not invoke PTI functions when PTI is disabled
Date:   Thu,  3 Oct 2019 17:52:15 +0200
Message-Id: <20191003154548.392993969@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



