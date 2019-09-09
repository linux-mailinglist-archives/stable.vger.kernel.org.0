Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C20ADFB5
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 21:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405918AbfIITzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 15:55:03 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36642 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730465AbfIITzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 15:55:03 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so9927956pfr.3
        for <stable@vger.kernel.org>; Mon, 09 Sep 2019 12:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uq1vOZmAZWkLF7K17ZXxDZiv8Z7gVxrVpiTC8znLLKU=;
        b=OKIKRRw2rP0AlPBwRSiQrYch3qsqaQWiy7HNfc5EP3YrTLPW7sYfWHZ9+iJJTxrVaN
         1gmDTeVgwjXjv1nYOmqCI8tu9DLRqQ0HUDCvuO1hTI4jm4XwILuZC66p2VBBzqGizUzu
         6YtvIBPpVe4x6VyUnbl4nsQw1+lKB/HoXKris=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uq1vOZmAZWkLF7K17ZXxDZiv8Z7gVxrVpiTC8znLLKU=;
        b=ccH0y3v4Hqgdo3ODW6edOpbVBS1rxJxeO1m0R46EUtkYEaeCnVRZ1WczJiz3/qtwOM
         MLUM78QYFLFnZjL2BLi/m1Pt7gLqiveJ89FaDscaRR2HYRmCcbeBwjCdGZEcHUDWjich
         eLePLG5ulVc6XChGsng8tjcKGKLyL/OuP9UpBIN1fZ8KE/I+FcmbJT0f4fcwUaQy3Kji
         6ubmV3DZEkVNAcO1V0A55cARHmkPBLFZ8S8WYkSfPOnOsf7K7SPq6cz6xMV34aT7aDso
         wIKzX5qLIPRLPbVUOee/wqAiAyawqUjnBrTm3y0uUPiv709/JxHH44PYuS4/gs4/D9Cy
         5mig==
X-Gm-Message-State: APjAAAWz1cFUeYqOLFkVEfr/aZsp/Weeoh2iqXCaQT+oPhBFkw+FjQYK
        B4Iu57JBrld5l4GvvEKHZ/S3upw7OP6GmQ==
X-Google-Smtp-Source: APXvYqxeRElw6/2mRI2Z8CvfDEgKSuDzSumGZE9lpC/CumwQrR5W+pOdRPPAUWR/5dBTKaTVD9vuCw==
X-Received: by 2002:a63:3805:: with SMTP id f5mr23311711pga.272.1568058901637;
        Mon, 09 Sep 2019 12:55:01 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id c125sm23389647pfa.107.2019.09.09.12.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 12:55:00 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        xiyou.wangcong@gmail.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au
Subject: [v4.14.y, v4.9.y] xfrm: clean up xfrm protocol checks
Date:   Mon,  9 Sep 2019 12:54:57 -0700
Message-Id: <20190909195457.56783-1-zsm@chromium.org>
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
 __dump_stack lib/dump_stack.c:17 [inline]
 dump_stack+0x114/0x1cf lib/dump_stack.c:53
 panic+0x1bb/0x3a0 kernel/panic.c:181
 __warn.cold.9+0x149/0x186 kernel/panic.c:542
 report_bug+0x1f7/0x272 lib/bug.c:186
 fixup_bug arch/x86/kernel/traps.c:177 [inline]
 do_error_trap+0x1c1/0x430 arch/x86/kernel/traps.c:295
 do_invalid_op+0x20/0x30 arch/x86/kernel/traps.c:314
 invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:944
 xfrm_net_exit+0x2a/0x30 net/xfrm/xfrm_policy.c:2971
 ops_exit_list.isra.11+0xb5/0x160 net/core/net_namespace.c:142
 cleanup_net+0x575/0xab0 net/core/net_namespace.c:483
 process_one_work+0xb5c/0x1950 kernel/workqueue.c:2114
 worker_thread+0x224/0x18c0 kernel/workqueue.c:2248
 kthread+0x359/0x430 kernel/kthread.c:231
 ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:402

* The commit is present in linux-4.19.y. A backport for linux-4.4.y will
be sent separately.

* The patch resolves the following conflicts:
- conflicts in content of xfrm6_tunnel_net_exit()
- changes in the prototype of xfrm_state_flush()
- ordering of xfrm_state_flush(...) and flush_work(&xfrm_state_gc_work)
  inside xfrm_state_fini.

* Tests run: Chrome OS tryjobs, syzkaller reproducer

 include/net/xfrm.h    | 17 +++++++++++++++++
 net/key/af_key.c      |  4 +++-
 net/xfrm/xfrm_state.c |  2 +-
 net/xfrm/xfrm_user.c  | 14 +-------------
 4 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index bdf185ae93db..57b8b11cf7d4 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1366,6 +1366,23 @@ static inline int xfrm_state_kern(const struct xfrm_state *x)
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
index ac38b47e9f86..f8f7065f7b62 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1951,8 +1951,10 @@ parse_ipsecrequest(struct xfrm_policy *xp, struct sadb_x_ipsecrequest *rq)
 
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
index 7c093de68780..bd16e6882017 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2330,7 +2330,7 @@ void xfrm_state_fini(struct net *net)
 	unsigned int sz;
 
 	flush_work(&net->xfrm.state_hash_work);
-	xfrm_state_flush(net, IPSEC_PROTO_ANY, false);
+	xfrm_state_flush(net, 0, false);
 	flush_work(&xfrm_state_gc_work);
 
 	WARN_ON(!list_empty(&net->xfrm.state_all));
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 150c58dc8a7b..339a070da597 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1489,20 +1489,8 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family)
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

