Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 745FE3A0104
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbhFHSut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235300AbhFHSrs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:47:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B0E26140D;
        Tue,  8 Jun 2021 18:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177489;
        bh=fIOEOif+4m3JjVr/T7UF7uGZM0HAgbywGRpjqsl8jfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAcsm1MiBn0vsomMMNU9iW0Qxwmo6tE2MNRDB0xGZwPd1KKQMb0dks9pXgCM6kXrX
         vi8hoBVLKgpkdGg9sFhqEtZ7DW9nBMkceQmBqDYy2Uzau9x1/jdMz7WBp4Ncks1VvD
         MG42S7LjjOv4xYhvtlGnzby0FEMwvNhY3YbqHJTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 36/78] tipc: add extack messages for bearer/media failure
Date:   Tue,  8 Jun 2021 20:27:05 +0200
Message-Id: <20210608175936.481014748@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit b83e214b2e04204f1fc674574362061492c37245 ]

Add extack error messages for -EINVAL errors when enabling bearer,
getting/setting properties for a media/bearer

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bearer.c | 50 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index 0214aa1c4427..0e0161597749 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -233,7 +233,8 @@ void tipc_bearer_remove_dest(struct net *net, u32 bearer_id, u32 dest)
  */
 static int tipc_enable_bearer(struct net *net, const char *name,
 			      u32 disc_domain, u32 prio,
-			      struct nlattr *attr[])
+			      struct nlattr *attr[],
+			      struct netlink_ext_ack *extack)
 {
 	struct tipc_net *tn = tipc_net(net);
 	struct tipc_bearer_names b_names;
@@ -247,17 +248,20 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 
 	if (!bearer_name_validate(name, &b_names)) {
 		errstr = "illegal name";
+		NL_SET_ERR_MSG(extack, "Illegal name");
 		goto rejected;
 	}
 
 	if (prio > TIPC_MAX_LINK_PRI && prio != TIPC_MEDIA_LINK_PRI) {
 		errstr = "illegal priority";
+		NL_SET_ERR_MSG(extack, "Illegal priority");
 		goto rejected;
 	}
 
 	m = tipc_media_find(b_names.media_name);
 	if (!m) {
 		errstr = "media not registered";
+		NL_SET_ERR_MSG(extack, "Media not registered");
 		goto rejected;
 	}
 
@@ -271,6 +275,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 			break;
 		if (!strcmp(name, b->name)) {
 			errstr = "already enabled";
+			NL_SET_ERR_MSG(extack, "Already enabled");
 			goto rejected;
 		}
 		bearer_id++;
@@ -282,6 +287,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 			name, prio);
 		if (prio == TIPC_MIN_LINK_PRI) {
 			errstr = "cannot adjust to lower";
+			NL_SET_ERR_MSG(extack, "Cannot adjust to lower");
 			goto rejected;
 		}
 		pr_warn("Bearer <%s>: trying with adjusted priority\n", name);
@@ -292,6 +298,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 
 	if (bearer_id >= MAX_BEARERS) {
 		errstr = "max 3 bearers permitted";
+		NL_SET_ERR_MSG(extack, "Max 3 bearers permitted");
 		goto rejected;
 	}
 
@@ -305,6 +312,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	if (res) {
 		kfree(b);
 		errstr = "failed to enable media";
+		NL_SET_ERR_MSG(extack, "Failed to enable media");
 		goto rejected;
 	}
 
@@ -320,6 +328,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	if (res) {
 		bearer_disable(net, b);
 		errstr = "failed to create discoverer";
+		NL_SET_ERR_MSG(extack, "Failed to create discoverer");
 		goto rejected;
 	}
 
@@ -862,6 +871,7 @@ int tipc_nl_bearer_get(struct sk_buff *skb, struct genl_info *info)
 	bearer = tipc_bearer_find(net, name);
 	if (!bearer) {
 		err = -EINVAL;
+		NL_SET_ERR_MSG(info->extack, "Bearer not found");
 		goto err_out;
 	}
 
@@ -901,8 +911,10 @@ int __tipc_nl_bearer_disable(struct sk_buff *skb, struct genl_info *info)
 	name = nla_data(attrs[TIPC_NLA_BEARER_NAME]);
 
 	bearer = tipc_bearer_find(net, name);
-	if (!bearer)
+	if (!bearer) {
+		NL_SET_ERR_MSG(info->extack, "Bearer not found");
 		return -EINVAL;
+	}
 
 	bearer_disable(net, bearer);
 
@@ -960,7 +972,8 @@ int __tipc_nl_bearer_enable(struct sk_buff *skb, struct genl_info *info)
 			prio = nla_get_u32(props[TIPC_NLA_PROP_PRIO]);
 	}
 
-	return tipc_enable_bearer(net, bearer, domain, prio, attrs);
+	return tipc_enable_bearer(net, bearer, domain, prio, attrs,
+				  info->extack);
 }
 
 int tipc_nl_bearer_enable(struct sk_buff *skb, struct genl_info *info)
@@ -999,6 +1012,7 @@ int tipc_nl_bearer_add(struct sk_buff *skb, struct genl_info *info)
 	b = tipc_bearer_find(net, name);
 	if (!b) {
 		rtnl_unlock();
+		NL_SET_ERR_MSG(info->extack, "Bearer not found");
 		return -EINVAL;
 	}
 
@@ -1039,8 +1053,10 @@ int __tipc_nl_bearer_set(struct sk_buff *skb, struct genl_info *info)
 	name = nla_data(attrs[TIPC_NLA_BEARER_NAME]);
 
 	b = tipc_bearer_find(net, name);
-	if (!b)
+	if (!b) {
+		NL_SET_ERR_MSG(info->extack, "Bearer not found");
 		return -EINVAL;
+	}
 
 	if (attrs[TIPC_NLA_BEARER_PROP]) {
 		struct nlattr *props[TIPC_NLA_PROP_MAX + 1];
@@ -1059,12 +1075,18 @@ int __tipc_nl_bearer_set(struct sk_buff *skb, struct genl_info *info)
 		if (props[TIPC_NLA_PROP_WIN])
 			b->window = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
 		if (props[TIPC_NLA_PROP_MTU]) {
-			if (b->media->type_id != TIPC_MEDIA_TYPE_UDP)
+			if (b->media->type_id != TIPC_MEDIA_TYPE_UDP) {
+				NL_SET_ERR_MSG(info->extack,
+					       "MTU property is unsupported");
 				return -EINVAL;
+			}
 #ifdef CONFIG_TIPC_MEDIA_UDP
 			if (tipc_udp_mtu_bad(nla_get_u32
-					     (props[TIPC_NLA_PROP_MTU])))
+					     (props[TIPC_NLA_PROP_MTU]))) {
+				NL_SET_ERR_MSG(info->extack,
+					       "MTU value is out-of-range");
 				return -EINVAL;
+			}
 			b->mtu = nla_get_u32(props[TIPC_NLA_PROP_MTU]);
 			tipc_node_apply_property(net, b, TIPC_NLA_PROP_MTU);
 #endif
@@ -1192,6 +1214,7 @@ int tipc_nl_media_get(struct sk_buff *skb, struct genl_info *info)
 	rtnl_lock();
 	media = tipc_media_find(name);
 	if (!media) {
+		NL_SET_ERR_MSG(info->extack, "Media not found");
 		err = -EINVAL;
 		goto err_out;
 	}
@@ -1228,9 +1251,10 @@ int __tipc_nl_media_set(struct sk_buff *skb, struct genl_info *info)
 	name = nla_data(attrs[TIPC_NLA_MEDIA_NAME]);
 
 	m = tipc_media_find(name);
-	if (!m)
+	if (!m) {
+		NL_SET_ERR_MSG(info->extack, "Media not found");
 		return -EINVAL;
-
+	}
 	if (attrs[TIPC_NLA_MEDIA_PROP]) {
 		struct nlattr *props[TIPC_NLA_PROP_MAX + 1];
 
@@ -1246,12 +1270,18 @@ int __tipc_nl_media_set(struct sk_buff *skb, struct genl_info *info)
 		if (props[TIPC_NLA_PROP_WIN])
 			m->window = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
 		if (props[TIPC_NLA_PROP_MTU]) {
-			if (m->type_id != TIPC_MEDIA_TYPE_UDP)
+			if (m->type_id != TIPC_MEDIA_TYPE_UDP) {
+				NL_SET_ERR_MSG(info->extack,
+					       "MTU property is unsupported");
 				return -EINVAL;
+			}
 #ifdef CONFIG_TIPC_MEDIA_UDP
 			if (tipc_udp_mtu_bad(nla_get_u32
-					     (props[TIPC_NLA_PROP_MTU])))
+					     (props[TIPC_NLA_PROP_MTU]))) {
+				NL_SET_ERR_MSG(info->extack,
+					       "MTU value is out-of-range");
 				return -EINVAL;
+			}
 			m->mtu = nla_get_u32(props[TIPC_NLA_PROP_MTU]);
 #endif
 		}
-- 
2.30.2



