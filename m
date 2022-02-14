Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23D54B4AB0
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344098AbiBNJ7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:59:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344276AbiBNJ6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:58:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BCA65836;
        Mon, 14 Feb 2022 01:46:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B57C461200;
        Mon, 14 Feb 2022 09:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9A7C340E9;
        Mon, 14 Feb 2022 09:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831968;
        bh=Gp4lZMUWtUqof2YOT21LQIdrUUR7ioeSZppaIqJ5ESE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKOjcjdKHEhu4jmGotdY6sRKUjcHAsqylNie6xwz1CdI2Bl3RTrw6Yki0uy0tOK7Y
         qTfLi4xxhdpPsaYfLM6w6Wlb7RSjM3zBrLxsMD4W1p6HyM9K9iakncwANLjv2chR/t
         BEU19wsQ8g45KlZkxK62UaFjGsWIC+K8NrvJstUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xuhaifeng <xuhaifeng@oppo.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/172] sched: Avoid double preemption in __cond_resched_*lock*()
Date:   Mon, 14 Feb 2022 10:24:56 +0100
Message-Id: <20220214092507.716840592@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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



