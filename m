Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823143CD526
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbhGSMNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhGSMNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:13:31 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DD5C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:12:37 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t2so23405004edd.13
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RLAFEMSHEAjHyWGb7WMVIwkHP/31gWjL5+vJ3R8qmhw=;
        b=pI/RNHMNdf+xOzZrP5hLjVDrBdORcbA4VLQKfqukCMh55KdzaqIaB7LE3UaEvIKaZg
         ca7LdROeE00RbyST1cZ+o6Gra0nUNAlaf2zm9fEV3Zxoiw92N+iaNa3BYCuX77e+5+pv
         Q1wsqNpSKwHwjAywNIvBg3BS+qxEhIw+BTG6cm8OFfmRVJCh560uX2Oa8nSdfekPT4O9
         vDdueCT4oUKkDcelhDQpH6qOo0EwP1pmQ+0WWvbUfPs6o+wNySc/VbXJcYF1MeauY1KX
         Q2HxrOzE8Grnz8RJGU/NI6QKuBJG1COkrwKRo8MlsiiQfVDDa9OSolJWaamLSIbi+Tik
         bmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RLAFEMSHEAjHyWGb7WMVIwkHP/31gWjL5+vJ3R8qmhw=;
        b=ctBb/FlbVjAiL8Khk23OB1MT68I9hN0Ukse33stJc1qxycFkzod5c205mhSYYK07w8
         dAPZEpBYCb777ULhyZt2RJ6i7HM6pQ6iSZsSABPUs+DRLanaZSK2bAbY7EEgjTQ9cHfI
         EjktABVgYsaV+cN64gPzueG2yYmP8z6PqkE3iWZU8/teuK/apNVnk/Bcf1cTFljk5wey
         ZqH2VubmHwmdqgEW76QIzQdolMe7/PMhAQYXDxrYa0DfswuyIn6RSYBgUsjZIQ0pJTtT
         qK7wE0dBqbcwXitpyQX9pGMI//Lt0dcGeqevzMsPD1eKuZ9YZEXmAr1TomCLV/nnaDSy
         4H1w==
X-Gm-Message-State: AOAM531uaJrOIzvbgf0BexNZkB2lE13E3IIZ401W7s3GjfoNd7iO/xRK
        QsEQYKXw5QotoeeddQZ+F4QqjL1Mypr6jRLUMuY=
X-Google-Smtp-Source: ABdhPJw7odC5PxrQxVgRhgFY5fSx2lm4Y+uLyHY73dlIsEPEGmMiBuq8t+uok1Uz/b3g5F3hU+KBiw==
X-Received: by 2002:a05:6402:1385:: with SMTP id b5mr34356687edv.276.1626699249199;
        Mon, 19 Jul 2021 05:54:09 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o26sm7797691edt.18.2021.07.19.05.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 05:54:08 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     stable@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 5.13 1/2] net: bridge: multicast: fix PIM hello router port marking race
Date:   Mon, 19 Jul 2021 15:53:54 +0300
Message-Id: <20210719125355.317449-1-razor@blackwall.org>
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
index 226bb05c3b42..e27fe6e6ecd4 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3087,7 +3087,9 @@ static void br_multicast_pim(struct net_bridge *br,
 	    pim_hdr_type(pimhdr) != PIM_TYPE_HELLO)
 		return;
 
+	spin_lock(&br->multicast_lock);
 	br_multicast_mark_router(br, port);
+	spin_unlock(&br->multicast_lock);
 }
 
 static int br_ip4_multicast_mrd_rcv(struct net_bridge *br,
-- 
2.31.1

