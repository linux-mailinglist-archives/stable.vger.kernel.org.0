Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B67E49E9DA
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 19:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244869AbiA0SKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 13:10:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245097AbiA0SKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 13:10:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681A4C06175E;
        Thu, 27 Jan 2022 10:09:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0792061998;
        Thu, 27 Jan 2022 18:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBF7C340E8;
        Thu, 27 Jan 2022 18:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643306973;
        bh=cTzy/uUSa4SbHM+Sg65a3vUrWjXyn+gy5N/7gXWhp/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xtbrkqICQenRVWrbg2ujnhODqnOwR5v2ilynetkPKdDk5J7V4a5UUtJZec8XPkCV
         I25kgo992H7KzQcP3AclSsgxdXJUOrkoHThO15jrwgQ4i8JRu6R92OPCkdUxNFnqKp
         PCjL9ECw8+Si6dySXSJ37vb6En1aOczhgcs/cin0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        Huang Guobin <huangguobin4@huawei.com>
Subject: [PATCH 4.19 2/3] net: bridge: clear bridges private skb space on xmit
Date:   Thu, 27 Jan 2022 19:09:02 +0100
Message-Id: <20220127180256.913580967@linuxfoundation.org>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220127180256.837257619@linuxfoundation.org>
References: <20220127180256.837257619@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

commit fd65e5a95d08389444e8591a20538b3edece0e15 upstream.

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
Signed-off-by: Huang Guobin <huangguobin4@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_device.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -42,6 +42,8 @@ netdev_tx_t br_dev_xmit(struct sk_buff *
 	struct ethhdr *eth;
 	u16 vid = 0;
 
+	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
+
 	rcu_read_lock();
 	nf_ops = rcu_dereference(nf_br_ops);
 	if (nf_ops && nf_ops->br_dev_xmit_hook(skb)) {


