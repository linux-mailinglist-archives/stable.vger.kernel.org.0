Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71DB3CD539
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbhGSMPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236867AbhGSMPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:15:51 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A999C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:15:09 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id h2so23831752edt.3
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3KleoVijwUG1KPNuSx3FYt/OGw+iX0Uw0Awgf4mbYrs=;
        b=hG8kiC9BA+XKtqERmywGMfF9srMltkFUsp5w9drWT2Q3x/fB1HpRegLX3ks/gnxvmp
         7kibriLe/Eaf2n5U/yTIKFv71FKFe0Ib2WCB77k3RtZHUYtXUeBmXcBY6RelQ+mLgK89
         uDgrsTAufP4mK8DTO4UaPz+hX3A/hI1kl02uWvvSEFCo11Rgepr7wJ5ldSdNQvz9WPWt
         iYIcoTYr5lN2mapfls0rXSzTUJPrEx9b+esLKCGWDuTh3AkiboUKWwWF6CSiqIua19Yf
         /fSMLQmp/EkDNTCCb3YulxXY2Jn2QfR3VzMfxCen7hO/NW+WZJvGQojEmKRHQB4pTz3c
         23UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3KleoVijwUG1KPNuSx3FYt/OGw+iX0Uw0Awgf4mbYrs=;
        b=uhOc4kI78uzZsVjNaT/XAGXiDww+Z1c6R7lKfxqKd+SOZKeVl4/rD6D+uN0BkK/O8A
         jTP5cZVXXiKN1jPHLv85KQ3ZB/Lu2zJf8svdVqALR9fCKez7uXe4/y+urI95G0CSdKvZ
         FU67h8qOUsaaEBubw37bjAlF5shVPBXddR1L1i4gRwhjwf4C+NqkTWTe2xhiwALuGtQI
         UnRoI2VlfzY68oqlk8JxmzdgpNePnRPmYxsXdobXifsk9JwabpjbYvZDMm6F/5wSjik4
         CIsht5F0jgez1JrAD7Tnjes6MwRnyLb0ZeuA6ULkTcK/Nh22itGKPO8NvvVORsTWK77g
         Iiag==
X-Gm-Message-State: AOAM531C0fJuI7ozJsgAl6PbGGfsoOzV03oDsoI9LmBBpG4X/z2OxI34
        nRlU7H9x/YTl9v1lmzUVzEXQXuFsq9cyYsFqanE=
X-Google-Smtp-Source: ABdhPJw2GH+SvZlNHM6VAPJ9P0x0wttLfV509aUP0NrAFBDKNsrWUHtlzeMbv3F4RnlAw1CUeVcbnw==
X-Received: by 2002:a05:6402:13c9:: with SMTP id a9mr34236194edx.247.1626699389476;
        Mon, 19 Jul 2021 05:56:29 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id k21sm7770281edo.41.2021.07.19.05.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 05:56:29 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     stable@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>, linus.luessing@c0d3.blue,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 2/2] net: bridge: multicast: fix MRD advertisement router port marking race
Date:   Mon, 19 Jul 2021 15:56:24 +0300
Message-Id: <20210719125624.317823-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719125624.317823-1-razor@blackwall.org>
References: <20210719125624.317823-1-razor@blackwall.org>
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
index 9e9a584cf993..e5328a2777ec 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3011,7 +3011,9 @@ static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,
 	    igmp_hdr(skb)->type != IGMP_MRDISC_ADV)
 		return -ENOMSG;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 
 	return 0;
 }
@@ -3079,7 +3081,9 @@ static void br_ip6_multicast_mrd_rcv(struct net_bridge *br,
 	if (icmp6_hdr(skb)->icmp6_type != ICMPV6_MRDISC_ADV)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_multicast_ipv6_rcv(struct net_bridge *br,
-- 
2.31.1

