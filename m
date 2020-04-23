Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3521B65A1
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgDWUke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUke (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:34 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF79C09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:34 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id x17so7492844wrt.5
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MjyavgGyBdte0j44srlHhXp1P/92pFuLJMScfcP5L5Q=;
        b=qTrw4mgkgs2wz89ScBTwSXCurCFAeBrELWyH1XTFaeBu4ZujBqNWHdYmVm0dDKlVPp
         J4sRwg2BIhzZlHyPi5xGKl3Olo4cJB4WxaXyESpjKfLeWk/GgEAcbvQ0EHTCv5MbPATc
         tsIQWfr6iXiNnU4LgYL3EuqVZTGPBftARq6vZvPXO3UCAgUpF6sUqleyn1HUFlt5EexV
         gUtzMzg1N541cG3iOQwasFd5RsSkUPwEW5tqyzFQjIZCHSqDuQ1YoMi2fIgz+YioK88V
         wa2JODXuPd+cM3lY8Z7qRyv41xDSI4q0i8/ervI4nY+J+3vMICanQ+tvS5Nnugwgfmde
         aDfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MjyavgGyBdte0j44srlHhXp1P/92pFuLJMScfcP5L5Q=;
        b=LeNiYCTJzJ2VnfJoFMfjnAPMcWpoLyq+/WnnW7lcu/5PhE5sK0NElRbRBpJsdCSAUj
         La4AszgqPombx8HBNR0PxYd+AxgtLae8oBQ5jh3rgaylEU/vKHDe5jn+myJ9sV1L72CO
         si7jVl5NZ2Uenl7qBIGPUaHm7qEnLntxpkfX01lFv3+tBfAY3IYEUsYf/YoNk2bXRVxa
         Vi6U2HvcTh80mKY0JXGJKwO8kzVv97LYDLhkrXztjag3C53f5nMUQ4+W3kfRcigKFxe4
         5GRAYbH2R9TPjR0vCrpSnWT6oAIhsDKMfUCTvZKyNaVz5MPLn1bKWtKvVOEDvpZ3kQAs
         LXug==
X-Gm-Message-State: AGi0Pua7o9AuL28WEGBvyLWmZNpTEJYmwGkZMSYbRKRo5jjFWsV64kEv
        KGf2bD8lCbUkLrwbIaW4yQjAeBWcgU0=
X-Google-Smtp-Source: APiQypLEJzEXKz8kwvhXa8bIzwnLtySiVSEJ4x+/pjwOfnRPkqQHzpVwzDBBL3YhQre9U+7dBLTzSQ==
X-Received: by 2002:adf:e3c2:: with SMTP id k2mr6746703wrm.287.1587674432658;
        Thu, 23 Apr 2020 13:40:32 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:31 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 12/16] wil6210: rate limit wil_rx_refill error
Date:   Thu, 23 Apr 2020 21:40:10 +0100
Message-Id: <20200423204014.784944-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
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
index 3bc9bc0efbacc..af436292190b1 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -538,8 +538,8 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
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

