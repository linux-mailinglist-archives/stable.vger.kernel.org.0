Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBE766B0E81
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjCHQWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjCHQWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:22:30 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F12595E31
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:22:28 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id g3so15928664wri.6
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=weOU2dU3gqoCllGshbAFNi/wPiQw2N8nLzQAUD/oZvg=;
        b=pQMXGV6QmV6cLrglW7h0+lVbXdiTBHvnsUpC84RsrN0XlRUJAb+ccdz6xTbKdDFeW/
         UqAJlXB8SIY16mfiGGDMAgDiKiKOux4LrB3u/dhWDVWjI3jsBKo7OGWg+YXpIrQcc/76
         +0XyQ/d9BI5IplzxD0IE0/Sj5IYRXYJnuc2mT4larOGY5OlUJG6bMat8cOmp4qIynBtn
         eBUzd8blOaOKIKAnqfEAWNFEOZDkoFoQ3QMEaY2sSU8SnwUgs8loBfBSmKAo/NQTub99
         of79gOOGRgyaIf8pWT7mbgmrtIUgNSVnYaGcSCeJwsov1As4FtKjR2gpeWqKzXfcwy8+
         YB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=weOU2dU3gqoCllGshbAFNi/wPiQw2N8nLzQAUD/oZvg=;
        b=m7cBbK8Q+7DBM7RZJILLrkDv2qiF5MfIuvWfkiLlBYaYcIQqpDLok8FI1aMLKW95Uy
         Xz5Onj9mkyWVLC3gnl5MFjRBBLj6Lx8+uWWfM8CxLt+l/7GPg9lTRTxD7xlCgiXOiQuD
         YRaMzbcp6qeqsHQ9BvbT3QhW82Oj4FBqAGFYcsugo38t1xfXkiFrQbwOjamY/aoYUQXg
         8csv5vegDtd3g1PLY50XeVPKwX7jjcr6LsGO4UCfmTd7M9GXI0EghTyzxIGhz8qBd9cF
         dxbwWE/NG1wEgWQffN+PpaaaL+MnRKPEJKpYvraiV4JifAGaLvcgoLRJsY75VwLChLE+
         YVRg==
X-Gm-Message-State: AO0yUKU5084uj3fME8SeclneHGe1Hk5DK+EK2XCIsZXMRz8vtVraWPz+
        nDdGVwL4CeyBq6mAcHRPJ4gpZeJ9qFkuk4RT6l8=
X-Google-Smtp-Source: AK7set85dmZxPok5wuCdaLU36DtWlQMd9pg9Nql1kI6pz4JI91M2lyukchVg463U2sEVko2ZLZjLLA==
X-Received: by 2002:a5d:52cd:0:b0:2ca:554c:17ab with SMTP id r13-20020a5d52cd000000b002ca554c17abmr11438248wrv.25.1678292547128;
        Wed, 08 Mar 2023 08:22:27 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id r8-20020a5d4e48000000b002c5d3f0f737sm15786015wrt.30.2023.03.08.08.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:22:26 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 2/7] sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
Date:   Wed,  8 Mar 2023 16:22:02 +0000
Message-Id: <20230308162207.2886641-3-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230308162207.2886641-1-qyousef@layalina.io>
References: <20230308162207.2886641-1-qyousef@layalina.io>
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
[Fixed trivial conflict in cpu_overutilized() - use cpu_util() instead
of cpu_util_cfs()]
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 1f7db97b531e..cd4eccdf3291 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5692,7 +5692,10 @@ static inline unsigned long cpu_util(int cpu);
 
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

