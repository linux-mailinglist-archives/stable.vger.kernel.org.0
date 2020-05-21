Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4841DDB78
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730119AbgEUX6g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:36 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DDFEC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:36 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id n36so8867246qvg.22
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=t1Ebs5RyOsrCUbuRL8x9WiX4CM5UPYjY+EL09/qgliM=;
        b=fF4L85YYjAHyUt8kf6hL4+OlD7S4wmiNSQkDzK3ZTuNJKQP+0Y4AGSGYWqIAJ/XGpG
         P+ElouHVfpvToiZMIvNAII5Rel986aQfEMir00KPB9x5BiMkJf0FRjNS1sw4fj4F8f13
         QSiGvMU5HMWMaKXSt7eO6jyp18/qJyGBp9daGOMMn37sXyDZnnky1SavxqkVPRcqn8sQ
         0Zg6t9+GPzRUgZaBSstqUiSp5sp7t/3/RGHRC5W200G+aXFPkRo69YuD2sLt5DzXbhth
         z4R5RIJ+Kj1NlmT0k8O8EYc8TtsQu7qDoW1CXJaJE8W2m7Hn8A+b/b+ddmpjtrE+qAZc
         W/Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=t1Ebs5RyOsrCUbuRL8x9WiX4CM5UPYjY+EL09/qgliM=;
        b=SOzlDBOYGvSSYF7ySMKqoWohvVLZhg8EXWnWJH5duCeEXUeSOwu/3NL+hwJNuAAma1
         mmHptJ9CAT1N9UfzDx07+PEVX6Tz+83sVl8lDQWbeLhJkZaUOHALCUgOlR9RQDmpe4Ri
         PeO5gIk1yPKg4c0UxhtuL9FrQigymqLGiff1AQNMKHmMz2V50/6R/olc71XlbgrosfqT
         nNLQ/d8SOG3GA+89pSCwuZgxSHFqW/ZRVAMpnWnY681uXkJSLSHYMz7uQ7Jz3Z94o+J9
         DJs3Lhuqwbs+fMbznvAFuQbXqzyosnTnibCCCTyKwcAIYvFczKHuneLMbMozdA5BgPxy
         Unkw==
X-Gm-Message-State: AOAM5313cKb68Ubza5FBEdGGxLhrbxYCwerav4nFxCrUAFU8DHWYhojC
        g/BokbVx+L9RZ39mwxB5F71650Wz12I/NQ==
X-Google-Smtp-Source: ABdhPJzj9YMxOmuDfwvPBTRnefSKW8WI7MwMMHUZ+H3lJTRu9lTinOGnFvG0RMeyjtJ+kdO/Osw1FMWLGujN5g==
X-Received: by 2002:a0c:e9c9:: with SMTP id q9mr1210156qvo.215.1590105515358;
 Thu, 21 May 2020 16:58:35 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:33 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-21-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 20/27] l2tp: hold tunnel used while creating sessions with netlink
From:   Giuliano Procida <gprocida@google.com>
To:     greg@kroah.com
Cc:     stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        "David S . Miller" <davem@davemloft.net>,
        Giuliano Procida <gprocida@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>

commit e702c1204eb57788ef189c839c8c779368267d70 upstream.

Use l2tp_tunnel_get() to retrieve tunnel, so that it can't go away on
us. Otherwise l2tp_tunnel_destruct() might release the last reference
count concurrently, thus freeing the tunnel while we're using it.

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_netlink.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index b86a2caa9356..22917e751edf 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -502,8 +502,9 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 		ret = -EINVAL;
 		goto out;
 	}
+
 	tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
+	tunnel = l2tp_tunnel_get(net, tunnel_id);
 	if (!tunnel) {
 		ret = -ENODEV;
 		goto out;
@@ -511,24 +512,24 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 
 	if (!info->attrs[L2TP_ATTR_SESSION_ID]) {
 		ret = -EINVAL;
-		goto out;
+		goto out_tunnel;
 	}
 	session_id = nla_get_u32(info->attrs[L2TP_ATTR_SESSION_ID]);
 
 	if (!info->attrs[L2TP_ATTR_PEER_SESSION_ID]) {
 		ret = -EINVAL;
-		goto out;
+		goto out_tunnel;
 	}
 	peer_session_id = nla_get_u32(info->attrs[L2TP_ATTR_PEER_SESSION_ID]);
 
 	if (!info->attrs[L2TP_ATTR_PW_TYPE]) {
 		ret = -EINVAL;
-		goto out;
+		goto out_tunnel;
 	}
 	cfg.pw_type = nla_get_u16(info->attrs[L2TP_ATTR_PW_TYPE]);
 	if (cfg.pw_type >= __L2TP_PWTYPE_MAX) {
 		ret = -EINVAL;
-		goto out;
+		goto out_tunnel;
 	}
 
 	if (tunnel->version > 2) {
@@ -550,7 +551,7 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 			u16 len = nla_len(info->attrs[L2TP_ATTR_COOKIE]);
 			if (len > 8) {
 				ret = -EINVAL;
-				goto out;
+				goto out_tunnel;
 			}
 			cfg.cookie_len = len;
 			memcpy(&cfg.cookie[0], nla_data(info->attrs[L2TP_ATTR_COOKIE]), len);
@@ -559,7 +560,7 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 			u16 len = nla_len(info->attrs[L2TP_ATTR_PEER_COOKIE]);
 			if (len > 8) {
 				ret = -EINVAL;
-				goto out;
+				goto out_tunnel;
 			}
 			cfg.peer_cookie_len = len;
 			memcpy(&cfg.peer_cookie[0], nla_data(info->attrs[L2TP_ATTR_PEER_COOKIE]), len);
@@ -602,7 +603,7 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 	if ((l2tp_nl_cmd_ops[cfg.pw_type] == NULL) ||
 	    (l2tp_nl_cmd_ops[cfg.pw_type]->session_create == NULL)) {
 		ret = -EPROTONOSUPPORT;
-		goto out;
+		goto out_tunnel;
 	}
 
 	/* Check that pseudowire-specific params are present */
@@ -612,7 +613,7 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 	case L2TP_PWTYPE_ETH_VLAN:
 		if (!info->attrs[L2TP_ATTR_VLAN_ID]) {
 			ret = -EINVAL;
-			goto out;
+			goto out_tunnel;
 		}
 		break;
 	case L2TP_PWTYPE_ETH:
@@ -640,6 +641,8 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 		}
 	}
 
+out_tunnel:
+	l2tp_tunnel_dec_refcount(tunnel);
 out:
 	return ret;
 }
-- 
2.27.0.rc0.183.gde8f92d652-goog

