Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F50F35CCF0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243726AbhDLQcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245225AbhDLQaA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:30:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35AA961354;
        Mon, 12 Apr 2021 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244758;
        bh=BH5uT9wWnkuOJ8bQZILH7EHiUw3+Hb0DcX3SRKvVRL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKIqBGlIfKy39a/Z8hKqY7Ooed+UI2DztIEIZpxAU6kz+RxZvQ4zHjlPLFwQeEosJ
         fdaRBHH4gnIfRAO1k/zDgVxdjAA7OB47S6jIk8b/AAJQHTacQWNjVADssjDDKp72mp
         0qsQneVpfJTCvNrtvfKDhco99YADDVlE1hxkae+7ym25boH6dt7RXBpbUipvSOgusV
         654k3K50VqZc3fkLeFYCgjdhWrec1CSkPDu0HugHEcAxQ1hM5ROTTvLy9FfKjOCbK3
         yRkUR58CuHMF4nIs6JR4jhOy2kdT9J8G57Uuezl5CydKNDpMGgq0s359XBWYEXpkzW
         Nk56DtJNxxEHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 04/28] lockdep: Add a missing initialization hint to the "INFO: Trying to register non-static key" message
Date:   Mon, 12 Apr 2021 12:25:29 -0400
Message-Id: <20210412162553.315227-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162553.315227-1-sashal@kernel.org>
References: <20210412162553.315227-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3a85969e9d912d5dd85362ee37b5f81266e00e77 ]

Since this message is printed when dynamically allocated spinlocks (e.g.
kzalloc()) are used without initialization (e.g. spin_lock_init()),
suggest to developers to check whether initialization functions for objects
were called, before making developers wonder what annotation is missing.

[ mingo: Minor tweaks to the message. ]

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20210321064913.4619-1-penguin-kernel@I-love.SAKURA.ne.jp
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 8a1758b094b7..126c6d524a0f 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -722,7 +722,8 @@ static bool assign_lock_key(struct lockdep_map *lock)
 		/* Debug-check: all keys must be persistent! */
 		debug_locks_off();
 		pr_err("INFO: trying to register non-static key.\n");
-		pr_err("the code is fine but needs lockdep annotation.\n");
+		pr_err("The code is fine but needs lockdep annotation, or maybe\n");
+		pr_err("you didn't initialize this object before use?\n");
 		pr_err("turning off the locking correctness validator.\n");
 		dump_stack();
 		return false;
-- 
2.30.2

