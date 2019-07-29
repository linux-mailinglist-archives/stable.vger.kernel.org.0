Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A05794A8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388203AbfG2TeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388199AbfG2TeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:34:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D459E2171F;
        Mon, 29 Jul 2019 19:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428844;
        bh=mU/cphH8ryHrVmuO9omVALk2fgtD/LhRfsJrntv7E2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMV9blYZKpjeEIji5DmT2mpWBJQyQNryBQ4jLwpvIv3Ri9Q8mKRaQLFwGWaV0TZnb
         MnHIi45MvYKG4U6SOkgXX+DlGL4Tlp18kaTBHqb8YrbMgGpodzQ/FVpB7F8ToKjZ+9
         j9qEx3MnzwIBdGK8W7Bmyb7kQQhp9k/x6bpqPsT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 204/293] net: bridge: stp: dont cache eth dest pointer before skb pull
Date:   Mon, 29 Jul 2019 21:21:35 +0200
Message-Id: <20190729190840.091972186@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
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


