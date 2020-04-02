Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D78F19C9A1
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389054AbgDBTN3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:29 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36608 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388755AbgDBTN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:28 -0400
Received: by mail-wr1-f68.google.com with SMTP id 31so5590021wrs.3
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9HCLRvGXYC5n1AHCqufnjpyrxqZW9cO7ygbPcIujNSw=;
        b=BsY0Kfs4i+EDx4e3wReNotPSh6uLnvP77DrPfr8NDUHE6gH0oJ90+FmsNIFfPNlKE6
         oSkPLnfiSqImlVoW71BNJdg6YnfRozGZKeQyrxFVzz4sKPv0bb4wkNtaKQVPvAXKMENu
         7rRxdnnLLAKzKNq8+CYKCndImCHX+bR+JmrIZ2iy73bnuINsNvybcionXIA4WXjEt1e2
         zZP0JYnRqMYgF2oW0L761XdDMtEZDCP3hDoH73WiYF5eNOlL1aLGKSfvkzVfGJUW61u4
         AG08veddmwhun/SQCLipuQv7KyfFFTgICEwFszWpbaBwy3re2jek+0F4P1AZZDAPI/Dq
         pn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9HCLRvGXYC5n1AHCqufnjpyrxqZW9cO7ygbPcIujNSw=;
        b=adOLHkeWP4pnVnE5bXayH+bYgr3rklsNOiVkI6d82My5cahGIheVTKJO9kFJ9gG2jN
         Bo9W+pc49jaZUm/erLb3G4yJhDEFrtRxg81Ji8cofHF+l0cmvcwzCKPplRFfqfQPcUmj
         oHVN5/d6F67aup+5nt+0fy21/saG35HyjZ8fcwSmvwCMJX4/fmTTQzUoY8Yfb2Hm9vyR
         ofzF5P/sUs19BzS65K4WRks3B9266frwf9iVt5ti0TS1eb/in/xUzRY3P2id5v2rOqQI
         cHl9IR5mwiE3peeTszvhOYUOfw25AeXzG4qumcCcSgKJ5XrMnwHehsXGmzw1My+b8P9r
         bygg==
X-Gm-Message-State: AGi0PuaJMkHVfAhoTx8t2kh+tvkZH3dl2v0XZ9JDMQhVohFK58AO4MzP
        95tbDkW6MEBWJWPCl1rVwXEPelhh+6Smhw==
X-Google-Smtp-Source: APiQypIjBX7AttmMJKtOgTGnxRba0J4gOtjJkIl3wfhySyaUYXVN/k8TUQrTPyFesukh9t1mOC2hDQ==
X-Received: by 2002:adf:dfce:: with SMTP id q14mr5184354wrn.326.1585854806560;
        Thu, 02 Apr 2020 12:13:26 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:25 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 27/33] wil6210: abort properly in cfg suspend
Date:   Thu,  2 Apr 2020 20:13:47 +0100
Message-Id: <20200402191353.787836-27-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

[ Upstream commit 144a12a6d83f3ca34ddefce5dee4d502afd2fc5b ]

On-going operations were not aborted properly
and required locks were not taken.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index c374ed311520e..58784e77e215b 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1735,9 +1735,12 @@ static int wil_cfg80211_suspend(struct wiphy *wiphy,
 
 	wil_dbg_pm(wil, "suspending\n");
 
-	wil_p2p_stop_discovery(wil);
-
+	mutex_lock(&wil->mutex);
+	mutex_lock(&wil->p2p_wdev_mutex);
+	wil_p2p_stop_radio_operations(wil);
 	wil_abort_scan(wil, true);
+	mutex_unlock(&wil->p2p_wdev_mutex);
+	mutex_unlock(&wil->mutex);
 
 out:
 	return rc;
-- 
2.25.1

