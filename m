Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98235206511
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389197AbgFWUOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388885AbgFWUOd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:14:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B31D6206C3;
        Tue, 23 Jun 2020 20:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943273;
        bh=UA5Iy2yywDIJFznu0z+/7VIb+IIeFKicMJ2FXnd/Hjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fg2I2AZZ/OslPtGfaVTU9Vu79kdEoSNFRCTtG6f19WeROGbu+yGk6LGxn5q67GB1+
         vQclKYQ7rU+sraiXCrBeKOT4rdtS8YA1bNltmPtvhtEZCXax8IV1vio63mSQjSUh9H
         L54SOrOgdONfIVn55P9gzIIr8tyBpTp4VbEOiKEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Benc <jbenc@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 327/477] geneve: change from tx_error to tx_dropped on missing metadata
Date:   Tue, 23 Jun 2020 21:55:24 +0200
Message-Id: <20200623195422.993121461@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 9d149045b3c0e44c049cdbce8a64e19415290017 ]

If the geneve interface is in collect_md (external) mode, it can't send any
packets submitted directly to its net interface, as such packets won't have
metadata attached. This is expected.

However, the kernel itself sends some packets to the interface, most
notably, IPv6 DAD, IPv6 multicast listener reports, etc. This is not wrong,
as tunnel metadata can be specified in routing table (although technically,
that has never worked for IPv6, but hopefully will be fixed eventually) and
then the interface must correctly participate in IPv6 housekeeping.

The problem is that any such attempt increases the tx_error counter. Just
bringing up a geneve interface with IPv6 enabled is enough to see a number
of tx_errors. That causes confusion among users, prompting them to find
a network error where there is none.

Change the counter used to tx_dropped. That better conveys the meaning
(there's nothing wrong going on, just some packets are getting dropped) and
hopefully will make admins panic less.

Signed-off-by: Jiri Benc <jbenc@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/geneve.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 6b461be1820bb..75266580b586d 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -987,9 +987,10 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (geneve->collect_md) {
 		info = skb_tunnel_info(skb);
 		if (unlikely(!info || !(info->mode & IP_TUNNEL_INFO_TX))) {
-			err = -EINVAL;
 			netdev_dbg(dev, "no tunnel metadata\n");
-			goto tx_error;
+			dev_kfree_skb(skb);
+			dev->stats.tx_dropped++;
+			return NETDEV_TX_OK;
 		}
 	} else {
 		info = &geneve->info;
@@ -1006,7 +1007,7 @@ static netdev_tx_t geneve_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (likely(!err))
 		return NETDEV_TX_OK;
-tx_error:
+
 	dev_kfree_skb(skb);
 
 	if (err == -ELOOP)
-- 
2.25.1



