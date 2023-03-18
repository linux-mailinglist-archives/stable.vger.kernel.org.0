Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367CD6BFC74
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 20:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCRTdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 15:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjCRTds (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 15:33:48 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95BA234E9
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:45 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i9so7102462wrp.3
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679168024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l6nzPPKPMrrryqwLrZQWWwBP+D779TAq0gGgfB/a2hM=;
        b=yqioVwTOlkcX54fM29L11fzSlccXXpjWGTkwDnfhfBtIhuTn34M81WZY00VYDzjVti
         cuaMniF76/95M3p206DHXwikHG9cOc96V5yeCeXUjcllsuc7Jm0XetHiifCtg/t7Q6Qd
         XoS3vSB6Qnxhnd2VE/aKomlcaoYRYGB3s0PERvK+gkQYzXbxlLio+0PDiPhYmR+2WLFu
         BHTHiiXZCdupZrX0/eJJRcqg4tiEDzibscppkKeoSF7e+ntgHJTq+L7fXDP+nK3lUrGv
         kOY7gdsfdpGQSWVZe25yn9xm8vAQJDvBy3MejtmGhjSnWGZAP46NrcJaayV/miHP/+ao
         OIBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679168024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l6nzPPKPMrrryqwLrZQWWwBP+D779TAq0gGgfB/a2hM=;
        b=A76MsVaEGh/db8NugxWRW+3OVjCvQYwoX2TlsuREdZgmFCttS0wp/yY45Xe+y5am9/
         mQUDSpbq1LGlrDDT4S85VG53bSvo0yL2FoFILE7A/ThL5AiKs2/Z0ExXrlUiuuA6CDF2
         6h8SmuKqCinqnsLKpLP5EhwWt8SERhVTHN9Nxgy1cq2Ycbpfl1uG+UdqNLUL88aximjU
         oTXANXeNg8+lJrhO59dU0Rc36cKElt9CKFvneEcaAUliN+nunK1L+GZX9g5lJjU2a7ld
         iH6S7kKkHlo7Rv7gikxcMm1TiczZ+8VtBvtbgtMeuh80CcBEj59dY9Jzb8oAH7c7Hl6U
         KrZw==
X-Gm-Message-State: AO0yUKWCMa+6kPe54Z7UObsGYwI0Kl7/hYF3H8LqexdhPOwR/Nl1O1V1
        48t6e+Hq6at6+/iBwMtfDRt2AtpZnO43ORbV4Vo=
X-Google-Smtp-Source: AK7set8s93h2Gqg2bu4ET878QlEr9WldrI0KXuiDxxsh1uEBm6euwx0+Y5oe/ELCdhUw1xMvkX96/g==
X-Received: by 2002:a05:6000:142:b0:2d2:59cf:468f with SMTP id r2-20020a056000014200b002d259cf468fmr5665988wrx.15.1679168024567;
        Sat, 18 Mar 2023 12:33:44 -0700 (PDT)
Received: from localhost.localdomain (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id o6-20020adfeac6000000b002c71a32394dsm4968696wrn.64.2023.03.18.12.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 12:33:44 -0700 (PDT)
From:   Qais Yousef <qyousef@layalina.io>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Qais Yousef <qais.yousef@arm.com>
Subject: [PATCH RESEND 5/7] sched/fair: Consider capacity inversion in util_fits_cpu()
Date:   Sat, 18 Mar 2023 19:33:00 +0000
Message-Id: <20230318193302.3194615-6-qyousef@layalina.io>
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

