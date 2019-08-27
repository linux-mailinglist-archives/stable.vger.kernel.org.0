Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C589F659
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 00:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbfH0Wqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 18:46:44 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:45379 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfH0Wqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 18:46:44 -0400
Received: by mail-oi1-f195.google.com with SMTP id v12so546643oic.12;
        Tue, 27 Aug 2019 15:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NRN9jDgZzBZ969hO8AcW+KEvnXMsADWSJP11xMrYntw=;
        b=aCPKU9PZaiCMIp8KlGaLbwABbNDg0quQmiEUZ54F8QCVpaBDMnSdm6i5C2dyp/7vxO
         NKl1n+kxWU0P79j6IHsJ8yICJatXJ+DumGLBIY/gJwntJJyak+6U286UmfpLyBDLGTt6
         EQtA+Mhtl8lr4j8+IMJRLSzEFnYDXegAnS0RqO/I05DpWERBcIqHy5JzQE4tr2x5IwFE
         6XBt+uoQLbfPBNTXnZj2RCyCI2CYOib3JWVMQ33s81k+UPu2SewyWtadKXSHMPMsOxtz
         IiSnQiM4+EJHiwQ7CZg1lbG7iCQD83GBRJSAUft/HaDhb9/xrE8W+Se8Dqs5NLr/B9G8
         GnHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NRN9jDgZzBZ969hO8AcW+KEvnXMsADWSJP11xMrYntw=;
        b=FiO0EnSvGAN5mR2WMXKIaP/dN0wrMM3Odsd0AzPLmOBj5wGs0dJAxa+MBHCLdYugXd
         xT5NF3LoT2RCkNqC6nexCVqcnWphmkT/uePqVq7zj4FJ8J9Ib6P6s85GIGB6UPf9iPJ/
         jVfiSruf9jx5jm/KHvX4wShlYT8/56ori0LGt2lVbhWN8meeXJ1oDZA1w2Jn3Yj0DORv
         FFNGCaajSRPx0gPi7dbahc7r3xruYNwx4yleqXLwOVxBsnIQ3T6EvNhkgECZ990ayX+O
         ImFMew3rDL5qgNUPy60JZiTcqdM6cUSv0P8lisjLy2CFxnJZCIKoibQwtqf8vLL+QbaG
         IaQw==
X-Gm-Message-State: APjAAAVawP3mzzfnzVkG/VenYRJKRcxWvVoWU6+qU17oi9VavaJZQQOa
        rHqq/j/AkruKLVjOviRxVgmXMg8z
X-Google-Smtp-Source: APXvYqxrvia+LyRjTnvSEJ/Fx2E2BP9YNGRaJxlritExaIbyOTqdSL8powTJv7g80+39roTHAeDysg==
X-Received: by 2002:aca:55d8:: with SMTP id j207mr792591oib.38.1566946003153;
        Tue, 27 Aug 2019 15:46:43 -0700 (PDT)
Received: from localhost.localdomain (cpe-70-114-247-242.austin.res.rr.com. [70.114.247.242])
        by smtp.gmail.com with ESMTPSA id a94sm289911otb.15.2019.08.27.15.46.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 15:46:42 -0700 (PDT)
From:   Denis Kenzior <denkenz@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Denis Kenzior <denkenz@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] mac80211: Don't memset RXCB prior to PAE intercept
Date:   Tue, 27 Aug 2019 17:41:19 -0500
Message-Id: <20190827224120.14545-2-denkenz@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190827224120.14545-1-denkenz@gmail.com>
References: <20190827224120.14545-1-denkenz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In ieee80211_deliver_skb_to_local_stack intercepts EAPoL frames if
mac80211 is configured to do so and forwards the contents over nl80211.
During this process some additional data is also forwarded, including
whether the frame was received encrypted or not.  Unfortunately just
prior to the call to ieee80211_deliver_skb_to_local_stack, skb->cb is
cleared, resulting in incorrect data being exposed over nl80211.

Fixes: 018f6fbf540d ("mac80211: Send control port frames over nl80211")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/mac80211/rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3c1ab870fefe..7c4aeac006fb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2452,6 +2452,8 @@ static void ieee80211_deliver_skb_to_local_stack(struct sk_buff *skb,
 		cfg80211_rx_control_port(dev, skb, noencrypt);
 		dev_kfree_skb(skb);
 	} else {
+		memset(skb->cb, 0, sizeof(skb->cb));
+
 		/* deliver to local stack */
 		if (rx->napi)
 			napi_gro_receive(rx->napi, skb);
@@ -2546,8 +2548,6 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 
 	if (skb) {
 		skb->protocol = eth_type_trans(skb, dev);
-		memset(skb->cb, 0, sizeof(skb->cb));
-
 		ieee80211_deliver_skb_to_local_stack(skb, rx);
 	}
 
-- 
2.19.2

