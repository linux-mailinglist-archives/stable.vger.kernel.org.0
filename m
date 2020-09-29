Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C5A27C630
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbgI2Lmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:40044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730453AbgI2Lma (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:42:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6D6E206F7;
        Tue, 29 Sep 2020 11:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379750;
        bh=VF4UTKdIP0qSqG3PAh5qbaxMAT9+q28jnpmSM+KnBrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WW26/LqVX2o8MxKGHan8yuJv26q5mhZcKlcj3Bpnp16gmvz3bD6rfCNymg7gNkHpc
         ZIWLjv4yxmk1x+BP03nrjxamMCAX6kHhCKA2Ck9JYMAL+sPhgNr3sEfR2fBOuTSItY
         PADEtAJwq8NgVaOAkzmJeMTqznjahizBtVegIvno=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 301/388] x86/speculation/mds: Mark mds_user_clear_cpu_buffers() __always_inline
Date:   Tue, 29 Sep 2020 13:00:32 +0200
Message-Id: <20200929110025.033152962@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



