Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C82D1E262F
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 17:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgEZP70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 11:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbgEZP70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 11:59:26 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA12C03E96D;
        Tue, 26 May 2020 08:59:26 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id v17so16755015ote.0;
        Tue, 26 May 2020 08:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DQ8gVpgHVGfTCy/8d6M/EI7esdWmDQI9qAQ3EdUpOBg=;
        b=on6ABHVzrIuk3ZU5P4ysqilGLLBUWmQHrtQ7fwQAwlb9Dqq5DyCl1LXOijRLennx/F
         zpv1a0zKH96wNqfqWGUf5bRczKbdGPWJD/pTocGKrUfHAXGI7vvkpRP+s/IXgsu9Hx4e
         ohN4KtNn+QjuyXu00JeZHRKNdQpfbuuFBVZIz+46Ysg5AgjOLB7qBZY4MZNl4EADwrcu
         IZcRMamG2qZKKBweXZzKkAXBRtOjkhX56ZNDEbfy0DLwCi1YZo8pKUG0LZPQQVg9w4FX
         QUjlSNbbk4jAXcsxyUDCtcrdGbR4+Z+VmwxbeqFRfZyQZn4GFkZzC11BkQ0PQQihIdu8
         06aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=DQ8gVpgHVGfTCy/8d6M/EI7esdWmDQI9qAQ3EdUpOBg=;
        b=gyJDd6HDHyGDNAes8QJSs8DwSCERBGS/WqIFlP0C6ZsS+NmRgXncR4oPQkqc0Hd8kt
         KjcRS+YeemzRbAvju5nLQl4UjYS4u3w0S0lhBz5H83pYrays97hNooukl5F/9AI4XIwU
         BNPSneO5Hdqguss3T+jIwa7qzhMjdolPR+W0K+4/QeCqfITPR3M2tz22/U5GeU44I9/B
         QP1zbM6N5pEYUW54QyM7aqaqBKylJhv3v7Z51F4Dud/kYclRIN71p/mORT6aya/ecutJ
         gJl5rs8h/p/8qPEe2uJfXoj8LfFTKI65qtVUm2XzNKNnFlwsG+fU/BP+d5SQth+kHrGX
         joxQ==
X-Gm-Message-State: AOAM531mCNK2P675NfI0gsK8jFfmja3Zxh3MQNKUWnaBas9wiZklZA+w
        wp5aTQhppzm5CqzY6/sjXbU=
X-Google-Smtp-Source: ABdhPJxD7OK1LeyHTXuiUgzqjpxZkYT4GVXsNxTVB/K1Pe/p3MScTeKm75knHvAc4kthp6ZxhRYmSw==
X-Received: by 2002:a9d:621:: with SMTP id 30mr238739otn.47.1590508765792;
        Tue, 26 May 2020 08:59:25 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id k18sm36185otn.51.2020.05.26.08.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 08:59:24 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 2/2] b43_legacy: Fix connection problem with WPA3
Date:   Tue, 26 May 2020 10:59:09 -0500
Message-Id: <20200526155909.5807-3-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526155909.5807-1-Larry.Finger@lwfinger.net>
References: <20200526155909.5807-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since the driver was first introduced into the kernel, it has only
handled the ciphers associated with WEP, WPA, and WPA2. It fails with
WPA3 even though mac80211 can handle those additional ciphers in software,
b43legacy did not report that it could handle them. By setting MFP_CAPABLE using
ieee80211_set_hw(), the problem is fixed.

With this change, b43legacy will handle the ciohers it knows in hardare,
and let mac80211 handle the others in software. It is not necessary to
use the module parameter NOHWCRYPT to turn hardware encryption off.
Although this change essentially eliminates that module parameter,
I am choosing to keep it for cases where the hardware is broken,
and software encryption is required for all ciphers.

This patch fixes a problem that has been in b43legacy since commit
75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx
devices").

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/b43legacy/main.c b/drivers/net/wireless/broadcom/b43legacy/main.c
index 8b6b657c4b85..5208a39fd6f7 100644
--- a/drivers/net/wireless/broadcom/b43legacy/main.c
+++ b/drivers/net/wireless/broadcom/b43legacy/main.c
@@ -3801,6 +3801,7 @@ static int b43legacy_wireless_init(struct ssb_device *dev)
 	/* fill hw info */
 	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, MFP_CAPABLE); /* Allow WPA3 in software */
 
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
-- 
2.26.2

