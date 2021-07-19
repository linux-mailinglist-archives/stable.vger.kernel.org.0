Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E183CDBC9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238723AbhGSOuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:50:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344389AbhGSOsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 702216141E;
        Mon, 19 Jul 2021 15:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708528;
        bh=m7AG3zOuLiNi7xGfbVE7T3RJueLBlRwxFnNvlXigvoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geOSgq3Ot+ylgTVqc0cJwjDyQUePXd/nYajJN8X6Gw4f1OXCqUhEA7/5ijv4gtc6J
         5lwi6IGEjScqGnOgOjfO27khMu9IoP9jV9OSPyZirT0WXmOhJ7iI/EIG8WAEZh87qo
         n9o02PnFp9eQ9MK0DxWXdFtwGck+qbmuw0ubgByc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.19 027/421] can: gw: synchronize rcu operations before removing gw job entry
Date:   Mon, 19 Jul 2021 16:47:18 +0200
Message-Id: <20210719144947.193132777@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
@@ -494,6 +494,7 @@ static int cgw_notifier(struct notifier_
 			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
 				hlist_del(&gwj->list);
 				cgw_unregister_filter(net, gwj);
+				synchronize_rcu();
 				kmem_cache_free(cgw_cache, gwj);
 			}
 		}
@@ -941,6 +942,7 @@ static void cgw_remove_all_jobs(struct n
 	hlist_for_each_entry_safe(gwj, nx, &net->can.cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(net, gwj);
+		synchronize_rcu();
 		kmem_cache_free(cgw_cache, gwj);
 	}
 }
@@ -1010,6 +1012,7 @@ static int cgw_remove_job(struct sk_buff
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(net, gwj);
+		synchronize_rcu();
 		kmem_cache_free(cgw_cache, gwj);
 		err = 0;
 		break;


