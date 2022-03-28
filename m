Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098084EA00E
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 21:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245600AbiC1Tnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 15:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241259AbiC1Tns (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 15:43:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F3D5C659;
        Mon, 28 Mar 2022 12:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1907612B2;
        Mon, 28 Mar 2022 19:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D84CC34100;
        Mon, 28 Mar 2022 19:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648496526;
        bh=bk9cWPr/wjcvI1DpKgD6lGJ0CQY4X1di6UU/QY0bodk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fGe1iyRRVDxFQqX0PvvfzczrEp0NXbuzjWIFWXMnLPjgNHIAdLM8v7O3KNtmXdZ9n
         6hPKH2LqS3lkoavtpiTJWePb8htCASii73h9tFklkjt+QIFdJFcADTNR/sCGhTnEtY
         cffgASjjxBMd27j2T4sSMh6m+sjvOfLr+nhxcxG1hZfJTgwm1g31NaIXS3MlWGl1GX
         iUTeQN75K7ZFpCZk/Bc/hP/Jy97XO97STdonwsRpgrK8EY+VLYo3WZ8b1bGx37a56l
         9/0yJpZrMClSB3TkwIpOFpxtvXWKcx96OkBWRntXjnrSAV+KjAKgpw0Lj59pjlsaBe
         2lwgpoDRs7/Og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valentin Schneider <valentin.schneider@arm.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com
Subject: [PATCH AUTOSEL 5.17 06/21] sched/tracing: Report TASK_RTLOCK_WAIT tasks as TASK_UNINTERRUPTIBLE
Date:   Mon, 28 Mar 2022 15:41:41 -0400
Message-Id: <20220328194157.1585642-6-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328194157.1585642-1-sashal@kernel.org>
References: <20220328194157.1585642-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 25795ef6299f07ce3838f3253a9cb34f64efcfae ]

TASK_RTLOCK_WAIT currently isn't part of TASK_REPORT, thus a task blocking
on an rtlock will appear as having a task state == 0, IOW TASK_RUNNING.

The actual state is saved in p->saved_state, but reading it after reading
p->__state has a few issues:
o that could still be TASK_RUNNING in the case of e.g. rt_spin_lock
o ttwu_state_match() might have changed that to TASK_RUNNING

As pointed out by Eric, adding TASK_RTLOCK_WAIT to TASK_REPORT implies
exposing a new state to userspace tools which way not know what to do with
them. The only information that needs to be conveyed here is that a task is
waiting on an rt_mutex, which matches TASK_UNINTERRUPTIBLE - there's no
need for a new state.

Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/20220120162520.570782-3-valentin.schneider@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index a76a178f8eb6..36e38434391c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1630,6 +1630,14 @@ static inline unsigned int __task_state_index(unsigned int tsk_state,
 	if (tsk_state == TASK_IDLE)
 		state = TASK_REPORT_IDLE;
 
+	/*
+	 * We're lying here, but rather than expose a completely new task state
+	 * to userspace, we can make this appear as if the task has gone through
+	 * a regular rt_mutex_lock() call.
+	 */
+	if (tsk_state == TASK_RTLOCK_WAIT)
+		state = TASK_UNINTERRUPTIBLE;
+
 	return fls(state);
 }
 
-- 
2.34.1

