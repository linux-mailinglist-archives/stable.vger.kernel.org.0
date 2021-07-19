Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B542C3CD540
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbhGSMQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237158AbhGSMQP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:16:15 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E4AC061766
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:15:35 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id bu12so28630264ejb.0
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ttzFvAohsntPzxwMZVqHuX1Oo9BLfMDsKb+NfeVVUEc=;
        b=IRVSkC4UpW17YnWXuOoievBPZ35G1lXidJh9WkPfZNU7uSBsjDxTC+vtqngDTbtxFP
         z6u2drZJ8nqr6oqr90Tke3IYQS9clK6SyQGeWjQd+2TgCdGdTio7CI4fHIoeTjLCLc9K
         nHiLX+cPFFnZQOUq4w5lQy23BFJOxKvWQJKwywv5p7Jne/7lGpHYBAKqBKupqEeWEW9Z
         d2qKy+uIjQw1SWNZNlgu/4k5d4XwGzuFCs/10plHhG1ddtV+NVurgWQNFhG5kRoDWKTC
         4OrJQB3LuurW8zIPD31HU98RIhdFZcNT1zz1eJ9k+wgBhJupnYqndOAlypAHn/8Ms/Y9
         B5SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ttzFvAohsntPzxwMZVqHuX1Oo9BLfMDsKb+NfeVVUEc=;
        b=eUBMXbNPsMWn8i4PT2/VvAegyXs/Dbu56R8FFI63Fd7vmrZA79qn+4y4QLQyPv0mxC
         IQM1PRDaAJ2N7yXbD1BgXDyQEL3+g8ynpYJxfB78IIdfpfiYzwspgvnKnxFMchlpvx5q
         AaS+AnaBZzqaIu0lc1OyQoQz+wk2k7XtWmFDElF7BaGb3lE9NpzR1R/Wh6FAaK+Bkjr+
         lKiQfwW2QR9vcMwNG5HUER/FyE7Wyt+0TUcRdWSFU0+9uogYZu/QW+XbXgByHXFHka4J
         1lfb1fn+ajDqPefkJhwxo+Pm6rnMz+MsmvFgIntGuDySa5GRiP7zjjyFYTen1qUcPBUO
         wm1Q==
X-Gm-Message-State: AOAM532XSTo72WH/L7C60YSntmSbqSgLyZXfeWYt9ODgnRiFKjKhVYm9
        CfpGeaIpYp5FWZx+p12Oae+288r8ga97rUpuC2I=
X-Google-Smtp-Source: ABdhPJz/wQn5Au5HguLn566VVxx/mp8Fy3KH+VLd5cSSPSSblyFd0208RdMx9x+uVwkbV19ZbBnZEQ==
X-Received: by 2002:a17:906:2541:: with SMTP id j1mr1927133ejb.128.1626699413267;
        Mon, 19 Jul 2021 05:56:53 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id n26sm3202284eds.63.2021.07.19.05.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 05:56:52 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     stable@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.14] net: bridge: multicast: fix PIM hello router port marking race
Date:   Mon, 19 Jul 2021 15:56:50 +0300
Message-Id: <20210719125650.318063-1-razor@blackwall.org>
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
index b24782d53474..4e3ff0b55ec1 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1763,7 +1763,9 @@ static void br_multicast_pim(struct net_bridge *br,
 	    pim_hdr_type(pimhdr) != PIM_TYPE_HELLO)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_multicast_ipv4_rcv(struct net_bridge *br,
-- 
2.31.1

