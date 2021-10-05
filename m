Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155394228CA
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbhJENyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:54:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235212AbhJENxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:53:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA266619E1;
        Tue,  5 Oct 2021 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441894;
        bh=X2qHAsp56YMNgUDqJUXqXG6yyLbOSmo094q9X/g+quo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwBhkCJlTHpTUYrcTKlG2I/kg3H3veVjyIOHOEynanS1wJKT5P16R8ueKpzEHoiAw
         LpoE63KGWez16MRZ383JgE5OoAeSJMlt2nJGV7NFlmfl+WFvXGPh4a7tSEAIBeMruh
         QwPV4qTYEasBEUFAGYG5zQER/nCcPmXxMrDZMEkYiR9/uH50Fm+tjynofcfMKHTUJ5
         yBbOmAcH4pgxdT7WqXtTab1/ge1peN/b9srFlkKfbXqfyghFVVj1D4wLEQk3KpGj3N
         8K6dWu/T4NuRJJ0ea8Yn5jjha+nCsTAuI//RLh+y/chAL96djbA1LOfcJhifYcNSDd
         4A8DvSJ7RiPVw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org
Subject: [PATCH AUTOSEL 5.14 38/40] sched: Always inline is_percpu_thread()
Date:   Tue,  5 Oct 2021 09:50:17 -0400
Message-Id: <20211005135020.214291-38-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 83d40a61046f73103b4e5d8f1310261487ff63b0 ]

  vmlinux.o: warning: objtool: check_preemption_disabled()+0x81: call to is_percpu_thread() leaves .noinstr.text section

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210928084218.063371959@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index f6935787e7e8..8e10c7accdbc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1633,7 +1633,7 @@ extern struct pid *cad_pid;
 #define tsk_used_math(p)			((p)->flags & PF_USED_MATH)
 #define used_math()				tsk_used_math(current)
 
-static inline bool is_percpu_thread(void)
+static __always_inline bool is_percpu_thread(void)
 {
 #ifdef CONFIG_SMP
 	return (current->flags & PF_NO_SETAFFINITY) &&
-- 
2.33.0

