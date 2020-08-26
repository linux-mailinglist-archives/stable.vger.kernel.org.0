Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B801A252DA3
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 14:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbgHZMD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 08:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729568AbgHZMDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 08:03:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C5EE20838;
        Wed, 26 Aug 2020 12:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598443432;
        bh=5U+tmU2juCn60do5qpSxUDlrHl9vpMadgZ7NJ3teTpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y72geNk0tivsoxj6aznK3FHVT3zEvW1GEn6MfqbiXWW3mJEAIq/d994taq72Y2t/j
         eF4hF8aZIznq/goytEx3AXsCyHYCUtxtGtkJ2TNmQYvrvmtPKI4UwtBWhU4PjX+U17
         6/6qWPfrlCvW/pl5elHihT5FPrNRoG7nnHP8C1o8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+47bbc6b678d317cccbe0@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 08/16] tipc: call rcu_read_lock() in tipc_aead_encrypt_done()
Date:   Wed, 26 Aug 2020 14:02:45 +0200
Message-Id: <20200826114911.633044442@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826114911.216745274@linuxfoundation.org>
References: <20200826114911.216745274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit f6db9096416209474090d64d8284e7c16c3d8873 ]

b->media->send_msg() requires rcu_read_lock(), as we can see
elsewhere in tipc,  tipc_bearer_xmit, tipc_bearer_xmit_skb
and tipc_bearer_bc_xmit().

Syzbot has reported this issue as:

  net/tipc/bearer.c:466 suspicious rcu_dereference_check() usage!
  Workqueue: cryptd cryptd_queue_worker
  Call Trace:
   tipc_l2_send_msg+0x354/0x420 net/tipc/bearer.c:466
   tipc_aead_encrypt_done+0x204/0x3a0 net/tipc/crypto.c:761
   cryptd_aead_crypt+0xe8/0x1d0 crypto/cryptd.c:739
   cryptd_queue_worker+0x118/0x1b0 crypto/cryptd.c:181
   process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
   worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
   kthread+0x3b5/0x4a0 kernel/kthread.c:291
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293

So fix it by calling rcu_read_lock() in tipc_aead_encrypt_done()
for b->media->send_msg().

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Reported-by: syzbot+47bbc6b678d317cccbe0@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/crypto.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -757,10 +757,12 @@ static void tipc_aead_encrypt_done(struc
 	switch (err) {
 	case 0:
 		this_cpu_inc(tx->stats->stat[STAT_ASYNC_OK]);
+		rcu_read_lock();
 		if (likely(test_bit(0, &b->up)))
 			b->media->send_msg(net, skb, b, &tx_ctx->dst);
 		else
 			kfree_skb(skb);
+		rcu_read_unlock();
 		break;
 	case -EINPROGRESS:
 		return;


