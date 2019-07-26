Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D0476D0F
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbfGZPaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726260AbfGZP36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:29:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0799922CBD;
        Fri, 26 Jul 2019 15:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154998;
        bh=mU/cphH8ryHrVmuO9omVALk2fgtD/LhRfsJrntv7E2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCWuOYUUa7S1+CpTqEb8UsQ/Fl1jmJRv7McEi5yeMvzd5omIfwv0dRNCb9lrlXlNJ
         H9HfV7zW7fUCUhZtVIsmuPwlgq86VbKXMNlfkEDXIVD1cTPzxoZ0OJACI1B4dvgvtB
         Fh9Rjkeeuiv5hcLmnVWpnro30u66YAxvSeQjW+08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 31/62] net: bridge: stp: dont cache eth dest pointer before skb pull
Date:   Fri, 26 Jul 2019 17:24:43 +0200
Message-Id: <20190726152305.002892598@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit 2446a68ae6a8cee6d480e2f5b52f5007c7c41312 ]

Don't cache eth dest pointer before calling pskb_may_pull.

Fixes: cf0f02d04a83 ("[BRIDGE]: use llc for receiving STP packets")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_stp_bpdu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -147,7 +147,6 @@ void br_send_tcn_bpdu(struct net_bridge_
 void br_stp_rcv(const struct stp_proto *proto, struct sk_buff *skb,
 		struct net_device *dev)
 {
-	const unsigned char *dest = eth_hdr(skb)->h_dest;
 	struct net_bridge_port *p;
 	struct net_bridge *br;
 	const unsigned char *buf;
@@ -176,7 +175,7 @@ void br_stp_rcv(const struct stp_proto *
 	if (p->state == BR_STATE_DISABLED)
 		goto out;
 
-	if (!ether_addr_equal(dest, br->group_addr))
+	if (!ether_addr_equal(eth_hdr(skb)->h_dest, br->group_addr))
 		goto out;
 
 	if (p->flags & BR_BPDU_GUARD) {


