Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A66F1DDB2C
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729980AbgEUXkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbgEUXkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:13 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81007C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z7so7222351ybn.21
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=CkxOaQNTFZ2ysMFttxirbDAJauqkbS9Fk4EQW8ok/u4=;
        b=cU2v1uz25vhmcIOQZvBMceudeSjBWvZFPugDDh68STGdLM3PwjzDMy9C1lfwK9jk8D
         kH3DCzZb2liu+fEkJbeLOtbg1FeLG0gRxhKNDZjWofS6D/zkqeyX+o1TLat60YkfHmas
         18yM8nvbehkg+XV2FLsxZuPk1jA92X3So6pzheyvUsRpeAqwr2vaIF/+rL1oMRk59FPr
         ipBY6aryEnbN8zsCLa9oBxJQyKB6cDxxo6ATF2PJJ8m3qck9vTv/kY232NddR5nS4Af5
         Ugb1PWENVWjmpmSnNwPn+157toxwFZ7DhV0A6h5Y+sghRbzOcHXHGuGKK6QjIopBnT95
         4XMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CkxOaQNTFZ2ysMFttxirbDAJauqkbS9Fk4EQW8ok/u4=;
        b=iP7ZT2QtWH//CaG6s4FqMMmNd3eAv4sjcsXq5ego+ZCuPtS0DVIuKq4SVCZo3jkZLB
         Z2YzbRHIEk0HCiNgnWz5ztERlV0rP6kk1P7buZEJ67e+nmBm2Ax5mcajZhFrAQmnCZn7
         SOBHlpcZTI2mT5oYGvMAbXlNfxmKFGss//gaZkmiFjfGD4PdEHbH/fLT8f0odcQs2+2g
         xVCvMUfydEw3N+QNIDvx8aAFIDKh7VEKv7PMpMyu5b10NZ57kVuD8rmkfCrCxOL9AlYC
         iPqhij76icbrSOkl+LlJbQkRP6B8htDeHZH/QrZUGfrNi8GjsQ5cSN6s/S9D6eJMAo19
         /dbA==
X-Gm-Message-State: AOAM533SCiKlYz8QJKbGmtKFq98Xj9ROKEDGkkba+uaUsq6tjj9aWi2D
        SCzx4rwxUNbXstJXH5p1pMea1cnYVu1MKQ==
X-Google-Smtp-Source: ABdhPJxSnoUyCIM62uJbicyesCHUakePiLFMR2V43WHjtOliEqYdSKhEvAjLaF4zG5YeqfjWPCnb1mjAMjFFaw==
X-Received: by 2002:a25:ad59:: with SMTP id l25mr18927778ybe.489.1590104412753;
 Thu, 21 May 2020 16:40:12 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:28 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-14-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 13/22] l2tp: hold tunnel while handling genl tunnel updates
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

commit 8c0e421525c9eb50d68e8f633f703ca31680b746 upstream.

We need to make sure the tunnel is not going to be destroyed by
l2tp_tunnel_destruct() concurrently.

Fixes: 309795f4bec2 ("l2tp: Add netlink control API for L2TP")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_netlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index 93148a215e7c..e454f23f31fb 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -310,8 +310,8 @@ static int l2tp_nl_cmd_tunnel_modify(struct sk_buff *skb, struct genl_info *info
 	}
 	tunnel_id = nla_get_u32(info->attrs[L2TP_ATTR_CONN_ID]);
 
-	tunnel = l2tp_tunnel_find(net, tunnel_id);
-	if (tunnel == NULL) {
+	tunnel = l2tp_tunnel_get(net, tunnel_id);
+	if (!tunnel) {
 		ret = -ENODEV;
 		goto out;
 	}
@@ -322,6 +322,8 @@ static int l2tp_nl_cmd_tunnel_modify(struct sk_buff *skb, struct genl_info *info
 	ret = l2tp_tunnel_notify(&l2tp_nl_family, info,
 				 tunnel, L2TP_CMD_TUNNEL_MODIFY);
 
+	l2tp_tunnel_dec_refcount(tunnel);
+
 out:
 	return ret;
 }
-- 
2.27.0.rc0.183.gde8f92d652-goog

