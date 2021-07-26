Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4604B3D612F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhGZPaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232256AbhGZP1k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:27:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D49B60F92;
        Mon, 26 Jul 2021 16:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315599;
        bh=QKwWh6cnZ5Mb0nW5dyJdBWlnfQC0Hq4ZFL0s5tjAdaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lwU0ug+GlwOJJqSSv6nm4/duX1cjZyRVQytu4tKyKSbIiZvRe44iHemRXytmGEFbv
         XwunNUbeILM1qrfhYifdr2yHNSTc583uBNjr/X9FKH5Tn97mA9zS9uaCcakykhP/Tc
         2vO8IPFpYOj4wciwq4WPbYHqV5AoEVCZV5GBkNHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 161/167] skbuff: Release nfct refcount on napi stolen or re-used skbs
Date:   Mon, 26 Jul 2021 17:39:54 +0200
Message-Id: <20210726153844.812901889@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

commit 8550ff8d8c75416e984d9c4b082845e57e560984 upstream.

When multiple SKBs are merged to a new skb under napi GRO,
or SKB is re-used by napi, if nfct was set for them in the
driver, it will not be released while freeing their stolen
head state or on re-use.

Release nfct on napi's stolen or re-used SKBs, and
in gro_list_prepare, check conntrack metadata diff.

Fixes: 5c6b94604744 ("net/mlx5e: CT: Handle misses after executing CT action")
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c    |   13 +++++++++++++
 net/core/skbuff.c |    1 +
 2 files changed, 14 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5870,6 +5870,18 @@ static struct list_head *gro_list_prepar
 			diffs = memcmp(skb_mac_header(p),
 				       skb_mac_header(skb),
 				       maclen);
+
+		diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
+
+		if (!diffs) {
+			struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
+			struct tc_skb_ext *p_ext = skb_ext_find(p, TC_SKB_EXT);
+
+			diffs |= (!!p_ext) ^ (!!skb_ext);
+			if (!diffs && unlikely(skb_ext))
+				diffs |= p_ext->chain ^ skb_ext->chain;
+		}
+
 		NAPI_GRO_CB(p)->same_flow = !diffs;
 	}
 
@@ -6151,6 +6163,7 @@ static void napi_reuse_skb(struct napi_s
 	skb_shinfo(skb)->gso_type = 0;
 	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
 	skb_ext_reset(skb);
+	nf_reset_ct(skb);
 
 	napi->skb = skb;
 }
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -659,6 +659,7 @@ fastpath:
 
 void skb_release_head_state(struct sk_buff *skb)
 {
+	nf_reset_ct(skb);
 	skb_dst_drop(skb);
 	if (skb->destructor) {
 		WARN_ON(in_irq());


