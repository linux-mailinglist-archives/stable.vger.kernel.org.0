Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 930D5406234
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhIJAo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233728AbhIJAUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:20:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D07A61101;
        Fri, 10 Sep 2021 00:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233185;
        bh=HmqB+qH72XGDU9O7s5aiYB8gYxyGZHG6dlXlJyxEEe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZzKzbfNFfUapU6dWXZMtY87LJQJOjyY/l5dpIwrncBw7NLFBWNPl3TdQHJxE5/l6d
         a/46VC5ibXrXkdVzsATi8ftSNf7tHgCcQRQNajraDheim8MHwc6WHWN91lyqLruSzD
         L+xfwucIu/Pwq/p/5jtjyiLLpe0z5Feco5EsI9LwaH8GzWu0DFcTNPRIpi0JGozYlm
         VTiviP1OJi3ehdJXLkl2TdN8FlUKEDyMq95kbA9BgKeXQF7FkwzULJFlVv5na+yzV1
         eSmOT46g7pi0xoiHliTNMsdohMvM0aVMJvK0wHjB2naeM62YUwETsk9VKs0szeqGPL
         1T6z8fAL1BPnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.13 60/88] powerpc/32: indirect function call use bctrl rather than blrl in ret_from_kernel_thread
Date:   Thu,  9 Sep 2021 20:17:52 -0400
Message-Id: <20210910001820.174272-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 113ec9ccc8049c3772f0eab46b62c5d6654c09f7 ]

Copied from commit 89bbe4c798bc ("powerpc/64: indirect function call
use bctrl rather than blrl in ret_from_kernel_thread")

blrl is not recommended to use as an indirect function call, as it may
corrupt the link stack predictor.

This is not a performance critical path but this should be fixed for
consistency.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/91b1d242525307ceceec7ef6e832bfbacdd4501b.1629436472.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/entry_32.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 9160285cb2f4..01531906291a 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -142,10 +142,10 @@ ret_from_fork:
 ret_from_kernel_thread:
 	REST_NVGPRS(r1)
 	bl	schedule_tail
-	mtlr	r14
+	mtctr	r14
 	mr	r3,r15
 	PPC440EP_ERR42
-	blrl
+	bctrl
 	li	r3,0
 	b	ret_from_syscall
 
-- 
2.30.2

