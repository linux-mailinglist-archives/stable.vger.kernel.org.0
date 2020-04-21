Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CF41B2668
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbgDUMlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728898AbgDUMlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:03 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AC2C061A41
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:02 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id g12so3502897wmh.3
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aCe1QZjmaMyeP77BfjlfNyliRZWqjMuk0JjgiLARwG8=;
        b=J185qmfDEXUDonxaCmmgLwF/QJCr1UqP8Ky/ufOv92nmw3WR3hRTi0Turp0xzPva76
         3Nh+WNPV68+x3kV1jz5rc59CHeZuWecNHS11n1qJhyrF7U9J/1p3OxjbOre1QNJghwPK
         fZQPf3XPVRDzvdTiSvtprablkdIWMyo5Uco8pL0qlJaJmBPwMrJqKrjfV1A92MAMXKGt
         KPQCOWwMJTQJn7T3XbOEwJOxE8sQDG0qsseMCmSrekno3sXmUtBA4qGLgQJhDE1Lbvxy
         EGcsyYz2e15vw6dzcOkNnNLEHPnrF8StrbSCqDl8hWpSImr4REpPTBZ/e159ZmPVmyZg
         taBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aCe1QZjmaMyeP77BfjlfNyliRZWqjMuk0JjgiLARwG8=;
        b=XlbplbnXhentkziL95y/YvwvzbR4CJtnXA7Sdt5u2Q8d03P+bqlBN8lMhwpfJk7rnL
         P+PLrard+CqQ139v6nmcF5F4YAHS7U4bCbDIS42o2HpOplDYukZATTGhRhm14hE/hS7i
         YlR/RX/L8EpYpjZlHCfnn+fMs/TL7bJcmkg3qqf6gJzjyaK9CMDMWD/OlpyYRC1dlSJF
         R0rgtrnpvzh30D388tPQ1dmz8kSNmgEfwqeMS6jx7y93m9FY+RTFdtIgRuB3SbDKXAfy
         XU5ryp/ccWaRcqJ8sGBaARqNbZFiTlblGrUPVScGzz7TQ9sx6zOzth+CZ8Eo7GfWPeUx
         1cEw==
X-Gm-Message-State: AGi0PuZ8u6GzJNyjVNefwCHcT+GKKbc0PETEs2TmW3SCX3+Eq3NCCfxd
        ++oUN41bVMOx+KMYILXMlT2Oj/HRhPM=
X-Google-Smtp-Source: APiQypIjkYEOPisndokxGWEjb0sJYwxUPOs2UbyGbYFRkegF4LA1AlgqjHQrsOaoPxSl5/gvu4GO5A==
X-Received: by 2002:a1c:b144:: with SMTP id a65mr5150231wmf.54.1587472861313;
        Tue, 21 Apr 2020 05:41:01 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:00 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Dedy Lansky <dlansky@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 12/24] wil6210: rate limit wil_rx_refill error
Date:   Tue, 21 Apr 2020 13:40:05 +0100
Message-Id: <20200421124017.272694-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
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
index 16750056b8b52..b483c42660971 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -636,8 +636,8 @@ static int wil_rx_refill(struct wil6210_priv *wil, int count)
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

