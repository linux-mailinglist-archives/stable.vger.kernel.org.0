Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831F023FB2C
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgHHXhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgHHXht (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:37:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF424208E4;
        Sat,  8 Aug 2020 23:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929868;
        bh=vHQKLvC3sJRLNXwWVjhFUagzEPs+oh0rPWSpdLoSuLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ttOVhPt2R6CAqhsqdawICCPK77OA9sOeNu1ole8lbYqThsZukXEmKO+NwXOBUSOFX
         rN3vM5OurOJ0/BogOWcIpcsjYotwBRaPx8sR3eGwAz+NcqfiFBcIokSbK8HAg6ZBi6
         EzadXFhvuLuwDao+I576oQ2R/b5oKfSCGrvuv1S0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 18/58] rcu/tree: Repeat the monitor if any free channel is busy
Date:   Sat,  8 Aug 2020 19:36:44 -0400
Message-Id: <20200808233724.3618168-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233724.3618168-1-sashal@kernel.org>
References: <20200808233724.3618168-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

[ Upstream commit 594aa5975b9b5cfe9edaec06170e43b8c0607377 ]

It is possible that one of the channels cannot be detached
because its free channel is busy and previously queued data
has not been processed yet. On the other hand, another
channel can be successfully detached causing the monitor
work to stop.

Prevent that by rescheduling the monitor work if there are
any channels in the pending state after a detach attempt.

Fixes: 34c881745549e ("rcu: Support kfree_bulk() interface in kfree_rcu()")
Acked-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index d9a49cd6065a2..a3aa129cc8f5f 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -2895,7 +2895,7 @@ static void kfree_rcu_work(struct work_struct *work)
 static inline bool queue_kfree_rcu_work(struct kfree_rcu_cpu *krcp)
 {
 	struct kfree_rcu_cpu_work *krwp;
-	bool queued = false;
+	bool repeat = false;
 	int i;
 
 	lockdep_assert_held(&krcp->lock);
@@ -2931,11 +2931,14 @@ static inline bool queue_kfree_rcu_work(struct kfree_rcu_cpu *krcp)
 			 * been detached following each other, one by one.
 			 */
 			queue_rcu_work(system_wq, &krwp->rcu_work);
-			queued = true;
 		}
+
+		/* Repeat if any "free" corresponding channel is still busy. */
+		if (krcp->bhead || krcp->head)
+			repeat = true;
 	}
 
-	return queued;
+	return !repeat;
 }
 
 static inline void kfree_rcu_drain_unlock(struct kfree_rcu_cpu *krcp,
-- 
2.25.1

