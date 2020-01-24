Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6CAF1484A5
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgAXLnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:43:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:37552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387683AbgAXLDk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:03:40 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 436C22071A;
        Fri, 24 Jan 2020 11:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863819;
        bh=0yewvMhf8AqFzUJFiC+c4tjGMKVsBQlw6gbehAq0MtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rf7kEW83T1kTw7iJ/CHx6hzbb6Q8ub5wrR618cHuI7qLBXKU1N4P+CrHtE61hhClu
         EPM5QU0TfaeiUW7d2iVZ7qiE+ZKrVDRs2iCJYeFrQD83PPvGW/hYZR1IFeo4gE18Er
         HgacD1P/eu2+8aLIzq5O4aFz8y2EadlqCdyxVGiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/639] ipv6: add missing tx timestamping on IPPROTO_RAW
Date:   Fri, 24 Jan 2020 10:24:14 +0100
Message-Id: <20200124093057.889176715@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit fbfb2321e950918b430e7225546296b2dcadf725 ]

Raw sockets support tx timestamping, but one case is missing.

IPPROTO_RAW takes a separate packet construction path. raw_send_hdrinc
has an explicit call to sock_tx_timestamp, but rawv6_send_hdrinc does
not. Add it.

Fixes: 11878b40ed5c ("net-timestamp: SOCK_RAW and PING timestamping")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/raw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 4856d9320b28e..a41156a00dd44 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -660,6 +660,8 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 
 	skb->ip_summed = CHECKSUM_NONE;
 
+	sock_tx_timestamp(sk, sockc->tsflags, &skb_shinfo(skb)->tx_flags);
+
 	if (flags & MSG_CONFIRM)
 		skb_set_dst_pending_confirm(skb, 1);
 
-- 
2.20.1



