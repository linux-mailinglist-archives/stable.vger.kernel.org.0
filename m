Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6496E61D8
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjDRM2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:28:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbjDRM2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:28:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF37AF2F
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:27:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C3D1624C0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F198C433EF;
        Tue, 18 Apr 2023 12:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820812;
        bh=BMr0ezNsO/wEAu8Oyg2t+sow/kPTDi5XMWv+pNsoAcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocbJHKBv+2Sj46eivX3IaPMWr32hMSg/OSIh65j3AxcuprQDywoxZ4t9uhsHbGFoP
         g/InZfCdcISCPwU8IKsIZB9Uw0JCrrnEN6TGqZ2YIvcZbx6w4jYRgVONcLIc1FpYh7
         AWklm/wQWxvaoyweSdzJXUAjhN/gekqOkP2RekXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/57] net: dont let netpoll invoke NAPI if in xmit context
Date:   Tue, 18 Apr 2023 14:21:11 +0200
Message-Id: <20230418120259.114269603@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 275b471e3d2daf1472ae8fa70dc1b50c9e0b9e75 ]

Commit 0db3dc73f7a3 ("[NETPOLL]: tx lock deadlock fix") narrowed
down the region under netif_tx_trylock() inside netpoll_send_skb().
(At that point in time netif_tx_trylock() would lock all queues of
the device.) Taking the tx lock was problematic because driver's
cleanup method may take the same lock. So the change made us hold
the xmit lock only around xmit, and expected the driver to take
care of locking within ->ndo_poll_controller().

Unfortunately this only works if netpoll isn't itself called with
the xmit lock already held. Netpoll code is careful and uses
trylock(). The drivers, however, may be using plain lock().
Printing while holding the xmit lock is going to result in rare
deadlocks.

Luckily we record the xmit lock owners, so we can scan all the queues,
the same way we scan NAPI owners. If any of the xmit locks is held
by the local CPU we better not attempt any polling.

It would be nice if we could narrow down the check to only the NAPIs
and the queue we're trying to use. I don't see a way to do that now.

Reported-by: Roman Gushchin <roman.gushchin@linux.dev>
Fixes: 0db3dc73f7a3 ("[NETPOLL]: tx lock deadlock fix")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 41e32a958d08d..08f0da9e6a809 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -136,6 +136,20 @@ static void queue_process(struct work_struct *work)
 	}
 }
 
+static int netif_local_xmit_active(struct net_device *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->num_tx_queues; i++) {
+		struct netdev_queue *txq = netdev_get_tx_queue(dev, i);
+
+		if (READ_ONCE(txq->xmit_lock_owner) == smp_processor_id())
+			return 1;
+	}
+
+	return 0;
+}
+
 static void poll_one_napi(struct napi_struct *napi)
 {
 	int work;
@@ -182,7 +196,10 @@ void netpoll_poll_dev(struct net_device *dev)
 	if (!ni || down_trylock(&ni->dev_lock))
 		return;
 
-	if (!netif_running(dev)) {
+	/* Some drivers will take the same locks in poll and xmit,
+	 * we can't poll if local CPU is already in xmit.
+	 */
+	if (!netif_running(dev) || netif_local_xmit_active(dev)) {
 		up(&ni->dev_lock);
 		return;
 	}
-- 
2.39.2



