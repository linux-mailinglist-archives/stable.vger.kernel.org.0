Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B3A6BFBF7
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 18:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjCRRkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 13:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjCRRko (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 13:40:44 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B2C2213F
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:43 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id c8-20020a05600c0ac800b003ed2f97a63eso6798845wmr.3
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 10:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679161241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oL/SZKj4sy5TbUYwqAtD83DRN3/SqY86+LNlauIFk24=;
        b=8S5AuS7ZuGnCH4d3hlYZbnI9xLQ32gUSxGnNc24qA59tHZCGeFQ49+ZhvNZJ0PH8Qu
         wOL9UvTjPrqQCDZLdqVurlo9JfI3PohNHYWFWFVtPNWAPT3yFZYBF5xy6rzDw7Jdz0dH
         p9LVIVY/fSZF81uQzYUdTY7xwCY8Q05t0yI7rLYPXCB3KSrhPDRzmvFymjkXM57DYtXt
         aiPTkMFtPJn2iysNMNSIA/ImUT7wnHe6gfx6pzMj7JC8mLI8nZykY8z9XhR8J5zhXTD9
         SBVcl8wYBVGUFqBlUi3bueE19717SvvZPuvVuu1NoxX8ZQG4ytJueg95/b6VNg5jw9MY
         bwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679161241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oL/SZKj4sy5TbUYwqAtD83DRN3/SqY86+LNlauIFk24=;
        b=SUDM/WEXENjhoNcvnTL95uPcZpiAcTF9sEFmWVCCbE1lJOiXt+k+y5irOIy5D/G48c
         7xX2cON6Tt1UJ004sVVK461g1xN34KbMY84hcrm8oH0KCtSEMm3GCnM/dqJrZUeYoRsm
         mJDo8NKKJ486z6gzP7q1clUDFd3bCQeZSwpttvLKRXcnwUJ2zVZ7jR4jlibvVK/fzIhN
         MMQBCg3f1JTTLqxCchBvz0nSr9yqskvILRBWcnsrJoXTojtd1X00FnW2zoipxopvvxn/
         P+qqPfyko/JT0RGwB12ltQCg/WgyRQqCN6E8qKpMMjTdghrn0FGKnj7o6GyZUeCutLqR
         K/pw==
X-Gm-Message-State: AO0yUKXxkNBa5LCqB7w90yBd/fhnMd5aYsI0l9wdjAkn8r5S41XERurV
        YPee55A/xp5A48UMMWJdNm5IU/lbK0bYRoY7DH4=
X-Google-Smtp-Source: AK7set8FO7Om9JhRyGpFQyF1u6iPV/r+OaDWcvuTaFZabe/OJEnrObCrBpWlzDlhlWN5QNlGO/adDQ==
X-Received: by 2002:a05:600c:3b99:b0:3ed:234d:b0c0 with SMTP id n25-20020a05600c3b9900b003ed234db0c0mr20596205wms.13.1679161241556;
        Sat, 18 Mar 2023 10:40:41 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id f20-20020a7bcd14000000b003e203681b26sm5313886wmj.29.2023.03.18.10.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 10:40:41 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 06/10] sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early exit condition
Date:   Sat, 18 Mar 2023 17:39:39 +0000
Message-Id: <20230318173943.3188213-7-qyousef@layalina.io>
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

