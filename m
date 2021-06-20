Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D143AE014
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 21:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbhFTTnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 15:43:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbhFTTnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Jun 2021 15:43:32 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08D8C061574;
        Sun, 20 Jun 2021 12:41:16 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id w1so4400212oie.13;
        Sun, 20 Jun 2021 12:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C4t4/34qAmUK0cRQooLZaxuJ5+txKPG78U0BIO+ntvs=;
        b=BjIvQneEAf4otCGhlWYEZYxsFRfVv1Hga/+/oA/FVpSmRzf74o62w/mUL/hMZ0Omyn
         A7lm7OkoT22oprSv4Rq7hvEsvb4wFOmK4pYvuZZ3aCo0mq6Hn8X3ANQCQ/S8k/uNiGR8
         k1y80xtJqMwnY4g6xE9MZO2jI4OHSd5ImR8vXMRTtTPgUvKTY6AHRZIrfG8PlQGWqfFK
         4GrUVy653w2F9vLT2W2KFMOuZaWXc8bGYVSTc22nX9dFtAkiOYP9UTlrx5wtQ9quEmCa
         lyZu1cnTB6toh8KxhyM1xNIYMraj8odzQuJi9bmeWsxHEDJIFgesYJq6hLpTDVdYt/sH
         ISUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=C4t4/34qAmUK0cRQooLZaxuJ5+txKPG78U0BIO+ntvs=;
        b=JinfBAkBO7RL2t+YYOW449Tp0OhOTMh1dYFcPngHRHsZLfY3P7VDJMLqWENKEnqIX5
         k30qwtHb2/3quS4jp3W8/YvOjVQ4BctggDnPO+5tvnU8lerCwXP9d+o642EZQ8RsiLcs
         24lW5527FP9UGi9b1ZfkKPkPOLwkdhPMhZcNnm8P+IKYQ97lOKOazEihqyeEHYJL6xu6
         i9s4CkDzejd653MxWQVuR/GqwPxof10sFMAOIYs11jg7PK94A6D+w+Nf0NObe7L/T3bz
         O7ULqU0Ka/BdOZjZqoysFBwy8Txs9szLizzLaNnDhvK9Gkkgecobu8jrml4vZng+nyDm
         zl7Q==
X-Gm-Message-State: AOAM532UFZgeHhwbJwtcUkNMOQLGRVCfVD4lux6nx7QvlJJ82adR6v8Q
        hELIIA5SzMqUy1jchypqF8xELplQdBs=
X-Google-Smtp-Source: ABdhPJy4X+Kax8uZoAsyjF8W/5ZEL5REl+VlVfDhdvvW80U7mnDHzKic466Bpcj7EHxTqjRbvosovg==
X-Received: by 2002:a05:6808:a05:: with SMTP id n5mr22059942oij.93.1624218076216;
        Sun, 20 Jun 2021 12:41:16 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id 26sm3295893ooy.46.2021.06.20.12.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 12:41:15 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH v2] rtw88: Fix some memory leaks
Date:   Sun, 20 Jun 2021 14:41:10 -0500
Message-Id: <20210620194110.7520-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

There are memory leaks of skb's from routines rtw_fw_c2h_cmd_rx_irqsafe()
and rtw_coex_info_response(), both arising from C2H operations. There are
no leaks from the buffers sent to mac80211.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
v2 - add the missinf changelog.

---
 drivers/net/wireless/realtek/rtw88/coex.c | 4 +++-
 drivers/net/wireless/realtek/rtw88/fw.c   | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
index cedbf3825848..e81bf5070183 100644
--- a/drivers/net/wireless/realtek/rtw88/coex.c
+++ b/drivers/net/wireless/realtek/rtw88/coex.c
@@ -591,8 +591,10 @@ void rtw_coex_info_response(struct rtw_dev *rtwdev, struct sk_buff *skb)
 	struct rtw_coex *coex = &rtwdev->coex;
 	u8 *payload = get_payload_from_coex_resp(skb);
 
-	if (payload[0] != COEX_RESP_ACK_BY_WL_FW)
+	if (payload[0] != COEX_RESP_ACK_BY_WL_FW) {
+		dev_kfree_skb_any(skb);
 		return;
+	}
 
 	skb_queue_tail(&coex->queue, skb);
 	wake_up(&coex->wait);
diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 797b08b2a494..43525ad8543f 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -231,9 +231,11 @@ void rtw_fw_c2h_cmd_rx_irqsafe(struct rtw_dev *rtwdev, u32 pkt_offset,
 	switch (c2h->id) {
 	case C2H_BT_MP_INFO:
 		rtw_coex_info_response(rtwdev, skb);
+		dev_kfree_skb_any(skb);
 		break;
 	case C2H_WLAN_RFON:
 		complete(&rtwdev->lps_leave_check);
+		dev_kfree_skb_any(skb);
 		break;
 	default:
 		/* pass offset for further operation */
-- 
2.32.0

