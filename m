Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 751AA6B0E60
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbjCHQRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:17:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjCHQRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:17:05 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9607EC80BF
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:16:45 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so1693070wmb.3
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZeBgeZRgKvbbWdcefpQr4KYzbM2xYJ+x6PzQ/FxkhM=;
        b=WoD+S1RNAEx5QnB/ZlHL5ANNDGgbsGLbmWyhTjY/P7ThaA5bDcyeXRKkEeQW9pmzT0
         HEiABqjC5HS5nn+XNGyPQ8Xc2CdxnZBKSr3zYyqMlQqIBgYzer9HM6emMlxXQJVDyEyZ
         HnQAv9dHJUjHNohxy5OKEdK28mT+VJ3FSBsEI3Q9AC0pK0ox0PDI+JsO0sA3axfemBXn
         6mcEYW+l3aZ2tzWKLKQEc6wgn66fmkLMDrbEETNXHo6Wc/qJLmzU0AbD40N9riSEY6W2
         43oLgxSodldJX4+jlBAq70qN2r14t/hwx42GB2AbVUn1jav9pDtjZMltQmwPSd+zZAA0
         m57Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ZeBgeZRgKvbbWdcefpQr4KYzbM2xYJ+x6PzQ/FxkhM=;
        b=BHTWx7Z4WgUqfIhkRGHRsicLheOFUoVZ90BrevLgbdO7bMCl8nc0VOy9FfEW4bijHK
         y8LFB43SMg2QePVqEd7jV+LlLsRFCYX1JwCM5pqlVqKFZUORWh6hBAOyjNkmV1lGBUpr
         Ss6UkEqykb2G2Gyjc6Rf2J2IuhYH70T4WR/skCDYPnrgu0h4H8Dwdy6nkFvbNovDCVEN
         p8nsq2eS1364CoeA90BdcMpRD4j5dzDIGT3ZEUZxNI5fvYI1S2CiACD4kgshHT8EF7De
         uXH8lhxhn2UOedHN2rgJ7FT7sC/WBqIG53i+cIG2kixSL1uws5GFAfne5k1R8i/F1Eq0
         562w==
X-Gm-Message-State: AO0yUKWi0Kyq8ocylXYZVPc2UyxpyRqLDSXkOCNy+QNjNQfzS1IQVARr
        T4qp5tOqKpN28BOTi4zpnFWoAGL8AOWe6HxVN4I=
X-Google-Smtp-Source: AK7set8X9VPAce3DdAU+XdPTmOTsmChWSFaJErRwB6NJiMUSvrkydgOtbSN3ozgoUx0nRtIy/F76gg==
X-Received: by 2002:a05:600c:4708:b0:3eb:20f6:2d5c with SMTP id v8-20020a05600c470800b003eb20f62d5cmr17229301wmo.35.1678292204122;
        Wed, 08 Mar 2023 08:16:44 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id w7-20020a5d6087000000b002c567b58e9asm15862379wrt.56.2023.03.08.08.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:16:43 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 08/10] sched/fair: Consider capacity inversion in util_fits_cpu()
Date:   Wed,  8 Mar 2023 16:15:56 +0000
Message-Id: <20230308161558.2882972-9-qyousef@layalina.io>
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

commit: aa69c36f31aadc1669bfa8a3de6a47b5e6c98ee8 upstream.

We do consider thermal pressure in util_fits_cpu() for uclamp_min only.
With the exception of the biggest cores which by definition are the max
performance point of the system and all tasks by definition should fit.

Even under thermal pressure, the capacity of the biggest CPU is the
highest in the system and should still fit every task. Except when it
reaches capacity inversion point, then this is no longer true.

We can handle this by using the inverted capacity as capacity_orig in
util_fits_cpu(). Which not only addresses the problem above, but also
ensure uclamp_max now considers the inverted capacity. Force fitting
a task when a CPU is in this adverse state will contribute to making the
thermal throttling last longer.

Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220804143609.515789-10-qais.yousef@arm.com
(cherry picked from commit aa69c36f31aadc1669bfa8a3de6a47b5e6c98ee8)
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
---
 kernel/sched/fair.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b22f6e80ed62..67db24a7a5f8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4113,12 +4113,16 @@ static inline int util_fits_cpu(unsigned long util,
 	 * For uclamp_max, we can tolerate a drop in performance level as the
 	 * goal is to cap the task. So it's okay if it's getting less.
 	 *
-	 * In case of capacity inversion, which is not handled yet, we should
-	 * honour the inverted capacity for both uclamp_min and uclamp_max all
-	 * the time.
+	 * In case of capacity inversion we should honour the inverted capacity
+	 * for both uclamp_min and uclamp_max all the time.
 	 */
-	capacity_orig = capacity_orig_of(cpu);
-	capacity_orig_thermal = capacity_orig - arch_scale_thermal_pressure(cpu);
+	capacity_orig = cpu_in_capacity_inversion(cpu);
+	if (capacity_orig) {
+		capacity_orig_thermal = capacity_orig;
+	} else {
+		capacity_orig = capacity_orig_of(cpu);
+		capacity_orig_thermal = capacity_orig - arch_scale_thermal_pressure(cpu);
+	}
 
 	/*
 	 * We want to force a task to fit a cpu as implied by uclamp_max.
-- 
2.25.1

