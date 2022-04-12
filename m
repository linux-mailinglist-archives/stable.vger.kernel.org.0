Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C42C4FDA00
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352531AbiDLHqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356480AbiDLHgA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:36:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7E54A3EE;
        Tue, 12 Apr 2022 00:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6370C6146F;
        Tue, 12 Apr 2022 07:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B25C385A6;
        Tue, 12 Apr 2022 07:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747371;
        bh=3XFV5biq5OKl0CczAPZ36nRwmNhb5XFyF+xyv26CnHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASj+6bU47RexSFOwbVrYwVfvtDi5eOn4VC+z5zwI0GyOdrDk4FqfUSCVbQPIjLgur
         5ZD7M5xDvyzOskl95Nqy5sb9sHI35EunVF3au4tptGszQyjWMgCHhUJMMGzj5JShiK
         PdZ5FfU+GRX/YRRDY6BlDk9CIn8omRTKn5xx210E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 054/343] ref_tracker: implement use-after-free detection
Date:   Tue, 12 Apr 2022 08:27:52 +0200
Message-Id: <20220412062952.665386470@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e3ececfe668facd87d920b608349a32607060e66 ]

Whenever ref_tracker_dir_init() is called, mark the struct ref_tracker_dir
as dead.

Test the dead status from ref_tracker_alloc() and ref_tracker_free()

This should detect buggy dev_put()/dev_hold() happening too late
in netdevice dismantle process.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/ref_tracker.h | 2 ++
 lib/ref_tracker.c           | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/ref_tracker.h b/include/linux/ref_tracker.h
index 60f3453be23e..a443abda937d 100644
--- a/include/linux/ref_tracker.h
+++ b/include/linux/ref_tracker.h
@@ -13,6 +13,7 @@ struct ref_tracker_dir {
 	spinlock_t		lock;
 	unsigned int		quarantine_avail;
 	refcount_t		untracked;
+	bool			dead;
 	struct list_head	list; /* List of active trackers */
 	struct list_head	quarantine; /* List of dead trackers */
 #endif
@@ -26,6 +27,7 @@ static inline void ref_tracker_dir_init(struct ref_tracker_dir *dir,
 	INIT_LIST_HEAD(&dir->quarantine);
 	spin_lock_init(&dir->lock);
 	dir->quarantine_avail = quarantine_count;
+	dir->dead = false;
 	refcount_set(&dir->untracked, 1);
 	stack_depot_init();
 }
diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index a6789c0c626b..32ff6bd497f8 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -20,6 +20,7 @@ void ref_tracker_dir_exit(struct ref_tracker_dir *dir)
 	unsigned long flags;
 	bool leak = false;
 
+	dir->dead = true;
 	spin_lock_irqsave(&dir->lock, flags);
 	list_for_each_entry_safe(tracker, n, &dir->quarantine, head) {
 		list_del(&tracker->head);
@@ -72,6 +73,8 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
 	gfp_t gfp_mask = gfp;
 	unsigned long flags;
 
+	WARN_ON_ONCE(dir->dead);
+
 	if (gfp & __GFP_DIRECT_RECLAIM)
 		gfp_mask |= __GFP_NOFAIL;
 	*trackerp = tracker = kzalloc(sizeof(*tracker), gfp_mask);
@@ -100,6 +103,8 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 	unsigned int nr_entries;
 	unsigned long flags;
 
+	WARN_ON_ONCE(dir->dead);
+
 	if (!tracker) {
 		refcount_dec(&dir->untracked);
 		return -EEXIST;
-- 
2.35.1



