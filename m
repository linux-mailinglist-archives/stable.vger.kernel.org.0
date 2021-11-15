Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3774513AC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348603AbhKOTyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343828AbhKOTWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7D80635F2;
        Mon, 15 Nov 2021 18:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002020;
        bh=9V0xfq1pZHTHLowIkoCjJ7cS7Qyf39rtxP8WkmGKoRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZN53YLJ/TkaM1P7vHw6DGI56ejpEwuKBMXDxb7F/3IsAgauR9yNaKcu0ZcyX0OGK8
         C+okk/sRYgMSN6LK3m5/l9V3bOIoGqsAvhwfNZZ1o7TKbw2Ls2L6+rOo9Q8dqOEKuz
         zRJTQy3u+THHcm/rAVD+sjhZBFop/qH9g1xE0eqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 407/917] rcu: Fix rcu_dynticks_curr_cpu_in_eqs() vs noinstr
Date:   Mon, 15 Nov 2021 17:58:22 +0100
Message-Id: <20211115165442.593517721@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 74aece72f95f399dd29363669dc32a1344c8fab4 ]

  vmlinux.o: warning: objtool: rcu_nmi_enter()+0x36: call to __kasan_check_read() leaves .noinstr.text section

noinstr cannot have atomic_*() functions in because they're explicitly
annotated, use arch_atomic_*().

Fixes: 2be57f732889 ("rcu: Weaken ->dynticks accesses and updates")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index bce848e50512e..bdd1dc6de71ab 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -327,7 +327,7 @@ static void rcu_dynticks_eqs_online(void)
  */
 static __always_inline bool rcu_dynticks_curr_cpu_in_eqs(void)
 {
-	return !(atomic_read(this_cpu_ptr(&rcu_data.dynticks)) & 0x1);
+	return !(arch_atomic_read(this_cpu_ptr(&rcu_data.dynticks)) & 0x1);
 }
 
 /*
-- 
2.33.0



