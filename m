Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D2B3C3624
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 20:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhGJSlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 14:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhGJSlA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 14:41:00 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B42C0613E5
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 11:38:15 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id z9so14391479ljm.2
        for <stable@vger.kernel.org>; Sat, 10 Jul 2021 11:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mosenkovs.lv; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mIJv2deqhOMpOnP04N17ikHc3lWENGrZFchXndtdyJ4=;
        b=SSFInKfE8pQCBXT4LJFKvlEqplepLSNjo0WUysDiXvurJFca5QccTeF/4oAGpC0uUH
         F+ncze4HV3HfJBmfbWn5I+PGhSA2wxdIdy253eLArLU7jR4DS6dqI6BYcc6Uqxur0HDp
         9NKCjpVxT56Xz3lQugX7lWVcFz1kOW7w9uc2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mIJv2deqhOMpOnP04N17ikHc3lWENGrZFchXndtdyJ4=;
        b=iu5iEUlXzDhv+DfzyqBw8w3XEnF1HWP7SFlDW0hES1IVMh083dhXiZNXqpDx58Yfw6
         y29AR/INrh2Dj1tAdE77tpN8XJslD+lNGzdDZ44HJ2qb/qg0rt4rOQivXnmz0frLLot0
         0vMhjkLQH/8Hc5aSDg83xhcMlBuSSNZEHUAovO+5qPAuMJ+AAwSoENBG6dJvSQV5kM4p
         irmEwRJADp1OISCPVb2KcSWuaHjxczkfies/YhkHZcLbfDLJMeaq16HY0FLoaw8BxvG9
         N9kP/ePKYe1mY+dXcNBFgUonCXSxr2vPXFYK/2P1J0+T2UG/CHELP5a6+OVZvdh/y0jx
         KN5g==
X-Gm-Message-State: AOAM53159WXOieXc3F9h0K4pzsrN4cd8IqdEIJWtc0sYR/9KiTZvuD12
        04eY7ijmmWe6o2CUFgsrmLZO3A==
X-Google-Smtp-Source: ABdhPJxV1jEs6WYYOOMSw381R0XJ01l7QPKwJpwLabzHhSvl8tgWkMotaQl8+c2dZ5Qlb85VrzPm0w==
X-Received: by 2002:a05:651c:1ac:: with SMTP id c12mr20569765ljn.179.1625942293578;
        Sat, 10 Jul 2021 11:38:13 -0700 (PDT)
Received: from ubuntu.ciemini.majas.lan (balticom-135-235.balticom.lv. [83.99.135.235])
        by smtp.gmail.com with ESMTPSA id n9sm763814lfu.49.2021.07.10.11.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 11:38:13 -0700 (PDT)
From:   Davis Mosenkovs <davis@mosenkovs.lv>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Davis Mosenkovs <davis@mosenkovs.lv>
Subject: [PATCH 4.14] mac80211: fix memory corruption in EAPOL handling
Date:   Sat, 10 Jul 2021 21:38:07 +0300
Message-Id: <20210710183807.5792-1-davis@mosenkovs.lv>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 557bb37533a3 ("mac80211: do not accept/forward invalid EAPOL
frames") uses skb_mac_header() before eth_type_trans() is called
leading to incorrect pointer, the pointer gets written to. This issue
has appeared during backporting to 4.4, 4.9 and 4.14.

Fixes: 557bb37533a3 ("mac80211: do not accept/forward invalid EAPOL frames")
Link: https://lore.kernel.org/r/CAHQn7pKcyC_jYmGyTcPCdk9xxATwW5QPNph=bsZV8d-HPwNsyA@mail.gmail.com
Cc: <stable@vger.kernel.org> # 4.14.x
Signed-off-by: Davis Mosenkovs <davis@mosenkovs.lv>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ac2c52709e1c..87926c6fe0bf 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2404,7 +2404,7 @@ ieee80211_deliver_skb(struct ieee80211_rx_data *rx)
 #endif
 
 	if (skb) {
-		struct ethhdr *ehdr = (void *)skb_mac_header(skb);
+		struct ethhdr *ehdr = (struct ethhdr *)skb->data;
 
 		/* deliver to local stack */
 		skb->protocol = eth_type_trans(skb, dev);
-- 
2.25.1

