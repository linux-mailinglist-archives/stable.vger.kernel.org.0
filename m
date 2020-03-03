Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E113178009
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbgCCRyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:54:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:35440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731544AbgCCRyU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:54:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65DB120870;
        Tue,  3 Mar 2020 17:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258059;
        bh=HsMMMtuFBrmgN09XbK09/hXyX9IUjGtNnAz1PQKwXM8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkwkjwMKlZ5H3lCVemTFz1p/pi8nDMCzr1jfEnhLAfkmSPjSUx3snoApKp7upgbXm
         uPFbeEilLgyMYRY/+ArOjUtBRnmElKmHqh9VjfPUNCRI5yfUBpEW8Havlah5StTa1e
         OgVa26aaRqHgb+gizo3+vCM94jEtU5IZ0VTQoMxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 018/152] net: export netdev_next_lower_dev_rcu()
Date:   Tue,  3 Mar 2020 18:41:56 +0100
Message-Id: <20200303174304.547601697@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 7151affeef8d527f50b4b68a871fd28bd660023f ]

netdev_next_lower_dev_rcu() will be used to implement a function,
which is to walk all lower interfaces.
There are already functions that they walk their lower interface.
(netdev_walk_all_lower_dev_rcu, netdev_walk_all_lower_dev()).
But, there would be cases that couldn't be covered by given
netdev_walk_all_lower_dev_{rcu}() function.
So, some modules would want to implement own function,
which is to walk all lower interfaces.

In the next patch, netdev_next_lower_dev_rcu() will be used.
In addition, this patch removes two unused prototypes in netdevice.h.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/netdevice.h |    7 +++----
 net/core/dev.c            |    6 +++---
 2 files changed, 6 insertions(+), 7 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -72,6 +72,8 @@ void netdev_set_default_ethtool_ops(stru
 #define NET_RX_SUCCESS		0	/* keep 'em coming, baby */
 #define NET_RX_DROP		1	/* packet dropped */
 
+#define MAX_NEST_DEV 8
+
 /*
  * Transmit return codes: transmit return codes originate from three different
  * namespaces:
@@ -4294,11 +4296,8 @@ void *netdev_lower_get_next(struct net_d
 	     ldev; \
 	     ldev = netdev_lower_get_next(dev, &(iter)))
 
-struct net_device *netdev_all_lower_get_next(struct net_device *dev,
+struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
 					     struct list_head **iter);
-struct net_device *netdev_all_lower_get_next_rcu(struct net_device *dev,
-						 struct list_head **iter);
-
 int netdev_walk_all_lower_dev(struct net_device *dev,
 			      int (*fn)(struct net_device *lower_dev,
 					void *data),
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -146,7 +146,6 @@
 #include "net-sysfs.h"
 
 #define MAX_GRO_SKBS 8
-#define MAX_NEST_DEV 8
 
 /* This should be increased if a protocol with a bigger head is added. */
 #define GRO_MAX_HEAD (MAX_HEADER + 128)
@@ -6914,8 +6913,8 @@ static int __netdev_walk_all_lower_dev(s
 	return 0;
 }
 
-static struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
-						    struct list_head **iter)
+struct net_device *netdev_next_lower_dev_rcu(struct net_device *dev,
+					     struct list_head **iter)
 {
 	struct netdev_adjacent *lower;
 
@@ -6927,6 +6926,7 @@ static struct net_device *netdev_next_lo
 
 	return lower->dev;
 }
+EXPORT_SYMBOL(netdev_next_lower_dev_rcu);
 
 static u8 __netdev_upper_depth(struct net_device *dev)
 {


