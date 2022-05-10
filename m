Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E65521AAE
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245223AbiEJODQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245402AbiEJN5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:57:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F635BA9B6;
        Tue, 10 May 2022 06:39:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E20CE615E9;
        Tue, 10 May 2022 13:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F3FC385A6;
        Tue, 10 May 2022 13:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189958;
        bh=+mJTXgsOIxd3Wmqr468P9HZLAksdzKwrV1S7ZpA+WV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y8rZlnkQv+5NWqtxBs8Fb1iT7ET6ymVhAxjuxYeteeQYEbNmrTeqKsg1IeLR1LDE9
         0aZ+eYP1zC1obOlnaQaHwoVQhT+I3XleQC/dPQZVh6NaqzBmA9kfPIXRz37XN2QFJj
         o9rkEvGpRZ3fB7+DO3hh/ZT5+XkdvUMrzKkGISqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.17 081/140] RDMA/irdma: Reduce iWARP QP destroy time
Date:   Tue, 10 May 2022 15:07:51 +0200
Message-Id: <20220510130743.929800313@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shiraz Saleem <shiraz.saleem@intel.com>

commit 2df6d895907b2f5dfbc558cbff7801bba82cb3cc upstream.

QP destroy is synchronous and waits for its refcnt to be decremented in
irdma_cm_node_free_cb (for iWARP) which fires after the RCU grace period
elapses.

Applications running a large number of connections are exposed to high
wait times on destroy QP for events like SIGABORT.

The long pole for this wait time is the firing of the call_rcu callback
during a CM node destroy which can be slow. It holds the QP reference
count and blocks the destroy QP from completing.

call_rcu only needs to make sure that list walkers have a reference to the
cm_node object before freeing it and thus need to wait for grace period
elapse. The rest of the connection teardown in irdma_cm_node_free_cb is
moved out of the grace period wait in irdma_destroy_connection. Also,
replace call_rcu with a simple kfree_rcu as it just needs to do a kfree on
the cm_node

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Link: https://lore.kernel.org/r/20220425181703.1634-3-shiraz.saleem@intel.com
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/irdma/cm.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -2305,10 +2305,8 @@ err:
 	return NULL;
 }
 
-static void irdma_cm_node_free_cb(struct rcu_head *rcu_head)
+static void irdma_destroy_connection(struct irdma_cm_node *cm_node)
 {
-	struct irdma_cm_node *cm_node =
-			    container_of(rcu_head, struct irdma_cm_node, rcu_head);
 	struct irdma_cm_core *cm_core = cm_node->cm_core;
 	struct irdma_qp *iwqp;
 	struct irdma_cm_info nfo;
@@ -2356,7 +2354,6 @@ static void irdma_cm_node_free_cb(struct
 	}
 
 	cm_core->cm_free_ah(cm_node);
-	kfree(cm_node);
 }
 
 /**
@@ -2384,8 +2381,9 @@ void irdma_rem_ref_cm_node(struct irdma_
 
 	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
 
-	/* wait for all list walkers to exit their grace period */
-	call_rcu(&cm_node->rcu_head, irdma_cm_node_free_cb);
+	irdma_destroy_connection(cm_node);
+
+	kfree_rcu(cm_node, rcu_head);
 }
 
 /**


