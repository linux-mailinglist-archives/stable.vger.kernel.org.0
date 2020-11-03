Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803F62A4B77
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgKCQ3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:29:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgKCQ3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:29:16 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D78C0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:29:16 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id g17so3527358qts.5
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 08:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LbDs0pe3ThWChyJx1q2j7lYP9mbEo2f3PprZySMGAlA=;
        b=SuxDh6djGIRRmG6jTLvxOdxvOd0OyfTma5w4xHOHjcy1K3a3fPwN4Wlb5zVthJMUq6
         oPm09+w/REFqnlvrp4PUPqC8zDf/m8rFf5v0pJISyTUlKGxdkmi3besgIxjoU9eA8L90
         pjn2ke/Amzz04Gfax+L/BjCVwl7SeYMDdINd6xup6QvGYGIMBYwzs1MD3efj7OL3bk9r
         FoHqYaiyhiXboBkSJju5MH5ML1jJCcYGzVs1GZMLSyHEgFe7uUJSBoD2qaChc7o+nyU5
         2t6vcCLOPkZ5GmMTq4pWfMFBQDW0tFmjq7Xg0oR9fuImV7HNc1l66Dww5UH1y4UkINkX
         fuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LbDs0pe3ThWChyJx1q2j7lYP9mbEo2f3PprZySMGAlA=;
        b=TnpsPO1aTDlzFTjxf0LyoWN1OeXyqj5oaPetzrbU1O8LsU9/474OgyEvxwN42jphTH
         y5XFeKKw4tI+dardpuygW8OgpetefpMUE6XNsTrcz9tVjfawJWVhgFsR1GxjBgrDWA11
         veiMYUqH1x9HP/bfSg80oCBfOWNDfsYsmqzTk443p6D40SJtLSCUY9dBwVnU7svzuwDD
         xXUa1lKIruJCEaT6uXwwWN3SEy457xfaYdYNU7GHImBzjConWLr1FFfYiLqXrhMM8Khx
         8bZyFwi8e2w7SF7g3E95IJBhWQKk1+0J6EKw1RmgvAdvJo/ArP4sJUlwTJU4MPWJB83Z
         1ulg==
X-Gm-Message-State: AOAM5308NnYDN3uZ8mxMIofsJYTnptiGtJ4PDURQPWp1ffLB/GiAtVkj
        qLsTdjEJEoboVdYwtnfOnryifZh9cNk=
X-Google-Smtp-Source: ABdhPJyr5ZjLxHh3npaRZ3RO2kxM6aQgWif1k2qdT3E1t8FSsYeZy+p4Ap+kKusiQXGQf9dly9ZWJw==
X-Received: by 2002:ac8:4d5b:: with SMTP id x27mr11448074qtv.135.1604420955634;
        Tue, 03 Nov 2020 08:29:15 -0800 (PST)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id d48sm10171434qta.26.2020.11.03.08.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:29:15 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Kenneth Feng <kenneth.feng@amd.com>, Likun Gao <Likun.Gao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3/7] drm/amd/pm: fix pp_dpm_fclk
Date:   Tue,  3 Nov 2020 11:28:59 -0500
Message-Id: <20201103162903.687752-5-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103162903.687752-1-alexander.deucher@amd.com>
References: <20201103162903.687752-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

fclk value is missing in pp_dpm_fclk. add this to correctly show the current value.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
(cherry picked from commit 392d256fa26d943fb0a019fea4be80382780d3b1)
---
 drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c
index ace682fde22f..f2844943f6b7 100644
--- a/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/sienna_cichlid_ppt.c
@@ -447,6 +447,9 @@ static int sienna_cichlid_get_smu_metrics_data(struct smu_context *smu,
 	case METRICS_CURR_DCEFCLK:
 		*value = metrics->CurrClock[PPCLK_DCEFCLK];
 		break;
+	case METRICS_CURR_FCLK:
+		*value = metrics->CurrClock[PPCLK_FCLK];
+		break;
 	case METRICS_AVERAGE_GFXCLK:
 		if (metrics->AverageGfxActivity <= SMU_11_0_7_GFX_BUSY_THRESHOLD)
 			*value = metrics->AverageGfxclkFrequencyPostDs;
-- 
2.25.4

