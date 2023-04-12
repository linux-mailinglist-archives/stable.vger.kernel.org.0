Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23496DEF11
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjDLIrI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231224AbjDLIrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:47:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB40F72A7
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBFF763107
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBFFC433EF;
        Wed, 12 Apr 2023 08:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289200;
        bh=NdJIdttaNnPy+/lC6CYgAQwQRlNTxsx9GHiIsy2XfZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QR/h/+evK5/haaK+pHn7fCVx6hy0ddJffQAJFk+SXbZ2ekpUgkTEMAkt4sDMZJFbQ
         xNNwi+JTBbnWZyI7hYprli4gHt3X5mRgJhSyUgTkf5utcb/DA5QNpk1u4i+HFG5q3g
         KxDtnKH/0koaX2R9vMJGZzh+I5a3VNA9waaNMS/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 001/173] dm cache: Add some documentation to dm-cache-background-tracker.h
Date:   Wed, 12 Apr 2023 10:32:07 +0200
Message-Id: <20230412082838.191564117@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

[ Upstream commit 22c40e134c4c7a828ac09d25a5a8597b1e45c031 ]

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Stable-dep-of: f7b58a69fad9 ("dm: fix improper splitting for abnormal bios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-background-tracker.h | 40 ++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-cache-background-tracker.h b/drivers/md/dm-cache-background-tracker.h
index 27ab90dbc2752..b5056e8275c15 100644
--- a/drivers/md/dm-cache-background-tracker.h
+++ b/drivers/md/dm-cache-background-tracker.h
@@ -12,19 +12,44 @@
 
 /*----------------------------------------------------------------*/
 
+/*
+ * The cache policy decides what background work should be performed,
+ * such as promotions, demotions and writebacks. The core cache target
+ * is in charge of performing the work, and does so when it sees fit.
+ *
+ * The background_tracker acts as a go between. Keeping track of future
+ * work that the policy has decided upon, and handing (issuing) it to
+ * the core target when requested.
+ *
+ * There is no locking in this, so calls will probably need to be
+ * protected with a spinlock.
+ */
+
 struct background_work;
 struct background_tracker;
 
 /*
- * FIXME: discuss lack of locking in all methods.
+ * Create a new tracker, it will not be able to queue more than
+ * 'max_work' entries.
  */
 struct background_tracker *btracker_create(unsigned max_work);
+
+/*
+ * Destroy the tracker. No issued, but not complete, work should
+ * exist when this is called. It is fine to have queued but unissued
+ * work.
+ */
 void btracker_destroy(struct background_tracker *b);
 
 unsigned btracker_nr_writebacks_queued(struct background_tracker *b);
 unsigned btracker_nr_demotions_queued(struct background_tracker *b);
 
 /*
+ * Queue some work within the tracker. 'work' should point to the work
+ * to queue, this will be copied (ownership doesn't pass).  If pwork
+ * is not NULL then it will be set to point to the tracker's internal
+ * copy of the work.
+ *
  * returns -EINVAL iff the work is already queued.  -ENOMEM if the work
  * couldn't be queued for another reason.
  */
@@ -33,11 +58,20 @@ int btracker_queue(struct background_tracker *b,
 		   struct policy_work **pwork);
 
 /*
+ * Hands out the next piece of work to be performed.
  * Returns -ENODATA if there's no work.
  */
 int btracker_issue(struct background_tracker *b, struct policy_work **work);
-void btracker_complete(struct background_tracker *b,
-		       struct policy_work *op);
+
+/*
+ * Informs the tracker that the work has been completed and it may forget
+ * about it.
+ */
+void btracker_complete(struct background_tracker *b, struct policy_work *op);
+
+/*
+ * Predicate to see if an origin block is already scheduled for promotion.
+ */
 bool btracker_promotion_already_present(struct background_tracker *b,
 					dm_oblock_t oblock);
 
-- 
2.39.2



