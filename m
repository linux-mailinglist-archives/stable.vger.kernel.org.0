Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9DD1B2660
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgDUMk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728885AbgDUMk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:40:57 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8055C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:56 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t63so3379334wmt.3
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pGegqeDbRY6Y5f60xelQQzofEJmSdDI54qyCBBvOxXA=;
        b=rBWNv0AH8cQv5Cyy63I5CLPO4X4icj8jUXu4nVQzKmG0A8h1hF+N7vyGAmpNE0XOQm
         ohaqhlnMp+QGxMr1fFO/+HkjB/ddGuoJopxJOSqMFjhm/wevyHRRMqhuBL6E0xBO7MlT
         /9ada0Z6+ivelCoBPKGAIwXszu4gAQHqW5OvLbdi8ne4z2PGIL7//5E1mP8wQ8342YlL
         Fk9/ss3mgcEmHEoxrwdKFX8f+cclLEqyxrLEu4UdHcjDciEThQer1gOyGe9HS/Ky9BI9
         re85KUHMEMhrYimU3uT0BfxCRbh2Zy+DrOm6BIwK8l7M9/p1GgiRMUrbnRul18FCK087
         4SSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pGegqeDbRY6Y5f60xelQQzofEJmSdDI54qyCBBvOxXA=;
        b=sGILF9W1jpu2X2BQvASrLiOtlNfNixGj/OvHpCCTzoacLJ+ZhEm6FyLWj7QeFvj58u
         Xt0oooHCOPNzlJ19dkuchj8zkfSRldkqNLsrEurlzE57e2FnhoGPzMmOXh1/kWEdiBdQ
         w8GLxhk7ep5QEgQ/emRiiuaf16R9oHNSZ2GQyJP6xp5y3gAw/39MNBI467qTRreLYz6R
         QdH3VDbBLLsVJCVxoX7WmhyyyNXYsTYBjeKrRtMj+PGXY7wW0iN74Lwz7FfAoCSi5OV8
         AsjFh751TQjvAvEVabP4/YkPLuha9kkTCc4BsAnrKUXXpC/jnXbKoI4cHWGKnnkKq88S
         6nKQ==
X-Gm-Message-State: AGi0PuZTW3soEBKJKcU4Vxjjr90/6uJ9BgbLRbaOhUDy8/Jj3R/MichL
        LUuDQ00LoiJADKK3u05HgXEMuVkOFmE=
X-Google-Smtp-Source: APiQypLADsc65FIDUYrw2Ng2dgZdMQ2WByGiC159M0k9+CInivkkFZ7swYtFtHaSV7fqyW0qNPDfsA==
X-Received: by 2002:a05:600c:414b:: with SMTP id h11mr4672864wmm.9.1587472855253;
        Tue, 21 Apr 2020 05:40:55 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.40.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:40:54 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Hamad Kadmany <hkadmany@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 08/24] wil6210: increase firmware ready timeout
Date:   Tue, 21 Apr 2020 13:40:01 +0100
Message-Id: <20200421124017.272694-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
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
index bac829aa950d5..a3dc42841526f 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -871,7 +871,7 @@ static void wil_bl_crash_info(struct wil6210_priv *wil, bool is_err)
 
 static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 {
-	ulong to = msecs_to_jiffies(1000);
+	ulong to = msecs_to_jiffies(2000);
 	ulong left = wait_for_completion_timeout(&wil->wmi_ready, to);
 
 	if (0 == left) {
-- 
2.25.1

