Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6A13ADFEA
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 21:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhFTTbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 15:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbhFTTbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Jun 2021 15:31:53 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D933C061574;
        Sun, 20 Jun 2021 12:29:39 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id t40so17576166oiw.8;
        Sun, 20 Jun 2021 12:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qu6fBuMh64lrI4f61hCLY5QUT4ZgoRuYD96GPAue7zg=;
        b=OKcbKXOsRdz7SW/4lCerafSnc+FFg3AU0vulzjlEbV5Ca3q0TptA13xOyvSEJM51bF
         2VRn2nhsHzwrUOLE4Vs5CQv1HbVzd3ajc2uxZmZUL8pCThnXchYdVW++OIZx16muhFou
         jZSbJVl0ZhB3O0QUPZ8NY5DkApjrRYJyGWwEX8RfCBFt9H2iXIwKh50X7WSbeZQcww2O
         6nXoHS7W3EhBhHnCrmnjkeNF2X94UOTe5Ti0ok9cyJwbpi19OqREpp0m3iKYf7apcmEa
         fSkhajgEbmI6Hh0jQdzc/0r9zW/sHFL7NxLlftMExFxYQc+rUDEOxeSm98bVQx3tCTiy
         tQsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=Qu6fBuMh64lrI4f61hCLY5QUT4ZgoRuYD96GPAue7zg=;
        b=HoEfGZrV537kJA/aA2A79a72fSDRhK2tOCk/pnf7dEf0gI5EpoeDJUppc6mE5lenoy
         XHKZZfZOW0dRM6etJZPyrwHB8NJ/QWXGLDz4UWYxr8qRsnQ6rSbMYsa2xDx+4hykuoVa
         JoaNfdEa9tyQVooD5LN6ACXXsxisSIZxKB9h5MNKilvXoOgloCx/8uzINSH3h6Zpad0H
         MX94fbs2yu7OlB26abrttON5JZF6wh3RrkRvqhQ8K38fRYl1YVvCj35AKQTUj9/Chwsd
         YAObWAff53XYO6pQc03hVx/ZJq+UMwWoFAsCrR0dcIOrxVkT+lDZ+a54TrykII1W8zkG
         Lj0g==
X-Gm-Message-State: AOAM530tW0BWPz5x6R9SljRMEDWOBzy/LuwbyfyTkgvuTtnHhVNXRiLH
        F3PttE3ck0VAbEkUoCqlaEk=
X-Google-Smtp-Source: ABdhPJz3ndRuoqcarZlKK4Npc/trmAwIcIulEu0SMQcBGfn6RR1gPceRm0k9kKBqrrt/aMS6bWZwHQ==
X-Received: by 2002:aca:1c11:: with SMTP id c17mr15955572oic.77.1624217378873;
        Sun, 20 Jun 2021 12:29:38 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id 3sm3187612oob.1.2021.06.20.12.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 12:29:38 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH] rtw88: Fix some memory leaks
Date:   Sun, 20 Jun 2021 14:24:07 -0500
Message-Id: <20210620192407.22812-1-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
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

