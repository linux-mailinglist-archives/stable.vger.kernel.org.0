Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD5361EF3F
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfEOLbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732389AbfEOLbp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:31:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96DCF206BF;
        Wed, 15 May 2019 11:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919905;
        bh=XEBQsgEMtGwqV0S4Aabkcag4Y+CbX6J+lt0ONluxREA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1JkxUj9+DshaTjIOtyXgy42ev8uZLmkVcVg8l9BMawmnv9BvjSig+RpvdxuxuFn+L
         Wstnk33kjY4zU3RYHHiVc3huWYqAtW/33VQHVii44TK5qoXyzb7UMysAV3qqrSHFZO
         Wc9Q7GlVGe+zCw9GxBd8WtUU+Fv6s5bheQ2JX3Ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 124/137] tuntap: synchronize through tfiles array instead of tun->numqueues
Date:   Wed, 15 May 2019 12:56:45 +0200
Message-Id: <20190515090702.734469763@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 9871a9e47a2646fe30ae7fd2e67668a8d30912f6 ]

When a queue(tfile) is detached through __tun_detach(), we move the
last enabled tfile to the position where detached one sit but don't
NULL out last position. We expect to synchronize the datapath through
tun->numqueues. Unfortunately, this won't work since we're lacking
sufficient mechanism to order or synchronize the access to
tun->numqueues.

To fix this, NULL out the last position during detaching and check
RCU protected tfile against NULL instead of checking tun->numqueues in
datapath.

Cc: YueHaibing <yuehaibing@huawei.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: weiyongjun (A) <weiyongjun1@huawei.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: c8d68e6be1c3b ("tuntap: multiqueue support")
Signed-off-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -705,6 +705,8 @@ static void __tun_detach(struct tun_file
 				   tun->tfiles[tun->numqueues - 1]);
 		ntfile = rtnl_dereference(tun->tfiles[index]);
 		ntfile->queue_index = index;
+		rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
+				   NULL);
 
 		--tun->numqueues;
 		if (clean) {
@@ -1087,7 +1089,7 @@ static netdev_tx_t tun_net_xmit(struct s
 	tfile = rcu_dereference(tun->tfiles[txq]);
 
 	/* Drop packet if interface is not attached */
-	if (txq >= tun->numqueues)
+	if (!tfile)
 		goto drop;
 
 	if (!rcu_dereference(tun->steering_prog))
@@ -1310,6 +1312,7 @@ static int tun_xdp_xmit(struct net_devic
 
 	rcu_read_lock();
 
+resample:
 	numqueues = READ_ONCE(tun->numqueues);
 	if (!numqueues) {
 		rcu_read_unlock();
@@ -1318,6 +1321,8 @@ static int tun_xdp_xmit(struct net_devic
 
 	tfile = rcu_dereference(tun->tfiles[smp_processor_id() %
 					    numqueues]);
+	if (unlikely(!tfile))
+		goto resample;
 
 	spin_lock(&tfile->tx_ring.producer_lock);
 	for (i = 0; i < n; i++) {


