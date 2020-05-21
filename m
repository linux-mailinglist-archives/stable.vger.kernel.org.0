Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC15F1DD04C
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgEUOlk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgEUOlk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:40 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457C2C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:40 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id t57so7925723qte.7
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WTzJB+DaZGN8di0faLbc1mNIiCX5suV8EZV/5jMAz/0=;
        b=nQt2V7VOPuBPIGbvqLddl0UV3TorlM+XybXnFLRH/wcJ8T6aGWNxWc0ZA6Ac04y9f4
         Og2qzvGK4gThXS2bcZPDkpk2kFTK68x/7SBmfM1iryiDwrmETR7NcTR0FYkopC+JIgiF
         qyjcpg4zCotzD/z3InOMNFvVcuCkFxHzWXr8qUY3istqSz2R7vK7Fnm3zYomcA+XthtT
         dNbF0jBFbbME1Cp2gkDTeoQnXEBTAjfBnVm+Idu2BrDiDu9qLHi9YNpjewiuR5JjWTTf
         JIJSGaNWyy6aCrZYA9M9icXdhlJ3OhXduqXJ8ZDWLoA8NYMtds77IevOKOU9VXPV1EJv
         Zj6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WTzJB+DaZGN8di0faLbc1mNIiCX5suV8EZV/5jMAz/0=;
        b=kMq70ddjjMqVz+ZyXyn9bFV2UTI8kHix71IiKH2XkY2l1X85zfUAzvwV1XvfTN/5qT
         NN3IcXs6KqN/KslYLbHLToaQsfhED9N11LLpbIrAYcQxx6lrCo6gGdsdBBnH5LIuYXwR
         oFzT5fLi1fHdnnkHVU0XGRvlgXA2HGOO5vVYjAGXd37bpTgLnBi0t4hNjAcTvm6Au0jU
         4OphIKB7EWyslRawn/yxhDcA0wwUgZeW0C3Z11uuwfkoHOlSxNYE92yj374MG54cqjj0
         mqx2d1Bata0Ujll29fJhkZ779vyXqQZrv0GZoOKsOGu+ORxEYXNZeiw28+Q1j8xbS+/j
         ydLQ==
X-Gm-Message-State: AOAM532RdaerDfchaH0BXxlPfc/RjNDb2Z6LmlmI7/+vZiNoRKXWuU94
        0Taw7o74DX2uctProfQAx2U9yVUIPrYCcA==
X-Google-Smtp-Source: ABdhPJyrNuLDPlFO8OMgR98bgneE/ixRM6I3w9tqIiXtlZAX2fcubiXXngm4+MVBwbW6I9MxYVQK9T6FM4YfPw==
X-Received: by 2002:ad4:4e6a:: with SMTP id ec10mr9969607qvb.225.1590072099492;
 Thu, 21 May 2020 07:41:39 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:52 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-15-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 14/22] l2tp: hold tunnel while handling genl TUNNEL_GET commands
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

commit 4e4b21da3acc68a7ea55f850cacc13706b7480e9 uptream.

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
2.26.2.761.g0e0b3e54be-goog

