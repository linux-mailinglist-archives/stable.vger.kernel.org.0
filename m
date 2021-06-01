Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006FF395D84
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhEaNrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:47:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231580AbhEaNo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:44:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E90066141C;
        Mon, 31 May 2021 13:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467771;
        bh=chRS472GWhhR5JQis0YvThFSqaRbPhgR2khsjQae0nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvAca1uiB9lzMnP0Inotcmlt1EDphV9TcY5YZY72FtrO1AmBWqgMWPbkm7r8jYxnY
         PJFkHKachhUZNAHvDZ5K9971uxWRivXhX9h+vXJANvpIHMSjYaGUzSI1QRYc0MkRoX
         BYzGSwumc+CYOAjiQTcgt+blVjZh/Sbz0Rh5PmN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 73/79] ipv6: record frag_max_size in atomic fragments in input path
Date:   Mon, 31 May 2021 15:14:58 +0200
Message-Id: <20210531130638.331799659@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
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
index 6dea6e92e686..b2f7a335a12b 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -347,7 +347,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	hdr = ipv6_hdr(skb);
 	fhdr = (struct frag_hdr *)skb_transport_header(skb);
 
-	if (!(fhdr->frag_off & htons(0xFFF9))) {
+	if (!(fhdr->frag_off & htons(IP6_OFFSET | IP6_MF))) {
 		/* It is not a fragmented frame */
 		skb->transport_header += sizeof(struct frag_hdr);
 		__IP6_INC_STATS(net,
@@ -355,6 +355,8 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 
 		IP6CB(skb)->nhoff = (u8 *)fhdr - skb_network_header(skb);
 		IP6CB(skb)->flags |= IP6SKB_FRAGMENTED;
+		IP6CB(skb)->frag_max_size = ntohs(hdr->payload_len) +
+					    sizeof(struct ipv6hdr);
 		return 1;
 	}
 
-- 
2.30.2



