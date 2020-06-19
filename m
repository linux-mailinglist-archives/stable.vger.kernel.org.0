Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECAB201673
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388286AbgFSQbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389666AbgFSOxE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:53:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DCF4217D8;
        Fri, 19 Jun 2020 14:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578384;
        bh=krZvaaKbZupcbCVuMdkXCRkKX12CC/ankJb4E+BbGlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HrSTWEmf1Ke8kGY2HGhFONcH1K879xvT/RPoBgKRobR10+rDKjm7HvkikVhxB3g5f
         gTV6uzu2l1o/0m/+mLaNCuXEOxWH7A/DWsVbBXKuiX/FA6eacezDW3JAsxwKl1gz3r
         6eVfamk2r8rZT1E2FUd2OwUcbb/6DT2iUj/ry+gE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Giuliano Procida <gprocida@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 161/190] blk-mq: move _blk_mq_update_nr_hw_queues synchronize_rcu call
Date:   Fri, 19 Jun 2020 16:33:26 +0200
Message-Id: <20200619141641.804697508@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Giuliano Procida <gprocida@google.com>

This fixes the
4.14 backport commit 574eb136ec7f315c3ef2ca68fa9b3e16c56baa24
which was
upstream commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f.

The upstream commit added a call to synchronize_rcu to
_blk_mq_update_nr_hw_queues, just after freezing queues.

In the backport this landed just after unfreezeing queues.

This commit moves the call to its intended place.

Fixes: 574eb136ec7f ("blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter")
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9d53f476c517..cf56bdad2e06 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2738,6 +2738,10 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_freeze_queue(q);
+	/*
+	 * Sync with blk_mq_queue_tag_busy_iter.
+	 */
+	synchronize_rcu();
 
 	set->nr_hw_queues = nr_hw_queues;
 	blk_mq_update_queue_map(set);
@@ -2748,10 +2752,6 @@ static void __blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set,
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_unfreeze_queue(q);
-	/*
-	 * Sync with blk_mq_queue_tag_busy_iter.
-	 */
-	synchronize_rcu();
 }
 
 void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
-- 
2.25.1



