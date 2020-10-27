Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF2C629B4B0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752793AbgJ0PCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:02:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789761AbgJ0PCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:02:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB05020747;
        Tue, 27 Oct 2020 15:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810967;
        bh=JXZONq7X0oCbEAnznopNN9JnAMd0U9fKlt09WB8qHoY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S71CDBwapHpoHH/erP4HXPrF9B1djl5LCxEntc8Z8K7DsWuyzCk4n2JxcjGvV91qk
         FYmtwMnHkKXhibR1SbM83dIVkBxht1PiEMhT/Vw3+W6KmmT/sM3VdOsvkjspC3INKF
         W16XLRn8cEgNlGYN8CcVCUwEJR12VVzHEHhRlhtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 327/633] rcu/tree: Force quiescent state on callback overload
Date:   Tue, 27 Oct 2020 14:51:10 +0100
Message-Id: <20201027135538.021558130@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neeraj Upadhyay <neeraju@codeaurora.org>

[ Upstream commit 9c39245382de4d52a122641952900709d4a9950b ]

On callback overload, it is necessary to quickly detect idle CPUs,
and rcu_gp_fqs_check_wake() checks for this condition.  Unfortunately,
the code following the call to this function does not repeat this check,
which means that in reality no actual quiescent-state forcing, instead
only a couple of quick and pointless wakeups at the beginning of the
grace period.

This commit therefore adds a check for the RCU_GP_FLAG_OVLD flag in
the post-wakeup "if" statement in rcu_gp_fqs_loop().

Fixes: 1fca4d12f4637 ("rcu: Expedite first two FQS scans under callback-overload conditions")
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 1e9e500ff7906..572a79b1a8510 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -1882,7 +1882,7 @@ static void rcu_gp_fqs_loop(void)
 			break;
 		/* If time for quiescent-state forcing, do it. */
 		if (!time_after(rcu_state.jiffies_force_qs, jiffies) ||
-		    (gf & RCU_GP_FLAG_FQS)) {
+		    (gf & (RCU_GP_FLAG_FQS | RCU_GP_FLAG_OVLD))) {
 			trace_rcu_grace_period(rcu_state.name, rcu_state.gp_seq,
 					       TPS("fqsstart"));
 			rcu_gp_fqs(first_gp_fqs);
-- 
2.25.1



