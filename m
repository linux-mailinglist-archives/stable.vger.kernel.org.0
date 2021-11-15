Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7C3945277E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344519AbhKPCZy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:25:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236620AbhKORYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6852963274;
        Mon, 15 Nov 2021 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996554;
        bh=cEGt+sVEagdCK+aCvHbgs6njTuxAEVnO4PgOynNRAEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R8MTfnecxx6eJiApRSMJgW3b+XES93kZX+csJCUjmwZk/VWPlEhKkFXOZ08sFnDjJ
         6g16mB0dgQfVoB9+PFpEJQrLdqnrEf0CXyPztbbLyYmFafcGO/MApH6I7P40AzEr3v
         YILnZhAGapFB1e+ZsBjaPEIHuhMDg3aZnivcda98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neeraj Upadhyay <neeraju@codeaurora.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 183/355] rcu: Fix existing exp request check in sync_sched_exp_online_cleanup()
Date:   Mon, 15 Nov 2021 18:01:47 +0100
Message-Id: <20211115165319.697720565@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neeraj Upadhyay <neeraju@codeaurora.org>

[ Upstream commit f0b2b2df5423fb369ac762c77900bc7765496d58 ]

The sync_sched_exp_online_cleanup() checks to see if RCU needs
an expedited quiescent state from the incoming CPU, sending it
an IPI if so. Before sending IPI, it checks whether expedited
qs need has been already requested for the incoming CPU, by
checking rcu_data.cpu_no_qs.b.exp for the current cpu, on which
sync_sched_exp_online_cleanup() is running. This works for the
case where incoming CPU is same as self. However, for the case
where incoming CPU is different from self, expedited request
won't get marked, which can potentially delay reporting of
expedited quiescent state for the incoming CPU.

Fixes: e015a3411220 ("rcu: Avoid self-IPI in sync_sched_exp_online_cleanup()")
Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_exp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index df90d4d7ad2e2..4c4d7683a4e5b 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -738,7 +738,7 @@ static void sync_sched_exp_online_cleanup(int cpu)
 	my_cpu = get_cpu();
 	/* Quiescent state either not needed or already requested, leave. */
 	if (!(READ_ONCE(rnp->expmask) & rdp->grpmask) ||
-	    __this_cpu_read(rcu_data.cpu_no_qs.b.exp)) {
+	    rdp->cpu_no_qs.b.exp) {
 		put_cpu();
 		return;
 	}
-- 
2.33.0



