Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 488753A95F
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbfFIRDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:03:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387765AbfFIRDU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:03:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BC9320840;
        Sun,  9 Jun 2019 17:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099799;
        bh=exr5VrKN2HiPAqvHZsPTLreAnSfu4iNJj4l+IMGWFko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kYWCK+GxA6sQj29Z6JJEocH6p/2qR/KgYO1sCFKkgNU0OjJcVgDJk0YN5Z5sUAwnB
         6VFwlOLvg5L/h1IyEIqVWLjPwcKG4CrYEqqSlHM74wr4MViKWVlLjroBAkSnp71fpF
         y1N9XJFKw2LqyOsiXLAiHukbLwf2LurNgansMfk4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <rong.a.chen@intel.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 169/241] rcutorture: Fix cleanup path for invalid torture_type strings
Date:   Sun,  9 Jun 2019 18:41:51 +0200
Message-Id: <20190609164152.657821644@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
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
index d89328e260df6..041a02b334d73 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1603,6 +1603,10 @@ rcu_torture_cleanup(void)
 			cur_ops->cb_barrier();
 		return;
 	}
+	if (!cur_ops) {
+		torture_cleanup_end();
+		return;
+	}
 
 	rcu_torture_barrier_cleanup();
 	torture_stop_kthread(rcu_torture_stall, stall_task);
@@ -1741,6 +1745,7 @@ rcu_torture_init(void)
 			pr_alert(" %s", torture_ops[i]->name);
 		pr_alert("\n");
 		firsterr = -EINVAL;
+		cur_ops = NULL;
 		goto unwind;
 	}
 	if (cur_ops->fqs == NULL && fqs_duration != 0) {
-- 
2.20.1



