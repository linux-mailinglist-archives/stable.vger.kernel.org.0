Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3824719B26A
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389651AbgDAQnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:43:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389650AbgDAQnl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:43:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E81D62063A;
        Wed,  1 Apr 2020 16:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759421;
        bh=VqqyroAfWhyQOvnteSX/FAKaG6w+Qak3m5q11T6oLKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIfJYyBegzHN6gozLHT6GJPpg5IY/Gohq4OEXBjiSwPgUxV0TcBzC3a761FaNKrvi
         dejak29f/cyzG/VjJJLw9bkUbYVwnqe5AesEHiNfx95ceWBJSQqg4yCF7oNYOgV4X1
         4Rzi+/xbrG1g9h9VCk91Pge7KZFR6hmSO9MMMngo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 073/148] net: ipv4: dont let PMTU updates increase route MTU
Date:   Wed,  1 Apr 2020 18:17:45 +0200
Message-Id: <20200401161600.427535721@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
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
index 8b855d3eec9e7..05fe1d0075444 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1014,21 +1014,22 @@ out:	kfree_skb(skb);
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



