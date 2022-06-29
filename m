Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13501560C7A
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 00:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiF2WuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 18:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiF2Wt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 18:49:59 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BE21C91B
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 15:49:56 -0700 (PDT)
Received: (Authenticated sender: didi.debian@cknow.org)
        by mail.gandi.net (Postfix) with ESMTPSA id 06BEF240003;
        Wed, 29 Jun 2022 22:49:54 +0000 (UTC)
From:   Diederik de Haas <didi.debian@cknow.org>
To:     stable@vger.kernel.org
Cc:     Vlad Buslov <vladbu@mellanox.com>,
        Diederik de Haas <didi.debian@cknow.org>,
        Thorsten Glaser <tg@mirbsd.de>
Subject: [PATCH] [4.19.y] net/sched: move NULL ptr check to qdisc_put() too
Date:   Thu, 30 Jun 2022 00:49:38 +0200
Message-Id: <20220629224938.7760-1-didi.debian@cknow.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit 92833e8b5db6c209e9311ac8c6a44d3bf1856659 titled
"net: sched: rename qdisc_destroy() to qdisc_put()" part of the
functionality of qdisc_destroy() was moved into a (for linux-4.19.y)
new function qdisk_put(), and the previous calls to qdisc_destroy()
were changed to qdisk_put().
This made it similar to f.e. 5.10.y and current master.

There was one part of qdisc_destroy() not moved over to qdisc_put() and
that was the check for a NULL pointer, causing oopses.
(See upstream commit: 6efb971ba8edfbd80b666f29de12882852f095ae)
This patch fixes that.

Fixes: 92833e8b5db6c209e9311ac8c6a44d3bf1856659
Reported-by: Thorsten Glaser <tg@mirbsd.de>
Link: https://bugs.debian.org/1013299
Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
---
 net/sched/sch_generic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 7c1b1eff84f4..cad2586c3473 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -970,8 +970,6 @@ static void qdisc_destroy(struct Qdisc *qdisc)
 	const struct Qdisc_ops *ops;
 	struct sk_buff *skb, *tmp;
 
-	if (!qdisc)
-		return;
 	ops = qdisc->ops;
 
 #ifdef CONFIG_NET_SCHED
@@ -1003,6 +1001,9 @@ static void qdisc_destroy(struct Qdisc *qdisc)
 
 void qdisc_put(struct Qdisc *qdisc)
 {
+	if (!qdisc)
+		return;
+
 	if (qdisc->flags & TCQ_F_BUILTIN ||
 	    !refcount_dec_and_test(&qdisc->refcnt))
 		return;
-- 
2.36.1

