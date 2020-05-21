Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042371DDB29
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729973AbgEUXkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgEUXkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D33C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:06 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k186so7164542ybc.19
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=U2jA9IFroig05yrupVtJUeqDeE8hi8w+mzxx/tOTtNo=;
        b=CsvXXCDXY+dj2DT7q2yECTJAicWM0BZbBbGzbujlz6mWUrWgwapjNNiWc3JGm8HoWt
         M1SBK4TIVGg+Wj4261jOS7GEQTaRGIYg0LYiPWUFkNRg3bdyVEbnnMMY373ADcOSTc/p
         yguJgpldfFci6wIMVhUOYANmWq1gFWND2zF8CMCkM4KWKQ8rxhSNYeNmKtFfYWSfa69n
         Y+jmpk8hu4OiilIpc5y4gYPgMKf/YJEJZnvwDgjKH+S6KLvAG6/2TOsg7xyQUBs9v0y2
         vlS4EgC1c5Rc+5+8qFabRDfr8ptV4Uy35WbjmGl1Cj9zWqPO40V09L84qUhr5JOH3XxT
         wxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=U2jA9IFroig05yrupVtJUeqDeE8hi8w+mzxx/tOTtNo=;
        b=UTccFcpu4KWPMzP24EHgvSoIgvr1Mf0A2KMMd1tpCkbPBaiCl+m7D2bLa+/WXDEVf7
         9LaDdB87lO0EutpszDNC7ixqM2ERaL9C7R222jI4ictwQMI080SZDGfGa6bl3LzcPEQW
         1R5nj3l9vsYiDwWFH43PcwoqewUdSVRU0O1/0z/7Fsd9aC6i4ZkJZXXecx+axxxWBgwg
         QKrZa5c0gEBp1m68O/zMb0TmzG23Ws/jFDSyQ1OIiSwdQfwDfBixOfjbj6z6CPdXFUwg
         wS3tC9Q1HcEY++nlOeKAtJem86pUD6JDTrDSpQqyfTlOACQKCV5Svi/CWf/tCojmTOwn
         2geg==
X-Gm-Message-State: AOAM531ysg4pE8P/JzzLY0aLeqQAtibpVgLq9+GlUQ7vqmRIrEttElCo
        71bmDDwYXQa25o9RaRD0XJxKYNupdFqFXg==
X-Google-Smtp-Source: ABdhPJzEPFokvlcM0f6RFaPykQn0XqT3cvuL71sdgx6RG17PNXuFyaaL9/YVNdfZ+CwXroPmj8Y9+6d8zIAPmA==
X-Received: by 2002:a25:209:: with SMTP id 9mr8211711ybc.153.1590104406164;
 Thu, 21 May 2020 16:40:06 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:25 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-11-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 10/22] l2tp: initialise session's refcount before making it reachable
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

commit 9ee369a405c57613d7c83a3967780c3e30c52ecc upstream.

Sessions must be fully initialised before calling
l2tp_session_add_to_tunnel(). Otherwise, there's a short time frame
where partially initialised sessions can be accessed by external users.

Backporting Notes

l2tp_core.c: moving code that had been converted from atomic to
refcount_t by an earlier change (which isn't being included in this
patch series).

Fixes: dbdbc73b4478 ("l2tp: fix duplicate session creation")
Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index a9d4d42e2ef6..7f72957405b8 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1847,6 +1847,8 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 
 		l2tp_session_set_header_len(session, tunnel->version);
 
+		l2tp_session_inc_refcount(session);
+
 		err = l2tp_session_add_to_tunnel(tunnel, session);
 		if (err) {
 			kfree(session);
@@ -1854,10 +1856,6 @@ struct l2tp_session *l2tp_session_create(int priv_size, struct l2tp_tunnel *tunn
 			return ERR_PTR(err);
 		}
 
-		/* Bump the reference count. The session context is deleted
-		 * only when this drops to zero.
-		 */
-		l2tp_session_inc_refcount(session);
 		l2tp_tunnel_inc_refcount(tunnel);
 
 		/* Ensure tunnel socket isn't deleted */
-- 
2.27.0.rc0.183.gde8f92d652-goog

