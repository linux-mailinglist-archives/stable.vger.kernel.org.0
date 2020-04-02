Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3B519C97A
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389155AbgDBTLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:34 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41573 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731689AbgDBTLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:34 -0400
Received: by mail-wr1-f65.google.com with SMTP id h9so5579666wrc.8
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=u/8Oj2Ff4RNeFgOmfCdgYmb1Rv0nrDRFoL1TCNAUQ/o=;
        b=JvXVuFjJNiudwYQJwM3L7Jke5bLiUlsCa+y+LtVQvhAutACNI7kv6N/6jG57CrFkpl
         rIwvK8v2AZaOLUqzAU2mMg5e4mnJ4zDnq7SwpEWbGAncf9qxxqsb/VPgcQhQ5XvOdu3h
         krUxV0HwAuifQvlxoSZScc/YVpNfC+4wATxlDwNvVS7Gu3jzzauYn4nTvYKIeIaYx1op
         1+/jKxeiiwzL5NsMbRaeNNC78uupV91wa11e8tiIUCx1uVQR2G1XgfjVz00VM5T/7DDT
         ZqlgYawku68GavMfGCmFi41WNPDlK6E/plgDITCiOP4zeKDnZng4Lg3sNJyEenfSXNBw
         zqhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/8Oj2Ff4RNeFgOmfCdgYmb1Rv0nrDRFoL1TCNAUQ/o=;
        b=s2ypudpy0SN7e3Fpf6sEiEktxA180Jhsoknl1B0k6OkRLA/p06aZ90UJk095LoSu7z
         NRkmbHfuboqdRR0cprVJQ8hdgG/h/5C3UDxG9y+27O30tUkKADe+PVGw8flBQVWVcAex
         Fig21GuPd7BwkbRTPKsJShWXHNJGlEEQUtf8wtue24H4qsOinCeLZ6eByD6YCoIM/NN0
         hq6IhVwbCG0wHMP4S7PmaovEZIPKWVZ0OEjJ3Lw1OfPU77TygfthSnbVq5ZYJb2oCjmk
         f5dUrf8dUJN1JCUaSanwP8Cu9VqYCA7EknQRmWPNYXypCAQxvLMY+KBKWerLsUlDA1+0
         PetA==
X-Gm-Message-State: AGi0PuZ3cuSClofWo2bUZjkTFPGNcFNwPKiRsz4wrxGJQQFxYvNABH3l
        lRVlc1pB9I/ZpblK6SolWZ0zRst2UFXfWw==
X-Google-Smtp-Source: APiQypLFNa0iq7FcJIsNnR0q+E2j2o7kKhdFBPxwEhRWY0x22Ax8qUNIEA1qWVfl+NNn9FY0tHMS0Q==
X-Received: by 2002:adf:b189:: with SMTP id q9mr4629573wra.373.1585854691656;
        Thu, 02 Apr 2020 12:11:31 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:30 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 05/14] wil6210: check rx_buff_mgmt before accessing it
Date:   Thu,  2 Apr 2020 20:12:11 +0100
Message-Id: <20200402191220.787381-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191220.787381-1-lee.jones@linaro.org>
References: <20200402191220.787381-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dedy Lansky <dlansky@codeaurora.org>

[ Upstream commit d6a553c0c61b0b0219764e4d4fc14e385085f374 ]

Make sure rx_buff_mgmt is initialized before accessing it.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 5fa8d6ad66482..03d0e6c550b98 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -268,6 +268,9 @@ static void wil_move_all_rx_buff_to_free_list(struct wil6210_priv *wil,
 	struct list_head *active = &wil->rx_buff_mgmt.active;
 	dma_addr_t pa;
 
+	if (!wil->rx_buff_mgmt.buff_arr)
+		return;
+
 	while (!list_empty(active)) {
 		struct wil_rx_buff *rx_buff =
 			list_first_entry(active, struct wil_rx_buff, list);
-- 
2.25.1

