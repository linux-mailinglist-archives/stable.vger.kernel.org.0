Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF4111EF1A
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732633AbfEOL36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732166AbfEOL35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:29:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 763FB20881;
        Wed, 15 May 2019 11:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919796;
        bh=ZXfI5rOLK+JAyxi0GMFDARkhQbo+4KCbdDkLOuPMubI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aw1dyJjv57zo79um3izrNAt5cqdy+vvDE8x8lW45zfU/dHVAOOAzoTMpJwGBdTf2K
         qjl2vUOMSjDJnN8IfBDbVuqk8QUZ8QjidjFM9iCAXiC/5Ixc61y49rBksJNA5TjJT6
         LyfyCI1UKXhxPn85xLdoleQIB9cFMxshxweJjwj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 5.0 097/137] bpf: only test gso type on gso packets
Date:   Wed, 15 May 2019 12:56:18 +0200
Message-Id: <20190515090700.580924077@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4c3024debf62de4c6ac6d3cb4c0063be21d4f652 ]

BPF can adjust gso only for tcp bytestreams. Fail on other gso types.

But only on gso packets. It does not touch this field if !gso_size.

Fixes: b90efd225874 ("bpf: only adjust gso_size on bytestream protocols")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 include/linux/skbuff.h | 4 ++--
 net/core/filter.c      | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bdb9563c64a01..b8679dcba96f8 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4212,10 +4212,10 @@ static inline bool skb_is_gso_sctp(const struct sk_buff *skb)
 	return skb_shinfo(skb)->gso_type & SKB_GSO_SCTP;
 }
 
+/* Note: Should be called only if skb_is_gso(skb) is true */
 static inline bool skb_is_gso_tcp(const struct sk_buff *skb)
 {
-	return skb_is_gso(skb) &&
-	       skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6);
+	return skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6);
 }
 
 static inline void skb_gso_reset(struct sk_buff *skb)
diff --git a/net/core/filter.c b/net/core/filter.c
index f7d0004fc1609..ff07996515f2d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2789,7 +2789,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 	u32 off = skb_mac_header_len(skb);
 	int ret;
 
-	if (!skb_is_gso_tcp(skb))
+	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb))
 		return -ENOTSUPP;
 
 	ret = skb_cow(skb, len_diff);
@@ -2830,7 +2830,7 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 	u32 off = skb_mac_header_len(skb);
 	int ret;
 
-	if (!skb_is_gso_tcp(skb))
+	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb))
 		return -ENOTSUPP;
 
 	ret = skb_unclone(skb, GFP_ATOMIC);
@@ -2955,7 +2955,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 len_diff)
 	u32 off = skb_mac_header_len(skb) + bpf_skb_net_base_len(skb);
 	int ret;
 
-	if (!skb_is_gso_tcp(skb))
+	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb))
 		return -ENOTSUPP;
 
 	ret = skb_cow(skb, len_diff);
@@ -2984,7 +2984,7 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 len_diff)
 	u32 off = skb_mac_header_len(skb) + bpf_skb_net_base_len(skb);
 	int ret;
 
-	if (!skb_is_gso_tcp(skb))
+	if (skb_is_gso(skb) && !skb_is_gso_tcp(skb))
 		return -ENOTSUPP;
 
 	ret = skb_unclone(skb, GFP_ATOMIC);
-- 
2.20.1



