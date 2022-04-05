Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2717D4F31FE
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241159AbiDEKTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344297AbiDEJTJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:19:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD62A23BEB;
        Tue,  5 Apr 2022 02:07:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A13661573;
        Tue,  5 Apr 2022 09:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B791C385A1;
        Tue,  5 Apr 2022 09:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149646;
        bh=bGozNgv5tjLJ84Cay1tq/nxVZeU7A+W6BXdShzv6ds8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qANHCvoKEYK9MreRgxDxgNE6OR7+5Jbq20jsYlrSUVACoWH0jRtHgFLiARDc3D5id
         oae41v9ZYxmhskXL5bJwJHaaEes2ennNxA/Ia+3vBtpvpeI/UzDNmIMOxz2jntUmpV
         KUu2muM/Z1DOxQ2HPk25YyaqUKSrNwgwkLBIbHuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0789/1017] sched/tracing: Report TASK_RTLOCK_WAIT tasks as TASK_UNINTERRUPTIBLE
Date:   Tue,  5 Apr 2022 09:28:22 +0200
Message-Id: <20220405070417.674637916@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 084de9b70a77..46ef8c75802f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1622,6 +1622,14 @@ static inline unsigned int __task_state_index(unsigned int tsk_state,
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



