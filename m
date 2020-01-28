Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E5214BA39
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730937AbgA1OTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:19:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:44300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730651AbgA1OTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:19:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EEA624681;
        Tue, 28 Jan 2020 14:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221186;
        bh=GkmS6Nex2vCZ6uL4UYPfmvaRHWDpmAKvtj3pkJAo20o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITZfBNvz7kryh/jd/woNoUiscNJiK4tcJ1dFaNiE9ZLC37qQQ6tcNvsQNasFIu7jB
         Na+eTvZjvJKhcGkH7yHqPt6ToVqh8zyU4WMmtgc2cwQRLYbesp9WXOU82poHoHS0Au
         QC7jBRrazWOqYZYLkAHWNDmQS2O0Uj+s/C3hCMX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Laight <David.Laight@aculab.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 124/271] packet: in recvmsg msg_name return at least sizeof sockaddr_ll
Date:   Tue, 28 Jan 2020 15:04:33 +0100
Message-Id: <20200128135901.826156562@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit b2cf86e1563e33a14a1c69b3e508d15dc12f804c ]

Packet send checks that msg_name is at least sizeof sockaddr_ll.
Packet recv must return at least this length, so that its output
can be passed unmodified to packet send.

This ceased to be true since adding support for lladdr longer than
sll_addr. Since, the return value uses true address length.

Always return at least sizeof sockaddr_ll, even if address length
is shorter. Zero the padding bytes.

Change v1->v2: do not overwrite zeroed padding again. use copy_len.

Fixes: 0fb375fb9b93 ("[AF_PACKET]: Allow for > 8 byte hardware addresses.")
Suggested-by: David Laight <David.Laight@aculab.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 40cade140222f..47a862cc7b349 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3404,20 +3404,29 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
+		int copy_len;
+
 		/* If the address length field is there to be filled
 		 * in, we fill it in now.
 		 */
 		if (sock->type == SOCK_PACKET) {
 			__sockaddr_check_size(sizeof(struct sockaddr_pkt));
 			msg->msg_namelen = sizeof(struct sockaddr_pkt);
+			copy_len = msg->msg_namelen;
 		} else {
 			struct sockaddr_ll *sll = &PACKET_SKB_CB(skb)->sa.ll;
 
 			msg->msg_namelen = sll->sll_halen +
 				offsetof(struct sockaddr_ll, sll_addr);
+			copy_len = msg->msg_namelen;
+			if (msg->msg_namelen < sizeof(struct sockaddr_ll)) {
+				memset(msg->msg_name +
+				       offsetof(struct sockaddr_ll, sll_addr),
+				       0, sizeof(sll->sll_addr));
+				msg->msg_namelen = sizeof(struct sockaddr_ll);
+			}
 		}
-		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa,
-		       msg->msg_namelen);
+		memcpy(msg->msg_name, &PACKET_SKB_CB(skb)->sa, copy_len);
 	}
 
 	if (pkt_sk(sk)->auxdata) {
-- 
2.20.1



