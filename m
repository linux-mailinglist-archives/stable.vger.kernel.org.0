Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5079869096
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390424AbfGOOWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390338AbfGOOWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:22:51 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B65FB20896;
        Mon, 15 Jul 2019 14:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200570;
        bh=lK9lfElVqVXzrAUTT9+IEnKKOZByTMSF42kelGYAQdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHQIwVyhgzUhCYYvidnfc7USrglTuCpzJKkqD0JPCTw7v15yb57bOZ0XVdgPeCs12
         VkrhJeki3O4b86kdklzOieJuWAbuOiDUeBtsCbmz2WvKE3VuV5FUqVc3U9Y2P4tNZx
         XjPJ1/EWXjOzwkRL018JtCiuGGXgF9NsdZK7gffg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Kirjanov <kda@linux-powerpc.org>,
        Doug Ledford <dledford@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 080/158] ipoib: correcly show a VF hardware address
Date:   Mon, 15 Jul 2019 10:16:51 -0400
Message-Id: <20190715141809.8445-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>

[ Upstream commit 64d701c608fea362881e823b666327f5d28d7ffd ]

in the case of IPoIB with SRIOV enabled hardware
ip link show command incorrecly prints
0 instead of a VF hardware address.

Before:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0 MAC 00:00:00:00:00:00, spoof checking off, link-state disable,
trust off, query_rss off
...
After:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0     link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
checking off, link-state disable, trust off, query_rss off

v1->v2: just copy an address without modifing ifla_vf_mac
v2->v3: update the changelog

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
Acked-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 30f840f874b3..009615499b37 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1997,6 +1997,7 @@ static int ipoib_get_vf_config(struct net_device *dev, int vf,
 		return err;
 
 	ivf->vf = vf;
+	memcpy(ivf->mac, dev->dev_addr, dev->addr_len);
 
 	return 0;
 }
-- 
2.20.1

