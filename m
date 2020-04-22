Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 919F31B4314
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgDVLUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726829AbgDVLUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:24 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F39C03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:23 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x18so1938523wrq.2
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7n6+1RB+Povmh3mXFIHzZpp6IxvkbnS6OC8yNx3V8CE=;
        b=K5lt7r7PSYgs20uvN/4F/7K1KLqqtHmmbrd0JU+CKoxrYuqCuBZHe+YmLr77TPVOKg
         LmeoXkf2EmeQ/IyYS2t3ijH2o0K8lo6/2fSRZvkn87pslxcC5sMiOzUl6A0y/EeKtXbj
         NBlIB9n5LKHxfugh8IpnrT4dx9lVrEPNEeKMfaF9Eo4RnT9X/qivj0cRFCyL8wvcQhDu
         obVO23wUUIsiZlN1XdAv+CvtobItaKPUV5/kIUHxXsXV5v7XmsW3neSzOFMP0AI6+vSI
         rBFhjWuDacwgej2Q+zyrw2j6IaiAMM1RE/CquZTlth1v6P0Bx7R6L2Mt/xh8eP6l8xcL
         s30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7n6+1RB+Povmh3mXFIHzZpp6IxvkbnS6OC8yNx3V8CE=;
        b=Bj6chrpY0xVmR9EVWa/cO0tVTvPHihVKD72g5WNdc8no8haRxBBBpNQgjeErfiO6do
         HQmhvB0YjfDOFtbHyPWXLeu///l/4SzYS5Gc9l3gLIZsmvUZvrpK0gthL0in2fKtIN2k
         Yj04gFA5b+WZ4ICH9+zyb8fpwIUW1ixF8rkQARMNlC7Tq/EoUtjaA30TwyL8Lx997rjH
         fdUQGrUf9QN4Lh5pfKtmYtjoWcoXU47XjXhOs6ScIYd5S6iY+7Dk7Rbwdpu9EGIEJtDq
         0ZQPc1hLUuAhtBJN57LW/wD2Ie66gww8EVaUP8qJmiNf5CYqTNurvtGya5/t9SDu+v2V
         MlvQ==
X-Gm-Message-State: AGi0PuZD5uWWXSpSTXDA1E+FanWpG3mxFUbpKBxh6muWYbsg7uhMruFe
        m+FLQ58jfBsrrUt4jX0PR3HdRoSrIMs=
X-Google-Smtp-Source: APiQypKL5KJt/NGrZRlA0V/fuckZcQYI+qkRsERpxRUmAERpc8/XjY/firuDiN63AFmFH6QbW+JLEA==
X-Received: by 2002:a5d:4d8f:: with SMTP id b15mr29389650wru.107.1587554422182;
        Wed, 22 Apr 2020 04:20:22 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:21 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 15/21] wil6210: rate limit wil_rx_refill error
Date:   Wed, 22 Apr 2020 12:19:51 +0100
Message-Id: <20200422111957.569589-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

[ Upstream commit 3d6b72729cc2933906de8d2c602ae05e920b2122 ]

wil_err inside wil_rx_refill can flood the log buffer.
Replace it with wil_err_ratelimited.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 4c38520d4dd2d..72e8fea05e5e1 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -546,8 +546,8 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
 			v->swtail = next_tail) {
 		rc = wil_vring_alloc_skb(wil, v, v->swtail, headroom);
 		if (unlikely(rc)) {
-			wil_err(wil, "Error %d in wil_rx_refill[%d]\n",
-				rc, v->swtail);
+			wil_err_ratelimited(wil, "Error %d in rx refill[%d]\n",
+					    rc, v->swtail);
 			break;
 		}
 	}
-- 
2.25.1

