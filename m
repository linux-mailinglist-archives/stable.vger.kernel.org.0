Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94C219C9DC
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389523AbgDBTSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:18 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40408 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389486AbgDBTSS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:18 -0400
Received: by mail-wm1-f67.google.com with SMTP id a81so4929157wmf.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MjyavgGyBdte0j44srlHhXp1P/92pFuLJMScfcP5L5Q=;
        b=SoVdql2GCrilhMmtlxeG2iPRTLAJDlcL8jXeJffXbOe3DltZgBeyAC9XozaHf6oteS
         UzHdbHgHJM3UhRyDMXHktBASVeec421QQIVik0DJNq4VjUn733WuvUI1AzT6d+ZSfota
         gTqR0Lybq/a8+4dYxG6zPMyVgIskXcZBjW++/UXGAW0NUBWLng91CQaF2JU+KeWvOS9x
         EEAKLpANzapMHZHGTiSnuqbvutSt3I3BaWHReOlnK38maJWDDlHbuGcOyUpsOuHyuRwz
         e/q1lLUkLOH0w40qtWbpOOUCs03uxT9NbANsPBZUcN+q58QPB+fooq1kUQo8giT/it11
         jZCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MjyavgGyBdte0j44srlHhXp1P/92pFuLJMScfcP5L5Q=;
        b=V9+QHsxZfegd86R32u1QRkp+5CJGY+zuFrVKs8BcXcCJvbNm776I1et/NkQMvr/r6n
         jU1f94lx/JiVhyX67e6ZCF98+6/sHQW1F2cYJZopRWhIHwYHrTTPSVrEOhSwHGZo/sGg
         QXFPMxF/NRJzTiyEoHrp9AskU1I5LphDuH6CRIA0ev+rCm4eHVhzR1ineFHxujZWsXVI
         sDvAQsXc57hYPVbJPP3xZSpSLE2iRUlLonwkcilLw/zlo54UnYEuQsJz3o6wuMK3XSdK
         /pbc1wqCq6lQ/dE3Wa1nTaEP8N5lqwHJ9ZG/+nJqRGHA2njLkWoAz+lbKkHGjYHuG3ev
         vdOA==
X-Gm-Message-State: AGi0PuYEIyGnMKMqq0wPT6P+nrCRlkgP+7xm3OGNgFfExufcPqRU57i5
        6Nasapd7ZQ2a8R/nNdLInajVm1Uyz+d2xw==
X-Google-Smtp-Source: APiQypK77u9vaKasWzqbaIP7EIJlJXoSXCxLj5gRIFzuzAuatCt04AXtzGf/fVrxfVZp4JfohVnqxw==
X-Received: by 2002:a05:600c:2c06:: with SMTP id q6mr4962607wmg.42.1585855096183;
        Thu, 02 Apr 2020 12:18:16 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 14/20] wil6210: rate limit wil_rx_refill error
Date:   Thu,  2 Apr 2020 20:18:50 +0100
Message-Id: <20200402191856.789622-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
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

