Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1D93AEF6E
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhFUQih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232624AbhFUQgo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:36:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F9D261427;
        Mon, 21 Jun 2021 16:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292912;
        bh=g8hkcpIWnKJJCVub/cnjok61ZJ55LxZ85Spea6vkxXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nyXunIO1S5Jjgz9UQ2UnsWKo2NGam1U99dqT2amYmfoIZkrPBNCVFz4Qq15UVNOuP
         6kHLr6FFc4SfkGVlm8TveuEY7/wNl8IMB2eCVrznkwI9siZQj+H3E269q5p43Cr2sM
         rjACPRLF8ezGjJRmtBUBP8urlHGoIUMDql4QZK1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 031/178] net/sched: act_ct: handle DNAT tuple collision
Date:   Mon, 21 Jun 2021 18:14:05 +0200
Message-Id: <20210621154922.964935445@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
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
index ba7f57cb41c3..143786d8cde0 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -904,14 +904,19 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
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



