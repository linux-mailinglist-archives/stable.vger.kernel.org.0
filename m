Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668BB1DDB72
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgEUX6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgEUX6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:58:24 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5830CC061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:23 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id x30so9700082qte.14
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DF7HDCmO9rr/ylUWqE9/AZ2u5j2xGvSqZmcKYuo5Jwg=;
        b=S5wSSHNeZKlG/TsoK/YaA0T7WLfw0mG4Gtdz4DubKDdRDpuzzODMzt3jkMTuzvefDP
         UX4+zKUuAwwIsOY4TqMarJvrFf6pPwhAfmSJtoFojtOVqvhZ/phrXG6ElIY4Ppvzu/Qn
         p6diM7EJCKE3PO/q6Rbetm2KINF+DMB0SUpib94fSPTtrBNcRG+4AdQOV02c6jNtYGDa
         94Rn/QWlhUbjEOQKHmMypoBOzl/GSaS0CN+qgWm+70AW2KNnkQiEm1i8AWvZ631wBSrL
         ChLQWcGWdbadrGcgKJwM7gVaNb3Vq0bL7IvqBZ9gpcCvZ5kDK1rXxkOyYGFybCRF902B
         MstQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DF7HDCmO9rr/ylUWqE9/AZ2u5j2xGvSqZmcKYuo5Jwg=;
        b=RVLlDg7KUG/COk9iGUnO8KRbidR6cVAC/5bTmd258DPN10cDdSr3t4WssLAKk8mFPy
         Gyy0EnJ6A+ULSFURzwnHV+YVLVMzii40oyHd6eyvU0VVxPqIcB4juYhcdpM6MhnE3+EW
         RSdtxUVXZmShp4sr/O63QPUUijBv1f+ZMzT9DMqFCjelApf1KZGXL0+bLAFFSQK6wFu5
         3fzWh04UicXRCj2r2VVJhfX9xJrooSoq4TRq9rCH5ApthpR6gGDqMl9xUyWerPi3pYbm
         Fx8d6PZehpiIJzqnfFszqKyoVT5cy4EQte4NlRtImWZRzUxD4eCcbB7lfVFV1NgxfRE7
         xxAA==
X-Gm-Message-State: AOAM533BvAg8ZiIAyhMd4qemYltXFUUB1V37HfUnZ+boBUHcrHxbkKDy
        Fhjd8Y4zLeiE0glrrW6BAURP23dvnuHjZQ==
X-Google-Smtp-Source: ABdhPJwaudlLJKbykndFOY1IM3zZSGeNog3tcmjusuNsEj6YpNloudiCCIoBbe0WwqYbaEuesY9+ZPuHflycng==
X-Received: by 2002:a0c:e4d4:: with SMTP id g20mr1180752qvm.228.1590105502496;
 Thu, 21 May 2020 16:58:22 -0700 (PDT)
Date:   Fri, 22 May 2020 00:57:27 +0100
In-Reply-To: <20200521235740.191338-1-gprocida@google.com>
Message-Id: <20200521235740.191338-15-gprocida@google.com>
Mime-Version: 1.0
References: <20200521235740.191338-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH 14/27] l2tp: define parameters of l2tp_tunnel_find*() as "const"
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

commit 2f858b928bf5a8174911aaec76b8b72a9ca0533d upstream.

l2tp_tunnel_find() and l2tp_tunnel_find_nth() don't modify "net".

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_core.c | 4 ++--
 net/l2tp/l2tp_core.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 4e2859d72167..7e593e399774 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -378,7 +378,7 @@ exist:
 
 /* Lookup a tunnel by id
  */
-struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id)
+struct l2tp_tunnel *l2tp_tunnel_find(const struct net *net, u32 tunnel_id)
 {
 	struct l2tp_tunnel *tunnel;
 	struct l2tp_net *pn = l2tp_pernet(net);
@@ -396,7 +396,7 @@ struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id)
 }
 EXPORT_SYMBOL_GPL(l2tp_tunnel_find);
 
-struct l2tp_tunnel *l2tp_tunnel_find_nth(struct net *net, int nth)
+struct l2tp_tunnel *l2tp_tunnel_find_nth(const struct net *net, int nth)
 {
 	struct l2tp_net *pn = l2tp_pernet(net);
 	struct l2tp_tunnel *tunnel;
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index dab75dc4ea48..8fa4ad103c25 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -242,8 +242,8 @@ struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth,
 struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
 						const char *ifname,
 						bool do_ref);
-struct l2tp_tunnel *l2tp_tunnel_find(struct net *net, u32 tunnel_id);
-struct l2tp_tunnel *l2tp_tunnel_find_nth(struct net *net, int nth);
+struct l2tp_tunnel *l2tp_tunnel_find(const struct net *net, u32 tunnel_id);
+struct l2tp_tunnel *l2tp_tunnel_find_nth(const struct net *net, int nth);
 
 int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id,
 		       u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg,
-- 
2.27.0.rc0.183.gde8f92d652-goog

