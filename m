Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5836BFBF9
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCRRk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjCRRks (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:40:48 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA99231C6
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:46 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id ip21-20020a05600ca69500b003ed56690948so4716647wmb.1
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679161245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZeBgeZRgKvbbWdcefpQr4KYzbM2xYJ+x6PzQ/FxkhM=;
        b=fhXpBuK1tYYjxAxFpl6wc0Np2ysGn0iLFSRbtpLbQUpmMb95VxxjGRuhTR/1XvYR8c
         7E70Pjo7amexuLTVYJRhQXQ5zb7WO8aILbksaoDfscTcONjnqaEvXc4mw8zMcWEf+ywV
         GY8LQwZXtpH6DkRmtl6zE/mkz/1dZvWiDdeoBnjqGko4+lEYe5YeryjYJwSgoLWjQIc/
         opDsmu+aBs5D8S4E7MybPT9mkkttsAYF18rUoYQ1XUuXablOq+MvQm6uwjifmg7nVrz7
         X7cBeSPQk4e8hHSqU6Vy7tQtF7KGLMCdERr/+KazxiPcWBtla3nAoDyLAl2FGLGt19xF
         hPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679161245;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ZeBgeZRgKvbbWdcefpQr4KYzbM2xYJ+x6PzQ/FxkhM=;
        b=dNbN5hmRJcknQt75lZjVMZi2KOzagFTHlrEZpfUmORziETmemAAbzzKb6wIP77mc3D
         S2vWFWUu4tyhAN8QYPEqVc9gfdCxTLBnlkIBTJBz9eM0YIznZCRNRfaeYt2AopoMZjL0
         4llCUxcv7+QWxNIt0Agkl25eX6bxiE18zkp/x/iSFJqA0U3mOXsy/dEABd3sQpvx6JCs
         Lf+9QI9xUwxCqhRsrY74K3KH0IF5kdUbluxEiOv7aObxwIZH4xuX4XhC2EqjsOJC+iNF
         Bgnrbhte/X8W7tiBk5QGGzIrRRp2fqL95OA60oc3RlthImV6LxMMibVQXEWkmsPL+hwV
         iAfQ==
X-Gm-Message-State: AO0yUKULHlz7ZwIA6TqyQ9xEaoVWt30GrFu8Hip3iL+XBNJN/SubdSrj
        iFy6938pQzdqBVO9OVl7jN/vSX/PxQ4e1McD5rU=
X-Google-Smtp-Source: AK7set+qiuz5tl2vWwACwB65BQAd72MbWBkKsOZGppnJ4gOo68h26nW2SC8Ggn8nbvDBRkTLPwopCA==
X-Received: by 2002:a05:600c:2052:b0:3de:a525:1d05 with SMTP id p18-20020a05600c205200b003dea5251d05mr5387271wmg.8.1679161245379;
        Sat, 18 Mar 2023 10:40:45 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003e203681b26sm5313886wmj.29.2023.03.18.10.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:40:45 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 08/10] sched/fair: Consider capacity inversion in util_fits_cpu()
Date:   Sat, 18 Mar 2023 17:39:41 +0000
Message-Id: <20230318173943.3188213-9-qyousef@layalina.io>
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

