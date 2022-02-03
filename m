Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30794A8E2C
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbiBCUfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:35:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354476AbiBCUdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:33:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632ECC0617BC;
        Thu,  3 Feb 2022 12:33:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0150D61B05;
        Thu,  3 Feb 2022 20:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80802C340F0;
        Thu,  3 Feb 2022 20:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920395;
        bh=Gp4lZMUWtUqof2YOT21LQIdrUUR7ioeSZppaIqJ5ESE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EMdY4PkJxRwh1HG8d9SdN7Ecsl84r5tkDUYY7LNrqEd+ImWXaITmCSg4falhGWf/L
         7LxkQ76G4PJ5h1WbXFTSKnDAe9jqd5zjYLgGrsUtMX/ZybhYJxBm2eWZA40Yto4gUR
         s3h4ho4OpX4kXnQGHZKOGAp+fv5J3VPz2uxWxr1PfmJWwhC1bLb6kyIVVYjxQC5ubc
         PMZ2xXXUtEQTep7Oh7qrS162HGQ8Du7r7UI9X2Yjkc+XgKXUvJKXvWIWZd3haBOpY0
         lGEdZES6xZGrKyf4My94w53pSP+8gz4pkzkEhCB04Bl0Bx+X3EWKI8IyMl/t2kvAY5
         mpdD1q6WE9F7A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        xuhaifeng <xuhaifeng@oppo.com>, Sasha Levin <sashal@kernel.org>,
        mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org
Subject: [PATCH AUTOSEL 5.15 18/41] sched: Avoid double preemption in __cond_resched_*lock*()
Date:   Thu,  3 Feb 2022 15:32:22 -0500
Message-Id: <20220203203245.3007-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 7e406d1ff39b8ee574036418a5043c86723170cf ]

For PREEMPT/DYNAMIC_PREEMPT the *_unlock() will already trigger a
preemption, no point in then calling preempt_schedule_common()
*again*.

Use _cond_resched() instead, since this is a NOP for the preemptible
configs while it provide a preemption point for the others.

Reported-by: xuhaifeng <xuhaifeng@oppo.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/YcGnvDEYBwOiV0cR@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0d12ec7be3017..c2dec6ce98091 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8199,9 +8199,7 @@ int __cond_resched_lock(spinlock_t *lock)
 
 	if (spin_needbreak(lock) || resched) {
 		spin_unlock(lock);
-		if (resched)
-			preempt_schedule_common();
-		else
+		if (!_cond_resched())
 			cpu_relax();
 		ret = 1;
 		spin_lock(lock);
@@ -8219,9 +8217,7 @@ int __cond_resched_rwlock_read(rwlock_t *lock)
 
 	if (rwlock_needbreak(lock) || resched) {
 		read_unlock(lock);
-		if (resched)
-			preempt_schedule_common();
-		else
+		if (!_cond_resched())
 			cpu_relax();
 		ret = 1;
 		read_lock(lock);
@@ -8239,9 +8235,7 @@ int __cond_resched_rwlock_write(rwlock_t *lock)
 
 	if (rwlock_needbreak(lock) || resched) {
 		write_unlock(lock);
-		if (resched)
-			preempt_schedule_common();
-		else
+		if (!_cond_resched())
 			cpu_relax();
 		ret = 1;
 		write_lock(lock);
-- 
2.34.1

