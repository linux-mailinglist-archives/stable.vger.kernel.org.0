Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD919B382
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388912AbgDAQhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388909AbgDAQg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:36:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B719C20857;
        Wed,  1 Apr 2020 16:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759019;
        bh=ohqJLmyECEmNlowxB0+bY4WZAdYt+06EO59CPW/sGCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgWApvuTM7faNIeOiLepUeKCLMnIrqi76Oq0GvijGXUWYoIyWL6R8N+yw4E3jlXuh
         A5KX0ay90nZI7iecRFef9ODlI3B3Pxd9tFv3uq+MIGp5AredU2/pOxl+RveG3bdupV
         sEdMjX58A8rVqN+aooO6/vOQ26B+6Q2Wo82HPqC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 051/102] net: ipv4: dont let PMTU updates increase route MTU
Date:   Wed,  1 Apr 2020 18:17:54 +0200
Message-Id: <20200401161542.614838063@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161530.451355388@linuxfoundation.org>
References: <20200401161530.451355388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 28d35bcdd3925e7293408cdb8aa5f2aac5f0d6e3 ]

When an MTU update with PMTU smaller than net.ipv4.route.min_pmtu is
received, we must clamp its value. However, we can receive a PMTU
exception with PMTU < old_mtu < ip_rt_min_pmtu, which would lead to an
increase in PMTU.

To fix this, take the smallest of the old MTU and ip_rt_min_pmtu.

Before this patch, in case of an update, the exception's MTU would
always change. Now, an exception can have only its lock flag updated,
but not the MTU, so we need to add a check on locking to the following
"is this exception getting updated, or close to expiring?" test.

Fixes: d52e5a7e7ca4 ("ipv4: lock mtu in fnhe when received PMTU < net.ipv4.route.min_pmtu")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6058dbc4e2c19..8f5c6fa54ac09 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -991,21 +991,22 @@ out:	kfree_skb(skb);
 static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 {
 	struct dst_entry *dst = &rt->dst;
+	u32 old_mtu = ipv4_mtu(dst);
 	struct fib_result res;
 	bool lock = false;
 
 	if (ip_mtu_locked(dst))
 		return;
 
-	if (ipv4_mtu(dst) < mtu)
+	if (old_mtu < mtu)
 		return;
 
 	if (mtu < ip_rt_min_pmtu) {
 		lock = true;
-		mtu = ip_rt_min_pmtu;
+		mtu = min(old_mtu, ip_rt_min_pmtu);
 	}
 
-	if (rt->rt_pmtu == mtu &&
+	if (rt->rt_pmtu == mtu && !lock &&
 	    time_before(jiffies, dst->expires - ip_rt_mtu_expires / 2))
 		return;
 
-- 
2.20.1



