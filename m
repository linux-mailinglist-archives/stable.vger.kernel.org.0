Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C539B1DDB2E
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgEUXkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbgEUXkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5609C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:17 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id z7so7222529ybn.21
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0QITFDTkwv0vFpVhrWXC7TyUDTBWgmqMhJWrN119rLQ=;
        b=c391aTrogpgiF+amG7HAR2jsiaEO2sfrQCECJY5diJPqjvQqquYH2ck8/f9eyKT2Ot
         eBzKeXr9j90h/sqrEY+ctcXa8ZFgwg0jhk5NSxr+GWCfwAH7jaDjch3IIacbcyhpwuAj
         lv+MFGxytZzzf7OlkJZ9c0vwXNV4F4Xu2UkwGzAnlC6hsKBgp3893CUH72um/UuUyk4w
         jdfz0tzvnSFC9dLt2wvyBpiC5v/iycJSrVirE3Uy96BAsJ+WEptU0lzaBgiB5uepV13b
         x/4CwuZlCyZvw2gsRLfd83a+33pCumjz+yoZXavMc0ugoh9D1V2P1pZI1SeWkXGgwoZ9
         ZGiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0QITFDTkwv0vFpVhrWXC7TyUDTBWgmqMhJWrN119rLQ=;
        b=QzmR7yWYGl+ER0ofy4aaBf97YRWkq9W6Bv7B+o9YvYE6zfAov88DTFnyO/IfdX/UT/
         ZFGqThi3QcByKB7sThz+rsL7RN9w9X080iM11zZlQh/wGwx86nCzcMYxCPSDikUfD48S
         Qzb9De91HxHK20YzDL7D8mPLwxo1CpHZJ93cj7IqGS7QmJ7hCY7EYXbu0pVisTSDAmEl
         DiVuy4rVtEEohJp7rGR0UrG1SjCyNhUdAFstJpE656sH/ZbQcBq06zHr9oRvt0RcEKmZ
         F8lfU/jUbgUZ8cr06BRviQKcnbIXV+b5mmhn+6/dD40cD8MwGybYuQeP6LcE1k4UttBv
         rTlw==
X-Gm-Message-State: AOAM530RXLDzu6+hpncUOUlIQCA9s/Fo7nJoNdmv/IHpC2x8E7zrBTHA
        mEdUUFAOSyt4KzGAN1Nu6Sz2VkZFCj6Uew==
X-Google-Smtp-Source: ABdhPJwXFY3pyLOy10eJ0HrcIFSodRbX0/02B3zUq2aAwEszkouDFJum13p34n3WTsWYeSOFcekn+SzDkTVEbA==
X-Received: by 2002:a25:d181:: with SMTP id i123mr18848498ybg.316.1590104416964;
 Thu, 21 May 2020 16:40:16 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:30 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-16-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 15/22] l2tp: hold tunnel used while creating sessions with netlink
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
index 8f39086de144..5ea5d3ffa309 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -510,8 +510,9 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
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
@@ -519,24 +520,24 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 
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
@@ -555,7 +556,7 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 			u16 len = nla_len(info->attrs[L2TP_ATTR_COOKIE]);
 			if (len > 8) {
 				ret = -EINVAL;
-				goto out;
+				goto out_tunnel;
 			}
 			cfg.cookie_len = len;
 			memcpy(&cfg.cookie[0], nla_data(info->attrs[L2TP_ATTR_COOKIE]), len);
@@ -564,7 +565,7 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 			u16 len = nla_len(info->attrs[L2TP_ATTR_PEER_COOKIE]);
 			if (len > 8) {
 				ret = -EINVAL;
-				goto out;
+				goto out_tunnel;
 			}
 			cfg.peer_cookie_len = len;
 			memcpy(&cfg.peer_cookie[0], nla_data(info->attrs[L2TP_ATTR_PEER_COOKIE]), len);
@@ -607,7 +608,7 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 	if ((l2tp_nl_cmd_ops[cfg.pw_type] == NULL) ||
 	    (l2tp_nl_cmd_ops[cfg.pw_type]->session_create == NULL)) {
 		ret = -EPROTONOSUPPORT;
-		goto out;
+		goto out_tunnel;
 	}
 
 	/* Check that pseudowire-specific params are present */
@@ -617,7 +618,7 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 	case L2TP_PWTYPE_ETH_VLAN:
 		if (!info->attrs[L2TP_ATTR_VLAN_ID]) {
 			ret = -EINVAL;
-			goto out;
+			goto out_tunnel;
 		}
 		break;
 	case L2TP_PWTYPE_ETH:
@@ -645,6 +646,8 @@ static int l2tp_nl_cmd_session_create(struct sk_buff *skb, struct genl_info *inf
 		}
 	}
 
+out_tunnel:
+	l2tp_tunnel_dec_refcount(tunnel);
 out:
 	return ret;
 }
-- 
2.27.0.rc0.183.gde8f92d652-goog

