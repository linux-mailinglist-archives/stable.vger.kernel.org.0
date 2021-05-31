Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65BC395FA7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbhEaONj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:13:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233354AbhEaOLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:11:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B8FC61988;
        Mon, 31 May 2021 13:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468479;
        bh=UNlO1fM6zCSxN2GOwmtuEV0qOlY3BkYmF6gkGidp3oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S0x+eGVraK+yyrNqfIyOY2nn7sAigZCl2n7mUsOYtOake30dIOApk5hvdWYshQ7Kf
         khWUC7s3tC5FQXi9gUds3siiG4YdZIUdNrdf8INmpLD2A2rzfRa/yr080TVgLdi8/5
         mHqtqLg0cM2dJxYcFlMeW9eQn8jpr4Or6QYOkCpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/252] ipv6: record frag_max_size in atomic fragments in input path
Date:   Mon, 31 May 2021 15:14:59 +0200
Message-Id: <20210531130705.953755666@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Ruggeri <fruggeri@arista.com>

[ Upstream commit e29f011e8fc04b2cdc742a2b9bbfa1b62518381a ]

Commit dbd1759e6a9c ("ipv6: on reassembly, record frag_max_size")
filled the frag_max_size field in IP6CB in the input path.
The field should also be filled in case of atomic fragments.

Fixes: dbd1759e6a9c ('ipv6: on reassembly, record frag_max_size')
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/reassembly.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 47a0dc46cbdb..28e44782c94d 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -343,7 +343,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	hdr = ipv6_hdr(skb);
 	fhdr = (struct frag_hdr *)skb_transport_header(skb);
 
-	if (!(fhdr->frag_off & htons(0xFFF9))) {
+	if (!(fhdr->frag_off & htons(IP6_OFFSET | IP6_MF))) {
 		/* It is not a fragmented frame */
 		skb->transport_header += sizeof(struct frag_hdr);
 		__IP6_INC_STATS(net,
@@ -351,6 +351,8 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 
 		IP6CB(skb)->nhoff = (u8 *)fhdr - skb_network_header(skb);
 		IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
+		IP6CB(skb)->frag_max_size = ntohs(hdr->payload_len) +
+					    sizeof(struct ipv6hdr);
 		return 1;
 	}
 
-- 
2.30.2



