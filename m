Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74342594E0
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731459AbgIAPoF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:44:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731756AbgIAPn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:43:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 638AC2064B;
        Tue,  1 Sep 2020 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975038;
        bh=fmxv0V4N9+tf7rxMDoxnYF0FThFSVdaQ05vU8gSpJss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuJe38zRU334eqOrKqPNubGoNYA3Xa9QmzKAR2/EatHoBUk/c3uOG7bwReL7oq0yK
         Uu+oLDmOOetZtvwp+bhHfbrrjM0dOCPWlKZ+PGGEDWboTQEMZYMxhCDToDPNoeF9Zm
         O4R9xT/wVSy87r594D95f6E8sbxZx7WJ0364dZD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 155/255] macvlan: validate setting of multiple remote source MAC addresses
Date:   Tue,  1 Sep 2020 17:10:11 +0200
Message-Id: <20200901151008.117626476@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

[ Upstream commit 8b61fba503904acae24aeb2bd5569b4d6544d48f ]

Remote source MAC addresses can be set on a 'source mode' macvlan
interface via the IFLA_MACVLAN_MACADDR_DATA attribute. This commit
tightens the validation of these MAC addresses to match the validation
already performed when setting or adding a single MAC address via the
IFLA_MACVLAN_MACADDR attribute.

iproute2 uses IFLA_MACVLAN_MACADDR_DATA for its 'macvlan macaddr set'
command, and IFLA_MACVLAN_MACADDR for its 'macvlan macaddr add' command,
which demonstrates the inconsistent behaviour that this commit
addresses:

 # ip link add link eth0 name macvlan0 type macvlan mode source
 # ip link set link dev macvlan0 type macvlan macaddr add 01:00:00:00:00:00
 RTNETLINK answers: Cannot assign requested address
 # ip link set link dev macvlan0 type macvlan macaddr set 01:00:00:00:00:00
 # ip -d link show macvlan0
 5: macvlan0@eth0: <BROADCAST,MULTICAST,DYNAMIC,UP,LOWER_UP> mtu 1500 ...
     link/ether 2e:ac:fd:2d:69:f8 brd ff:ff:ff:ff:ff:ff promiscuity 0
     macvlan mode source remotes (1) 01:00:00:00:00:00 numtxqueues 1 ...

With this change, the 'set' command will (rightly) fail in the same way
as the 'add' command.

Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 4942f6112e51f..5da04e9979894 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1269,6 +1269,9 @@ static void macvlan_port_destroy(struct net_device *dev)
 static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
 			    struct netlink_ext_ack *extack)
 {
+	struct nlattr *nla, *head;
+	int rem, len;
+
 	if (tb[IFLA_ADDRESS]) {
 		if (nla_len(tb[IFLA_ADDRESS]) != ETH_ALEN)
 			return -EINVAL;
@@ -1316,6 +1319,20 @@ static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[],
 			return -EADDRNOTAVAIL;
 	}
 
+	if (data[IFLA_MACVLAN_MACADDR_DATA]) {
+		head = nla_data(data[IFLA_MACVLAN_MACADDR_DATA]);
+		len = nla_len(data[IFLA_MACVLAN_MACADDR_DATA]);
+
+		nla_for_each_attr(nla, head, len, rem) {
+			if (nla_type(nla) != IFLA_MACVLAN_MACADDR ||
+			    nla_len(nla) != ETH_ALEN)
+				return -EINVAL;
+
+			if (!is_valid_ether_addr(nla_data(nla)))
+				return -EADDRNOTAVAIL;
+		}
+	}
+
 	if (data[IFLA_MACVLAN_MACADDR_COUNT])
 		return -EINVAL;
 
@@ -1372,10 +1389,6 @@ static int macvlan_changelink_sources(struct macvlan_dev *vlan, u32 mode,
 		len = nla_len(data[IFLA_MACVLAN_MACADDR_DATA]);
 
 		nla_for_each_attr(nla, head, len, rem) {
-			if (nla_type(nla) != IFLA_MACVLAN_MACADDR ||
-			    nla_len(nla) != ETH_ALEN)
-				continue;
-
 			addr = nla_data(nla);
 			ret = macvlan_hash_add_source(vlan, addr);
 			if (ret)
-- 
2.25.1



