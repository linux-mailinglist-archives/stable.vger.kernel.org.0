Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B74F6ECD38
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232007AbjDXNVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232027AbjDXNVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:21:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B445E49FD
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91A9162209
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:21:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5310C433A0;
        Mon, 24 Apr 2023 13:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342476;
        bh=bB7ZOSh4TORDmWGI3374u5WwOIG/GDEF6YT5jR2n8XY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrCgRYn7zdX6sDusl6MkSFluaxaIZYIy/UQoUTlpaRlXoCLxXW2K+OvQODZUSgOpv
         2uLGSx43NKCNXmGXjIAA0uykVd3i654my7mPmS4b/XC1RnMlaDRCxfB2uN5PNWT8rz
         WS5R3/U0P6EDFoFjfCHzWm0j9rpzaQTzDsmnFcxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Qais Yousef (Google)" <qyousef@layalina.io>
Subject: [PATCH 5.15 46/73] sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
Date:   Mon, 24 Apr 2023 15:17:00 +0200
Message-Id: <20230424131130.689803419@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

commit c56ab1b3506ba0e7a872509964b100912bde165d upstream.

So that it is now uclamp aware.

This fixes a major problem of busy tasks capped with UCLAMP_MAX keeping
the system in overutilized state which disables EAS and leads to wasting
energy in the long run.

Without this patch running a busy background activity like JIT
compilation on Pixel 6 causes the system to be in overutilized state
74.5% of the time.

With this patch this goes down to  9.79%.

It also fixes another problem when long running tasks that have their
UCLAMP_MIN changed while running such that they need to upmigrate to
honour the new UCLAMP_MIN value. The upmigration doesn't get triggered
because overutilized state never gets set in this state, hence misfit
migration never happens at tick in this case until the task wakes up
again.

Fixes: af24bde8df202 ("sched/uclamp: Add uclamp support to energy_compute()")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-7-qais.yousef@arm.com
(cherry picked from commit c56ab1b3506ba0e7a872509964b100912bde165d)
[Fixed trivial conflict in cpu_overutilized() - use cpu_util() instead
of cpu_util_cfs()]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5739,7 +5739,10 @@ static inline unsigned long cpu_util(int
 
 static inline bool cpu_overutilized(int cpu)
 {
-	return !fits_capacity(cpu_util(cpu), capacity_of(cpu));
+	unsigned long rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
+	unsigned long rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
+
+	return !util_fits_cpu(cpu_util(cpu), rq_util_min, rq_util_max, cpu);
 }
 
 static inline void update_overutilized_status(struct rq *rq)


