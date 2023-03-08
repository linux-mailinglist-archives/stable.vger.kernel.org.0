Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED5A6B0E84
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCHQWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjCHQWg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:22:36 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80131B7DBB
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:22:35 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id l25so15958678wrb.3
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6nzPPKPMrrryqwLrZQWWwBP+D779TAq0gGgfB/a2hM=;
        b=m5Ky6UMGiV4afUyGpUB2iLL+mUEdEJjhk6fo0CY+rBqH5/OkBsfygkiIknSbZKbzbp
         /Pi1s4DTYGKTsTP5KmF/BYvj1lR2auiVy1m91Ow54akvGpUryjd6F38XWduof77vKY1E
         rwGQfXxtpWQoN1teaCRYPUfY+RiPvxuB0ae3SUTQZMqxwyPd+Y8JTctCcwFRSWPDOXMh
         PV4TGC7bBBmpYLZLcRGhgle9U0PEn1T2LF3f5M/mhzXMQmc4Cl3t0r3PLt93riOktZrA
         796JTP0t23uV//Nh479TlIgwckgejVZ3M7l5265aVDmkrCcuFP1kDWuz78xonIOCAPIo
         F+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l6nzPPKPMrrryqwLrZQWWwBP+D779TAq0gGgfB/a2hM=;
        b=zjczJTAUrdluB4fkwKdkEtRHMNdf9kgRu/2DFFs/SCIQ3SoPWR9qefLD+LcgrgTNFb
         HMZ0y/y+XdrL9Lh9qFMQ5AUNLCCHoE6nfd4cHbGbLFv64zKha3UtK5L7W6a1IByq37Ux
         2JBuVaZBQUMp37yE5EmGN9Y1+2JBsv95TCUmrNBd7FIfJI9nbBKPEUAgoOtZa89hWzUJ
         E2+V9BMogNYdVJEb9FDjJ1osU0eoIou53vAbId3etAJtt3ZYlEV66DNfvzTTDVFuZZed
         6iaAz7JoUMxM3+XixGKYY7vdqBKzbRXmn4QjGLUc7pYy+Ka26GVZIev+tXSznju80Nl5
         +Xyg==
X-Gm-Message-State: AO0yUKXBbp3UlQU/WXJUZSJwMC8XjNmkmoD46lUp4VnyjWa6jTHH9q7P
        bJWU4E8e/V+BLRJmLj49q9qoRPwAAbr6AV49jqs=
X-Google-Smtp-Source: AK7set9kAA/ZDaMq4UEWi1EirL757ne1QFSwLfO5imOv8YvFg1HhiEDfvlrJ4w6NpRnKSlmQ1kDuYQ==
X-Received: by 2002:adf:e990:0:b0:2c5:9eaa:831 with SMTP id h16-20020adfe990000000b002c59eaa0831mr10494967wrm.69.1678292553967;
        Wed, 08 Mar 2023 08:22:33 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id r8-20020a5d4e48000000b002c5d3f0f737sm15786015wrt.30.2023.03.08.08.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:22:33 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 5/7] sched/fair: Consider capacity inversion in util_fits_cpu()
Date:   Wed,  8 Mar 2023 16:22:05 +0000
Message-Id: <20230308162207.2886641-6-qyousef@layalina.io>
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

commit aa69c36f31aadc1669bfa8a3de6a47b5e6c98ee8 upstream.

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
index e472f1849092..a9ae621d58cb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4159,12 +4159,16 @@ static inline int util_fits_cpu(unsigned long util,
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

