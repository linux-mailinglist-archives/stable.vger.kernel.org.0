Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DAF1B2656
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728881AbgDUMkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728874AbgDUMkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:40:51 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF17C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:50 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g12so3502198wmh.3
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yViPn8Fbz3RmNQjEqtPLmElTrNVmdZ3e4vYeMjUnLFM=;
        b=N61NQu1JjNoqZQoeblPvtN/rYL8PcxIX/UivRLX4uoB8AiAO/QcqtDpS9rZFB4rA2W
         YIKO6wWoWYJNeo91Ni3sJSi5x446rGFYwXPA499xzrjTeFZBcR+Roun/SF4RMNpJQ2r7
         gpCL2FMrbEIHezg5qCcpxepHK7qFFxvXX6aD8Tr9S5P/VqyD6F46nFrrSA9admJc14yK
         Bn1jD7cbFB9rvgxiWLNIIWQipCMpI2elpKEMK2MhKMO7IfMeoe97ZLsHSAeVfLSMudef
         KIqYFDRt0THiB9EXByGOQBTPMhMbBjgkI3O9eO43i4nAPNyRme3oxkJWqckyrYobLuNR
         tbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yViPn8Fbz3RmNQjEqtPLmElTrNVmdZ3e4vYeMjUnLFM=;
        b=BqzNVVE1EgZBtzicisTvWlakW93+zcYWLBQ5eT0bCWsni5s1AxDRIx0wdBGLwn4ImK
         j5Qz7X7Zp1FPvevOhA8NGu+ZW6HqCaAEcjtcnjCHBJ8/9pWbKqAl5q1IrPEC5zdQHxh3
         pRwTcYD0hsL5PGwEgMA4MnRxhu7HPg0Ppl2MCKaZ/5h4RJTb5B2vwtMCjwvwjok3jcEY
         +gTHjjYj77BcCRtEmLMRWtzazDV4qisoMfUo64eRmWaHoi8h9dKh6vupKGho6PFfJwCq
         UXp3oUR1RwrN8waZKQRjHEmPFOFZHVW9vVeb8JssCvn26xVF4aY/S2gNyi5GHS/MJDBK
         HQQg==
X-Gm-Message-State: AGi0PuYSvG+U2+GGNHlPj0FNXAUDkB5Iv1uRwqFpZTColOWTsRN3NFsq
        dMtHr5+APTM30mYkkCvyLMdcTmtsOqA=
X-Google-Smtp-Source: APiQypKhkZ9+Atlav6XE7j55CLG9RFti6kTxtS1VpW13kozRUX/MqZlaom3n+ZY9C9vhqWebCcArQA==
X-Received: by 2002:a7b:cf2b:: with SMTP id m11mr4432437wmg.147.1587472849416;
        Tue, 21 Apr 2020 05:40:49 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:48 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Xu YiPing <xuyiping@hisilicon.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 04/24] arm64: perf: remove unsupported events for Cortex-A73
Date:   Tue, 21 Apr 2020 13:39:57 +0100
Message-Id: <20200421124017.272694-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu YiPing <xuyiping@hisilicon.com>

[ Upstream commit f8ada189550984ee21f27be736042b74a7da1d68 ]

bus access read/write events are not supported in A73, based on the
Cortex-A73 TRM r0p2, section 11.9 Events (pages 11-457 to 11-460).

Fixes: 5561b6c5e981 "arm64: perf: add support for Cortex-A73"
Acked-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Xu YiPing <xuyiping@hisilicon.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm64/kernel/perf_event.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 05fdae70e9f6e..53df84b2a07f4 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -262,12 +262,6 @@ static const unsigned armv8_a73_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 
 	[C(L1D)][C(OP_READ)][C(RESULT_ACCESS)]	= ARMV8_IMPDEF_PERFCTR_L1D_CACHE_RD,
 	[C(L1D)][C(OP_WRITE)][C(RESULT_ACCESS)]	= ARMV8_IMPDEF_PERFCTR_L1D_CACHE_WR,
-
-	[C(NODE)][C(OP_READ)][C(RESULT_ACCESS)]	= ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD,
-	[C(NODE)][C(OP_WRITE)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR,
-
-	[C(NODE)][C(OP_READ)][C(RESULT_ACCESS)]	= ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD,
-	[C(NODE)][C(OP_WRITE)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR,
 };
 
 static const unsigned armv8_thunder_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
-- 
2.25.1

