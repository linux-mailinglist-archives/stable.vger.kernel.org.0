Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1A96E66A1
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjDROGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjDROGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:06:06 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EC313C35
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:04 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id bi21-20020a05600c3d9500b003f17a8eaedbso838267wmb.1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681826763; x=1684418763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6nzPPKPMrrryqwLrZQWWwBP+D779TAq0gGgfB/a2hM=;
        b=zGyh1dgVU74xow7am7X6ZbvE9RBKsKOY81fxxfslme7buEI11tVn8rt/+4Mhlr3aaF
         Cjkhh0stMY+ADE/ihFzBJKw64BZR9be6Ngf1YqB3BLpGdAQzzkd69IysDbHaqvl+YVNR
         2lTlRGOY5xF+hFi+gaAwj9NKy+Rw8nzJcHXmOtEwTvkuzG6vBjHq8DcV+T/MBLA265MS
         3w8UpFmqUJ85Ax2AfYpOBlvNU8WRvTw+nkEON+1MkF59/2bW0jSJJ0QvxFZ0scScnOip
         5Yy0KyhtjBYd4ROBMVabpG90nYh9NDIADeXheuFz2g4AT4k6fFvd1iiG5tgvX4pth/N9
         pu2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681826763; x=1684418763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l6nzPPKPMrrryqwLrZQWWwBP+D779TAq0gGgfB/a2hM=;
        b=DHeD+PrQWkReZFMMmqBSQRIamFVh5kUhc6lNrUC+0m4ItoZoygasbkVkYKZlWM2ay9
         QN5g2VgacCeTVjJ78ibAtqUIwaDOUNI0BmOVSB7TYN6Jth8GW0/VXIgp0dNZezjybc9n
         EsWUbezeTUu50aaHWxsDdNLoyEZWsfN7/A+PY9ckG7T2tF/doOuKdggjV0zKmoaBpMGP
         GhtGiVBjencuQTJF4xoeEPLlCJ9MB92OWGC3HPOIaWpLC/Znlrf42tNLSDNZFRvSMSs/
         emx9B1d2Hv+Ep3hyX5xwAhFOpJlmbAPnCqNGTad/bhfLYcaI5WlFtmVbiKR3iJZvIP5S
         zSSw==
X-Gm-Message-State: AAQBX9dzKcOgjA8QhsiBiQQQDCx0uYqoLk36VaWKeyn+sJaZYapwuFay
        JvV1hwoaLdDUhejcA2aSfkpRqzZGCwTaIzX/3hg=
X-Google-Smtp-Source: AKy350baNBhrfaD6YN0ItF2E4fSIt9vO8JI92VrWVgkG1yacmQsrlM8KYJW59zS0+mhdZ4MrLno2vw==
X-Received: by 2002:a7b:c40b:0:b0:3ed:d3a7:7077 with SMTP id k11-20020a7bc40b000000b003edd3a77077mr12868284wmi.40.1681826763650;
        Tue, 18 Apr 2023 07:06:03 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c210900b003f17c1384c4sm571420wml.12.2023.04.18.07.06.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:06:03 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH RESEND 5/7] sched/fair: Consider capacity inversion in util_fits_cpu()
Date:   Tue, 18 Apr 2023 15:05:45 +0100
Message-Id: <20230418140547.88035-6-qyousef@layalina.io>
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

