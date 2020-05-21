Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53DE1DD04A
	for <lists+stable@lfdr.de>; Thu, 21 May 2020 16:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbgEUOli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 10:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728256AbgEUOlh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 10:41:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A7AC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:36 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m1so5546657ybk.5
        for <stable@vger.kernel.org>; Thu, 21 May 2020 07:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XaApZ6B1vdeZPKZuZRgn6DJIauohzKknIjVgNsB5814=;
        b=dBeWeRegaP/vk+RykFXOKvYobyMJDfLPDYt5QS/CGeKOfRjRp/4CNbw17eiw87yPma
         82dY/rh+pihvA0COStv8u03sW3TBktligCSzO6VqXir91J7gkZCiTHqIKFQjimpd6Ls/
         Woed1OGf2jd2zLS7yMiX+gjRgsEAAoUB7v4Scr5gXFSM7og7lQmy5UZDwFgltJBQRk0e
         OvixnBifHXMXhNnnuKuzn0wOqPXDPO6M6ChTiRYtD6QYG4LJNsX/BNDClJfZtOLYV6YP
         aMP4hrqFqAFDrcZiFA/keVwZO9aVIETYMJUu6da4esdzPRZg/cCftif816oAP7ISi+dP
         /lQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XaApZ6B1vdeZPKZuZRgn6DJIauohzKknIjVgNsB5814=;
        b=GqibVJuOKZWYTuAVPR9guHQkLG3DQ/dS1RT0HayDK1EPLe03snccJzudPsrotYZRon
         4WHJFnFb0t7EislN/RSPcPtnwFJEnH9Wb3fmTAO7hzJHlTSMm0NgInRNwAhvadFdXai2
         lcQHZzKZ9a/ZkbJQET15KE48BZ5Z2Q3gmmigUQCXnrZlp1fdTA4qKsgAZcZ3HGjLsJht
         7iTBDySyKJsucNv4UUn1Kns8xPt4hKjBhIN4ZB1M3ESpKeScPekzVBy1dBsRogZz0wEK
         pfJ3c0tpALkBK4nG5bFa33uzoOWl3YIIz4m6nwZEre6q9nc22tTe6JN2XrfFc/byMEuf
         e+cg==
X-Gm-Message-State: AOAM532XvlyzZkNaIw9WI9Hfp/eB5IuvqJlQdVjKTI2iF7Cmhje1sAMQ
        lEqY7VEuG9tzP/Pb1uWzRYv04gCIUssARQ==
X-Google-Smtp-Source: ABdhPJx4BTSWupeVk5PxJb2Q8FfG18dckNYm14REMBkOvCSkYwxns61NjsJyYAIWBx9eS/tTxiV5zDLTREc48w==
X-Received: by 2002:a25:ba81:: with SMTP id s1mr15294809ybg.508.1590072095406;
 Thu, 21 May 2020 07:41:35 -0700 (PDT)
Date:   Thu, 21 May 2020 15:40:50 +0100
In-Reply-To: <20200521144100.128936-1-gprocida@google.com>
Message-Id: <20200521144100.128936-13-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 12/22] l2tp: hold tunnel while processing genl delete command
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

commit bb0a32ce4389e17e47e198d2cddaf141561581ad uptream.

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
index 0a27f7e976f3..93148a215e7c 100644
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
2.26.2.761.g0e0b3e54be-goog

