Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198DD3CD83A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241491AbhGSOVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242600AbhGSOUF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:20:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EF7561263;
        Mon, 19 Jul 2021 15:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706844;
        bh=Avt3c1kTwwQobc01mLPNGoA7Y6A7NkOUJIcZUU2Fwu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G7rDWCULwk3ix7nfO3zkzw1iEiehCepwKgg5VLE9Jbtmn/6x1T9vXfKmkxwajCP+M
         paTL0cCIQ8/eYuIt1S2Ww1DA3O2M8yMxkBAFXkmtIPAKdAE/9aN0Qk+ao704DAYFES
         SKEBp5dhnsQDXy+2DUFpx0SgCM+xJomoPHqhXvu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 124/188] can: gw: synchronize rcu operations before removing gw job entry
Date:   Mon, 19 Jul 2021 16:51:48 +0200
Message-Id: <20210719144940.542402820@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit fb8696ab14adadb2e3f6c17c18ed26b3ecd96691 upstream.

can_can_gw_rcv() is called under RCU protection, so after calling
can_rx_unregister(), we have to call synchronize_rcu in order to wait
for any RCU read-side critical sections to finish before removing the
kmem_cache entry with the referenced gw job entry.

Link: https://lore.kernel.org/r/20210618173645.2238-1-socketcan@hartkopp.net
Fixes: c1aabdf379bc ("can-gw: add netlink based CAN routing")
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/can/gw.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -497,6 +497,7 @@ static int cgw_notifier(struct notifier_
 			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
 				hlist_del(&gwj->list);
 				cgw_unregister_filter(gwj);
+				synchronize_rcu();
 				kmem_cache_free(cgw_cache, gwj);
 			}
 		}
@@ -941,6 +942,7 @@ static void cgw_remove_all_jobs(void)
 	hlist_for_each_entry_safe(gwj, nx, &cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
+		synchronize_rcu();
 		kmem_cache_free(cgw_cache, gwj);
 	}
 }
@@ -1008,6 +1010,7 @@ static int cgw_remove_job(struct sk_buff
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
+		synchronize_rcu();
 		kmem_cache_free(cgw_cache, gwj);
 		err = 0;
 		break;


