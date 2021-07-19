Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CFC3CD53A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236883AbhGSMQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhGSMQI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:16:08 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C3EC061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:15:26 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id l26so23776095eda.10
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mn+8wHHpC24at37S3PiMQmwjqA88jzhgo0Pf7gsKdqc=;
        b=OETIYjxOip8DKIfdTzpdcyOx9Qy4VlhnQKOz0nPpEwVHf1ji7dr4GUfb4lE4ML9JL4
         E9F/OIgU8mYlKgoVysDV+J7E63jj2BhMnfCcCUpx7pYmhK2CstrKE6W/kwi+mZG+5SVP
         RAGuM29XzEwtBVTrUj/on//XngKpBy8qwvmnPM1r0epQDC23mLAeiyx5k6/A6MopQITX
         muIFFrPfK/Mc11Jxinavj47R6j3WYvzaq4yYYi7sbEjAIS4ShhbUMxwv+Cdua83AOdYN
         sXnYfWKUjcnbA896Tv7kJVImpAvwXlFWd61MpLOBBPot2Y4D1PqAx/6rMBrYBjJu05v+
         qKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mn+8wHHpC24at37S3PiMQmwjqA88jzhgo0Pf7gsKdqc=;
        b=eWsze262AkJuzBInf3xD00Gr17Jxmc+TNDErjcVOEFqFVQmoO0whdSMBciK/ceUK+L
         Sc+IzpuC5zvR+JBIvpI/Lg3BjBBf80/7YfWKvbdJ+NKgjBjJbh5zGPUin64ZKXMtw9uF
         esgzhmvVJbUaCFYKed6UcmQjjDIbNVWAV/18t6GSNBhqYW7VL5jQq9eOvJPlZ+At2nAl
         KjCghuT5Yfoxs2jog0kDYBVVCpkkUbNhrD6V7kVexSaTnV9QL1cM2YEP2cdfqke/J9lm
         3An9nV8oevntfdT/WXd4KesY5mh0VNg+gqNAND7t8KfkxGiVMcJZ9ytpsr0rnB7ufq0H
         LyKQ==
X-Gm-Message-State: AOAM533ZkM+ZiBEl8T89Op7lbak0zfpcarZw/CNRLTfrPIJ2eFs9yxdR
        Z6+NAPrOjXti5dI8Zz/+fHHo1d+9u/fifJ5cs/o=
X-Google-Smtp-Source: ABdhPJweF3LWtptwNbvgMSDAcr+ldg3JOoI3Ys0UR1Fo7JDFO5spsJTwdcuhig1U99zbTICGlTwoyg==
X-Received: by 2002:a05:6402:4cb:: with SMTP id n11mr33929509edw.292.1626699405326;
        Mon, 19 Jul 2021 05:56:45 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id dd24sm7810455edb.45.2021.07.19.05.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 05:56:44 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     stable@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 4.19] net: bridge: multicast: fix PIM hello router port marking race
Date:   Mon, 19 Jul 2021 15:56:41 +0300
Message-Id: <20210719125641.317916-1-razor@blackwall.org>
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
index 6a362da211e1..3504c3acd38f 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1791,7 +1791,9 @@ static void br_multicast_pim(struct net_bridge *br,
 	    pim_hdr_type(pimhdr) != PIM_TYPE_HELLO)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_multicast_ipv4_rcv(struct net_bridge *br,
-- 
2.31.1

