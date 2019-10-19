Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3408DDA92
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 21:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbfJSTCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Oct 2019 15:02:30 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:39625 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfJSTCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Oct 2019 15:02:30 -0400
Received: by mail-oi1-f193.google.com with SMTP id w144so7942834oia.6;
        Sat, 19 Oct 2019 12:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8fkGTWJ7nV0zqlGQILKgkuirDJcGK5IownLExBhIIBU=;
        b=m5FCJQzIgdyMX2abqBZPdulqgf4gkVcT82duLjP5DtD10mhWnlySxHWD+m0iO2H9lQ
         3YPfofm4Rn4Xh2VxvFWjEn9tzgEHAoheUkLhJdana7rBj5YmKQPt0RVzZddUzywamsoC
         yuEquaOiJVZ4pnBrVIIAQHliQ35uuvj/gekmtT+r+RSlyRDv0XZndgB7XF4DhTu6Uvq5
         N+DQBII5tkieA1sbby3stY1IQwyo/PwmCRDlowEzgieC7BMbesyQbS3Hun5f+BYn/v06
         3DriPsFWGPqxG2jPs3z4s0igKfyaxvR3AE60VBp43nhp/CPiWDLNW/fB4V95ELsnEX+e
         f14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=8fkGTWJ7nV0zqlGQILKgkuirDJcGK5IownLExBhIIBU=;
        b=ELUjdx5Px4Lde8mpQipV2AqEXZMwpcTVj15HOXO2Rdy6W2DW+mWszFpFSdBagHzjjf
         zo9D3/ZmhS56+yoeh/DNSnApKGgsM5MWAz+BHoxkAbLsoXay4c6a80afjxXQ98Phnrh5
         Un6KAfD4lMrOHBsnWFDgca5AKM03l5wPFeXNiZc7Qyy4b7qLMxTgFEeB7WbrL9eKL5mn
         r1j3Wx6bgNaR/Jf0XzglWk8pEN65wksmsBJi0M/1b/6sxZNZerlJKLMKAzm4h0cQ5Yxm
         zWnxW1KNN52icJuPycsNbcmNkJYe0mPQdA1CTsuke1NN808o7BQsKogEHINFEVS5nuHa
         zbhg==
X-Gm-Message-State: APjAAAXsfypIPs9CGP7Q7bnsceYf5BbhTzwZ2VjSSwQIdGNqmMlzk7on
        7q5ADWsO37RbUNU8T0V6pyo=
X-Google-Smtp-Source: APXvYqymv6JZ8koXfAiU6tyYOENvYSJwCkWYKATrdJieaXMpadqJvX5c2Us3xWjWxttswpivc4UZEQ==
X-Received: by 2002:aca:5357:: with SMTP id h84mr12928325oib.17.1571511748862;
        Sat, 19 Oct 2019 12:02:28 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id 109sm2621930otc.52.2019.10.19.12.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 12:02:28 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl_pci: Fix problem of too small skb->len
Date:   Sat, 19 Oct 2019 14:02:22 -0500
Message-Id: <20191019190222.29681-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 8020919a9b99 ("mac80211: Properly handle SKB with radiotap
only"), buffers whose length is too short cause a WARN_ON(1) to be
executed. This change exposed a fault in rtlwifi drivers, which is fixed
by increasing the length of the affected buffer before it is sent to
mac80211.

Cc: Stable <stable@vger.kernel.org> # v5.0+
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Kalle,

Please send to v5.4.

Larry
---

 drivers/net/wireless/realtek/rtlwifi/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 6087ec7a90a6..bb5144b7c64f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -692,7 +692,10 @@ static void _rtl_pci_rx_to_mac80211(struct ieee80211_hw *hw,
 		dev_kfree_skb_any(skb);
 	} else {
 		struct sk_buff *uskb = NULL;
+		int len = skb->len;
 
+		if (unlikely(len <= FCS_LEN))
+			len = FCS_LEN + 2;
 		uskb = dev_alloc_skb(skb->len + 128);
 		if (likely(uskb)) {
 			memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
-- 
2.23.0

