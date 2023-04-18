Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 957FB6E66BF
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjDROKL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjDROKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:10:10 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCE7CC17
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:08 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id ay3-20020a05600c1e0300b003f17289710aso3535862wmb.5
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681827007; x=1684419007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oL/SZKj4sy5TbUYwqAtD83DRN3/SqY86+LNlauIFk24=;
        b=osWNMOuRK/li33qBduQAuvinxxVWOYT7WXHGgKZ80v8siZkwoYA1bTCIs+vycRM3dv
         eEt+jRaERnWRL8XN3nQaLhxbams97oGzfjYWwftdsc3zExy2RjV+KzZwTzyjWCPpSGzZ
         9r+eofgfnDKWUtWXY6rKwSS+DQEmGLcmD8huA82ya6E+L0B/c9ITpXi9HS/r3Npp9pv1
         kZyVxBNuuF1klmV3xd1W33mtJ56adPm5z4tnHc3oUfmV9Jvu95V43aKcZVYG9KYiJFVb
         dL4opC010K5338B8jH34FKAZ8Qucz6fnR/ynVo3RbfGaIKsn8jK+QMWoST1AJj27kRpx
         aakA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681827007; x=1684419007;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oL/SZKj4sy5TbUYwqAtD83DRN3/SqY86+LNlauIFk24=;
        b=Gyie3kt6WPPDLapLsCDNMy3HAsikwX3l0Z+1VsG7lEaqZWI72nTFcqyxOzL6C7mLw1
         CEH6vhMY5g9FlpyxBvmpJVwMK2BDL8vDTSweW6VDY6Bj/pFPs08zvVmVeZhAbDbVWfI2
         2sJJTBm4TzYtgva9hgRJr+ph1m1ifV3V9ffgS2ADQtZQyyrphVtI61YKxnMCZ03/z6G5
         o3Hq2DsVa3rIGW1zGu6q9WOOEIp1Uyhtbm1WlEM6vucawHbuo/4iuLaKi01342kNNLX3
         XzicdOFCLUn/JgNnIEzj1ykD9ug88ls52q3NZHn52oDg06yLHC0VzAtVYzbbH8AK/R//
         rfKA==
X-Gm-Message-State: AAQBX9feafS/l9PUdIDj3TVKJHzM4JNrcvmZuH4K5sU8ti6HmBZgDPjY
        rvenCmguYi6cLX8sNxHKn7PXESNbqMlu/5Orhtw=
X-Google-Smtp-Source: AKy350aKufkhFZXWYNfSFDOe/S89MQIeeuv1+5N46xmnTvyR0H0BK54bAxyhR3t3ZQkSxN9Ra7TS0Q==
X-Received: by 2002:a05:600c:2152:b0:3f1:76d7:ae2b with SMTP id v18-20020a05600c215200b003f176d7ae2bmr3234252wml.13.1681827007459;
        Tue, 18 Apr 2023 07:10:07 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003f1712b1402sm7978018wmq.30.2023.04.18.07.10.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:10:07 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 RESEND 06/10] sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early exit condition
Date:   Tue, 18 Apr 2023 15:09:39 +0100
Message-Id: <20230418140943.90621-7-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140943.90621-1-qyousef@layalina.io>
References: <20230418140943.90621-1-qyousef@layalina.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

commit d81304bc6193554014d4372a01debdf65e1e9a4d upstream.

If the utilization of the woken up task is 0, we skip the energy
calculation because it has no impact.

But if the task is boosted (uclamp_min != 0) will have an impact on task
placement and frequency selection. Only skip if the util is truly
0 after applying uclamp values.

Change uclamp_task_cpu() signature to avoid unnecessary additional calls
to uclamp_eff_get(). feec() is the only user now.

Fixes: 732cd75b8c920 ("sched/fair: Select an energy-efficient CPU on task wake-up")
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-8-qais.yousef@arm.com
(cherry picked from commit d81304bc6193554014d4372a01debdf65e1e9a4d)
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fdfbed1e9be5..d25c6122e243 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3928,14 +3928,16 @@ static inline unsigned long task_util_est(struct task_struct *p)
 }
 
 #ifdef CONFIG_UCLAMP_TASK
-static inline unsigned long uclamp_task_util(struct task_struct *p)
+static inline unsigned long uclamp_task_util(struct task_struct *p,
+					     unsigned long uclamp_min,
+					     unsigned long uclamp_max)
 {
-	return clamp(task_util_est(p),
-		     uclamp_eff_value(p, UCLAMP_MIN),
-		     uclamp_eff_value(p, UCLAMP_MAX));
+	return clamp(task_util_est(p), uclamp_min, uclamp_max);
 }
 #else
-static inline unsigned long uclamp_task_util(struct task_struct *p)
+static inline unsigned long uclamp_task_util(struct task_struct *p,
+					     unsigned long uclamp_min,
+					     unsigned long uclamp_max)
 {
 	return task_util_est(p);
 }
@@ -6789,7 +6791,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 		goto fail;
 
 	sync_entity_load_avg(&p->se);
-	if (!task_util_est(p))
+	if (!uclamp_task_util(p, p_util_min, p_util_max))
 		goto unlock;
 
 	for (; pd; pd = pd->next) {
-- 
2.25.1

