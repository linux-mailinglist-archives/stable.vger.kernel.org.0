Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A9F1A0B8A
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728917AbgDGK1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbgDGK0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:26:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 887B220644;
        Tue,  7 Apr 2020 10:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255215;
        bh=863H0lNEbWwXgJwKX0fahP5LlX1HDAvX7TR8emyqTo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuqlILqtd1XA0PV9wCPuLUwt07y+7AGnlqExfwu1ROb22F2F0ULbne0/EQSiZDUoJ
         smZSwGD0FzqoTVZOeX+PV4KU9/TDdZNtlGjBoE66JAOloEcQyhg2rAWL1zskDTHyij
         nZeUivWX68TwtzbkzDhYQaPxaXyIiqQ5GPl4iU8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Xiumei Mu <xmu@redhat.com>, Xin Long <lucien.xin@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 07/29] net: fix fraglist segmentation reference count leak
Date:   Tue,  7 Apr 2020 12:22:04 +0200
Message-Id: <20200407101452.878711199@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101452.046058399@linuxfoundation.org>
References: <20200407101452.046058399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit cf673ed0e057a2dd68d930c6d7e30d53c70c5789 ]

Xin Long says:
 On udp rx path udp_rcv_segment() may do segment where the frag skbs
 will get the header copied from the head skb in skb_segment_list()
 by calling __copy_skb_header(), which could overwrite the frag skbs'
 extensions by __skb_ext_copy() and cause a leak.

 This issue was found after loading esp_offload where a sec path ext
 is set in the skb.

Fix this by discarding head state of the fraglist skb before replacing
its contents.

Fixes: 3a1296a38d0cf62 ("net: Support GRO/GSO fraglist chaining.")
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Reported-by: Xiumei Mu <xmu@redhat.com>
Tested-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3668,6 +3668,7 @@ struct sk_buff *skb_segment_list(struct
 
 		skb_push(nskb, -skb_network_offset(nskb) + offset);
 
+		skb_release_head_state(nskb);
 		 __copy_skb_header(nskb, skb);
 
 		skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));


