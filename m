Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E5544A100
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238350AbhKIBHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:07:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237342AbhKIBFD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:05:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A613A61360;
        Tue,  9 Nov 2021 01:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419717;
        bh=oS0rWzOE16NivlIzBeRY3vNUtdeZ3qqt0/5WQ+AX5rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0qv8uO6s8ysUga3Z2ecrvJQCZtSbmRzXPP+U8IgFtMYGJK+qrMlM2+3Be/YsY7mc
         DfIkQnJyEuua0077ZLfmaOiUgHcqulVuxZ6ZAev7lbfLrt6DIW1I7cztDO2MIAIKN/
         lhQkJ89xJweuvJIdGw3ne1xlJhQ99Gfw7/AZ5HM0KSw5K0B6jsmD+l6PA/z4Wf3Uun
         qAdwJzSTtUTXOuB+4SbgN/O7QA45tY4pZLK/0DVtw4VlkJf4ZFawSn7XQ6RH8eeQBS
         iTO33IXX1tTvgD1zjw7JFaFW/g1m5yIvt0WATOG0grnSxK6Japw+CuL0smNWjXFzjK
         sqFlgkZghBQ9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 015/138] rcu-tasks: Move RTGS_WAIT_CBS to beginning of rcu_tasks_kthread() loop
Date:   Mon,  8 Nov 2021 12:44:41 -0500
Message-Id: <20211108174644.1187889-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit 0db7c32ad3160ae06f497d48a74bd46a2a35e6bf ]

Early in debugging, it made some sense to differentiate the first
iteration from subsequent iterations, but now this just causes confusion.
This commit therefore moves the "set_tasks_gp_state(rtp, RTGS_WAIT_CBS)"
statement to the beginning of the "for" loop in rcu_tasks_kthread().

Reported-by: Neeraj Upadhyay <neeraju@codeaurora.org>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tasks.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 8536c55df5142..fd3909c59b6a4 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -197,6 +197,7 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 	 * This loop is terminated by the system going down.  ;-)
 	 */
 	for (;;) {
+		set_tasks_gp_state(rtp, RTGS_WAIT_CBS);
 
 		/* Pick up any new callbacks. */
 		raw_spin_lock_irqsave(&rtp->cbs_lock, flags);
@@ -236,8 +237,6 @@ static int __noreturn rcu_tasks_kthread(void *arg)
 		}
 		/* Paranoid sleep to keep this from entering a tight loop */
 		schedule_timeout_idle(rtp->gp_sleep);
-
-		set_tasks_gp_state(rtp, RTGS_WAIT_CBS);
 	}
 }
 
-- 
2.33.0

