Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F50C1DDB2D
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbgEUXkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbgEUXkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E898C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 207so7266911ybl.2
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JzeATT8FX/Ojybrup+ukgsty8LZ9zXLN3IWrpYdBg1o=;
        b=W2ULNvh+UIR+wMcnGdwI/Ed9jbZIQ0SVYGGMxPLrNUd+dJQuW30I1pbEXGZBWzLVc2
         Tvff1tHfUAZKltipXfuMC99addQoToR7crluyQVpXT4dN5GG/BUNUgiDrnLf20nXvq8b
         R9kvysAgrleQmfDkNjB5DczARuu2I4eKstb3WYF5GzKPqGsSoO55GY0Tzp+MWOVjdLZ9
         yxVWXBVchAq35i+hXXr4BK4m2eiSXAQwq+9IUJVepk8pFFlZsijS6Qpa4BBTVkaNKFmN
         8zgeEYQ0Lz134c4oFp3CwcEpn1kQB1SObqsBHvirhNme+AavrAoMefmKsk8YPLUYd8Y/
         IjJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JzeATT8FX/Ojybrup+ukgsty8LZ9zXLN3IWrpYdBg1o=;
        b=R5vUyU2s1PIV5pVcOaLhYLUntTMs++WBC7YC4cdq6z14hSWPcoCGIWSg0LEfbDvMot
         PieyS/PQYibENCbas293C/5jhKkPZZBoqX2Vp0g5XafcIMId3/Jz3d/lqTwm7gohDQfv
         7mwGRkj8YKzJtDSAInyvJ5chXCu9t1MXa+JKYEk8PtUArTZLKbGZbLrNY3aBMtzJG096
         kl+SjLsieQ2dQzdPgJ2ZY7s2N4b71Dlg09Rc4aCi8EZ1UduZ+HIOfcMIJwQYImzjFW+Q
         xahoW2AnQuw/cw1cAfV++7O/o+wrghA1OjjaZJ+lBQx5/saurqgRsksN07gzpyZ822DQ
         ajWQ==
X-Gm-Message-State: AOAM531aQIm5Jeplz17tgZCepLVWvzYRqfukVPi8A2DiSDxhHxu2cDRA
        bjyfN3zz7q+XKJGZe1tiB0Mg31AVA/td/A==
X-Google-Smtp-Source: ABdhPJwIMLV2XAd99srN5TiDpwzmYwBq0atLAI31d26ySUivL3Oby9WEMkyN7NfCAjm1CrIVgT3nR7dUsx+6rA==
X-Received: by 2002:a5b:50c:: with SMTP id o12mr19409823ybp.264.1590104414831;
 Thu, 21 May 2020 16:40:14 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:29 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-15-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 14/22] l2tp: hold tunnel while handling genl TUNNEL_GET commands
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

commit 4e4b21da3acc68a7ea55f850cacc13706b7480e9 upstream.

Use l2tp_tunnel_get() instead of l2tp_tunnel_find() so that we get
a reference on the tunnel, preventing l2tp_tunnel_destruct() from
freeing it from under us.

Also move l2tp_tunnel_get() below nlmsg_new() so that we only take
the reference when needed.

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_netlink.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index e454f23f31fb..8f39086de144 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -436,34 +436,37 @@ static int l2tp_nl_cmd_tunnel_get(struct sk_buff *skb, struct genl_info *info)
 
 	if (!info->attrs[L2TP_ATTR_CONN_ID]) {
 		ret = -EINVAL;
-		goto out;
+		goto err;
 	}
 
 	tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
 
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel == NULL) {
-		ret = -ENODEV;
-		goto out;
-	}
-
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg) {
 		ret = -ENOMEM;
-		goto out;
+		goto err;
+	}
+
+	tunnel = l2tp_tunnel_get(net, tunnel_id);
+	if (!tunnel) {
+		ret = -ENODEV;
+		goto err_nlmsg;
 	}
 
 	ret = l2tp_nl_tunnel_send(msg, info->snd_portid, info->snd_seq,
 				  NLM_F_ACK, tunnel, L2TP_CMD_TUNNEL_GET);
 	if (ret < 0)
-		goto err_out;
+		goto err_nlmsg_tunnel;
+
+	l2tp_tunnel_dec_refcount(tunnel);
 
 	return genlmsg_unicast(net, msg, info->snd_portid);
 
-err_out:
+err_nlmsg_tunnel:
+	l2tp_tunnel_dec_refcount(tunnel);
+err_nlmsg:
 	nlmsg_free(msg);
-
-out:
+err:
 	return ret;
 }
 
-- 
2.27.0.rc0.183.gde8f92d652-goog

