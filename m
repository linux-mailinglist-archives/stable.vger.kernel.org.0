Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68DF226B7E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729781AbgGTQlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:41:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730523AbgGTPp2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:45:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F3D32065E;
        Mon, 20 Jul 2020 15:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259927;
        bh=8OtSB7nWPHAUJcX3LrVccg62zsMc6i0VFnEsdZpoOHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZDzv/zAI8gw/Ws3fw6NfgyRt5rtEn9dEWH4rS7x2lc1Ck5HGpZ1LUWrl1NOO+pwo
         vXeqlb5idCSTwXjMuJHLK/5BB4RYaE54swDWVSqnWleInfBWtiIlCUSWKJpFrLsscQ
         6QMsWJFJivTijPZcM7Ya7tyZLXRMOe+VPAu8hbSc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        James Chapman <jchapman@katalix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 043/125] l2tp: remove skb_dst_set() from l2tp_xmit_skb()
Date:   Mon, 20 Jul 2020 17:36:22 +0200
Message-Id: <20200720152805.087450344@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 27d53323664c549b5bb2dfaaf6f7ad6e0376a64e ]

In the tx path of l2tp, l2tp_xmit_skb() calls skb_dst_set() to set
skb's dst. However, it will eventually call inet6_csk_xmit() or
ip_queue_xmit() where skb's dst will be overwritten by:

   skb_dst_set_noref(skb, dst);

without releasing the old dst in skb. Then it causes dst/dev refcnt leak:

  unregister_netdevice: waiting for eth0 to become free. Usage count = 1

This can be reproduced by simply running:

  # modprobe l2tp_eth && modprobe l2tp_ip
  # sh ./tools/testing/selftests/net/l2tp.sh

So before going to inet6_csk_xmit() or ip_queue_xmit(), skb's dst
should be dropped. This patch is to fix it by removing skb_dst_set()
from l2tp_xmit_skb() and moving skb_dst_drop() into l2tp_xmit_core().

Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: James Chapman <jchapman@katalix.com>
Tested-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1141,6 +1141,7 @@ static int l2tp_xmit_core(struct l2tp_se
 
 	/* Queue the packet to IP for output */
 	skb->ignore_df = 1;
+	skb_dst_drop(skb);
 #if IS_ENABLED(CONFIG_IPV6)
 	if (l2tp_sk_is_v6(tunnel->sock))
 		error = inet6_csk_xmit(tunnel->sock, skb, NULL);
@@ -1214,10 +1215,6 @@ int l2tp_xmit_skb(struct l2tp_session *s
 		goto out_unlock;
 	}
 
-	/* Get routing info from the tunnel socket */
-	skb_dst_drop(skb);
-	skb_dst_set(skb, sk_dst_check(sk, 0));
-
 	inet = inet_sk(sk);
 	fl = &inet->cork.fl;
 	switch (tunnel->encap) {


