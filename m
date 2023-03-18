Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8186C6BFBF6
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCRRko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjCRRkn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:40:43 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775E62312F
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:41 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso5138896wmo.0
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679161240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=544uuq3F9dLXA/08+tMENDXO1zPaLb7o7naTx3gxOpw=;
        b=kTKHVWPQV23S2D1r4nH3QlYUP6Xleh7Kjqo7Bf2VnPHsiIbc5SeunxfSAsp/iVcDYu
         MsbZh5TJrzTurWLgFlyTqE8DGrXYyHK4M8s04kLxvWQ3xwoEWt07xnPU1Ib+Bbm55iDL
         Q0H6I1aMIHAQHbu793vZDseR5McVonEZdsn3yQ5PnyWwdjSJBNPMR1zSOaZoslOZ3FAY
         4Jz4F7zq64lgLQrV5sTaZeZ+Z7mYHZkY/kF8DPjTwDT9NBYfjmMPEdl1WCFStUYW3Xfx
         ov9eEpUlPxC5oE2pYUk8UpKHad0E21w5xerY+QY1UsQy0qn8mARwA8SlEP/MghnSB2K/
         LUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679161240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=544uuq3F9dLXA/08+tMENDXO1zPaLb7o7naTx3gxOpw=;
        b=ePOJIiolGdFO/xRonuPwoarVGAOD+0sgreKP1ix6LkA3kWQ41FBymZ12PmBn+1ZJMR
         w4oQEZhcoV12CUMU9DykawIMoN8cDaOHA4xohrHhbGkxLOwtycd21qdWj0sVohDEm25V
         eLCgK7rIk13ZDNfi8J5wzGN0QvqUM4h1mBXI06+7qbokf3GsqbLENlhPVt1AFkwWTLSC
         tfxGLkX/QcwlQ9OKIY8hCq1j9zYioceWzEpbodcNjyvkt4VjJhffaqLn5i4hZ+N59Xhf
         +1aQziuHnjxVXoomZdcLmcnGm0mvtou+GEu5WsMghOGPiyLdn1e+JLaGWaBwxtltbebp
         Gnkw==
X-Gm-Message-State: AO0yUKWaHF4SJKIveK+/8N0af0+MZhwGPTKNi7wUfIrKt+rpy9/0a1wT
        2eBVyGx8kJM+P8Ho7WKr0EWQnCx1deQ3ZK2rHBU=
X-Google-Smtp-Source: AK7set++p4qgG0tp24EqccvFmfoMiXULTIOB+HRicNH2YVC5bRMzIT+BqSPBMmetSg6nwldYtDH5FA==
X-Received: by 2002:a05:600c:540a:b0:3ea:e582:48dd with SMTP id he10-20020a05600c540a00b003eae58248ddmr28593959wmb.34.1679161239963;
        Sat, 18 Mar 2023 10:40:39 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003e203681b26sm5313886wmj.29.2023.03.18.10.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:40:39 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 05/10] sched/uclamp: Make cpu_overutilized() use util_fits_cpu()
Date:   Sat, 18 Mar 2023 17:39:38 +0000
Message-Id: <20230318173943.3188213-6-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230318173943.3188213-1-qyousef@layalina.io>
References: <20230318173943.3188213-1-qyousef@layalina.io>
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

