Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD05D3CD538
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbhGSMPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:15:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbhGSMPu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:15:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DED7C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:15:08 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t2so23414778edd.13
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uyIqsIQypZpw94IKhYDdBJ94Ku3obaeFXaFQ2aAej8E=;
        b=LaL2os2J3dqVaYrtBg6cRWAoNvNLUy07WrEOLe2EhjzFNf1QPlN3jBXSVYb+IQUyP/
         NbjUc5uGWwlmqtGqEh3PMMdFpr6Lrq/qir6wfoReJANjGXXbVhOnVI9+r4BH8+hNh4eH
         M6vEZhqxNYKYcBbXKg1cZ1QwVk/dbQ//EoD1H/9iY+wh0GrGZSrGU9INQB6344zywh1C
         IK25ncDgU8ctcMdGSQz2nr2dW0xsQWdV51G5pOCTUDTOJDN9ShwxrghVuabaH6Nfk241
         mdsTX++EeoCraGN18oFwdKCU488JAOxDrVzIJ5CAoCF5x5O0Oa1X6P7vIgIVYBLg//Dv
         OaXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uyIqsIQypZpw94IKhYDdBJ94Ku3obaeFXaFQ2aAej8E=;
        b=Sj5h/MkrW+kWIPvXdSnnAyWm4kVcnZi7uiqOiap+VWKrl+iY1D3TxTwr4pqNro1eC4
         495XkOtLvXoT4+ZoB7T0Fu1plcwL4Xl9kqAJyygHMPBaxoYBC+fqKg8lImHTy+Pj5Zu3
         oXDavtN+xFCqYZqjqu+AxL/rQT1D7ENWuz+1+x4Q7pyTEs8p1IQQ6NDsyxEuS8e3cJMC
         dkXMCJigXfXQVPAn+x6FETUg1cctOfmGdBzlczXTXOWTRbhXag4UlhkKUjfgn7L3V7U9
         xFIbL2aaSOOdqHqfBExoMqU5KYkgYRwQbrd/qZuonYXj1Us/TeqKexcALIBil6trF2CW
         /Tng==
X-Gm-Message-State: AOAM532ym8lWY+eAUw196Zq4Ot3TiDFl1yzmdgbPO1FVBcXHde061DUF
        oHEgXnyEIS6wIZulN3K/jlyT+/FsQAVI6ZNk+RQ=
X-Google-Smtp-Source: ABdhPJwOzLVBALQIqzW7l0ZmTM4TmsfViyk8tBRs+V7TYFP4Ab5I5s0q96To0ind5DuLmp4eLX/EoQ==
X-Received: by 2002:a05:6402:516c:: with SMTP id d12mr33447041ede.323.1626699388678;
        Mon, 19 Jul 2021 05:56:28 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id k21sm7770281edo.41.2021.07.19.05.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 05:56:28 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     stable@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 1/2] net: bridge: multicast: fix PIM hello router port marking race
Date:   Mon, 19 Jul 2021 15:56:23 +0300
Message-Id: <20210719125624.317823-1-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

commit 04bef83a3358946bfc98a5ecebd1b0003d83d882 upstream.

When a PIM hello packet is received on a bridge port with multicast
snooping enabled, we mark it as a router port automatically, that
includes adding that port the router port list. The multicast lock
protects that list, but it is not acquired in the PIM message case
leading to a race condition, we need to take it to fix the race.

Cc: stable@vger.kernel.org
Fixes: 91b02d3d133b ("bridge: mcast: add router port on PIM hello message")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/bridge/br_multicast.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 5015ece7adf7..9e9a584cf993 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2998,7 +2998,9 @@ static void br_multicast_pim(struct net_bridge *br,
 	    pim_hdr_type(pimhdr) != PIM_TYPE_HELLO)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,
-- 
2.31.1

