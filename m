Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AB66E669E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbjDROGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDROGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:06:01 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AD713866
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:00 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id v3so2561560wml.0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826759; x=1684418759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=weOU2dU3gqoCllGshbAFNi/wPiQw2N8nLzQAUD/oZvg=;
        b=qgxVFoHWu4SBBeay9/dRa15/cxlG4M+QWElcfkarW6XDh5dCHxcvc+ENduTbs6Okx5
         u5ZRXxIosJZmpiAt7W3yA2D9fZkURt+8rFpRLc4fMtg4G1huTAA1crFI4KvuUb5iQXCV
         Y0RReqFUF2YI9PnFxhkt1atFGxd0sUI1DYJQ5xck130DZX0frNtKtaRa5wYI1DxrKcSz
         ua+O4dQH+HpiMLd33hZVGPg3HkILbNjKnSjGdCAIojyLGQOEZG1MHj1hE8byNFmaF/ZL
         GubF7EmJ29EoKsmGZ2uYz0g0ncFOfQjlT6uInm9fTIQpZ49ERnUM2NfTq8eUgTconrSR
         V27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826759; x=1684418759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=weOU2dU3gqoCllGshbAFNi/wPiQw2N8nLzQAUD/oZvg=;
        b=P9GSInEKf4xMvxGqrrd3VcHoN3b8kBJ4DvH6zqf5Op2yhp34covuccr9wIPM6VT8Ya
         fAorv6SNScnLgF4PPL1AFphBxfcqf1QvPFNxEie67X+iCtDqn1DRZVdw/XIRXLCxkJ4U
         EhCNNluxmXO882fwbXnzqgGHTwhn1XpHfYIpBRZ7xlz0LQlPeXlYv5pRhbg734EepRJw
         y46JmjNffObCRbfbk6S57iqbUwXRY+KmUuWSY9FbWP5HI2p7YywmDQhjVbWP4pJBLjeW
         /UAZ1UIPiXY9qBXHOl3WRLSlRTf3QVw5z/EStXn5PY8yNI7c8LAkjHAu1JwwuGUhORMU
         q4LQ==
X-Gm-Message-State: AAQBX9dABcynCx/UO1GuV0ZsHW+6qwOmtkIs14jooMOlPKyyBsj77Rp0
        84XfuXhIJ940L6oNP8tz3vH+b7ojXAleMBnjStM=
X-Google-Smtp-Source: AKy350bobuxWojcuXEQILK4RoH6QNYBCFrXJXunVfuD54WUNwtt+YwNvFXC6zhLLB7+h9JbtECf+MQ==
X-Received: by 2002:a7b:c004:0:b0:3ed:ea48:cd92 with SMTP id c4-20020a7bc004000000b003edea48cd92mr14857939wmb.15.1681826758985;
        Tue, 18 Apr 2023 07:05:58 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c210900b003f17c1384c4sm571420wml.12.2023.04.18.07.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:05:58 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH RESEND 2/7] sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
Date:   Tue, 18 Apr 2023 15:05:42 +0100
Message-Id: <20230418140547.88035-3-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140547.88035-1-qyousef@layalina.io>
References: <20230418140547.88035-1-qyousef@layalina.io>
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

