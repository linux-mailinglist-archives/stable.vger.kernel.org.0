Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80291DDB2B
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728706AbgEUXkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbgEUXkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:12 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6E1C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:11 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id n33so9639140qtd.10
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pPWnw4qHcqJ0BFyjA9l6MQdz4Yhc0+FAp9BOWpWc4Jg=;
        b=TAbQVf/uHE2A+q+05S+wguhp9X6kdxARDiwREyFZIgA1dPXYz1f3s/8MsoEqJFTa9L
         FcvoxUboYGTKJ3b67pRgN/Zqcfo71qjiKinPZ3g/0fZ2UYWfB3f/AO86lGVJvTwkIZYM
         LOfrE8kfe4c0MkMivtk8CKuN2Snudaj8NT0meq7B9RiMIpi+i9JN8aLMamigq0flaHOW
         EArCLWa8+GfPftyEgjGzg7WqhHVWMbm/0BXrE2UqYIJzQggqxzZe5wBbCYLnwnPLMVVS
         SDN45wSZyA3jGbOuz8L0o5z3YE2sGT5kwgBmoCl38bgyVc/9UJxKI1McXzX1NXXXR8fK
         36TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pPWnw4qHcqJ0BFyjA9l6MQdz4Yhc0+FAp9BOWpWc4Jg=;
        b=AKAbI1wjbp3YwxZyNIToG7N507/2yIrIfFDN/4tsWp81SoH3JEqUHhi5Ef+VvRwTrw
         oCqveO7Hg8TLL9hIE86AtcwP7383FB+Q5QTa+VI9PmdMAvrg1lL+VLDxnkmpeuz3NJHt
         ekQJRmMtUDoUeK9zCQ0X1wATgR1p/gL3YsdCr2upyp4eJJvib65uVE96HYXVLNuvHvOY
         pp48tsHyQ7d2MR401kip/anLYf8tMd4MhJciyJBp5IeLWUe9sjcQvs8gIkMixZXikVqe
         L5fAq18mX17VGv35sFc5WUjOxyL1hNBon51RJW1gJNL9cmWk2eKwBdH3QyJ5m0JyT8Co
         ZORQ==
X-Gm-Message-State: AOAM530pKZnDlvbsq85PML/6R9CO5XB3VXPf0XOLcTbvVoxPFPFGDScr
        iaioDCRHnZL/w3YAqa6Dt0PhkU2wPeiLDw==
X-Google-Smtp-Source: ABdhPJysSDnjIOKE5AEwILPl+qWTdMM8Rny08FW8AkLq8yblUMkCF5UJgfttrUqGZuJR1aR9fpZpnMPIbsyaeg==
X-Received: by 2002:a0c:8c4f:: with SMTP id o15mr1174239qvb.201.1590104410634;
 Thu, 21 May 2020 16:40:10 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:27 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-13-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 12/22] l2tp: hold tunnel while processing genl delete command
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
2.27.0.rc0.183.gde8f92d652-goog

