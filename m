Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27922681163
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbjA3ONP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237298AbjA3ONH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:13:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B3C3C2A8
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:12:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D9A36102E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50773C433EF;
        Mon, 30 Jan 2023 14:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087965;
        bh=2op0mRSE3g0bGWPNlW7+TDvtUCRJRRRCNOKwpT50KeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZMVKbaBAOnieW258YJqGontNzvoHU32Opne7ZQOLhXAinxhRpKZsLo4C5JJ8zVtl
         ZOgHZJcz+XPek+r3+v4pKRkf+QmWUkScTga6Fddxx93WpTEBLGwS3liI1g1uAXFET4
         E4kGN80AgQICaabcKSgYVVsp3A8tbW13DA1LOdvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/204] sch_htb: Avoid grafting on htb_destroy_class_offload when destroying htb
Date:   Mon, 30 Jan 2023 14:50:06 +0100
Message-Id: <20230130134318.122805636@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index caabdaa2f30f..45b92e40082e 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1558,7 +1558,7 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 	struct tc_htb_qopt_offload offload_opt;
 	struct netdev_queue *dev_queue;
 	struct Qdisc *q = cl->leaf.q;
-	struct Qdisc *old = NULL;
+	struct Qdisc *old;
 	int err;
 
 	if (cl->level)
@@ -1566,14 +1566,17 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
 
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
 		cl->parent->bstats_bias.bytes += q->bstats.bytes;
@@ -1589,10 +1592,12 @@ static int htb_destroy_class_offload(struct Qdisc *sch, struct htb_class *cl,
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



