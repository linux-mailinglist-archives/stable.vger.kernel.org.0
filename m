Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A54819C9BF
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388995AbgDBTRM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:17:12 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36800 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388894AbgDBTRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:17:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id d202so4979648wmd.1
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7n6+1RB+Povmh3mXFIHzZpp6IxvkbnS6OC8yNx3V8CE=;
        b=YVc7RzDHgult9o8iVm3G8+4DFyBMMEHtZCJEc1VKwGEfWCa1E3V1TWhlvJrU3S9a8P
         zpAFWIEjOLv3AqdOqmUM8+rqv0itco1xNPlUu3Mek02uU6ieIIWCKGM64IL2bA/ncYRi
         27UFhbdIYyoQ0GyuNnvV9O4Sp35oaA90S+t5a13x3y68NZ4x353CLf6YAWCsKs4KHbRa
         e7QoNbrulhKupOrId+BM+XKoLWUmaG37wIpXtVzpBZr1qqHco0MjJ6M8WbV1BSqcykgq
         r0D7oFPa4zGUnBvKFgnafpkyWPLr7c681hzaIiWDup/mLMX4M54kc0OtF31SLwY67mtP
         I+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7n6+1RB+Povmh3mXFIHzZpp6IxvkbnS6OC8yNx3V8CE=;
        b=eQF2nMC7Ohca2X3s3HezcBOJdoKy03YAaCRJPpA73BUS2/ymnEPHnaL9xp2Xci8gxc
         dQJcgJjOEyPbE0Ye0L22yvdx5og1rH7VgHxSjTVrrSTLBq4w1JpWcoUYdBc/WW5VqBXj
         5ovqbrgE0Ta+upiCM3vGAklsn5kK2OdOfgZsaN5k9Y/lM9WggqYldNL8nwjhXFQjSAZQ
         1mx2m1rrZfVX4IvUyhqfGcf/Ltz++h45ZesZTGDr2r/AZ+3olLGUI8hxcU47MHRRJto6
         MASN15aq/fmxXAnKDFVIq6bAVa4GPW8qb2r2Pd2rcUBGB0HAhluW28y+G5Y8jU1Rl/B9
         EPzA==
X-Gm-Message-State: AGi0PuYV5x03hcGFO1WdZ/gtlGEpHVL1AUMRMEJID/fcjGSvR5N5Y9h5
        KZ00St1ACj7h3xF5G+gPWbGn5drOQretNQ==
X-Google-Smtp-Source: APiQypKtvAIRekWV/b4ihfndixpchVPgSoAIFXI89etQobNf4xn005EKa06P9Am99m7GJP8BSHpj+A==
X-Received: by 2002:a1c:e203:: with SMTP id z3mr4956595wmg.71.1585855030039;
        Thu, 02 Apr 2020 12:17:10 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y1sm879050wmd.14.2020.04.02.12.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:17:09 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 16/24] wil6210: rate limit wil_rx_refill error
Date:   Thu,  2 Apr 2020 20:17:39 +0100
Message-Id: <20200402191747.789097-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191747.789097-1-lee.jones@linaro.org>
References: <20200402191747.789097-1-lee.jones@linaro.org>
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

