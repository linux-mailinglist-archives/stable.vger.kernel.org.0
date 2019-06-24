Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5D3B5084D
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbfFXKQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730716AbfFXKQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:16:23 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E7FC205ED;
        Mon, 24 Jun 2019 10:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371382;
        bh=H7KcwCPzwp32GeAwrWEZjLk6EOetBgEastjIgXmS3yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vPzakvMUuUBJ9dPhT8epxeu3+tgryp52op+iBRU7xb5lf6YpyQQe3PWx8b6geIh7S
         vy9i1NXIVx0rLDK3+7Js60fu949yqeZZpP64Qr0j/lT0R/SqWXXay4Eirif04LI6Pr
         eqXxOcrLDPUzyi5AjSO0GiT8SykxQgW83k+5W+/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 083/121] s390/qeth: check dst entry before use
Date:   Mon, 24 Jun 2019 17:56:55 +0800
Message-Id: <20190624092325.085560220@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0cd6783d3c7d40be165d1f3c811cedf0e3dfcdf1 ]

While qeth_l3 uses netif_keep_dst() to hold onto the dst, a skb's dst
may still have been obsoleted (via dst_dev_put()) by the time that we
end up using it. The dst then points to the loopback interface, which
means the neighbour lookup in qeth_l3_get_cast_type() determines a bogus
cast type of RTN_BROADCAST.
For IQD interfaces this causes us to place such skbs on the wrong
HW queue, resulting in TX errors.

Fix-up the various call sites to first validate the dst entry with
dst_check(), and fall back accordingly.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l3_main.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index cb641fd303d3..93a5748036de 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1883,13 +1883,20 @@ static int qeth_l3_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 static int qeth_l3_get_cast_type(struct sk_buff *skb)
 {
+	int ipv = qeth_get_ip_version(skb);
 	struct neighbour *n = NULL;
 	struct dst_entry *dst;
 
 	rcu_read_lock();
 	dst = skb_dst(skb);
-	if (dst)
-		n = dst_neigh_lookup_skb(dst, skb);
+	if (dst) {
+		struct rt6_info *rt = (struct rt6_info *) dst;
+
+		dst = dst_check(dst, (ipv == 6) ? rt6_get_cookie(rt) : 0);
+		if (dst)
+			n = dst_neigh_lookup_skb(dst, skb);
+	}
+
 	if (n) {
 		int cast_type = n->type;
 
@@ -1904,7 +1911,7 @@ static int qeth_l3_get_cast_type(struct sk_buff *skb)
 	rcu_read_unlock();
 
 	/* no neighbour (eg AF_PACKET), fall back to target's IP address ... */
-	switch (qeth_get_ip_version(skb)) {
+	switch (ipv) {
 	case 4:
 		if (ipv4_is_lbcast(ip_hdr(skb)->daddr))
 			return RTN_BROADCAST;
@@ -1943,6 +1950,7 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 	struct qeth_hdr_layer3 *l3_hdr = &hdr->hdr.l3;
 	struct vlan_ethhdr *veth = vlan_eth_hdr(skb);
 	struct qeth_card *card = queue->card;
+	struct dst_entry *dst;
 
 	hdr->hdr.l3.length = data_len;
 
@@ -1993,15 +2001,27 @@ static void qeth_l3_fill_header(struct qeth_qdio_out_q *queue,
 
 	hdr->hdr.l3.flags = qeth_l3_cast_type_to_flag(cast_type);
 	rcu_read_lock();
+	dst = skb_dst(skb);
+
 	if (ipv == 4) {
-		struct rtable *rt = skb_rtable(skb);
+		struct rtable *rt;
+
+		if (dst)
+			dst = dst_check(dst, 0);
+		rt = (struct rtable *) dst;
 
 		*((__be32 *) &hdr->hdr.l3.next_hop.ipv4.addr) = (rt) ?
 				rt_nexthop(rt, ip_hdr(skb)->daddr) :
 				ip_hdr(skb)->daddr;
 	} else {
 		/* IPv6 */
-		const struct rt6_info *rt = skb_rt6_info(skb);
+		struct rt6_info *rt;
+
+		if (dst) {
+			rt = (struct rt6_info *) dst;
+			dst = dst_check(dst, rt6_get_cookie(rt));
+		}
+		rt = (struct rt6_info *) dst;
 
 		if (rt && !ipv6_addr_any(&rt->rt6i_gateway))
 			l3_hdr->next_hop.ipv6_addr = rt->rt6i_gateway;
-- 
2.20.1



