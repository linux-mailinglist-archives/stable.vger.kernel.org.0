Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31D968100C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbjA3N7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236892AbjA3N7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:59:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B651D3B0F5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:58:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6BB561034
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8307C4339C;
        Mon, 30 Jan 2023 13:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087120;
        bh=6WHQDc8uigQEnEIpjhMNOOk/exoAJWKCJDBgrhIhimM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2KrUKp5kTaIPVKViJ1lkWKkdbyWCWMknaaARTo/9+FXiA3a7hMKafrxDf3oxiaAL
         fhECFVA0cZTU4vLy+RzO141AIdiZ8WUbej7wpp6G2RY4olpUyPdYdKqASajH1ZxX07
         1eIIelz2cKQtEH31M6AhTyw5V1P8/NNJjsD5IptU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/313] sch_htb: Avoid grafting on htb_destroy_class_offload when destroying htb
Date:   Mon, 30 Jan 2023 14:48:28 +0100
Message-Id: <20230130134340.058333253@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit a22b7388d658ecfcd226600c8c34ce4481e88655 ]

Peek at old qdisc and graft only when deleting a leaf class in the htb,
rather than when deleting the htb itself. Do not peek at the qdisc of the
netdev queue when destroying the htb. The caller may already have grafted a
new qdisc that is not part of the htb structure being destroyed.

This fix resolves two use cases.

  1. Using tc to destroy the htb.
    - Netdev was being prematurely activated before the htb was fully
      destroyed.
  2. Using tc to replace the htb with another qdisc (which also leads to
     the htb being destroyed).
    - Premature netdev activation like previous case. Newly grafted qdisc
      was also getting accidentally overwritten when destroying the htb.

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20230113005528.302625-1-rrameshbabu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index e5b4bbf3ce3d..3afac9c21a76 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1545,7 +1545,7 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 	struct tc_htb_qopt_offload offload_opt;
 	struct netdev_queue *dev_queue;
 	struct Qdisc *q = cl->leaf.q;
-	struct Qdisc *old = NULL;
+	struct Qdisc *old;
 	int err;
 
 	if (cl->level)
@@ -1553,14 +1553,17 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 
 	WARN_ON(!q);
 	dev_queue = htb_offload_get_queue(cl);
-	old = htb_graft_helper(dev_queue, NULL);
-	if (destroying)
-		/* Before HTB is destroyed, the kernel grafts noop_qdisc to
-		 * all queues.
+	/* When destroying, caller qdisc_graft grafts the new qdisc and invokes
+	 * qdisc_put for the qdisc being destroyed. htb_destroy_class_offload
+	 * does not need to graft or qdisc_put the qdisc being destroyed.
+	 */
+	if (!destroying) {
+		old = htb_graft_helper(dev_queue, NULL);
+		/* Last qdisc grafted should be the same as cl->leaf.q when
+		 * calling htb_delete.
 		 */
-		WARN_ON(!(old->flags & TCQ_F_BUILTIN));
-	else
 		WARN_ON(old != q);
+	}
 
 	if (cl->parent) {
 		_bstats_update(&cl->parent->bstats_bias,
@@ -1577,10 +1580,12 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 	};
 	err = htb_offload(qdisc_dev(sch), &offload_opt);
 
-	if (!err || destroying)
-		qdisc_put(old);
-	else
-		htb_graft_helper(dev_queue, old);
+	if (!destroying) {
+		if (!err)
+			qdisc_put(old);
+		else
+			htb_graft_helper(dev_queue, old);
+	}
 
 	if (last_child)
 		return err;
-- 
2.39.0



