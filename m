Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DAE3C5F64
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 17:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhGLPkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 11:40:12 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:32118 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbhGLPkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 11:40:12 -0400
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jul 2021 11:40:12 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626103879;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=VCCKzHWL5GFuPMX/s6AcajGIkdXiWNhNRuqwnHp23OE=;
    b=ra3NWFDTfspDgnPxkbEQ/IwX6ZuqpoNVj7sqhvUr96g3wO6EnyltGUXwWRhXUsHvM4
    kqP0mjjPjQptR38er1W7FN3JxsQOeqfBCHsQ+XnxuL1OVPniLN1qmqLHXGSS0IFpgeDS
    l4QQtg2DPx/Z4wkzBRZ7XhZPpiZsqh6t5dujAv60ChJ1VN3LiWDL3lwLm15So42hEERz
    a7xPnKeT1TkTtf676l120nvZExy9Z+pboPkS4ODymc0DczSE1/HxkUVT+GK/vR2KOg4V
    8my/doVJMmFWUVvbh7Kg0qK43tuL0q4ZF8tD5rvx7PtodNuzD2pgP/RUdE82AlqdHmBl
    9Q6g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh+JyKAeyWJabqMyH2G"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.28.1 AUTH)
    with ESMTPSA id h0143fx6CFVJUqS
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 12 Jul 2021 17:31:19 +0200 (CEST)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     gregkh@linuxfoundation.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH stable 4.4 4.9] can: gw: synchronize rcu operations before removing gw job entry
Date:   Mon, 12 Jul 2021 17:30:35 +0200
Message-Id: <20210712153036.5937-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
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
---
 net/can/gw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/gw.c b/net/can/gw.c
index 81650affa3fa..1867000f8a65 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -495,10 +495,11 @@ static int cgw_notifier(struct notifier_block *nb,
 		hlist_for_each_entry_safe(gwj, nx, &cgw_list, list) {
 
 			if (gwj->src.dev == dev || gwj->dst.dev == dev) {
 				hlist_del(&gwj->list);
 				cgw_unregister_filter(gwj);
+				synchronize_rcu();
 				kmem_cache_free(cgw_cache, gwj);
 			}
 		}
 	}
 
@@ -939,10 +940,11 @@ static void cgw_remove_all_jobs(void)
 	ASSERT_RTNL();
 
 	hlist_for_each_entry_safe(gwj, nx, &cgw_list, list) {
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
+		synchronize_rcu();
 		kmem_cache_free(cgw_cache, gwj);
 	}
 }
 
 static int cgw_remove_job(struct sk_buff *skb, struct nlmsghdr *nlh)
@@ -1006,10 +1008,11 @@ static int cgw_remove_job(struct sk_buff *skb, struct nlmsghdr *nlh)
 		if (memcmp(&gwj->ccgw, &ccgw, sizeof(ccgw)))
 			continue;
 
 		hlist_del(&gwj->list);
 		cgw_unregister_filter(gwj);
+		synchronize_rcu();
 		kmem_cache_free(cgw_cache, gwj);
 		err = 0;
 		break;
 	}
 
-- 
2.30.2

