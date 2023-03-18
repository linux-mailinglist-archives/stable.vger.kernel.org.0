Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3079E6BFC71
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 20:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjCRTdo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 15:33:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjCRTdn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 15:33:43 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 054A114498
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:41 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v1so991437wrv.1
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679168020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=weOU2dU3gqoCllGshbAFNi/wPiQw2N8nLzQAUD/oZvg=;
        b=UvZ5iRY+sFVixpY8nW7MuOnuxs6cEbwZ3YA1OYKUE6tYBvLyhXJ3CovmkmoZrd8kja
         hRM14bpfzqSpFbuo8n1Se1tqNsWSZgf2LppZ6Cxt4/zVrlL4ytHHGzIv9TtDt99n9xAg
         i0wxhuIyyaoMBvsNGyCFiTHdgOxALhGp9xgk/TMUeP1QznripmjilxLpzpOzrjvNyG1q
         HS8yYHbGIdzhqynUNtZVfCEbRnhqZmdvdEttwpVsVCD4LJ1LMVYXOg+LnWpljSOcjkUV
         MVdpS7SKwnkni03YJpnRv5TwbHSLHxg/jBqBpPLpkRm9yyLqZJ4zoLrkXTXu7fPv0LjU
         YkuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679168020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=weOU2dU3gqoCllGshbAFNi/wPiQw2N8nLzQAUD/oZvg=;
        b=5LkTMic773RZf5U15Lz9xORgdx6pzIrspRvEvPAzlsXLPbIrrxgec8CeSMYN822W1O
         nKEnxxbUUWqiWpDsPz8+OJtuIixxU9bM/t0h+9WoymUARYBUzSdXSc5aVzSYv+i/Wq29
         7c4fpffpoXauFnpGnArRm8F+kQovgbiPnCgcYvTEj5i634TLE69oKLd7+moKrA2AQQAP
         mbcvlxf2nzzkGRflber1hxS+KxviNovJy6dzeB6sbafiNhp6iAGshbgxIrjYZ32P19+8
         c2tX3GHdxbmxxP3Zgl5UcIJRGes10J2XrugLookhLhjZ0LV1AkJOYvsjCujSFR4VN6az
         R3Nw==
X-Gm-Message-State: AO0yUKX6T5oOroLY3s9GHzPuKtTaq7zgRjvHxJosPO/eJIpwYnw2fAqF
        ucUPGyMCKRrRDG/1K0NdUPrAKT6plcdx1Ka/pYk=
X-Google-Smtp-Source: AK7set+Si//P9kldYv+S1IJfGvbJiUN5A5QpEuG1g1YZpcpFwMigOjVwa8RaR9tqf/W9QGl+DH2rXw==
X-Received: by 2002:a5d:4b8b:0:b0:2d4:4762:48c4 with SMTP id b11-20020a5d4b8b000000b002d4476248c4mr2886910wrt.36.1679168020064;
        Sat, 18 Mar 2023 12:33:40 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id o6-20020adfeac6000000b002c71a32394dsm4968696wrn.64.2023.03.18.12.33.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 12:33:39 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH RESEND 2/7] sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
Date:   Sat, 18 Mar 2023 19:32:57 +0000
Message-Id: <20230318193302.3194615-3-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230318193302.3194615-1-qyousef@layalina.io>
References: <20230318193302.3194615-1-qyousef@layalina.io>
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

