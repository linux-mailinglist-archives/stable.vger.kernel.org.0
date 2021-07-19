Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837053CD529
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbhGSMNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhGSMNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:13:50 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D51C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:12:58 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id l1so23734724edr.11
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lYUriO2sUqROloobOwAsVnNmYA6XrVXYSAWT83qCQT4=;
        b=BMPKMwpl2F48JBG4/pbMREjca4tzqvKycumnWSoe0zpwzaU3BoLPWm+xvG4lxnebXb
         U7q8CPnNE5v1/I1X+tdo7bjoagfwrdaXIthC5Rf7avYvC/nn5swR2LzQb5YchIQ27zk8
         X6Kl+z4Z1lwssnINEHW0V1kDqAudMk7NDDsn5lLbdlcN4nBX3ZdxcDGGLU0LrVClXc2F
         0BFfPyRvnrfjRMBAWQ/OuA9mE8JzkfvfVCuXf6X4ua0T/+rbg4y2HnvfM/LrUsSnC90r
         c7z0IbDzbBy2xXbPLUoYq4m6kOOdy+mb4VPWFj0MXAX+mZcTjn25+kmqRI+zWfIpXjPZ
         MOlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lYUriO2sUqROloobOwAsVnNmYA6XrVXYSAWT83qCQT4=;
        b=EUJDDtQmXchwfUdQe2d+VNhp/bzvwa269eZcOhJGoFNEB0nkjcVM4wGhHNdc6YOisU
         O2t9b4kNAvQrfNfogl16EtigggcTDWCSc/2EbV+ToKhe0nudJA333HmEpZZq6rdoyGfy
         odPjIltjhHGSlYLRdWIluhkrzjahsx6gRrKmBLjWOdwVvu2s4j7WBnBPtYucNESLgT26
         E1dquYPwgCjxByLaf2i/USzWMDwzYZ1VuHybLHJVGj5QLuPzC5BallGxxa6mBEWCL3WT
         hN25L5EmPRmbjmKIV21pI3Ismj/XkqpSYV5jVfwU/9RC/LJU/4HUukKYu3X7SJ9UqcS2
         bA7Q==
X-Gm-Message-State: AOAM532P9nTE0upN9ab6K/oLTc2Sm4gEEIzbiHNtd/Xutbklkg8vZ095
        Z2OCwo8Tp01VX/rN967dRpskHL6flQbgDf8v+pg=
X-Google-Smtp-Source: ABdhPJzAbiyf9MxNIA4fTPwmkyOCfJjgpMKrPh8CuBrBZ2Lafuq7JGmpU/JlZ9+1/2TBksRlB/buZg==
X-Received: by 2002:a05:6402:312d:: with SMTP id dd13mr33940540edb.348.1626699269115;
        Mon, 19 Jul 2021 05:54:29 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r11sm5914257ejy.71.2021.07.19.05.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 05:54:28 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     stable@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>, linus.luessing@c0d3.blue,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 2/2] net: bridge: multicast: fix MRD advertisement router port marking race
Date:   Mon, 19 Jul 2021 15:54:25 +0300
Message-Id: <20210719125425.317547-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719125425.317547-1-razor@blackwall.org>
References: <20210719125425.317547-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

commit 000b7287b67555fee39d39fff75229dedde0dcbf upstream.

When an MRD advertisement is received on a bridge port with multicast
snooping enabled, we mark it as a router port automatically, that
includes adding that port to the router port list. The multicast lock
protects that list, but it is not acquired in the MRD advertisement case
leading to a race condition, we need to take it to fix the race.

Cc: stable@vger.kernel.org
Cc: linus.luessing@c0d3.blue
Fixes: 4b3087c7e37f ("bridge: Snoop Multicast Router Advertisements")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/bridge/br_multicast.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index e27fe6e6ecd4..869f1608c98a 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3100,7 +3100,9 @@ static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,
 	    igmp_hdr(skb)->type != IGMP_MRDISC_ADV)
 		return -ENOMSG;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 
 	return 0;
 }
@@ -3168,7 +3170,9 @@ static void br_ip6_multicast_mrd_rcv(struct net_bridge *br,
 	if (icmp6_hdr(skb)->icmp6_type != ICMPV6_MRDISC_ADV)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_multicast_ipv6_rcv(struct net_bridge *br,
-- 
2.31.1

