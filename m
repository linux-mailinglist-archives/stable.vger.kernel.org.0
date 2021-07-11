Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1CC3C3B68
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 11:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbhGKKAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 06:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhGKKAv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 06:00:51 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9E66C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 02:58:04 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id i2-20020a05600c3542b02902058529ea07so9254031wmq.3
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 02:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m+ppdXaepSm57DIGWDBCLlBbyDz4JtRjsnYacqgtWjM=;
        b=fnQhTuQfvikn8wsBlfQW8wa3TbTUdvL0BRKK1SsYvIwdDSwNo5zRHUXHIZiOrK1j0E
         DyOKpo7teKbeuC/1PSB5SYfWmdurOnmS2ML5Z3ywee1IsWq5zt134nq8CTF6o2Wpgagk
         vECivnNM30xVlMiDEndXTNjjyh24f6Uzcd5NrEZJRcUg4/anj/GxVspV+dI7IWBqik86
         utcc1VgQn9CSpmE3l212ly279r+QKBnk+8jfqmMAgn+bx31+Mus5OX/xNlcarV+grdl5
         Q+InIy7uEBcuh9LioRmh5VeBkXK1vglUBKECuZ3uu5JdQ8W2jW1QLLuft4wHStY4mr7Y
         b+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m+ppdXaepSm57DIGWDBCLlBbyDz4JtRjsnYacqgtWjM=;
        b=SN2kEXQvVuLkoc2MCYCAG1Y2gFJ5Qh/DgI/00YIoccQMgnEXZ7HDcnZrclZQSNeN7W
         eSGAKlv8TKUzEeLRHIWOXZ/K4FI9UZSZ7gQl5aqP4J4aXkZ8chmYymFrKOcC8Q+NmrYS
         4Cfao8DCF2SKwfkpGeATBDuGkIabwzPolVbdmH96p7YX0I/XR+kONxJmPVQLfmftX1rx
         LUOAWcD5xQ+Qm30BAmZiS65lf4h4lEavKpdbb0iZFYMSWgfEzAP6u2fpg/2t0A3oF4Vw
         Uwv28G4at4u/EwxT736rdGW31wM+bpmVemVtgj5DMny3Tg6yBzYqsYhvSELVv/NGVW3l
         fIQw==
X-Gm-Message-State: AOAM531WxjYYbzStWV2gOAC3zTCpC/XHfiztNQvOCEBIg+F9/Zpl8vhy
        UJDQsSbRB5XxlQzl8SbtA+Yaig==
X-Google-Smtp-Source: ABdhPJxMh5N/ZT1NO0GnZgOu0FK2DLpUQFpXk8FKrgs6M75XgwrtwyhH5hhkTruYNbSlG7vuXVK94A==
X-Received: by 2002:a1c:7314:: with SMTP id d20mr48433637wmb.167.1625997483257;
        Sun, 11 Jul 2021 02:58:03 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id m18sm9095567wmq.45.2021.07.11.02.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 02:58:02 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        linus.luessing@c0d3.blue
Subject: [PATCH net 2/2] net: bridge: multicast: fix MRD advertisement router port marking race
Date:   Sun, 11 Jul 2021 12:56:29 +0300
Message-Id: <20210711095629.2986949-3-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210711095629.2986949-1-razor@blackwall.org>
References: <20210711095629.2986949-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

When an MRD advertisement is received on a bridge port with multicast
snooping enabled, we mark it as a router port automatically, that
includes adding that port to the router port list. The multicast lock
protects that list, but it is not acquired in the MRD advertisement case
leading to a race condition, we need to take it to fix the race.

Cc: stable@vger.kernel.org
Cc: linus.luessing@c0d3.blue
Fixes: 4b3087c7e37f ("bridge: Snoop Multicast Router Advertisements")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 3bbbc6d7b7c3..d0434dc8c03b 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3277,7 +3277,9 @@ static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,
 	    igmp_hdr(skb)->type != IGMP_MRDISC_ADV)
 		return -ENOMSG;
 
+	spin_lock(&br->multicast_lock);
 	br_ip4_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 
 	return 0;
 }
@@ -3345,7 +3347,9 @@ static void br_ip6_multicast_mrd_rcv(struct net_bridge *br,
 	if (icmp6_hdr(skb)->icmp6_type != ICMPV6_MRDISC_ADV)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_ip6_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_multicast_ipv6_rcv(struct net_bridge *br,
-- 
2.31.1

