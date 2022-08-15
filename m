Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08A95940CA
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239594AbiHOVS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346297AbiHOVSD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:18:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDAE5A147;
        Mon, 15 Aug 2022 12:21:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0FC10B810C6;
        Mon, 15 Aug 2022 19:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4926AC433D6;
        Mon, 15 Aug 2022 19:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591277;
        bh=2rlkvR+VSCNZxJ9MpCjFN9T0LkYJDu75Wd2nel5TUv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oW+RQWsuB0XOvYx9LhU4t0EYhtaMghyJKnhLHZyCk4wr8Yj/nvkoBpFrtnMyVbWTx
         S11V4B0Davo6lovVCOLlUbac+362atI+FZ2+Hkl195PPmAHy/ECVF5ybnF+NBuHUDT
         1lLRRXsPXvAcVeTgSijjUEnOY+fdhpW5jyG4YAus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0527/1095] netdevsim: fib: Fix reference count leak on route deletion failure
Date:   Mon, 15 Aug 2022 19:58:46 +0200
Message-Id: <20220815180451.357535785@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 180a6a3ee60a7cb69ed1232388460644f6a21f00 ]

As part of FIB offload simulation, netdevsim stores IPv4 and IPv6 routes
and holds a reference on FIB info structures that in turn hold a
reference on the associated nexthop device(s).

In the unlikely case where we are unable to allocate memory to process a
route deletion request, netdevsim will not release the reference from
the associated FIB info structure, thereby preventing the associated
nexthop device(s) from ever being removed [1].

Fix this by scheduling a work item that will flush netdevsim's FIB table
upon route deletion failure. This will cause netdevsim to release its
reference from all the FIB info structures in its table.

Reported by Lucas Leong of Trend Micro Zero Day Initiative.

Fixes: 0ae3eb7b4611 ("netdevsim: fib: Perform the route programming in a non-atomic context")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/fib.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 378ee779061c..14787d17f703 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -53,6 +53,7 @@ struct nsim_fib_data {
 	struct rhashtable nexthop_ht;
 	struct devlink *devlink;
 	struct work_struct fib_event_work;
+	struct work_struct fib_flush_work;
 	struct list_head fib_event_queue;
 	spinlock_t fib_event_queue_lock; /* Protects fib event queue list */
 	struct mutex nh_lock; /* Protects NH HT */
@@ -977,7 +978,7 @@ static int nsim_fib_event_schedule_work(struct nsim_fib_data *data,
 
 	fib_event = kzalloc(sizeof(*fib_event), GFP_ATOMIC);
 	if (!fib_event)
-		return NOTIFY_BAD;
+		goto err_fib_event_alloc;
 
 	fib_event->data = data;
 	fib_event->event = event;
@@ -1005,6 +1006,9 @@ static int nsim_fib_event_schedule_work(struct nsim_fib_data *data,
 
 err_fib_prepare_event:
 	kfree(fib_event);
+err_fib_event_alloc:
+	if (event == FIB_EVENT_ENTRY_DEL)
+		schedule_work(&data->fib_flush_work);
 	return NOTIFY_BAD;
 }
 
@@ -1482,6 +1486,24 @@ static void nsim_fib_event_work(struct work_struct *work)
 	mutex_unlock(&data->fib_lock);
 }
 
+static void nsim_fib_flush_work(struct work_struct *work)
+{
+	struct nsim_fib_data *data = container_of(work, struct nsim_fib_data,
+						  fib_flush_work);
+	struct nsim_fib_rt *fib_rt, *fib_rt_tmp;
+
+	/* Process pending work. */
+	flush_work(&data->fib_event_work);
+
+	mutex_lock(&data->fib_lock);
+	list_for_each_entry_safe(fib_rt, fib_rt_tmp, &data->fib_rt_list, list) {
+		rhashtable_remove_fast(&data->fib_rt_ht, &fib_rt->ht_node,
+				       nsim_fib_rt_ht_params);
+		nsim_fib_rt_free(fib_rt, data);
+	}
+	mutex_unlock(&data->fib_lock);
+}
+
 static int
 nsim_fib_debugfs_init(struct nsim_fib_data *data, struct nsim_dev *nsim_dev)
 {
@@ -1540,6 +1562,7 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 		goto err_rhashtable_nexthop_destroy;
 
 	INIT_WORK(&data->fib_event_work, nsim_fib_event_work);
+	INIT_WORK(&data->fib_flush_work, nsim_fib_flush_work);
 	INIT_LIST_HEAD(&data->fib_event_queue);
 	spin_lock_init(&data->fib_event_queue_lock);
 
@@ -1586,6 +1609,7 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 err_nexthop_nb_unregister:
 	unregister_nexthop_notifier(devlink_net(devlink), &data->nexthop_nb);
 err_rhashtable_fib_destroy:
+	cancel_work_sync(&data->fib_flush_work);
 	flush_work(&data->fib_event_work);
 	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
 				    data);
@@ -1615,6 +1639,7 @@ void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 					    NSIM_RESOURCE_IPV4_FIB);
 	unregister_fib_notifier(devlink_net(devlink), &data->fib_nb);
 	unregister_nexthop_notifier(devlink_net(devlink), &data->nexthop_nb);
+	cancel_work_sync(&data->fib_flush_work);
 	flush_work(&data->fib_event_work);
 	rhashtable_free_and_destroy(&data->fib_rt_ht, nsim_fib_rt_free,
 				    data);
-- 
2.35.1



