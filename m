Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255731DD04D
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729738AbgEUOlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgEUOlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:42 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B81C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e14so5515239ybh.16
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wI+HKpFWvry3kI80xT6j3z58TG59ubekmoG0h0iKulY=;
        b=Z2e8o1WpTQGbuHGBTDWB4j818PZjhX+33yKcjwhc+dM8Ml4pav9wQYSfuG86klEZtu
         cbo3viePsX7ITCt1GEygAmwVA1voOBppgppwHRiaJZgxgWzE+DNOQteo0kdNee0al5W/
         ETPgGjNTvOShKA4sI88tJF/O9yWhTlwVuLr1syJb/kSjsWklrcEJBCZkmY/IWuTPJF3U
         xJsH+u15poFHpAqICE3mPrNEaQjkAjrVW6S1nLQ3eMvzDk5FWMSE7dgv8OV8vV6HWS9b
         iGVSxjDn+dW6pkzUusTqffDOyO4XIYhmC4fMFj+u/p3WCYn8j5dl04b6uIIKBvmnUYnn
         /EKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wI+HKpFWvry3kI80xT6j3z58TG59ubekmoG0h0iKulY=;
        b=nNGyFx5K7J0VOwCK6BP1oB+kR+bJR2IH9ixdXEvpMU0j2HEsXZYu3OqUkoXMAXa/O1
         mX9J9/9DxXpCfyGLEBB30NS6yHSse2S7PzjcInOtQ0Tq0XN0RiickBXXUUxQiv5lpII1
         zPJ/Pos0lOEfBNwIg14zk7lqENX1Bv2ErklSwBgq68M+wAZ/Hlu6H96WrAuNMhWSFA9A
         GLRHKm4aAOXc+NzD0XTLKh0fS/JPuPqNRPv4hUSnZ1Lr7ooN234FsfP2zqpLlhpUXVV+
         XlwRoyCachZywVfjnR+HVPB2kw+QOl4dXKVvvuZkZzTaf/bU3SWwuiA1Ic/hx6FZPuqz
         K6jg==
X-Gm-Message-State: AOAM531xf0do78D68nVZXCpZV7vaBXtl5V+UdZLlB18p01O7Mcewp6g7
        6q4iz2nhhn+YF2DPufbcXlPh+syQh1C0jg==
X-Google-Smtp-Source: ABdhPJyqEaqH0nJ5/CsZbu7cCDj6Hy+1Xkh3jpI7EMK1/x7YPF68IX/rMF3dGJbdlZnMDXLdciFUNL0qQDTJyA==
X-Received: by 2002:a25:6dd5:: with SMTP id i204mr15950049ybc.347.1590072101566;
 Thu, 21 May 2020 07:41:41 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:53 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-16-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 15/22] l2tp: hold tunnel used while creating sessions with netlink
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

commit e702c1204eb57788ef189c839c8c779368267d70 uptream.

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
2.26.2.761.g0e0b3e54be-goog

