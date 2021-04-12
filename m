Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3841D35B898
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbhDLCXx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236623AbhDLCXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EDBB61220;
        Mon, 12 Apr 2021 02:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194215;
        bh=3nZJXKN06TeW3fLgByy3YURnJcQnT+afUFZBPeW8O74=;
        h=From:To:Cc:Subject:Date:From;
        b=LIim0oHCUr9n7BdpU2xiFEqV0a874Hn7+L2n/MCu4TDaHVk7zxTiWI5UJfFE0WUr4
         k+Jp6ao4B9SfPaBw8MCpAcmSuxq5+DepcPP+6+KdJcjbM9FTHzUO2B7tErVNlGWpIJ
         1v2aRs2qNCChiY6InDWJscWocINnTwMnvhwSFhfxOT0e2Zip6EDg/h0A4/ZWgYn8CU
         Y5Z369wTlVNtIUoK8hpsgSPZ8t1rtas6r4ptjceVnm7DtHdhbN7A8fhrHsujWSY9KP
         KzQEpNLBuQCjm/z1l4ulaYq7jnTeI7xcgKxv61ioRJ20VXO4qbxLPJ9JI8gFQ7F4Nd
         +Lub9G6XbHlLg==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, evan.nimmo@alliedtelesis.co.nz
Cc:     Steffen Klassert <steffen.klassert@secunet.com>
Subject: FAILED: Patch "xfrm: Use actual socket sk instead of skb socket for xfrm_output_resume" failed to apply to 4.14-stable tree
Date:   Sun, 11 Apr 2021 22:23:34 -0400
Message-Id: <20210412022334.284699-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 9ab1265d52314fce1b51e8665ea6dbc9ac1a027c Mon Sep 17 00:00:00 2001
From: Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
Date: Tue, 2 Mar 2021 08:00:04 +1300
Subject: [PATCH] xfrm: Use actual socket sk instead of skb socket for
 xfrm_output_resume

A situation can occur where the interface bound to the sk is different
to the interface bound to the sk attached to the skb. The interface
bound to the sk is the correct one however this information is lost inside
xfrm_output2 and instead the sk on the skb is used in xfrm_output_resume
instead. This assumes that the sk bound interface and the bound interface
attached to the sk within the skb are the same which can lead to lookup
failures inside ip_route_me_harder resulting in the packet being dropped.

We have an l2tp v3 tunnel with ipsec protection. The tunnel is in the
global VRF however we have an encapsulated dot1q tunnel interface that
is within a different VRF. We also have a mangle rule that marks the
packets causing them to be processed inside ip_route_me_harder.

Prior to commit 31c70d5956fc ("l2tp: keep original skb ownership") this
worked fine as the sk attached to the skb was changed from the dot1q
encapsulated interface to the sk for the tunnel which meant the interface
bound to the sk and the interface bound to the skb were identical.
Commit 46d6c5ae953c ("netfilter: use actual socket sk rather than skb sk
when routing harder") fixed some of these issues however a similar
problem existed in the xfrm code.

Fixes: 31c70d5956fc ("l2tp: keep original skb ownership")
Signed-off-by: Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |  2 +-
 net/ipv4/ah4.c         |  2 +-
 net/ipv4/esp4.c        |  2 +-
 net/ipv6/ah6.c         |  2 +-
 net/ipv6/esp6.c        |  2 +-
 net/xfrm/xfrm_output.c | 10 +++++-----
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index b2a06f10b62c..bfbc7810df94 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1557,7 +1557,7 @@ int xfrm_trans_queue_net(struct net *net, struct sk_buff *skb,
 int xfrm_trans_queue(struct sk_buff *skb,
 		     int (*finish)(struct net *, struct sock *,
 				   struct sk_buff *));
-int xfrm_output_resume(struct sk_buff *skb, int err);
+int xfrm_output_resume(struct sock *sk, struct sk_buff *skb, int err);
 int xfrm_output(struct sock *sk, struct sk_buff *skb);
 
 #if IS_ENABLED(CONFIG_NET_PKTGEN)
diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index d99e1be94019..36ed85bf2ad5 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -141,7 +141,7 @@ static void ah_output_done(struct crypto_async_request *base, int err)
 	}
 
 	kfree(AH_SKB_CB(skb)->tmp);
-	xfrm_output_resume(skb, err);
+	xfrm_output_resume(skb->sk, skb, err);
 }
 
 static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index a3271ec3e162..4b834bbf95e0 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -279,7 +279,7 @@ static void esp_output_done(struct crypto_async_request *base, int err)
 		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 			esp_output_tail_tcp(x, skb);
 		else
-			xfrm_output_resume(skb, err);
+			xfrm_output_resume(skb->sk, skb, err);
 	}
 }
 
diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index 440080da805b..080ee7f44c64 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -316,7 +316,7 @@ static void ah6_output_done(struct crypto_async_request *base, int err)
 	}
 
 	kfree(AH_SKB_CB(skb)->tmp);
-	xfrm_output_resume(skb, err);
+	xfrm_output_resume(skb->sk, skb, err);
 }
 
 static int ah6_output(struct xfrm_state *x, struct sk_buff *skb)
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 153ad103ba74..727d791ed5e6 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -314,7 +314,7 @@ static void esp_output_done(struct crypto_async_request *base, int err)
 		    x->encap && x->encap->encap_type == TCP_ENCAP_ESPINTCP)
 			esp_output_tail_tcp(x, skb);
 		else
-			xfrm_output_resume(skb, err);
+			xfrm_output_resume(skb->sk, skb, err);
 	}
 }
 
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index a7ab19353313..b81ca117dac7 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -503,22 +503,22 @@ out:
 	return err;
 }
 
-int xfrm_output_resume(struct sk_buff *skb, int err)
+int xfrm_output_resume(struct sock *sk, struct sk_buff *skb, int err)
 {
 	struct net *net = xs_net(skb_dst(skb)->xfrm);
 
 	while (likely((err = xfrm_output_one(skb, err)) == 0)) {
 		nf_reset_ct(skb);
 
-		err = skb_dst(skb)->ops->local_out(net, skb->sk, skb);
+		err = skb_dst(skb)->ops->local_out(net, sk, skb);
 		if (unlikely(err != 1))
 			goto out;
 
 		if (!skb_dst(skb)->xfrm)
-			return dst_output(net, skb->sk, skb);
+			return dst_output(net, sk, skb);
 
 		err = nf_hook(skb_dst(skb)->ops->family,
-			      NF_INET_POST_ROUTING, net, skb->sk, skb,
+			      NF_INET_POST_ROUTING, net, sk, skb,
 			      NULL, skb_dst(skb)->dev, xfrm_output2);
 		if (unlikely(err != 1))
 			goto out;
@@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(xfrm_output_resume);
 
 static int xfrm_output2(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	return xfrm_output_resume(skb, 1);
+	return xfrm_output_resume(sk, skb, 1);
 }
 
 static int xfrm_output_gso(struct net *net, struct sock *sk, struct sk_buff *skb)
-- 
2.30.2




