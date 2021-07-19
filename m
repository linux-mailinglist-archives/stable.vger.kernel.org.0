Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDA33CD527
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236979AbhGSMNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhGSMNc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:13:32 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67657C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:12:38 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id h8so23823553eds.4
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lYUriO2sUqROloobOwAsVnNmYA6XrVXYSAWT83qCQT4=;
        b=fg+STFcEmbBF0aMtU9t4RtIKFHhhEFRagQyEDdPsx+JQz91+/zEXw7lBgWHoW0sc1b
         CFtMe6CH2qC41q/x0lNwqd8oIFCeby87IO7iHwkle1NdP8oNCcW5FZM7IjGEK6akDzwi
         28rRk/xzirEB+w+qtgr5XjDQ2jat0ZJi19GzH6EQf2lXp1U0IGmjOFYhN89mL26fNkPz
         GbpCNeB8tYpX3bzNn1/XKsmJm1ReSFZHolOGfv+WW7SdmJOVAiICaaenFmHS8j/h+A5x
         avQH5XMjtJBbOaWZsoZm8dH4gdMR8gQqJFBQMgOafwtWJNJGj7Ut9Qnl1xA5zm4rfWsF
         HSBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lYUriO2sUqROloobOwAsVnNmYA6XrVXYSAWT83qCQT4=;
        b=FCzL4OjP6WJiIRkbYpKeEXGIgSLrVq7rWw3KpNO1M7Hi1OLO+qxoAbrs/1y+cW2ZUw
         YuuPiuMvJYy7DY8+21QM+HQZfImOeTcCOJ25cBnFXcwQxPTIG5YPKRn2AJogqnfzYn7b
         Fr8kwQMrBC++x6XClfIMlsv/xvdHd1Rv+p0qxvaUb/lTAGS/xP54lAzIOVSoKhtBl64a
         dPss2H8LeDERtl4346lmmiZMRxuwh2bAe7uAJjDehxWn6sxrcfbbP7rbao8Mm6qF3PRQ
         XB040FclvpSBH+rs+oDw2WyZFfXU87MaebOKBgZuh6CgeZvrYfqhTSdNeoYEVSerDzfb
         pIvg==
X-Gm-Message-State: AOAM530cGRl/M1mzwFohE+BFNzNSagCcdmLABkgUarVpEaOtw+pLbp6j
        pMLAGubHpwvrsyJbDhTnZsx8VwYlk5BmT0X7i1g=
X-Google-Smtp-Source: ABdhPJznUW1SBdoNHH8s6a493YX+vU4Nq3z4C7bz7dER1XZnxwQJjTG1WGO6cMPcQ8wFhMviFO3Epg==
X-Received: by 2002:aa7:cd5a:: with SMTP id v26mr33780347edw.287.1626699250163;
        Mon, 19 Jul 2021 05:54:10 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o26sm7797691edt.18.2021.07.19.05.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 05:54:09 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     stable@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>, linus.luessing@c0d3.blue,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 2/2] net: bridge: multicast: fix MRD advertisement router port marking race
Date:   Mon, 19 Jul 2021 15:53:55 +0300
Message-Id: <20210719125355.317449-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719125355.317449-1-razor@blackwall.org>
References: <20210719125355.317449-1-razor@blackwall.org>
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

