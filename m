Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C604A41C5
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348685AbiAaLGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:06:00 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52250 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348484AbiAaLEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:04:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E09C1B82A65;
        Mon, 31 Jan 2022 11:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027C8C340E8;
        Mon, 31 Jan 2022 11:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627057;
        bh=ZoPY949hCwVCTd+mgsiOvYWdOrBBWHV7xdcxQnPKTBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkIadMKcOOgI2q9cK9evsJDbC1JMTadAYZbAlVxq9leVLHoijL8yObaiVpzv1xaxV
         10MWdqq6mtvhLIkq8PtWbP6r6vlqfBNJSZR37C9S7RLtIWhe6xCl17LXjEf3J9W3XE
         R4HZCGbTgXXyP3Qo2YrsyZ9rqs5HGX/glFaj2/ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 061/100] net-procfs: show net devices bound packet types
Date:   Mon, 31 Jan 2022 11:56:22 +0100
Message-Id: <20220131105222.483720997@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

commit 1d10f8a1f40b965d449e8f2d5ed7b96a7c138b77 upstream.

After commit:7866a621043f ("dev: add per net_device packet type chains"),
we can not get packet types that are bound to a specified net device by
/proc/net/ptype, this patch fix the regression.

Run "tcpdump -i ens192 udp -nns0" Before and after apply this patch:

Before:
  [root@localhost ~]# cat /proc/net/ptype
  Type Device      Function
  0800          ip_rcv
  0806          arp_rcv
  86dd          ipv6_rcv

After:
  [root@localhost ~]# cat /proc/net/ptype
  Type Device      Function
  ALL  ens192   tpacket_rcv
  0800          ip_rcv
  0806          arp_rcv
  86dd          ipv6_rcv

v1 -> v2:
  - fix the regression rather than adding new /proc API as
    suggested by Stephen Hemminger.

Fixes: 7866a621043f ("dev: add per net_device packet type chains")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net-procfs.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -193,12 +193,23 @@ static const struct seq_operations softn
 	.show  = softnet_seq_show,
 };
 
-static void *ptype_get_idx(loff_t pos)
+static void *ptype_get_idx(struct seq_file *seq, loff_t pos)
 {
+	struct list_head *ptype_list = NULL;
 	struct packet_type *pt = NULL;
+	struct net_device *dev;
 	loff_t i = 0;
 	int t;
 
+	for_each_netdev_rcu(seq_file_net(seq), dev) {
+		ptype_list = &dev->ptype_all;
+		list_for_each_entry_rcu(pt, ptype_list, list) {
+			if (i == pos)
+				return pt;
+			++i;
+		}
+	}
+
 	list_for_each_entry_rcu(pt, &ptype_all, list) {
 		if (i == pos)
 			return pt;
@@ -219,22 +230,40 @@ static void *ptype_seq_start(struct seq_
 	__acquires(RCU)
 {
 	rcu_read_lock();
-	return *pos ? ptype_get_idx(*pos - 1) : SEQ_START_TOKEN;
+	return *pos ? ptype_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
 }
 
 static void *ptype_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	struct net_device *dev;
 	struct packet_type *pt;
 	struct list_head *nxt;
 	int hash;
 
 	++*pos;
 	if (v == SEQ_START_TOKEN)
-		return ptype_get_idx(0);
+		return ptype_get_idx(seq, 0);
 
 	pt = v;
 	nxt = pt->list.next;
+	if (pt->dev) {
+		if (nxt != &pt->dev->ptype_all)
+			goto found;
+
+		dev = pt->dev;
+		for_each_netdev_continue_rcu(seq_file_net(seq), dev) {
+			if (!list_empty(&dev->ptype_all)) {
+				nxt = dev->ptype_all.next;
+				goto found;
+			}
+		}
+
+		nxt = ptype_all.next;
+		goto ptype_all;
+	}
+
 	if (pt->type == htons(ETH_P_ALL)) {
+ptype_all:
 		if (nxt != &ptype_all)
 			goto found;
 		hash = 0;


