Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86FDF240A2E
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgHJPZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:25:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbgHJPZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:25:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9021020772;
        Mon, 10 Aug 2020 15:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073103;
        bh=ajMsI4xUoVTgHLx3ZBH4Psl5Wd0PXJUml7ZJQggVTok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4E3hVmDYwa7FFVVd6tZsZ4fGRUFleK9qQ6/Pajhaf2JX9mp3s2KRCZFufdFm7BRt
         Vqtdbquj6o1zxPSg488TiOQCE6PQBMBZpTzJUfMrKvIFTFLdb0ynWOUOvhZ0n1tWID
         zVTEGXKtpu7kwHY2RPm8/fGrlJSjNbhXxA+RKt1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.7 66/79] net: bridge: clear bridges private skb space on xmit
Date:   Mon, 10 Aug 2020 17:21:25 +0200
Message-Id: <20200810151815.494804698@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151812.114485777@linuxfoundation.org>
References: <20200810151812.114485777@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit fd65e5a95d08389444e8591a20538b3edece0e15 ]

We need to clear all of the bridge private skb variables as they can be
stale due to the packet being recirculated through the stack and then
transmitted through the bridge device. Similar memset is already done on
bridge's input. We've seen cases where proxyarp_replied was 1 on routed
multicast packets transmitted through the bridge to ports with neigh
suppress which were getting dropped. Same thing can in theory happen with
the port isolation bit as well.

Fixes: 821f1b21cabb ("bridge: add new BR_NEIGH_SUPPRESS port flag to suppress arp and nd flood")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_device.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -36,6 +36,8 @@ netdev_tx_t br_dev_xmit(struct sk_buff *
 	const unsigned char *dest;
 	u16 vid = 0;
 
+	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
+
 	rcu_read_lock();
 	nf_ops = rcu_dereference(nf_br_ops);
 	if (nf_ops && nf_ops->br_dev_xmit_hook(skb)) {


