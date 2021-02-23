Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9F63322301
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 01:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbhBWALw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 19:11:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231982AbhBWALo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 19:11:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3C4764E6C;
        Tue, 23 Feb 2021 00:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614039042;
        bh=ZCarbVm1YuL/oQPdBXV9ouS+gRFM2kTIMFpFbA2cPxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZqzwRNv4eDqt5O9T31b6gNjwg0KtfFRSdf9RB05ybV5xvMBUNuKu4vW7gUY1Gnfzt
         KIMkOY7V89PFFsAcCso/qxF81iFZPG9mx7f6Om7hQBKMwP1mm9ui3PDtOd6ZdeRlWm
         ITBppttENx2Q1clhdLloZTX5tRdLbEffVnAFhojuCzNXBBVQH/1g5G4sQ1nGEOzu8u
         aX4vPwXv/rxFjzI/E8BbBmim4aeaxcWPHVB/dilNXkPW31YGDUBRTs0EMR6IcrSDm5
         /TOUdpNFSPcUEO+6/qLS9QMN6Axq2YTN72StYmDlr/ZNfraGbNrpIeY9ZrjoTUvurk
         gd23YkJ1+qIyA==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Boqun Feng <boqun.feng@gmail.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Stable <stable@vger.kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>
Subject: [PATCH 10/13] rcu/nocb: Delete bypass_timer upon nocb_gp wakeup
Date:   Tue, 23 Feb 2021 01:10:08 +0100
Message-Id: <20210223001011.127063-11-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210223001011.127063-1-frederic@kernel.org>
References: <20210223001011.127063-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A NOCB-gp wake up can safely delete the nocb_bypass_timer. nocb_gp_wait()
is going to check again the bypass state and rearm the bypass timer if
necessary.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Neeraj Upadhyay <neeraju@codeaurora.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
---
 kernel/rcu/tree_plugin.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index b62ad79bbda5..9da67b0d3997 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1711,6 +1711,8 @@ static bool __wake_nocb_gp(struct rcu_data *rdp_gp,
 		del_timer(&rdp_gp->nocb_timer);
 	}
 
+	del_timer(&rdp_gp->nocb_bypass_timer);
+
 	if (force || READ_ONCE(rdp_gp->nocb_gp_sleep)) {
 		WRITE_ONCE(rdp_gp->nocb_gp_sleep, false);
 		needwake = true;
-- 
2.25.1

