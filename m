Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F7B6E66C1
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 16:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjDROKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 10:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbjDROKN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 10:10:13 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5BC810269
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:11 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f0a80b694fso24171135e9.3
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 07:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20221208.gappssmtp.com; s=20221208; t=1681827010; x=1684419010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZeBgeZRgKvbbWdcefpQr4KYzbM2xYJ+x6PzQ/FxkhM=;
        b=X+CGg+kj/K7x9vYZP4/IgPgaS/yN9h8j8MgzaUDhJyLaSXg8Hs1Bw1+XDcorjBOjKA
         Dk/m6GVePVhwSYV6UfG4rldIbTQB5oujkqTUWh2EZrpJs9sgSF7nGs1GwMtHsOIB2uoq
         nm00tnZXf1CeSNcmqyZB+tK7S/P65E1rI2g8TcIPo3L2bMFaaszgkMivxMRV2qPQSjzv
         IFhmuIlCibTs77mAyoDBxDfas+NuGsHclvRpiPgb3AyYPwun0+HuET1lG4HxURHd2brV
         MWFENNCCBNNknYU7nJgVitvxmX6QF0rSdrT/c7pmHoPjej/9RQJ2j80WvShf91Mm6Yza
         M+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681827010; x=1684419010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ZeBgeZRgKvbbWdcefpQr4KYzbM2xYJ+x6PzQ/FxkhM=;
        b=ZVGwIbjf2Ma2EWJOeSx2NTdHujx8msMKShU7NE5S3nmjsKXH+TFqX3w4YV4r+9fMKI
         VN+jRprgl8c+GSrQ3jfd42uK3m55INW+Q8PiF6jXzv8qDXjRie6YOJHyeOpt0YRw1xq2
         FIBfv0dwzfMreC1NWNlc+oyK3ThY4VmhN6Uzk+6dSpuZS+pu/sYANUBcGtJYeMdGgAfc
         03AlBkLNgX6JNv4jBMNmWlbgcjiUhRZ9fCs9VIK5E7YkjX3CZ4R5E6TZLwBKYxuTDAu6
         z+t+9FtCpIsWrTPbu3wJy7PJKymJCd7mLtSU7rEQe2X6UrI2lbPCCQeEm1sPimqSlcuR
         SyjQ==
X-Gm-Message-State: AAQBX9cMPE/LK6rU8V+zxuA0/tNaeErmUIwrBzopDfIGzhCTIR2fcAAV
        VEnXawwWvnKMCg+DB2PIIcVJUV/8x8kUy+ofEfc=
X-Google-Smtp-Source: AKy350Yey0EN18Wr8TwBiHNF+0dXgMAhyRDjM+mst1/BbP0uDRuiWZlZTfF4Tn+pMelGqETKVKHODw==
X-Received: by 2002:adf:e70b:0:b0:2f5:1e06:3fe4 with SMTP id c11-20020adfe70b000000b002f51e063fe4mr1936674wrm.44.1681827010308;
        Tue, 18 Apr 2023 07:10:10 -0700 (PDT)
Received: from airbuntu.lon.corp.google.com ([104.132.45.106])
        by smtp.gmail.com with ESMTPSA id n16-20020a05600c4f9000b003f1712b1402sm7978018wmq.30.2023.04.18.07.10.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 07:10:10 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH v2 RESEND 08/10] sched/fair: Consider capacity inversion in util_fits_cpu()
Date:   Tue, 18 Apr 2023 15:09:41 +0100
Message-Id: <20230418140943.90621-9-qyousef@layalina.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230418140943.90621-1-qyousef@layalina.io>
References: <20230418140943.90621-1-qyousef@layalina.io>
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

