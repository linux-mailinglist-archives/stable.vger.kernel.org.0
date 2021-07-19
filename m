Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594523CD528
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236883AbhGSMNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhGSMNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:13:50 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC5AC061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:12:57 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id ee25so23758552edb.5
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 05:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RLAFEMSHEAjHyWGb7WMVIwkHP/31gWjL5+vJ3R8qmhw=;
        b=1FaLe+htYaJwyJ3GMphzurqMJmFij2cL77Ag/TI191/ZEvpxk92xcpsxZ4R6E/NxRU
         BGbBtM/e72+E6paPCkqXpxGA3/75kDpbf1SwIMB7ugayf3hDDB3ohsvvZdrnyDd0gpN3
         LblnVLKfllgVs07yUl8xV1yV0IUW02gpoF0WeLaB7CEHu5xLljBvIc8JQvOSGBxqT81f
         qD9UG7s3yNoiSoW/mUdk90C+BBWjY64TNHKg4kq5k/gLSoknm+TMfhEMtlKGNElP6BSj
         SIb4luWzHng3qD4/T7b0nh6k6cSk+rjSNYB8mJyvmtuqctGG6BXSF3R/nJWY+0loWbzj
         4x4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RLAFEMSHEAjHyWGb7WMVIwkHP/31gWjL5+vJ3R8qmhw=;
        b=OgAIdNNx+loBVltdmOED0l4uX8dsAoX7ZOMHv13wY1RRzfYNdTbpldHQjiDEv7r856
         3hpyuM7KwtgUmqFHwAct06aY03UndRdaf/w0Rx6KrQL4PuuWn095zXEmvJDl+6i9RcbU
         N6En6UuSXIeKpqquR2Tw4YcPDuK1TSRs5JtQHPpi0fxOMRnsxAjycztf9Az2pyR5RlFj
         2mxZWknuPJVM9+qVNPCnIrZHU+PgKGhAHR6mYJ6Wgo9m2Qe5Crp2ZbUQ/o+1pTKq3xLD
         mV+GmOxuqjOC1s7O0r6Mt2f6yNuhMTHBdxgBX6qzu8PykwR3vtptm71CehDIdF99509H
         qlDQ==
X-Gm-Message-State: AOAM53309ux6xdvNF86l53nCevknn4VCL7LNtCyCOqLTf/sXGQhtPuXU
        Xdg8wBzB3QtdH2LcfKWt57uF09eVvGR4BeAZc+Q=
X-Google-Smtp-Source: ABdhPJxPUpOioMRII1SbNie4TZloKE5fH6/+BVcBaWSer1U3vZxV+c1zm+NagTBiSR8aSawO45rr7g==
X-Received: by 2002:a05:6402:49a:: with SMTP id k26mr34109544edv.279.1626699268238;
        Mon, 19 Jul 2021 05:54:28 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r11sm5914257ejy.71.2021.07.19.05.54.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 05:54:27 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     stable@vger.kernel.org
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 1/2] net: bridge: multicast: fix PIM hello router port marking race
Date:   Mon, 19 Jul 2021 15:54:24 +0300
Message-Id: <20210719125425.317547-1-razor@blackwall.org>
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

