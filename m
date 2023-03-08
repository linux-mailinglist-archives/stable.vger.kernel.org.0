Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8F0C6B0E5D
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjCHQRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:17:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjCHQRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:17:01 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B8EC3633
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:16:39 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so1495783wmq.1
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=544uuq3F9dLXA/08+tMENDXO1zPaLb7o7naTx3gxOpw=;
        b=bP8s/x/W1z2NiiAlht2Pns8EaaE0uwgJD7H3kXQAKpEUn7lSr5S6YYuBWGZw+aKDxV
         mtb80EEw8aoL2jJnADOVlEWi5pmssLW+c5mBim9Iy8nm9gcEZg1DQOIeHeEN+ifKHRWb
         PvhzyrAZwQpbjPsviE4tWpmsrVEy9qPhiLyCIJr6UvY/OcPvzpB68RiAZdVJRPZiiMtv
         q47I3P/DpwARN6UZSOcV8B44arrBgWqcRFi0XlW6xMnvyZgztylWN4s8qzvzN90FhX3r
         w90006KrKAHODWhI41OiWaE++qKWsBYeTpwV3JgZQ6MIJw2+BBv2+5e9kXNCRN5Locid
         O0Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=544uuq3F9dLXA/08+tMENDXO1zPaLb7o7naTx3gxOpw=;
        b=n+DXwwfUut4cQpu//NCwRL2G2LrGZfhRzANyRF3D9AKGvoXCOdx3KBlY2P6VCIvGx9
         gGz3m0W9FADYGKj4Gj/foUH474DKW6z5jZtEv+FSNxvTjZJP83lE5hntBJTm8Vi9B1vj
         wHRFepPUn4AkJ3UE0LpS9dT/UfDVx7sLZD5ax8To4NS/U/VANErnd67UAe+gfeZ/9/mz
         RGOPrptPin6E4BgPnbRCteL0z8f7v0tAD6J8tljFsMd8miUsxRkAUBqCWska3B/FSciS
         f4Sq0lIvDzr3q7BAIon79bzsslITwK17EIWLPJo8fmlGRsNhdzBbKNrkig/sLNpImdco
         6lNg==
X-Gm-Message-State: AO0yUKWNYw3bYvteSrP4k4tPmZc26Koap3pehFbBaiTb4anH8IdyEXUb
        lSbjI1C/WxXpfzBxAtswnPKU5btZiZhAxlr0yOg=
X-Google-Smtp-Source: AK7set+y3FmrUs6M5SYro2KSJuUItp3XxeITJQoUNQCEx8mxVHeo6Vm77NnuTZU76MF8b7eMi40zww==
X-Received: by 2002:a05:600c:35ca:b0:3db:3476:6f02 with SMTP id r10-20020a05600c35ca00b003db34766f02mr15941742wmq.41.1678292197594;
        Wed, 08 Mar 2023 08:16:37 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d6087000000b002c567b58e9asm15862379wrt.56.2023.03.08.08.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:16:37 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 05/10] sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
Date:   Wed,  8 Mar 2023 16:15:53 +0000
Message-Id: <20230308161558.2882972-6-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308161558.2882972-2-qyousef@layalina.io>
References: <20230308161558.2882972-2-qyousef@layalina.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
[Conflict in kernel/sched/fair.c: use cpu_util() instead of
cpu_util_cfs()]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b03633bc994f..fdfbed1e9be5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5610,7 +5610,10 @@ static inline unsigned long cpu_util(int cpu);
 
 static inline bool cpu_overutilized(int cpu)
 {
-	return !fits_capacity(cpu_util(cpu), capacity_of(cpu));
+	unsigned long rq_util_min = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MIN);
+	unsigned long rq_util_max = uclamp_rq_get(cpu_rq(cpu), UCLAMP_MAX);
+
+	return !util_fits_cpu(cpu_util(cpu), rq_util_min, rq_util_max, cpu);
 }
 
 static inline void update_overutilized_status(struct rq *rq)
-- 
2.25.1

