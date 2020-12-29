Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB9D2E6EA6
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 07:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgL2G5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 01:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgL2G5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 01:57:36 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6744C0613D6
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 22:56:55 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id n25so8733645pgb.0
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 22:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JHlmOol5A/vir/D6u6sUABjAlF23eH6ZeuWW5/0eeyQ=;
        b=vUWfoY3hE/HRUocSYTxrD2N/+puKflVDGYhFmJlrFI6DXqtTWgUMKVF85CAvrzp4U+
         LMx39YnsO2u8INPkwMDH7FldLYY27wzUSLcO0e8KlJ1t8YGElS3ptbo4j6muaDdtIv0z
         whoZgKEu7tKoGrawQg2ZcRRhAvnQIr8yu1x2+bfKP1cPnrO8oyxy5fcw/ynLxuStgyZ+
         A3rUowerfeIh6nEkFqib8E1p+jY+LgmbcvlQ5uuQTwafhZ8/2p/KXvJE0i/RkfEKY1vD
         6b9BbxAXFSd3WLtiC919PswvE09x5J9qjkyT4msEfBNEpvzFXFfibJt1VDiFPuWgOppc
         X3Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JHlmOol5A/vir/D6u6sUABjAlF23eH6ZeuWW5/0eeyQ=;
        b=F+US2MBvQZBCoSxnsATWXA76phy6tE8mYtlBPAJGyQMHtlwbxYDS9QAQZ+e1RQNl0C
         LvT03uZhLijYHsppro4C8oc4KKHyijdeD1wINrEjzFs8W9lp3v0e5nn1BG7x1+ymUGz5
         0VvvzECy/lYuuLFDPkez9qAmeL1FI8uoB4yx2UNFUc7+vHUSFUDLTfyk58i8AlhrHE2U
         fg+C7z6fmLeUns2yVbSoLoOFZmt3nqG7wysiCvjV/hVikR/XwEu5wGMTywkzqgjFrYfV
         pyO94RRDoB2FP59CU05hvq5dNfFt4my1CP7ofzabkdDrOiSMjUtwSJJCgxJjJ9dvJBQA
         nWHA==
X-Gm-Message-State: AOAM530momL3cYzQtJbeUyIhBZo3zbNgNCKUr8SSfldpog3QZ1R1VvNA
        PBVJMu8fubY2o5sovlTceaELI3B1jVRzwQ==
X-Google-Smtp-Source: ABdhPJxOo9TV42RBlSoDs8WQR+OVRwSQVEEVGgwTFm+DdVFHCMoemY8IY9w9yxyA2QsvDcP5odQrjg==
X-Received: by 2002:aa7:82cc:0:b029:19e:1328:d039 with SMTP id f12-20020aa782cc0000b029019e1328d039mr44700866pfn.70.1609225014889;
        Mon, 28 Dec 2020 22:56:54 -0800 (PST)
Received: from localhost ([122.172.20.109])
        by smtp.gmail.com with ESMTPSA id i25sm34823229pfo.137.2020.12.28.22.56.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Dec 2020 22:56:54 -0800 (PST)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>, gregkh@linuxfoundation.org,
        zhuguangqing@xiaomi.com, daniel.lezcano@linaro.org
Subject: [PATCH for 5.4 stable] thermal/drivers/cpu_cooling: Update cpufreq_state only if state has changed
Date:   Tue, 29 Dec 2020 12:26:39 +0530
Message-Id: <7c80add4a09e3b1f24f4de322d3d4b4bda0db5ba.1609224933.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.25.0.rc1.19.g042ed3e048af
In-Reply-To: <1609156118189209@kroah.com>
References: <1609156118189209@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhuguangqing <zhuguangqing@xiaomi.com>

[ Upstream commit 236761f19a4f373354f1dcf399b57753f1f4b871 ]

If state has not changed successfully and we updated cpufreq_state,
next time when the new state is equal to cpufreq_state (not changed
successfully last time), we will return directly and miss a
freq_qos_update_request() that should have been.

Fixes: 5130802ddbb1 ("thermal: cpu_cooling: Switch to QoS requests for freq limits")
Cc: v5.4+ <stable@vger.kernel.org> # v5.4+
Signed-off-by: Zhuguangqing <zhuguangqing@xiaomi.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20201106092243.15574-1-zhuguangqing83@gmail.com
[ Viresh: Redo the patch for 5.4 stable kernel ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/thermal/cpu_cooling.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index c37886a26712..9d24bc05df0d 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -320,6 +320,7 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long state)
 {
 	struct cpufreq_cooling_device *cpufreq_cdev = cdev->devdata;
+	int ret;
 
 	/* Request state should be less than max_level */
 	if (WARN_ON(state > cpufreq_cdev->max_level))
@@ -329,10 +330,12 @@ static int cpufreq_set_cur_state(struct thermal_cooling_device *cdev,
 	if (cpufreq_cdev->cpufreq_state == state)
 		return 0;
 
-	cpufreq_cdev->cpufreq_state = state;
+	ret = freq_qos_update_request(&cpufreq_cdev->qos_req,
+			cpufreq_cdev->freq_table[state].frequency);
+	if (ret > 0)
+		cpufreq_cdev->cpufreq_state = state;
 
-	return freq_qos_update_request(&cpufreq_cdev->qos_req,
-				cpufreq_cdev->freq_table[state].frequency);
+	return ret;
 }
 
 /**
-- 
2.25.0.rc1.19.g042ed3e048af

