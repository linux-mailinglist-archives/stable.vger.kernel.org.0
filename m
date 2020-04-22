Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CA71B430F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgDVLUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726800AbgDVLUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0908BC03C1A9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:18 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id u127so1907905wmg.1
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eCvdfM93gNYyZjObZ9PQdmlbZuh+Svcu/m1gBXqJ96Y=;
        b=uRfUnzmdDUVGVpfz+Sp9IHAqEK44ojeOtDL+SlHHRXm0E9Sdb8pTbS4e+j/FQqwVXd
         8XAIV2MzAsuuy5lkPurGxqTa1/FtPR96MQe3AFCjH+aufOvUvmJQlADnbd2gHfESAR+K
         Wew2CWkyy4WYzPjaPJA2CMrFopnFX+9QDj838RHus0BMVzjbCcfk0DuJaTY88tWm9P1i
         zpaURZ4XyGDI3ZJKdY0JbWA60hOgVH5xMkiAz32TK/jboeNR8jf0oYGH5Od4ZfQ9Q/YF
         VNN5OEc26ceLSFs2kGpJy0wV4theCCqopUH5Ruzq1qhmh35jkAS4zIyE9e7nJt/c1oS6
         b9Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eCvdfM93gNYyZjObZ9PQdmlbZuh+Svcu/m1gBXqJ96Y=;
        b=ZS+Rov/qXqM29mnXjtid413x2afUNXPOoydsNNZ5zgtdGoxXf8MRetHcEnj3St3eNG
         fYALao8zPONJ/ouZIaei04oLBESCvuwjHAZ3g3nKTeYVogrrqj0F+o1L/wtg2VZlEMks
         WZUk6bM0cT8oGdJqtVEIbdWv1PuHfGoS7TopyIg99ut1nhN5BSScDetQnotTUTMnx2mQ
         mzfutd7v4J7wNanBa3ZVCSJOs8yVRBzktGnbkwBM3gsPeEG69lzvbv/Xj5PVJGIvgg9Z
         oQ1AXxMuc5PXz0PYgPYSZzt2+TRn9bgSiyANI9KD+doy2DHd3U6USf6D0O+UO9AAHrhU
         JBFg==
X-Gm-Message-State: AGi0PuaVmY5dEgK85JzjxrDYEVFfR8uGieJFGTr47NAXZ7qFGJVzq3l1
        Ug0ZkOJK1kZjUa7LYUZOkcmfYJHsw2E=
X-Google-Smtp-Source: APiQypK3qECmpwvfrncQV/Dqg0CqLZaFRKoyxpeBWs90QfnFv2PvH84qqu3RhJ5nI14i8QdaMqoRpA==
X-Received: by 2002:a7b:c1c4:: with SMTP id a4mr10288263wmj.86.1587554416543;
        Wed, 22 Apr 2020 04:20:16 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Hamad Kadmany <hkadmany@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 11/21] wil6210: increase firmware ready timeout
Date:   Wed, 22 Apr 2020 12:19:47 +0100
Message-Id: <20200422111957.569589-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamad Kadmany <hkadmany@codeaurora.org>

[ Upstream commit 6ccae584014ef7074359eb4151086beef66ecfa9 ]

Firmware ready event may take longer than
current timeout in some scenarios, for example
with multiple RFs connected where each
requires an initial calibration.

Increase the timeout to support these scenarios.

Signed-off-by: Hamad Kadmany <hkadmany@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index f8bce58d48ccd..12b4c6f003726 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -803,7 +803,7 @@ static void wil_bl_crash_info(struct wil6210_priv *wil, bool is_err)
 
 static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 {
-	ulong to = msecs_to_jiffies(1000);
+	ulong to = msecs_to_jiffies(2000);
 	ulong left = wait_for_completion_timeout(&wil->wmi_ready, to);
 
 	if (0 == left) {
-- 
2.25.1

