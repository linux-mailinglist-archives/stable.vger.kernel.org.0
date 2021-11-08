Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4336E44A055
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241538AbhKIBDC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:03:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241535AbhKIBC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:02:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6685561279;
        Tue,  9 Nov 2021 01:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419613;
        bh=RQZBkuTCNLkgmDs2BnOgeIkiEzrKkRq/yceimv6O7wQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fp6mP8wT/ywk6UCHoVwwGPi3EDAHt0WcP8gNjRz63LorV9YWeCh8WSIdnf+RTqJSX
         3mthuRzMOh56ZBW++52cu5KnPj9NGngymppxSUhisqyY2Cff56vW8WTWx4aK/SkX8W
         XXgjSo5obyWid5UiFeiE3pwGAvYKF4odo2Jo4Q/ROeZ+R7DVJx8vNeXlX4KtAiIg64
         /ALz+2C1Ad7sg95+vKYcG6SQ1GRB10ADnZXmMel7QobQQu2c2MI4/6UsPCRm9Aiypl
         Q80NgZPJynBxlu18gmQWHYdm0hnzR1qhqTED4BlD68H2rMDYR1nV0UmGxrFSte0EB/
         1p4aZdCeXVZmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Neeraj Upadhyay <neeraju@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, josh@joshtriplett.org,
        rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 017/146] rcu-tasks: Move RTGS_WAIT_CBS to beginning of rcu_tasks_kthread() loop
Date:   Mon,  8 Nov 2021 12:42:44 -0500
Message-Id: <20211108174453.1187052-17-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174453.1187052-1-sashal@kernel.org>
References: <20211108174453.1187052-1-sashal@kernel.org>
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
index 806160c44b172..6591914af4864 100644
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

