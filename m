Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBAEDADFDC
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 22:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfIIUTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 16:19:02 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37467 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732979AbfIIUTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 16:19:01 -0400
Received: by mail-pf1-f194.google.com with SMTP id y5so7245333pfo.4
        for <stable@vger.kernel.org>; Mon, 09 Sep 2019 13:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2SbHHuGlSF/34N7YRgI+XPxIHYN1V6G0+OaK6aiEA+U=;
        b=KGh8wFdR/Jo4kBpbdRvb8JE1/Ac/hwF3I58Lvz5VPmRa4ih/uCTqCGWW4BMACbhsKL
         bNBBJyFOqUO2MdlSiTz67IFBsgQ971lkEYGMuRhaGTyzbhM/mhL6rIno9qG6sahLx72C
         XMiM/+KtY2Y+7Dt7njY6WLDfWfsvm758OVRmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2SbHHuGlSF/34N7YRgI+XPxIHYN1V6G0+OaK6aiEA+U=;
        b=iiQV5cpx+8lq8YyKnicokK2z7+3RzmF9VGElpAniklS2ybRrmBkSLX6+lb23xB4yzY
         kFjUFBmzd3zuX5+1TdRzJDlSMgFLWRqoqAUr6GTR9TOD63Y1II9RQAe8fO75CQoy8h3q
         3u9asTAXUgkS9OMYfghUtzpqbDKjNPU6z6Z6J08KVBWGRXQtE4NPCOP7XFPJhP1XHvK6
         d+lOcyWKW3Urms8glSHKjSuufqK1GS6Qx5/6iBVHBXP+yf0ZgpxrNOrcrG0j6iR6Zhxr
         hYv75laQE8uv6z1V/J/J144biXHQ+l8t6fUyNHreO6yNZuN6IWKWfTm1xSs1drA+BoHK
         al4g==
X-Gm-Message-State: APjAAAVMmnTljUHrQ9zjeg/LeK76qstBRDGflyPITHs6EKtg/WbvMo5l
        j5seqBADe8k50ow6cewgSJrEQOhtESI8Jw==
X-Google-Smtp-Source: APXvYqxLIUgW3u67VXjvKdpynD3T+8ohv1d5VbXhxvsfiiqUpHdFfMvgEje4PktAPBUnYr76DoY4kQ==
X-Received: by 2002:a62:e50c:: with SMTP id n12mr30439439pff.206.1568060340546;
        Mon, 09 Sep 2019 13:19:00 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id f128sm21932432pfg.143.2019.09.09.13.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 13:18:59 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        xiyou.wangcong@gmail.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au
Subject: [v4.4.y] xfrm: clean up xfrm protocol checks
Date:   Mon,  9 Sep 2019 13:18:51 -0700
Message-Id: <20190909201851.117250-1-zsm@chromium.org>
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
MIME-Version: 1.0
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
---
Notes:
* Syzkaller triggered a WARNING with the following stacktrace:
  __dump_stack lib/dump_stack.c:15 [inline]
  dump_stack+0xbf/0x113 lib/dump_stack.c:51
  panic+0x1a6/0x361 kernel/panic.c:116
  __warn+0x168/0x1b0 kernel/panic.c:470
  warn_slowpath_null+0x3c/0x40 kernel/panic.c:514
  xfrm_state_fini+0x83/0x28e net/xfrm/xfrm_state.c:2131
  xfrm_net_exit+0x32/0x35 net/xfrm/xfrm_policy.c:3044
  ops_exit_list+0xfc/0x12f net/core/net_namespace.c:136
  cleanup_net+0x328/0x4ce net/core/net_namespace.c:454
  process_one_work+0x7df/0xca8 kernel/workqueue.c:2064
  worker_thread+0x592/0x765 kernel/workqueue.c:2196
  kthread+0x279/0x28d kernel/kthread.c:211
  ret_from_fork+0x4e/0x80 arch/x86/entry/entry_64.S:600

* The commit is present in linux-4.19.y. A backport for 4.14.y and 4.9.y
has been sent separately.

* The patch resolves the following conflicts:
- conflicts in content of xfrm6_tunnel_net_exit()
- changes in the prototype of xfrm_state_flush()
- net->xfrm.state_gc_work has been moved to a global xfrm_state_gc_work
- ordering of xfrm_state_flush(...) and flush_work(...)
  inside xfrm_state_fini.

* Tests run: Chrome OS tryjobs, syzkaller reproducer

 include/net/xfrm.h    | 17 +++++++++++++++++
 net/key/af_key.c      |  4 +++-
 net/xfrm/xfrm_state.c |  2 +-
 net/xfrm/xfrm_user.c  | 14 +-------------
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 185fb037b332..631614856afc 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1301,6 +1301,23 @@ static inline int xfrm_state_kern(const struct xfrm_state *x)
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
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 36db179d848e..d2ec620319d7 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1969,8 +1969,10 @@ parse_ipsecrequest(struct xfrm_policy *xp, struct sadb_x_ipsecrequest *rq)
 
 	if (rq->sadb_x_ipsecrequest_mode == 0)
 		return -EINVAL;
+	if (!xfrm_id_proto_valid(rq->sadb_x_ipsecrequest_proto))
+		return -EINVAL;
 
-	t->id.proto = rq->sadb_x_ipsecrequest_proto; /* XXX check proto */
+	t->id.proto = rq->sadb_x_ipsecrequest_proto;
 	if ((mode = pfkey_mode_to_xfrm(rq->sadb_x_ipsecrequest_mode)) < 0)
 		return -EINVAL;
 	t->mode = mode;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 13f261feb75c..787f2cac18c5 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2133,7 +2133,7 @@ void xfrm_state_fini(struct net *net)
 	unsigned int sz;
 
 	flush_work(&net->xfrm.state_hash_work);
-	xfrm_state_flush(net, IPSEC_PROTO_ANY, false);
+	xfrm_state_flush(net, 0, false);
 	flush_work(&net->xfrm.state_gc_work);
 
 	WARN_ON(!list_empty(&net->xfrm.state_all));
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 8cc2a9df84fd..4dbe6ebeabf8 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1448,20 +1448,8 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family)
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
-- 
2.23.0.162.g0b9fbb3734-goog

