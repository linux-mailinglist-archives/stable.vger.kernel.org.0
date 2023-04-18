Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4EA6E6699
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjDROFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:05:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjDROFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:05:19 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E44183D4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:05:18 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f0a80b686eso15779585e9.1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826717; x=1684418717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=17aAtpIJioBBShuvcIVHRSN+EwrnFJl6A4cMSgbgg/0=;
        b=M2UXJhW3BVHPQZK5/ya2BYqi1WmWGd2YyBn6dW6JEZ7pgZbOzQE6+kXotagRYd3Hgd
         z5bwJCiUNU6wRiMGyF/BAP/iWjmQJcOrP05GEl+k6zsBXWfkDYTegM/6kB3ylB6XLwV4
         P9Nf+nl2nKhGnJPZPQGX7wMLlDyr4HX0xI4Gv7eoUYTudejLPnUjSnN3oWirFBnt6d4N
         6vFKgY+V9lBOcbuYRAYjr/ypod6IcDarZ8vF4YfICQwY/AfDsJGHbn5MZOLQBHufS6Cz
         R7YBxw3v/J5mBWKuegvzmghAVNM1NpoEPbfh6nyBEpf0bSsOz1e6JwXmgcZqkv8d67Bs
         PklA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826717; x=1684418717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=17aAtpIJioBBShuvcIVHRSN+EwrnFJl6A4cMSgbgg/0=;
        b=Dg4yfLqc+hGwpZXPqSABtS+2ZjY+WxFmskA45pME3WJ/duXlJ/pzI7NDWQ8BLnGmGS
         2j9jSZPPhYn/0p0ix+iTH2XUTcNvpRvgMYU2rLSZpUqUe+0q7lIRudTou36t/m6cqZ9z
         D0+oyQ2Q1zg+eQBlmI5mCCiag778KfpdkTbgKHm1HwYkuiox53/lRnPtKPckD1iZpEYA
         f3yhNSeR5Nxkn5B4GG1Q06ZNIKj3/j4LHBw5VVmtNQpiZ++dEtjYnoLh+qLZWN4uh2N1
         fTvEsVD9aHuvq77jvgQwF6QLE3m3YmauByULn+7j9NPEnk9AgbJKBwZFBK/xSrW8IjcT
         WJXA==
X-Gm-Message-State: AAQBX9eUV/AZfcIuJgHJ/LckhbEWCaAF7UyDddq2IdPnCFZugElvHeMm
        emSdiapBVOcc0kGZtCZNqnO0VAAESMVb5peR62k=
X-Google-Smtp-Source: AKy350bB7nlMoWlIm8XOzZRro2ZIuiraFbHnnsOIti+2lseiyVk/KXr0357+R3gn3Ak7k935Ea1f7Q==
X-Received: by 2002:adf:fe50:0:b0:2e6:348:5fef with SMTP id m16-20020adffe50000000b002e603485fefmr2031632wrs.55.1681826716189;
        Tue, 18 Apr 2023 07:05:16 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id e16-20020a5d4e90000000b002f2782978d8sm13101943wru.20.2023.04.18.07.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:05:15 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Qais Yousef <qyousef@layalina.io>
Subject: [PATCH 2/3] sched/fair: Consider capacity inversion in util_fits_cpu()
Date:   Tue, 18 Apr 2023 15:04:53 +0100
Message-Id: <20230418140454.87367-3-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140454.87367-1-qyousef@layalina.io>
References: <20230418140454.87367-1-qyousef@layalina.io>
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
index b53b6f6e56d6..1de54a6c2176 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4465,12 +4465,16 @@ static inline int util_fits_cpu(unsigned long util,
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

