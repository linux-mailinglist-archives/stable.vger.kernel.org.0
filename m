Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B24E26F1C0
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbgIRCHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727960AbgIRCHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C8D0238E5;
        Fri, 18 Sep 2020 02:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394855;
        bh=VF4UTKdIP0qSqG3PAh5qbaxMAT9+q28jnpmSM+KnBrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlsC4RNLqdDJGM9fn407HDwjh/ykjMiyR3HqspY7LGgWlyOS8NMY4Rp7sheBd3Fv8
         uJwAFAXmkv87B2szRA8bAWk1ttqLzDQWtXBAFb9C+N0CV7BoAibEQTTM9gASWcMyiq
         q7Pu+RGm/7Cs0ZaI9X5jfMcTaOUnajGzZ4nFJens=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 310/330] x86/speculation/mds: Mark mds_user_clear_cpu_buffers() __always_inline
Date:   Thu, 17 Sep 2020 22:00:50 -0400
Message-Id: <20200918020110.2063155-310-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit a7ef9ba986b5fae9d80f8a7b31db0423687efe4e ]

Prevent the compiler from uninlining and creating traceable/probable
functions as this is invoked _after_ context tracking switched to
CONTEXT_USER and rcu idle.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200505134340.902709267@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/nospec-branch.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 5c24a7b351665..b222a35959467 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -320,7 +320,7 @@ DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
  * combination with microcode which triggers a CPU buffer flush when the
  * instruction is executed.
  */
-static inline void mds_clear_cpu_buffers(void)
+static __always_inline void mds_clear_cpu_buffers(void)
 {
 	static const u16 ds = __KERNEL_DS;
 
@@ -341,7 +341,7 @@ static inline void mds_clear_cpu_buffers(void)
  *
  * Clear CPU buffers if the corresponding static key is enabled
  */
-static inline void mds_user_clear_cpu_buffers(void)
+static __always_inline void mds_user_clear_cpu_buffers(void)
 {
 	if (static_branch_likely(&mds_user_clear))
 		mds_clear_cpu_buffers();
-- 
2.25.1

