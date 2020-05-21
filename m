Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6851DDB26
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 01:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbgEUXkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 19:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728706AbgEUXkA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 19:40:00 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EE98C061A0E
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 137so7223972ybf.7
        for <stable@vger.kernel.org>; Thu, 21 May 2020 16:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uxE/xHBD5MGztky4hCBVMVDix/xr6CBHo9ys5DW4bpI=;
        b=qW4NNb77Q7kQZjS1it9BrE6oUGxdcl5+wvCfftb+AQzBB9f6TZXVXZ/e2Zc1kRCEw0
         iYEbdw9xql8jpR/dgr/set2m08GuKuDLLrzcf69h7eO/5nnPv1FS26M3QzslcmCH+KLm
         pjiv29bplE4Ws/VVe0Q6kzEIrqQ4BUwo6CVnT8exfh7++43/EIRhB5GXIjOd+WtRnHjO
         mYr4qYeEwSn1JmKahmApKzaJS7FlxM4JmcyfrIkCGRwa5KE5dqvMsaPi6+4KoETfjzYu
         3v0lTXh75l+ITqZpJ1XMm0E/n4DgxN13rr5fVAksutkkDipJC4O894woNxdBlqsUKa0e
         ZAyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uxE/xHBD5MGztky4hCBVMVDix/xr6CBHo9ys5DW4bpI=;
        b=pZ8vpKwlYdySwQeOwa9VJjE5bOdSg7Q6JnMTredhJnP5myFVUVs35gxJFdjIGuKsc8
         WtmxpAahhIZmSakKg8+7t1J7N/OTSBkikbFLZFoBrAeLPPo1DqrhFqKrCYFlwLKhGp3n
         b+LpVWJh6wpgCVNCwJM2DfX7yxHKTOGyb91ITyaP/gi1xxU2uTnhQeYJnETusqIWHxti
         +sprR6DfuAt3E6K6ozpCtF0twp5DPd88bfw4xAoxG6i3RwimKIpxbZqS/ANu29jVhJFT
         5CLgYIcf4IbXafQLSGyaDDiFv5o3j9c2Kd1TTiOemZHnTDjMj3ndeVo7dn7B4nM/NIDc
         ug7Q==
X-Gm-Message-State: AOAM5312iZ0kGchvcQZV3sp95bJgt8TRZslLRrraEcZ/Al+TxTtoF+ZF
        TJjkUM4KLITnrxWTkTg6bDOe6MDy4YEBlg==
X-Google-Smtp-Source: ABdhPJy+7xhePmTPNQE8JA5nqIMWWqaLsYZb7btTqHaxF+42gvfvigzknS2LCQ+GM85Xk79xWwItf7CD29GqWw==
X-Received: by 2002:a25:80cd:: with SMTP id c13mr19253567ybm.335.1590104399670;
 Thu, 21 May 2020 16:39:59 -0700 (PDT)
Date:   Fri, 22 May 2020 00:39:22 +0100
In-Reply-To: <20200521233937.175182-1-gprocida@google.com>
Message-Id: <20200521233937.175182-8-gprocida@google.com>
Mime-Version: 1.0
References: <20200521144100.128936-1-gprocida@google.com> <20200521233937.175182-1-gprocida@google.com>
X-Mailer: git-send-email 2.27.0.rc0.183.gde8f92d652-goog
Subject: [PATCH v2 07/22] l2tp: remove l2tp_session_find()
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

commit 55a3ce3b9d98f752df9e2cfb1cba7e715522428a upstream.

This function isn't used anymore.

Signed-off-by: Guillaume Nault <g.nault@alphalink.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Giuliano Procida <gprocida@google.com>
---
 net/l2tp/l2tp_core.c | 51 +-------------------------------------------
 net/l2tp/l2tp_core.h |  3 ---
 2 files changed, 1 insertion(+), 53 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 7c3da29fad8e..440065462a69 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -216,27 +216,6 @@ static void l2tp_tunnel_sock_put(struct sock *sk)
 	sock_put(sk);
 }
 
-/* Lookup a session by id in the global session list
- */
-static struct l2tp_session *l2tp_session_find_2(struct net *net, u32 session_id)
-{
-	struct l2tp_net *pn = l2tp_pernet(net);
-	struct hlist_head *session_list =
-		l2tp_session_id_hash_2(pn, session_id);
-	struct l2tp_session *session;
-
-	rcu_read_lock_bh();
-	hlist_for_each_entry_rcu(session, session_list, global_hlist) {
-		if (session->session_id == session_id) {
-			rcu_read_unlock_bh();
-			return session;
-		}
-	}
-	rcu_read_unlock_bh();
-
-	return NULL;
-}
-
 /* Session hash list.
  * The session_id SHOULD be random according to RFC2661, but several
  * L2TP implementations (Cisco and Microsoft) use incrementing
@@ -249,35 +228,7 @@ l2tp_session_id_hash(struct l2tp_tunnel *tunnel, u32 session_id)
 	return &tunnel->session_hlist[hash_32(session_id, L2TP_HASH_BITS)];
 }
 
-/* Lookup a session by id
- */
-struct l2tp_session *l2tp_session_find(struct net *net, struct l2tp_tunnel *tunnel, u32 session_id)
-{
-	struct hlist_head *session_list;
-	struct l2tp_session *session;
-
-	/* In L2TPv3, session_ids are unique over all tunnels and we
-	 * sometimes need to look them up before we know the
-	 * tunnel.
-	 */
-	if (tunnel == NULL)
-		return l2tp_session_find_2(net, session_id);
-
-	session_list = l2tp_session_id_hash(tunnel, session_id);
-	read_lock_bh(&tunnel->hlist_lock);
-	hlist_for_each_entry(session, session_list, hlist) {
-		if (session->session_id == session_id) {
-			read_unlock_bh(&tunnel->hlist_lock);
-			return session;
-		}
-	}
-	read_unlock_bh(&tunnel->hlist_lock);
-
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(l2tp_session_find);
-
-/* Like l2tp_session_find() but takes a reference on the returned session.
+/* Lookup a session. A new reference is held on the returned session.
  * Optionally calls session->ref() too if do_ref is true.
  */
 struct l2tp_session *l2tp_session_get(struct net *net,
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 092698a8f74b..e38db6a807f5 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -234,9 +234,6 @@ static inline struct l2tp_tunnel *l2tp_sock_to_tunnel(struct sock *sk)
 struct l2tp_session *l2tp_session_get(struct net *net,
 				      struct l2tp_tunnel *tunnel,
 				      u32 session_id, bool do_ref);
-struct l2tp_session *l2tp_session_find(struct net *net,
-				       struct l2tp_tunnel *tunnel,
-				       u32 session_id);
 struct l2tp_session *l2tp_session_get_nth(struct l2tp_tunnel *tunnel, int nth,
 					  bool do_ref);
 struct l2tp_session *l2tp_session_get_by_ifname(struct net *net, char *ifname,
-- 
2.27.0.rc0.183.gde8f92d652-goog

