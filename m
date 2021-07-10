Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABDD3C2E6F
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhGJC1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233393AbhGJC0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:26:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0829961400;
        Sat, 10 Jul 2021 02:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883830;
        bh=HhGH2nShtf085j9Q6EdZ9DG6ZWL1jEl8tbmBg7X1qpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=deixQP7An3FnDv7B3uWbqnPABMgBkchsgjq+mJej9kk2GfdPhtOUW5Osv+201yLRi
         rH4JOojnTmoWRZz7u1UInPQaf7qyIySJMNZJNjhDoniyltuoNA3g9EIN4DLKRFqWQ1
         P1eE3L1QTarKoFZPYr9ozl1Z46YQdlrnJIQ0pfnUe6N2esRxhw0YGj+WrfVu7LZDhh
         WpxYWiEIT/mFD253aw25q6jBiAi3Ve30QyRyUCpbAiYQPj2HM9K/QwR04KfpvOTNjX
         TGK8DyqbB25JswVpHbnT4fkvLliCFK6iASBhqWwVqFDdIiDMt9iu00+Z+1dpu+PhVw
         1Wr93yBvJ0W4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 078/104] s390/processor: always inline stap() and __load_psw_mask()
Date:   Fri,  9 Jul 2021 22:21:30 -0400
Message-Id: <20210710022156.3168825-78-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 9c9a915afd90f7534c16a71d1cd44b58596fddf3 ]

s390 is the only architecture which makes use of the __no_kasan_or_inline
attribute for two functions. Given that both stap() and __load_psw_mask()
are very small functions they can and should be always inlined anyway.

Therefore get rid of __no_kasan_or_inline and always inline these
functions.

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/processor.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/processor.h b/arch/s390/include/asm/processor.h
index 023a15dc25a3..dbd380d81133 100644
--- a/arch/s390/include/asm/processor.h
+++ b/arch/s390/include/asm/processor.h
@@ -207,7 +207,7 @@ static __always_inline unsigned long current_stack_pointer(void)
 	return sp;
 }
 
-static __no_kasan_or_inline unsigned short stap(void)
+static __always_inline unsigned short stap(void)
 {
 	unsigned short cpu_address;
 
@@ -246,7 +246,7 @@ static inline void __load_psw(psw_t psw)
  * Set PSW mask to specified value, while leaving the
  * PSW addr pointing to the next instruction.
  */
-static __no_kasan_or_inline void __load_psw_mask(unsigned long mask)
+static __always_inline void __load_psw_mask(unsigned long mask)
 {
 	unsigned long addr;
 	psw_t psw;
-- 
2.30.2

