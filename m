Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09B15F997A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbiJJHMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbiJJHLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:11:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D3710F8;
        Mon, 10 Oct 2022 00:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC26AB80E53;
        Mon, 10 Oct 2022 07:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE11C433C1;
        Mon, 10 Oct 2022 07:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385670;
        bh=J3qP/71WZE3twwF9thKP8f6NNZtN+8NAb36zETMPdVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=108YL6ToL2qt2a+aoNJ5yt6meANDcha3M0jfpcMKERDDsr8ZpWKZQOOHlW3sZa27D
         +7LbRUwyP2sBqjKb/DQ4gkBCarMAeqqiAeDmhCnAEVmRVrs2O0cYY72m13inQ8q3aS
         qq0w17a6PDvvHV0kW8zrjalycwviB6VcpRZz15Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haimin Zhang <tcs_kernel@tencent.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 17/37] net/ieee802154: fix uninit value bug in dgram_sendmsg
Date:   Mon, 10 Oct 2022 09:05:36 +0200
Message-Id: <20221010070331.728862646@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haimin Zhang <tcs.kernel@gmail.com>

[ Upstream commit 94160108a70c8af17fa1484a37e05181c0e094af ]

There is uninit value bug in dgram_sendmsg function in
net/ieee802154/socket.c when the length of valid data pointed by the
msg->msg_name isn't verified.

We introducing a helper function ieee802154_sockaddr_check_size to
check namelen. First we check there is addr_type in ieee802154_addr_sa.
Then, we check namelen according to addr_type.

Also fixed in raw_bind, dgram_bind, dgram_connect.

Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ieee802154_netdev.h | 37 +++++++++++++++++++++++++++++
 net/ieee802154/socket.c         | 42 ++++++++++++++++++---------------
 2 files changed, 60 insertions(+), 19 deletions(-)

diff --git a/include/net/ieee802154_netdev.h b/include/net/ieee802154_netdev.h
index d0d188c3294b..a8994f307fc3 100644
--- a/include/net/ieee802154_netdev.h
+++ b/include/net/ieee802154_netdev.h
@@ -15,6 +15,22 @@
 #ifndef IEEE802154_NETDEVICE_H
 #define IEEE802154_NETDEVICE_H
 
+#define IEEE802154_REQUIRED_SIZE(struct_type, member) \
+	(offsetof(typeof(struct_type), member) + \
+	sizeof(((typeof(struct_type) *)(NULL))->member))
+
+#define IEEE802154_ADDR_OFFSET \
+	offsetof(typeof(struct sockaddr_ieee802154), addr)
+
+#define IEEE802154_MIN_NAMELEN (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, addr_type))
+
+#define IEEE802154_NAMELEN_SHORT (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, short_addr))
+
+#define IEEE802154_NAMELEN_LONG (IEEE802154_ADDR_OFFSET + \
+	IEEE802154_REQUIRED_SIZE(struct ieee802154_addr_sa, hwaddr))
+
 #include <net/af_ieee802154.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
@@ -165,6 +181,27 @@ static inline void ieee802154_devaddr_to_raw(void *raw, __le64 addr)
 	memcpy(raw, &temp, IEEE802154_ADDR_LEN);
 }
 
+static inline int
+ieee802154_sockaddr_check_size(struct sockaddr_ieee802154 *daddr, int len)
+{
+	struct ieee802154_addr_sa *sa;
+
+	sa = &daddr->addr;
+	if (len < IEEE802154_MIN_NAMELEN)
+		return -EINVAL;
+	switch (sa->addr_type) {
+	case IEEE802154_ADDR_SHORT:
+		if (len < IEEE802154_NAMELEN_SHORT)
+			return -EINVAL;
+		break;
+	case IEEE802154_ADDR_LONG:
+		if (len < IEEE802154_NAMELEN_LONG)
+			return -EINVAL;
+		break;
+	}
+	return 0;
+}
+
 static inline void ieee802154_addr_from_sa(struct ieee802154_addr *a,
 					   const struct ieee802154_addr_sa *sa)
 {
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 7bb9ef35c570..fd5862f9e26a 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -200,8 +200,9 @@ static int raw_bind(struct sock *sk, struct sockaddr *_uaddr, int len)
 	int err = 0;
 	struct net_device *dev = NULL;
 
-	if (len < sizeof(*uaddr))
-		return -EINVAL;
+	err = ieee802154_sockaddr_check_size(uaddr, len);
+	if (err < 0)
+		return err;
 
 	uaddr = (struct sockaddr_ieee802154 *)_uaddr;
 	if (uaddr->family != AF_IEEE802154)
@@ -493,7 +494,8 @@ static int dgram_bind(struct sock *sk, struct sockaddr *uaddr, int len)
 
 	ro->bound = 0;
 
-	if (len < sizeof(*addr))
+	err = ieee802154_sockaddr_check_size(addr, len);
+	if (err < 0)
 		goto out;
 
 	if (addr->family != AF_IEEE802154)
@@ -564,8 +566,9 @@ static int dgram_connect(struct sock *sk, struct sockaddr *uaddr,
 	struct dgram_sock *ro = dgram_sk(sk);
 	int err = 0;
 
-	if (len < sizeof(*addr))
-		return -EINVAL;
+	err = ieee802154_sockaddr_check_size(addr, len);
+	if (err < 0)
+		return err;
 
 	if (addr->family != AF_IEEE802154)
 		return -EINVAL;
@@ -604,6 +607,7 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	struct ieee802154_mac_cb *cb;
 	struct dgram_sock *ro = dgram_sk(sk);
 	struct ieee802154_addr dst_addr;
+	DECLARE_SOCKADDR(struct sockaddr_ieee802154*, daddr, msg->msg_name);
 	int hlen, tlen;
 	int err;
 
@@ -612,10 +616,20 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 		return -EOPNOTSUPP;
 	}
 
-	if (!ro->connected && !msg->msg_name)
-		return -EDESTADDRREQ;
-	else if (ro->connected && msg->msg_name)
-		return -EISCONN;
+	if (msg->msg_name) {
+		if (ro->connected)
+			return -EISCONN;
+		if (msg->msg_namelen < IEEE802154_MIN_NAMELEN)
+			return -EINVAL;
+		err = ieee802154_sockaddr_check_size(daddr, msg->msg_namelen);
+		if (err < 0)
+			return err;
+		ieee802154_addr_from_sa(&dst_addr, &daddr->addr);
+	} else {
+		if (!ro->connected)
+			return -EDESTADDRREQ;
+		dst_addr = ro->dst_addr;
+	}
 
 	if (!ro->bound)
 		dev = dev_getfirstbyhwtype(sock_net(sk), ARPHRD_IEEE802154);
@@ -651,16 +665,6 @@ static int dgram_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	cb = mac_cb_init(skb);
 	cb->type = IEEE802154_FC_TYPE_DATA;
 	cb->ackreq = ro->want_ack;
-
-	if (msg->msg_name) {
-		DECLARE_SOCKADDR(struct sockaddr_ieee802154*,
-				 daddr, msg->msg_name);
-
-		ieee802154_addr_from_sa(&dst_addr, &daddr->addr);
-	} else {
-		dst_addr = ro->dst_addr;
-	}
-
 	cb->secen = ro->secen;
 	cb->secen_override = ro->secen_override;
 	cb->seclevel = ro->seclevel;
-- 
2.35.1



