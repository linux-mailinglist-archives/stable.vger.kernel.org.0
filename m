Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E05261E70
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730879AbgIHTvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730702AbgIHPt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:49:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B1C324859;
        Tue,  8 Sep 2020 15:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579917;
        bh=x6dG5iZPys6XcszX9f3KVT/6LcOENDa9YEo2YC63G9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJC+SgjWj8lTrsk5TGrEdrnSLrfEOuAdBHLj6Yd7kSEAYq06NUWZYPi02x1qJpdYd
         Pn/Tqg3eUxu9Wvq+vtld1RBervnmRts7E79z0qBxGYxRiX8v7cUaeVjCYgcN1SDWY/
         OTzRIyEFH6UdR2IvoYRI+rKldSkO7ApjdHS5/elA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@dlink.ru>,
        Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hyunsoon Kim <h10.kim@samsung.com>
Subject: [PATCH 5.4 086/129] net: core: use listified Rx for GRO_NORMAL in napi_gro_receive()
Date:   Tue,  8 Sep 2020 17:25:27 +0200
Message-Id: <20200908152234.000867723@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@dlink.ru>

commit 6570bc79c0dfff0f228b7afd2de720fb4e84d61d upstream.

Commit 323ebb61e32b4 ("net: use listified RX for handling GRO_NORMAL
skbs") made use of listified skb processing for the users of
napi_gro_frags().
The same technique can be used in a way more common napi_gro_receive()
to speed up non-merged (GRO_NORMAL) skbs for a wide range of drivers
including gro_cells and mac80211 users.
This slightly changes the return value in cases where skb is being
dropped by the core stack, but it seems to have no impact on related
drivers' functionality.
gro_normal_batch is left untouched as it's very individual for every
single system configuration and might be tuned in manual order to
achieve an optimal performance.

Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
Acked-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Hyunsoon Kim <h10.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/dev.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5602,12 +5602,13 @@ static void napi_skb_free_stolen_head(st
 	kmem_cache_free(skbuff_head_cache, skb);
 }
 
-static gro_result_t napi_skb_finish(gro_result_t ret, struct sk_buff *skb)
+static gro_result_t napi_skb_finish(struct napi_struct *napi,
+				    struct sk_buff *skb,
+				    gro_result_t ret)
 {
 	switch (ret) {
 	case GRO_NORMAL:
-		if (netif_receive_skb_internal(skb))
-			ret = GRO_DROP;
+		gro_normal_one(napi, skb);
 		break;
 
 	case GRO_DROP:
@@ -5639,7 +5640,7 @@ gro_result_t napi_gro_receive(struct nap
 
 	skb_gro_reset_offset(skb);
 
-	ret = napi_skb_finish(dev_gro_receive(napi, skb), skb);
+	ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
 	trace_napi_gro_receive_exit(ret);
 
 	return ret;


