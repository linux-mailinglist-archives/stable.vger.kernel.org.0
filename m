Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E339B211D
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389999AbfIMNdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388524AbfIMNJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:09:36 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D566720CC7;
        Fri, 13 Sep 2019 13:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380175;
        bh=K6pKLWXHqc+Yt0nYkI/jxp9x1HNQc4F9C1cm09K8eFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBmPFQBe02QarFq7wYcIaAqzjT3zG2lp0eS84Dxp0vgc5tVxHCJzSDc+31j7FYNcm
         YcW1MVX3Mie2XvGsZv/pXTaSWCwJu/Nx7RjV9zeClJXr0gGFMvray2N/6/iGREduim
         4oIQpZwqbhXIp3cvDZZ3zTt+NNZyVIJEqR3yJ8H0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0bf0519d6e0de15914fe@syzkaller.appspotmail.com,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 4.9 06/14] xfrm: clean up xfrm protocol checks
Date:   Fri, 13 Sep 2019 14:06:59 +0100
Message-Id: <20190913130444.653504118@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130440.264749443@linuxfoundation.org>
References: <20190913130440.264749443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

commit dbb2483b2a46fbaf833cfb5deb5ed9cace9c7399 upstream.

In commit 6a53b7593233 ("xfrm: check id proto in validate_tmpl()")
I introduced a check for xfrm protocol, but according to Herbert
IPSEC_PROTO_ANY should only be used as a wildcard for lookup, so
it should be removed from validate_tmpl().

And, IPSEC_PROTO_ANY is expected to only match 3 IPSec-specific
protocols, this is why xfrm_state_flush() could still miss
IPPROTO_ROUTING, which leads that those entries are left in
net->xfrm.state_all before exit net. Fix this by replacing
IPSEC_PROTO_ANY with zero.

This patch also extracts the check from validate_tmpl() to
xfrm_id_proto_valid() and uses it in parse_ipsecrequest().
With this, no other protocols should be added into xfrm.

Fixes: 6a53b7593233 ("xfrm: check id proto in validate_tmpl()")
Reported-by: syzbot+0bf0519d6e0de15914fe@syzkaller.appspotmail.com
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/xfrm.h    |   17 +++++++++++++++++
 net/key/af_key.c      |    4 +++-
 net/xfrm/xfrm_state.c |    2 +-
 net/xfrm/xfrm_user.c  |   14 +-------------
 4 files changed, 22 insertions(+), 15 deletions(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1297,6 +1297,23 @@ static inline int xfrm_state_kern(const
 	return atomic_read(&x->tunnel_users);
 }
 
+static inline bool xfrm_id_proto_valid(u8 proto)
+{
+	switch (proto) {
+	case IPPROTO_AH:
+	case IPPROTO_ESP:
+	case IPPROTO_COMP:
+#if IS_ENABLED(CONFIG_IPV6)
+	case IPPROTO_ROUTING:
+	case IPPROTO_DSTOPTS:
+#endif
+		return true;
+	default:
+		return false;
+	}
+}
+
+/* IPSEC_PROTO_ANY only matches 3 IPsec protocols, 0 could match all. */
 static inline int xfrm_id_proto_match(u8 proto, u8 userproto)
 {
 	return (!userproto || proto == userproto ||
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1969,8 +1969,10 @@ parse_ipsecrequest(struct xfrm_policy *x
 
 	if (rq->sadb_x_ipsecrequest_mode == 0)
 		return -EINVAL;
+	if (!xfrm_id_proto_valid(rq->sadb_x_ipsecrequest_proto))
+		return -EINVAL;
 
-	t->id.proto = rq->sadb_x_ipsecrequest_proto; /* XXX check proto */
+	t->id.proto = rq->sadb_x_ipsecrequest_proto;
 	if ((mode = pfkey_mode_to_xfrm(rq->sadb_x_ipsecrequest_mode)) < 0)
 		return -EINVAL;
 	t->mode = mode;
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2168,7 +2168,7 @@ void xfrm_state_fini(struct net *net)
 	unsigned int sz;
 
 	flush_work(&net->xfrm.state_hash_work);
-	xfrm_state_flush(net, IPSEC_PROTO_ANY, false);
+	xfrm_state_flush(net, 0, false);
 	flush_work(&xfrm_state_gc_work);
 
 	WARN_ON(!list_empty(&net->xfrm.state_all));
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1452,20 +1452,8 @@ static int validate_tmpl(int nr, struct
 			return -EINVAL;
 		}
 
-		switch (ut[i].id.proto) {
-		case IPPROTO_AH:
-		case IPPROTO_ESP:
-		case IPPROTO_COMP:
-#if IS_ENABLED(CONFIG_IPV6)
-		case IPPROTO_ROUTING:
-		case IPPROTO_DSTOPTS:
-#endif
-		case IPSEC_PROTO_ANY:
-			break;
-		default:
+		if (!xfrm_id_proto_valid(ut[i].id.proto))
 			return -EINVAL;
-		}
-
 	}
 
 	return 0;


