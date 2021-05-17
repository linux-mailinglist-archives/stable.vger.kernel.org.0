Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC413830F6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240064AbhEQOdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238065AbhEQObB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:31:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C384461874;
        Mon, 17 May 2021 14:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260922;
        bh=wgvQslNOr1F/8lLug8UhFOeUi0yjiLj3rjoFMoLJVtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6JGsrK+PHAHfbpXLMUitd7b0BfuXL64T1GaQ6hrzot96iS1eBlE40wzWWzI987gr
         VfEzEMnu5BihNtI4Tw2W6E1mvs/pVA6A5hhX3rJrbZTt7zNuFCiuX2OOl4IjqXVaWh
         /bvdP2AIlX/waTEHz5mjoyho/UQH2wWChebg7y8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 035/329] net/sched: cls_flower: use ntohs for struct flow_dissector_key_ports
Date:   Mon, 17 May 2021 15:59:06 +0200
Message-Id: <20210517140303.235299868@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 6215afcb9a7e35cef334dc0ae7f998cc72c8465f ]

A make W=1 build complains that:

net/sched/cls_flower.c:214:20: warning: cast from restricted __be16
net/sched/cls_flower.c:214:20: warning: incorrect type in argument 1 (different base types)
net/sched/cls_flower.c:214:20:    expected unsigned short [usertype] val
net/sched/cls_flower.c:214:20:    got restricted __be16 [usertype] dst

This is because we use htons on struct flow_dissector_key_ports members
src and dst, which are defined as __be16, so they are already in network
byte order, not host. The byte swap function for the other direction
should have been used.

Because htons and ntohs do the same thing (either both swap, or none
does), this change has no functional effect except to silence the
warnings.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 14316ba9b3b3..a5212a3f86e2 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -209,16 +209,16 @@ static bool fl_range_port_dst_cmp(struct cls_fl_filter *filter,
 				  struct fl_flow_key *key,
 				  struct fl_flow_key *mkey)
 {
-	__be16 min_mask, max_mask, min_val, max_val;
+	u16 min_mask, max_mask, min_val, max_val;
 
-	min_mask = htons(filter->mask->key.tp_range.tp_min.dst);
-	max_mask = htons(filter->mask->key.tp_range.tp_max.dst);
-	min_val = htons(filter->key.tp_range.tp_min.dst);
-	max_val = htons(filter->key.tp_range.tp_max.dst);
+	min_mask = ntohs(filter->mask->key.tp_range.tp_min.dst);
+	max_mask = ntohs(filter->mask->key.tp_range.tp_max.dst);
+	min_val = ntohs(filter->key.tp_range.tp_min.dst);
+	max_val = ntohs(filter->key.tp_range.tp_max.dst);
 
 	if (min_mask && max_mask) {
-		if (htons(key->tp_range.tp.dst) < min_val ||
-		    htons(key->tp_range.tp.dst) > max_val)
+		if (ntohs(key->tp_range.tp.dst) < min_val ||
+		    ntohs(key->tp_range.tp.dst) > max_val)
 			return false;
 
 		/* skb does not have min and max values */
@@ -232,16 +232,16 @@ static bool fl_range_port_src_cmp(struct cls_fl_filter *filter,
 				  struct fl_flow_key *key,
 				  struct fl_flow_key *mkey)
 {
-	__be16 min_mask, max_mask, min_val, max_val;
+	u16 min_mask, max_mask, min_val, max_val;
 
-	min_mask = htons(filter->mask->key.tp_range.tp_min.src);
-	max_mask = htons(filter->mask->key.tp_range.tp_max.src);
-	min_val = htons(filter->key.tp_range.tp_min.src);
-	max_val = htons(filter->key.tp_range.tp_max.src);
+	min_mask = ntohs(filter->mask->key.tp_range.tp_min.src);
+	max_mask = ntohs(filter->mask->key.tp_range.tp_max.src);
+	min_val = ntohs(filter->key.tp_range.tp_min.src);
+	max_val = ntohs(filter->key.tp_range.tp_max.src);
 
 	if (min_mask && max_mask) {
-		if (htons(key->tp_range.tp.src) < min_val ||
-		    htons(key->tp_range.tp.src) > max_val)
+		if (ntohs(key->tp_range.tp.src) < min_val ||
+		    ntohs(key->tp_range.tp.src) > max_val)
 			return false;
 
 		/* skb does not have min and max values */
@@ -779,16 +779,16 @@ static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
 		       TCA_FLOWER_UNSPEC, sizeof(key->tp_range.tp_max.src));
 
 	if (mask->tp_range.tp_min.dst && mask->tp_range.tp_max.dst &&
-	    htons(key->tp_range.tp_max.dst) <=
-	    htons(key->tp_range.tp_min.dst)) {
+	    ntohs(key->tp_range.tp_max.dst) <=
+	    ntohs(key->tp_range.tp_min.dst)) {
 		NL_SET_ERR_MSG_ATTR(extack,
 				    tb[TCA_FLOWER_KEY_PORT_DST_MIN],
 				    "Invalid destination port range (min must be strictly smaller than max)");
 		return -EINVAL;
 	}
 	if (mask->tp_range.tp_min.src && mask->tp_range.tp_max.src &&
-	    htons(key->tp_range.tp_max.src) <=
-	    htons(key->tp_range.tp_min.src)) {
+	    ntohs(key->tp_range.tp_max.src) <=
+	    ntohs(key->tp_range.tp_min.src)) {
 		NL_SET_ERR_MSG_ATTR(extack,
 				    tb[TCA_FLOWER_KEY_PORT_SRC_MIN],
 				    "Invalid source port range (min must be strictly smaller than max)");
-- 
2.30.2



