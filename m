Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A6A2F51A
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388594AbfE3Eoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:52834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728781AbfE3DMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:00 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2DBD244B0;
        Thu, 30 May 2019 03:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185919;
        bh=PVPVlU2mJhGWN977JM1V2+R3IFbSesKHyzzRBu0vZeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRUZ9yhf7Ky/GdcRC9jp0JTi8J0yUVDi4U1n4itfveJCHq/LXztIPj5SXy8Z//tTA
         Y58b+/eQWhwcbhuc9MFg7UMZgiH0HNdBvkyMk/ZON/uFGBtp2Pa2a6E8eebgzpXHws
         AmamwyPy9OtwiS/zK6cCjWc68Uq0DWMwiygQpxAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <rong.a.chen@intel.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 306/405] rcutorture: Fix cleanup path for invalid torture_type strings
Date:   Wed, 29 May 2019 20:05:04 -0700
Message-Id: <20190530030556.302242343@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b813afae7ab6a5e91b4e16cc567331d9c2ae1f04 ]

If the specified rcutorture.torture_type is not in the rcu_torture_init()
function's torture_ops[] array, rcutorture prints some console messages
and then invokes rcu_torture_cleanup() to set state so that a future
torture test can run.  However, rcu_torture_cleanup() also attempts to
end the test that didn't actually start, and in doing so relies on the
value of cur_ops, a value that is not particularly relevant in this case.
This can result in confusing output or even follow-on failures due to
attempts to use facilities that have not been properly initialized.

This commit therefore sets the value of cur_ops to NULL in this case
and inserts a check near the beginning of rcu_torture_cleanup(),
thus avoiding relying on an irrelevant cur_ops value.

Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index f14d1b18a74fc..a2efe27317bef 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2094,6 +2094,10 @@ rcu_torture_cleanup(void)
 			cur_ops->cb_barrier();
 		return;
 	}
+	if (!cur_ops) {
+		torture_cleanup_end();
+		return;
+	}
 
 	rcu_torture_barrier_cleanup();
 	torture_stop_kthread(rcu_torture_fwd_prog, fwd_prog_task);
@@ -2267,6 +2271,7 @@ rcu_torture_init(void)
 		pr_cont("\n");
 		WARN_ON(!IS_MODULE(CONFIG_RCU_TORTURE_TEST));
 		firsterr = -EINVAL;
+		cur_ops = NULL;
 		goto unwind;
 	}
 	if (cur_ops->fqs == NULL && fqs_duration != 0) {
-- 
2.20.1



