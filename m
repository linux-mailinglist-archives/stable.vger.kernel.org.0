Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57463AEE41
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231853AbhFUQ12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:27:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232203AbhFUQZk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:25:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E566A613B3;
        Mon, 21 Jun 2021 16:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292513;
        bh=TSxMnFp0YdvzQE0zM5wiWnge1FLRpeiMZNyFb7UoRw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sa2lShYHpmdChrNNswIpd6AHqkeeM6l/hdV4+KCMgqschThdyvjqGRas2jke1DN89
         5ryNYbhL2JOuHqyE98WSGGQh4EZSX4s4wPLf6dB3euR3UyrLsAU7WGLNS8xAdtP1GT
         9a9sKdtefCIp8ZnP706FQUeI2NU2MpFhbqwGiryo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/146] net/sched: act_ct: handle DNAT tuple collision
Date:   Mon, 21 Jun 2021 18:14:17 +0200
Message-Id: <20210621154912.201597488@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

[ Upstream commit 13c62f5371e3eb4fc3400cfa26e64ca75f888008 ]

This this the counterpart of 8aa7b526dc0b ("openvswitch: handle DNAT
tuple collision") for act_ct. From that commit changelog:

"""
With multiple DNAT rules it's possible that after destination
translation the resulting tuples collide.

...

Netfilter handles this case by allocating a null binding for SNAT at
egress by default.  Perform the same operation in openvswitch for DNAT
if no explicit SNAT is requested by the user and allocate a null binding
for SNAT for packets in the "original" direction.
"""

Fixes: 95219afbb980 ("act_ct: support asymmetric conntrack")
Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 315a5b2f3add..7ef074c6dd16 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -900,14 +900,19 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
 	}
 
 	err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
-	if (err == NF_ACCEPT &&
-	    ct->status & IPS_SRC_NAT && ct->status & IPS_DST_NAT) {
-		if (maniptype == NF_NAT_MANIP_SRC)
-			maniptype = NF_NAT_MANIP_DST;
-		else
-			maniptype = NF_NAT_MANIP_SRC;
-
-		err = ct_nat_execute(skb, ct, ctinfo, range, maniptype);
+	if (err == NF_ACCEPT && ct->status & IPS_DST_NAT) {
+		if (ct->status & IPS_SRC_NAT) {
+			if (maniptype == NF_NAT_MANIP_SRC)
+				maniptype = NF_NAT_MANIP_DST;
+			else
+				maniptype = NF_NAT_MANIP_SRC;
+
+			err = ct_nat_execute(skb, ct, ctinfo, range,
+					     maniptype);
+		} else if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL) {
+			err = ct_nat_execute(skb, ct, ctinfo, NULL,
+					     NF_NAT_MANIP_SRC);
+		}
 	}
 	return err;
 #else
-- 
2.30.2



