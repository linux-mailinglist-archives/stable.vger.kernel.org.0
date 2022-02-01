Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896034A6379
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 19:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbiBASRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 13:17:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56668 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233343AbiBASRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 13:17:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21C6B614A6;
        Tue,  1 Feb 2022 18:17:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D59C36AE2;
        Tue,  1 Feb 2022 18:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643739442;
        bh=axx0hirfpuLP7ciyUX3JOUDGdTEjVsMD+NDMyWTIHy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sd7SNj1wlfZcQKzmupw4pIKMKwHkA/1ogc4BxgtHXBKIZc2h9pypFcKm55/8DW009
         JNp0K7ikiz3kSPVxKopiwz8SlLkTp2yq62NTJydxrMrwEObL8LyGWM8WvHS4vnQ0J9
         IVEZYlYnFBKgSPwzSSVUcoovdz+NTIUgDP/k64Yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 17/25] net-procfs: show net devices bound packet types
Date:   Tue,  1 Feb 2022 19:16:41 +0100
Message-Id: <20220201180822.707270379@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220201180822.148370751@linuxfoundation.org>
References: <20220201180822.148370751@linuxfoundation.org>
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
@@ -207,12 +207,23 @@ static const struct file_operations soft
 	.release = seq_release,
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
@@ -233,22 +244,40 @@ static void *ptype_seq_start(struct seq_
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


