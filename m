Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD4E26ECC7
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgIRCOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729130AbgIRCOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:14:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E5B5239D4;
        Fri, 18 Sep 2020 02:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395285;
        bh=SI+fWPNrFFRRT2Bdau69PuEhJHWv0Qy0sgSIomMiLeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xLy6WhIWjp3czhpznpPSCKOFinpuBnBX31ApbVlcGtXVCtuQ6bQS+++AM1hIkxlp7
         FVNwKJzyjbd7smWXelFgDz/2DIEOSmTJvWaahlQllPE8nlyVhf1ZGI/rCaqKEW5VJn
         s6vS5NQf+biSe2icVcmpqmP1FfGNOlM0ix5XM+Aw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 120/127] x86/speculation/mds: Mark mds_user_clear_cpu_buffers() __always_inline
Date:   Thu, 17 Sep 2020 22:12:13 -0400
Message-Id: <20200918021220.2066485-120-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918021220.2066485-1-sashal@kernel.org>
References: <20200918021220.2066485-1-sashal@kernel.org>
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
index 041d2a04be1d8..270448b178a7a 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -330,7 +330,7 @@ DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
  * combination with microcode which triggers a CPU buffer flush when the
  * instruction is executed.
  */
-static inline void mds_clear_cpu_buffers(void)
+static __always_inline void mds_clear_cpu_buffers(void)
 {
 	static const u16 ds = __KERNEL_DS;
 
@@ -351,7 +351,7 @@ static inline void mds_clear_cpu_buffers(void)
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

