Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F7F1E262D
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 17:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbgEZP7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 11:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729102AbgEZP7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 May 2020 11:59:25 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004AEC03E96D;
        Tue, 26 May 2020 08:59:24 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id z9so14220895oid.2;
        Tue, 26 May 2020 08:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dxBwsteWr6GHXVQjy1y6pzz/7l7a0qLRHpkn8Rfg8G4=;
        b=cW3I+KQD25tEhgCkoU6XSv0HPuraF9YCe8JlMFA6FyTmBEWsHWnwuB2G/S354tjiBm
         aAUkMA497GfYuWRxfp+vF8yj4ZViXrubcCKRk3ZcKHXtDOMJxMVoH0Zxt5z1mSprKQeo
         NlAopNDPj+K4TrK+jp2BY0g0fmWRfpXgUtygXWWfb43kiYGrgfzlYNc5S7QrNXMlX0ar
         fb3cGEGbz6RgmuD+AZDGgg6bhBqlFnf1yTdjg0iGrr3/YRu6ppf6Z8Yz5ZOUTaF+uHrF
         igz6XUSkGh3T4l+FQsvuBcicIZa8K4ff43AjlDyx2RTLfYzrzD9tFzXlE+eVG+JJrUKP
         vS6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=dxBwsteWr6GHXVQjy1y6pzz/7l7a0qLRHpkn8Rfg8G4=;
        b=fveuMNqWCvd0/Lgx4gwnfF7NRPFHSIYUfKPvScaj6E9Ss9346Wp+zt8unIEZUE43Yt
         V2izxRRdpLVBkoaTLjEatyC/k3PRCJoS1+/BtTo8FTQRMMpxWdowWU0xIVlCld5eU3Rn
         URUKuR794AwWp/PPU1JBtGVXPEA3t8ezxn+RsAdsIiNO3g/zqupEzym6WyMEjnHKg1Tg
         0d5izplpNqi1dnFvh4SxhtqFKkxsC5lCRg8/EM3Q2gdmQORpBGtnZEe1XNFlMkOFB3cK
         3J+/rsLHoUurVPUAZVqGClzlSEZhcqCcSse/ipM3v+ngEvET9KI7j/WX033qeQDsQaYZ
         aAuQ==
X-Gm-Message-State: AOAM533nxzTRmrM955LkoQd/ef8aU38I9CWl2EQ+B7FM/YdRjvFZbdC4
        gsfMeSTwOmyWRL+x1XPPAA8=
X-Google-Smtp-Source: ABdhPJx4FKcPbYYaSfYdlhpVym3hwCv21kikEHRV+gzULIKSD/FxFjAcnSK6wKGtJPReMurH8QtLcA==
X-Received: by 2002:aca:3746:: with SMTP id e67mr13978063oia.112.1590508764433;
        Tue, 26 May 2020 08:59:24 -0700 (PDT)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id k18sm36185otn.51.2020.05.26.08.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 08:59:24 -0700 (PDT)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        Stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] b43: Fix connection problem with WPA3
Date:   Tue, 26 May 2020 10:59:08 -0500
Message-Id: <20200526155909.5807-2-Larry.Finger@lwfinger.net>
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
b43 did not report that it could handle them. By setting MFP_CAPABLE using
ieee80211_set_hw(), the problem is fixed.

With this change, b43 will handle the ciohers it knows in hardare,
and let mac80211 handle the others in software. It is not necessary to
use the module parameter NOHWCRYPT to turn hardware encryption off.
Although this change essentially eliminates that module parameter,
I am choosing to keep it for cases where the hardware is broken,
and software encryption is required for all ciphers.

This patch fixes a prooblem that has been in the driver since it was first
merged with commit e4d6b7951812 ("[B43]: add mac80211-based driver for
modern BCM43xx devices").

Fixes e4d6b7951812 ("[B43]: add mac80211-based driver for modern BCM43xx devices")
Reported-and-tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
 drivers/net/wireless/broadcom/b43/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index 39da1a4c30ac..3ad94dad2d89 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -5569,7 +5569,7 @@ static struct b43_wl *b43_wireless_init(struct b43_bus_dev *dev)
 	/* fill hw info */
 	ieee80211_hw_set(hw, RX_INCLUDES_FCS);
 	ieee80211_hw_set(hw, SIGNAL_DBM);
-
+	ieee80211_hw_set(hw, MFP_CAPABLE);
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_AP) |
 		BIT(NL80211_IFTYPE_MESH_POINT) |
-- 
2.26.2

