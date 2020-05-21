Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231A31DDB77
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730064AbgEUX6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD71C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id q16so7231160ybg.18
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=aDiFmLRo09/z5PD1N7r++eFVdCxD35kDs8W9RmQKKf0=;
        b=E8qplZDfUeObyk2CHWzMVS90Lany8A+daeqsDROkrqZ898QLeev6ZqO9N7P1hlPzec
         cVPGNHeGQADi+Y8UpGy9X/T4wVLQ5ajL5HZwB8QF8enUq67Kgbr7iA+mR5CwXXYhfhP7
         LUKxuljeR26ZwpmjPWH9sa/GIRAgLmsn8B2EhSXITM85amMpHNtUKYKUG+mfcZvywI6I
         dVRFYQslYbz6vvXD5yF+DclTJS7NsIb/ZrvFiOGFftuTD3XRQp6p9ZKVGbtucyYUL23t
         adybRaqEffY2/6RN5mzE19TNOXTrUNya0+Sc1JMWis3Cf8VSyU1eRCKGsvmIgJCieQAy
         UUlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=aDiFmLRo09/z5PD1N7r++eFVdCxD35kDs8W9RmQKKf0=;
        b=eJlAorgcsVY/5zwRmbIlGhmHLtk4b+ueNAyLVbeKwOl5dZ+mHFWWpY0woMFR6BUhKl
         P34B+nkTE2b0FUh2UQnxVdcw57bnCu/5fCy//63gHzLw6FEgSiF+C57p8KCLP05qCYtO
         /akxxf0P6+X4eBPQ3Usn1Mc7LBowPRC6ZbN+YfiJjIDT8Kvo2AAE5/CtkzB+2WYcDjIP
         EipVqtQoo3qZHhi8c/k8rWGGmgBGJfQe8eOfGyCFQUBghOwmjfaamrdci8pB+2G+g8Qf
         YxlmEaqwv5iUJeewp5cilqaZ1B0P8iK26uwK8UPiOk/4kW7Zx7YG+e9F+wiO9/iebv9N
         Ni5g==
X-Gm-Message-State: AOAM533O4vhtiTVz76LrrrwHR2RNQvK6wrnb+9rLfmRNdRdjgL9axRNc
        9v0M2MNConJMAcwX10GhSE04p7AfxkLhCw==
X-Google-Smtp-Source: ABdhPJzhO8dkNhzNqU0ocB7UK5/LEoUehwZ3KPtj+2uGb10Urxhqy0DaH0Xk/z8skMdDT+qxqiEcTlB0RjO0Sw==
X-Received: by 2002:a5b:185:: with SMTP id r5mr15615275ybl.39.1590105513066;
 Thu, 21 May 2020 16:58:33 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:32 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-20-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 19/27] l2tp: hold tunnel while handling genl TUNNEL_GET commands
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
index 71784e7542cf..b86a2caa9356 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -428,34 +428,37 @@ static int l2tp_nl_cmd_tunnel_get(struct sk_buff *skb, struct genl_info *info)
 
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

