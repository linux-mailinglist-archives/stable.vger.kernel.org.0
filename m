Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6197921712E
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgGGPY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730155AbgGGPYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:24:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 617BC20663;
        Tue,  7 Jul 2020 15:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135494;
        bh=1vbPAtHeq3nKicDWuZcnx1viEjrIU0IOgLUmA2NYj1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZiMDYxpyE9IIlFWcXDufi5MiK2bqEPowApSfOATO9GXax4OjjXIsVNB8me6UXePt
         qZD61EpmiRK/alhFejn1WGOBwstvek8C1h4MR4z1eif0XPxuZHCutrOHAoPlqXDSyk
         5NllH4fhP8vlWzY7bufLp0ifhtB+t703MWmYQuLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 056/112] hsr: remove hsr interface if all slaves are removed
Date:   Tue,  7 Jul 2020 17:17:01 +0200
Message-Id: <20200707145803.665343106@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145800.925304888@linuxfoundation.org>
References: <20200707145800.925304888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 34a9c361dd480041d790fff3d6ea58513c8769e8 ]

When all hsr slave interfaces are removed, hsr interface doesn't work.
At that moment, it's fine to remove an unused hsr interface automatically
for saving resources.
That's a common behavior of virtual interfaces.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_main.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index 26d6c39f24e16..e2564de676038 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -15,12 +15,23 @@
 #include "hsr_framereg.h"
 #include "hsr_slave.h"
 
+static bool hsr_slave_empty(struct hsr_priv *hsr)
+{
+	struct hsr_port *port;
+
+	hsr_for_each_port(hsr, port)
+		if (port->type != HSR_PT_MASTER)
+			return false;
+	return true;
+}
+
 static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 			     void *ptr)
 {
-	struct net_device *dev;
 	struct hsr_port *port, *master;
+	struct net_device *dev;
 	struct hsr_priv *hsr;
+	LIST_HEAD(list_kill);
 	int mtu_max;
 	int res;
 
@@ -85,8 +96,15 @@ static int hsr_netdev_notify(struct notifier_block *nb, unsigned long event,
 		master->dev->mtu = mtu_max;
 		break;
 	case NETDEV_UNREGISTER:
-		if (!is_hsr_master(dev))
+		if (!is_hsr_master(dev)) {
+			master = hsr_port_get_hsr(port->hsr, HSR_PT_MASTER);
 			hsr_del_port(port);
+			if (hsr_slave_empty(master->hsr)) {
+				unregister_netdevice_queue(master->dev,
+							   &list_kill);
+				unregister_netdevice_many(&list_kill);
+			}
+		}
 		break;
 	case NETDEV_PRE_TYPE_CHANGE:
 		/* HSR works only on Ethernet devices. Refuse slave to change
-- 
2.25.1



