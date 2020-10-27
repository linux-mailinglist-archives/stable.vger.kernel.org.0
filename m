Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0225029B8A6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799491AbgJ0Pm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1800621AbgJ0Pgq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:36:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 882AA2225E;
        Tue, 27 Oct 2020 15:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813006;
        bh=2AgKnr0UrfMFZh5rOTq7UlJqxdO6ePG47xrXyI5Z3CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9CJUGFLcEgJtuzyY3qXBDhBDQ+Jf5N01E85bv+lrfs2ZnWEN95cgLuOF285mxb72
         TK7INFqMqYf7zIGF/xFGS9gbRxKqU9OHRlHXcVycfukKEZwil98Kjjw+R8bbI3xt+5
         voh9R2yk3unVLBTZl9ZVrhq8YAxuq0SVhtdg9HfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <rong.a.chen@intel.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 404/757] rcutorture: Properly set rcu_fwds for OOM handling
Date:   Tue, 27 Oct 2020 14:50:54 +0100
Message-Id: <20201027135509.534792859@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit c8fa63714763b7795a3f5fb7ed6d000763e6dccc ]

The conversion of rcu_fwds to dynamic allocation failed to actually
allocate the required structure.  This commit therefore allocates it,
frees it, and updates rcu_fwds accordingly.  While in the area, it
abstracts the cleanup actions into rcu_torture_fwd_prog_cleanup().

Fixes: 5155be9994e5 ("rcutorture: Dynamically allocate rcu_fwds structure")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index f453bf8d2f1ef..49202099692be 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2160,9 +2160,20 @@ static int __init rcu_torture_fwd_prog_init(void)
 		return -ENOMEM;
 	spin_lock_init(&rfp->rcu_fwd_lock);
 	rfp->rcu_fwd_cb_tail = &rfp->rcu_fwd_cb_head;
+	rcu_fwds = rfp;
 	return torture_create_kthread(rcu_torture_fwd_prog, rfp, fwd_prog_task);
 }
 
+static void rcu_torture_fwd_prog_cleanup(void)
+{
+	struct rcu_fwd *rfp;
+
+	torture_stop_kthread(rcu_torture_fwd_prog, fwd_prog_task);
+	rfp = rcu_fwds;
+	rcu_fwds = NULL;
+	kfree(rfp);
+}
+
 /* Callback function for RCU barrier testing. */
 static void rcu_torture_barrier_cbf(struct rcu_head *rcu)
 {
@@ -2460,7 +2471,7 @@ rcu_torture_cleanup(void)
 	show_rcu_gp_kthreads();
 	rcu_torture_read_exit_cleanup();
 	rcu_torture_barrier_cleanup();
-	torture_stop_kthread(rcu_torture_fwd_prog, fwd_prog_task);
+	rcu_torture_fwd_prog_cleanup();
 	torture_stop_kthread(rcu_torture_stall, stall_task);
 	torture_stop_kthread(rcu_torture_writer, writer_task);
 
-- 
2.25.1



