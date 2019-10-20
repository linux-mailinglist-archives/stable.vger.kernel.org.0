Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958E3DDBCD
	for <lists+stable@lfdr.de>; Sun, 20 Oct 2019 03:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfJTBMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Oct 2019 21:12:01 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:32881 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfJTBMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Oct 2019 21:12:01 -0400
Received: by mail-ot1-f67.google.com with SMTP id 60so8146604otu.0;
        Sat, 19 Oct 2019 18:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tmeNnBR9S1SCuFrJpp3kQZBcbxBQd+8zTBR6qv6nK40=;
        b=gOIvq4CYqKV7ceeTZx2PrjuoOOIHq6QoyFzaH4d6D0d+LJaW/ttUKW8bcjgv7brdsg
         Qp8mBJqbBoIRrik1pg9nE7gOdImzL1fcTgRHQMD+Ief46jodtwxXM//Pl1n45ewWWkTj
         RZ6WXGiYp2sWBqa3b76kZe2SSXHMIdOvZjS6ju2+GY0B1Y96ICtUAXEKdW4gf7bocgwS
         wuxBd9Phr8ms6vGe32oFYyCii2KDqKSVuhH1M+kzXF/lOTUXrNAhNh8Ii+9cqnvOPpXo
         ubYaQqIGBTSapGOu1c2dxY4wN3RVUDXshQv28OpWqWaZWtk0z2T6xAjQfVT0yWQDrZho
         vSgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=tmeNnBR9S1SCuFrJpp3kQZBcbxBQd+8zTBR6qv6nK40=;
        b=kxgCIkYcEeWI5AKt3llu/42dQwOqTKGE3gmUPV4xybXQP8YxZQIBvIbCqYH0SRO5Mv
         EihjotzvnHURQK2GJy/MIuKAVI/0NQep7xVzQAcJbQlqKqdpyviUMP5eijAN3BZF42Gy
         DKmwvoQfXwIa5cJSpgoqlp6wtVVr7WHRYoe/NuiVl7DQRm4uYkKFQVLShS18Yb42tbPz
         WACWNUrnOMdSJo/z8WsJAOSXK7jp/Sk3bakDVGnv45Yi2qjcEEE4C4J/lHb/ClZJMWP3
         qQM1RgFlyPOLuCsdZpTVE/dEw7B7Hn3xxaproJkVbC4fATLZGUr3qZ2bUv0SMhU7Xnj5
         aefg==
X-Gm-Message-State: APjAAAVf04eaKYSP/7VA3k6x8zMbpnn9p4I5w4ujUqRonHG/I9zVkGuo
        fISRduTw92gNzIS0bjS2kIA=
X-Google-Smtp-Source: APXvYqy9n6pKg6zz2lyPx0o6xFTJmoEz774m82v191/8fXtcheaPGhgEEvPNTvVjJVNgsYzqoTw7jw==
X-Received: by 2002:a05:6830:10cc:: with SMTP id z12mr12740335oto.20.1571533920123;
        Sat, 19 Oct 2019 18:12:00 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id x140sm2631535oix.42.2019.10.19.18.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Oct 2019 18:11:58 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH V2] rtlwifi: rtl_pci: Fix problem of too small skb->len
Date:   Sat, 19 Oct 2019 20:11:53 -0500
Message-Id: <20191020011153.29383-1-Larry.Finger@lwfinger.net>
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
V2 - added missing usage of new len
---
Please Apply to 5.4
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 6087ec7a90a6..3e9185162e51 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -692,12 +692,15 @@ static void _rtl_pci_rx_to_mac80211(struct ieee80211_hw *hw,
 		dev_kfree_skb_any(skb);
 	} else {
 		struct sk_buff *uskb = NULL;
+		int len = skb->len;
 
+		if (unlikely(len <= FCS_LEN))
+			len = FCS_LEN + 2;
 		uskb = dev_alloc_skb(skb->len + 128);
 		if (likely(uskb)) {
 			memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
 			       sizeof(rx_status));
-			skb_put_data(uskb, skb->data, skb->len);
+			skb_put_data(uskb, skb->data, len);
 			dev_kfree_skb_any(skb);
 			ieee80211_rx_irqsafe(hw, uskb);
 		} else {
-- 
2.23.0

