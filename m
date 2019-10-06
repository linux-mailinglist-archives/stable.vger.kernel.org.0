Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AFACD65C
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730001AbfJFRrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:47:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731281AbfJFRpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:45:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B50A52080F;
        Sun,  6 Oct 2019 17:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383914;
        bh=V0IPKrrdUzrOKmKyU4GfV33KE6odZ0Zi5xhzLS4aIZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1oLGhVaevEWxDC1il7RJa5pPVm/XHsJtWXPcBRsOFw08VExgcc3nFR5P9c3C2kQq
         hJYnmhJqfqngqyX6Qcuf4xCDG7JizIDLdsq81llAmuW3VBDVcFMVfrDrEYPAbUZuQt
         0YGLPCPZvyH+tzAweeLrwJZun8cyxydYDQKB/z38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josh Hunt <johunt@akamai.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 143/166] udp: fix gso_segs calculations
Date:   Sun,  6 Oct 2019 19:21:49 +0200
Message-Id: <20191006171225.047363914@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Hunt <johunt@akamai.com>

[ Upstream commit 44b321e5020d782ad6e8ae8183f09b163be6e6e2 ]

Commit dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
added gso_segs calculation, but incorrectly got sizeof() the pointer and
not the underlying data type. In addition let's fix the v6 case.

Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
Fixes: dfec0ee22c0a ("udp: Record gso_segs when supporting UDP segmentation offload")
Signed-off-by: Josh Hunt <johunt@akamai.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    2 +-
 net/ipv6/udp.c |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -856,7 +856,7 @@ static int udp_send_skb(struct sk_buff *
 
 		skb_shinfo(skb)->gso_size = cork->gso_size;
 		skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
-		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(uh),
+		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
 							 cork->gso_size);
 		goto csum_partial;
 	}
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1143,6 +1143,8 @@ static int udp_v6_send_skb(struct sk_buf
 
 		skb_shinfo(skb)->gso_size = cork->gso_size;
 		skb_shinfo(skb)->gso_type = SKB_GSO_UDP_L4;
+		skb_shinfo(skb)->gso_segs = DIV_ROUND_UP(len - sizeof(*uh),
+							 cork->gso_size);
 		goto csum_partial;
 	}
 


