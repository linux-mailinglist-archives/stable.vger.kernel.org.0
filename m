Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC4E1EAAB6
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730563AbgFASKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731012AbgFASKn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:10:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2053206E2;
        Mon,  1 Jun 2020 18:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035042;
        bh=H7naidMd5Qa0u04rOXvuNj7VG6ToA776KEDM8xBVLYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+MDhmO/PbA39SKoyuYBQGOCKCYhIKN5WvJpAIbZvtl+5xEpo/Zk4bUZ7ttFTUe9b
         hKCfY/jA3HKMNO1ipS5G9qb00VBjXzHQagZk49UgXkxhv1AR4yzXt32Lrjf0JxCJqS
         n2NeGUSte516/Om3YPfStCMWxQy13FS4SJMWLDT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 126/142] esp6: get the right proto for transport mode in esp6_gso_encap
Date:   Mon,  1 Jun 2020 19:54:44 +0200
Message-Id: <20200601174050.848248627@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit 3c96ec56828922e3fe5477f75eb3fc02f98f98b5 upstream.

For transport mode, when ipv6 nexthdr is set, the packet format might
be like:

    ----------------------------------------------------
    |        | dest |     |     |      |  ESP    | ESP |
    | IP6 hdr| opts.| ESP | TCP | Data | Trailer | ICV |
    ----------------------------------------------------

What it wants to get for x-proto in esp6_gso_encap() is the proto that
will be set in ESP nexthdr. So it should skip all ipv6 nexthdrs and
get the real transport protocol. Othersize, the wrong proto number
will be set into ESP nexthdr.

This patch is to skip all ipv6 nexthdrs by calling ipv6_skip_exthdr()
in esp6_gso_encap().

Fixes: 7862b4058b9f ("esp: Add gso handlers for esp4 and esp6")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv6/esp6_offload.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -121,9 +121,16 @@ static void esp6_gso_encap(struct xfrm_s
 	struct ip_esp_hdr *esph;
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct xfrm_offload *xo = xfrm_offload(skb);
-	int proto = iph->nexthdr;
+	u8 proto = iph->nexthdr;
 
 	skb_push(skb, -skb_network_offset(skb));
+
+	if (x->outer_mode.encap == XFRM_MODE_TRANSPORT) {
+		__be16 frag;
+
+		ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &proto, &frag);
+	}
+
 	esph = ip_esp_hdr(skb);
 	*skb_mac_header(skb) = IPPROTO_ESP;
 


