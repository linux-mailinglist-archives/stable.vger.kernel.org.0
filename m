Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA771DDB75
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgEUX6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:31 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE757C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:29 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id i1so8800344qvo.21
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zbp3ybiA9jYjSUhpVVg9Pf+zbN5QQ1/VtDIGjZ8hnfs=;
        b=vIACxHASLeBZIeAfcEWQBITrsopOYKQav8nhevq55IhUw/vI7lxPtQghBNsEaUI7Bn
         UoOsOIbl85hFDOSiN/kdOFeNVz1eFXJxmye9hwUcbOOianG+yHBRqqbktdFiYimDxQeC
         nQckuSdV2uPYbjnAd77A2V3ItwIogtHbkEAr8vGmYeyR70ys74gi0pOafdWg0Enat3aE
         4QbGau6yz/9cFfIDsYHpiqn/MKE5BsPnme5NJEhrpMaabvxg6SrVHPStjdlC1dMKX9ck
         TNj1xs/TyhCm/QOvRyx09Q6Q91Ak0XY27C/Kp7WiRQNiQx4yCCEjKe83O2rJW67xqWdZ
         bv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zbp3ybiA9jYjSUhpVVg9Pf+zbN5QQ1/VtDIGjZ8hnfs=;
        b=DUc0cqWeW+OfSg8RQKGAPfru+ZJsopyJZt/8xO7krNfBsIcqs0XlAQQIEBuJD+Xi7O
         IiZkJmn59kjN1pjj2nQnzRAqBdFT9//tiVN2IgsqozHK05vn5njMc1qhHGfNfaIX6DOz
         VoOqYQCB/LqDXSRkqwat/4g5Tqbwmcu3wdsFBsuVH1jo9CpFUQfxoIW1hF01dP6mvipR
         oZKfqULUejTikaU5HOne7+OB591ybe4tPYlsUSbMPf/1xHUt30jDEhFCTDHzf9f4jtN3
         9dW0A0HpeVPBMoNFI0Wlcw8wG4jGaglIE8tPLuiVwtr+5+xU0ELVJTmlVGNqtOdSfuLV
         bGJw==
X-Gm-Message-State: AOAM533w6lrEzlRMpOnOxhyQJHv3lTAHI0m7NuOucmCSFG4F/q1NqxhY
        a8yyjXq6pzwcWWcxtj9vNUd7iP49THV7XQ==
X-Google-Smtp-Source: ABdhPJzGFIVd3CFDa4KvOKdnTVIQW1figYIepIGXAvUwuJjzIvPYzTYFCflT8pfhzCHk3txEU4atDjFoU5Iqyw==
X-Received: by 2002:a0c:b501:: with SMTP id d1mr1263118qve.63.1590105508973;
 Thu, 21 May 2020 16:58:28 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:30 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-18-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 17/27] l2tp: hold tunnel while processing genl delete command
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

commit bb0a32ce4389e17e47e198d2cddaf141561581ad upstream.

l2tp_nl_cmd_tunnel_delete() needs to take a reference on the tunnel, to
prevent it from being concurrently freed by l2tp_tunnel_destruct().

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 558327d62167..e0c3a551c9bc 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -280,8 +280,8 @@ static int l2tp_nl_cmd_tunnel_delete(struct sk_buff *skb, struct genl_info *info
 	}
 	tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
 
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel == NULL) {
+	tunnel = l2tp_tunnel_get(net, tunnel_id);
+	if (!tunnel) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -291,6 +291,8 @@ static int l2tp_nl_cmd_tunnel_delete(struct sk_buff *skb, struct genl_info *info
 
 	l2tp_tunnel_delete(tunnel);
 
+	l2tp_tunnel_dec_refcount(tunnel);
+
 out:
 	return ret;
 }
-- 
2.27.0.rc0.183.gde8f92d652-goog

