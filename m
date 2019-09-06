Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F2BABF1D
	for <lists+stable@lfdr.de>; Fri,  6 Sep 2019 20:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731584AbfIFSGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Sep 2019 14:06:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40698 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731486AbfIFSGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Sep 2019 14:06:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so3908968pgj.7
        for <stable@vger.kernel.org>; Fri, 06 Sep 2019 11:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p8V7F8KyP/+hxEP3mQzxR8zQvVH94st7p5AqUmIp58o=;
        b=KYxNmbyKb7HyYEXpPpjDcy/Dpd9jCTYKt/74keKiG2/HtRpP/uMNQTR5+Px2Vx+XET
         v3M9kvYTm7v7Au7BLwR9NgPNnRdvjymJcNFDAmCW3GGUJiIFPQi33CQCppw0DXIooxcZ
         B5RxsyCrpNrhM0AS8Fg3xiZDSBNNvKcYUxgZ6DMZi2zLsZ9hwqhAkjsY73zk2HS2RDW9
         ap56YyunzImXHMO9e48SVwU8uYB83UK8Zhfy27jG7ZV/74z200v2ARAckKv5L7zAKhCb
         WkQO1K3tNZgfZqJlRjDp6+BFvEw4lrOD2MQxe4MG5PRrdn+FRJdCVZnzwgos5+FqJS0Y
         tDgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p8V7F8KyP/+hxEP3mQzxR8zQvVH94st7p5AqUmIp58o=;
        b=e9hwR+uAmAHEKxTXbpLGTQX0NDEBy+bh92sW6qZMHnwDEL+NNuJ2tt3H3tCC8y0DzH
         hVY2BWIZklk8tXUvRpX2vA36/e9tHnR7ZSEgD0BLtdmLrhkDdLgJ23qmXFULApq26MWh
         +6aISKDmPPlcanmgkbtDPrassaVOemgsxh5v+sWeBD/l6kvSG80QzuxMcg8WWhg3WKXf
         4Hud48bFpg2cHfm0iSWv8RX6NQSBBGz/oNHA8YgIkxASEkTyhildmU8s5LRfZIoej2+d
         d+EykVRnEvi0GaiZIzQMJTb1u/TSi+IiGlo6fLBSVPgQPNLeo5y03AbjWe8ASmWoJ6dE
         /n+A==
X-Gm-Message-State: APjAAAWsGQ7nUDwbj213ci6WOtS4gLVFUk8gBEYpsnkMD6Tv0NlNQhH3
        8LQHRfM6lrG/v6wP4mpzDDdKSw==
X-Google-Smtp-Source: APXvYqz3R0KV2UoI6cPr+Bfc/NaNPL+NeUrRz64kO6R/9IPa6CJkQmQDFNK6q7XylojGJ0m1fgULUw==
X-Received: by 2002:a62:60c7:: with SMTP id u190mr12406747pfb.54.1567793159283;
        Fri, 06 Sep 2019 11:05:59 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:200:5404:91ba:59dc:9400])
        by smtp.gmail.com with ESMTPSA id b185sm8749287pfg.14.2019.09.06.11.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2019 11:05:58 -0700 (PDT)
From:   Mark Salyzyn <salyzyn@android.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, Mark Salyzyn <salyzyn@android.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] net: enable wireless core features with WIRELESS_ALLCONFIG
Date:   Fri,  6 Sep 2019 11:05:45 -0700
Message-Id: <20190906180551.163714-1-salyzyn@android.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In embedded environments the requirements are to be able to pick and
chose which features one requires built into the kernel.  If an
embedded environment wants to supports loading modules that have been
kbuilt out of tree, there is a need to enable hidden configurations
for core features to provide the API surface for them to load.

Introduce CONFIG_WIRELESS_ALLCONFIG to select all wireless core
features by activating all the hidden configuration options, without
having to specifically select any wireless module(s).

Signed-off-by: Mark Salyzyn <salyzyn@android.com>
Cc: kernel-team@android.com
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # 4.19
---
 net/wireless/Kconfig | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 67f8360dfcee..0d32350e1729 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -17,6 +17,20 @@ config WEXT_SPY
 config WEXT_PRIV
 	bool
 
+config WIRELESS_ALLCONFIG
+	bool "allconfig for wireless core"
+	select WIRELESS_EXT
+	select WEXT_CORE
+	select WEXT_PROC
+	select WEXT_SPY
+	select WEXT_PRIV
+	help
+	  Config option used to enable all the wireless core functionality
+	  used by modules.
+
+	  If you are not building a kernel to be used for a variety of
+	  out-of-kernel built wireless modules, say N here.
+
 config CFG80211
 	tristate "cfg80211 - wireless configuration API"
 	depends on RFKILL || !RFKILL
-- 
2.23.0.187.g17f5b7556c-goog

