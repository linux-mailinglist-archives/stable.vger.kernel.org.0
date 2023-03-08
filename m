Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC006B0E82
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 17:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCHQWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 11:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjCHQWe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 11:22:34 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E43D136F7
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 08:22:31 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id bx12so15915106wrb.11
        for <stable@vger.kernel.org>; Wed, 08 Mar 2023 08:22:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1678292549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0gdivBw0RhYLQnFxVnm0ZOGV4X4RH5TQsXyf9vYN5/o=;
        b=qRAMc6Yaa5URaMu0T4zDb62m7k2owRC5czAiRbN8uMT8tE2AmYVVowpQyrqumzHrIB
         UfPcCFvzn8J0gZozbbz6UXe0eRrhOiV5fdta7of7tWO9AGR33GX1KOvt3rZGawIt+nut
         iLQ8MKLqFBfenI3ljqswHSiOclrWEnCHXVOuWcjhgumTzOdrHbicp3Q+Olh9tFpiNVdC
         fagKNh9dTQVGNPUkm5wq90KnkuLsR/I/DAYntdj7CNPxo06XsG4EXccFeBoht5FqqFTx
         Oz5sUaSszcmDT9lB55t2YZpvw6oIfonDfT7Ux4Agi0USzO3e3CmwUt2CGiqubiKLPShk
         HF7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678292549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0gdivBw0RhYLQnFxVnm0ZOGV4X4RH5TQsXyf9vYN5/o=;
        b=HDoeF5s8tpDKlwaCH0WuemAQklEGYuYbYBrswcYQe522UXnEWrPYnsIwxKALA0O0PN
         0zQjPiU5m7SajR5gNsrS6y7sP0p6Q+wGLWSR3icPlGhH4f16/gFIixzi5slLnXTEwd+i
         Co1371Ns0MmcUSnaEJABDxFFIFpKtqrjrmKzCqTDEtNGOi9Krfv3iCPypLa8vjRQDMzd
         OnDFEuhZhpOuPA2ORwHt/goaHUnWiiy0i/HhEfeivA3G5/oI+rpwj9pU+3OdWfyZgsoK
         bFl+9kOTfvlKXl39vpnugy8iZBHfbVZE+ov0gtXktfWgROOaPshq0/n+X9rPmXG+HVEW
         NUug==
X-Gm-Message-State: AO0yUKWr/ue/Q+sMwoz9gNAfLUj5pa+VvaRBur39rfKMvzLiSKpJPKmb
        wrpczdY1y0W8qhKII4MYoSNGQm4x5PdB/yedaTM=
X-Google-Smtp-Source: AK7set/G5yFJNPYoIFF3O/KGDkx7HpATIc08n/P6qs6OdC6+ncz/S/Olm4nOkXtZh4Byp+Drp9LoNA==
X-Received: by 2002:adf:ea03:0:b0:2c7:1e43:f46e with SMTP id q3-20020adfea03000000b002c71e43f46emr13650022wrm.37.1678292549416;
        Wed, 08 Mar 2023 08:22:29 -0800 (PST)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id r8-20020a5d4e48000000b002c5d3f0f737sm15786015wrt.30.2023.03.08.08.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 08:22:29 -0800 (PST)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH 3/7] sched/uclamp: Cater for uclamp in find_energy_efficient_cpu()'s early exit condition
Date:   Wed,  8 Mar 2023 16:22:03 +0000
Message-Id: <20230308162207.2886641-4-qyousef@layalina.io>
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
index cd4eccdf3291..66939333bdd1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3974,14 +3974,16 @@ static inline unsigned long task_util_est(struct task_struct *p)
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
@@ -6967,7 +6969,7 @@ static int find_energy_efficient_cpu(struct task_struct *p, int prev_cpu)
 	target = prev_cpu;
 
 	sync_entity_load_avg(&p->se);
-	if (!task_util_est(p))
+	if (!uclamp_task_util(p, p_util_min, p_util_max))
 		goto unlock;
 
 	for (; pd; pd = pd->next) {
-- 
2.25.1

