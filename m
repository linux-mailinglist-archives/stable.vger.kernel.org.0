Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF695200C4A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388180AbgFSOnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:34932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388505AbgFSOnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:43:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0A3521707;
        Fri, 19 Jun 2020 14:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577825;
        bh=FeCyewu7Db/5Xu+nwArUyTocoh2rNveCn+wmznFtYgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ih41QiMEesPmK1iwXm2rdkyjvyAXokcQqXmgqhlccbfVwo9z6NVYcnLZxN4HCgVQG
         GonSeOmUxL9658eAhc+65TgWexTRDynajSRd8SMCgLoLi/gnzMBquXtSLAVgklgw6G
         EuIgttamJubvMJ4quODT4oTWHr25hzRbtIuY2qeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Giuliano Procida <gprocida@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 105/128] blk-mq: move blk_mq_update_nr_hw_queues synchronize_rcu call
Date:   Fri, 19 Jun 2020 16:33:19 +0200
Message-Id: <20200619141625.689301820@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141620.148019466@linuxfoundation.org>
References: <20200619141620.148019466@linuxfoundation.org>
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
4.9 backport commit f530afb974c2e82047bd6220303a2dbe30eff304
which was
upstream commit f5bbbbe4d63577026f908a809f22f5fd5a90ea1f.

The upstream commit added a call to synchronize_rcu to
_blk_mq_update_nr_hw_queues, just after freezing queues.

In the backport this landed (in blk_mq_update_nr_hw_queues instead),
just after unfreezeing queues.

This commit moves the call to its intended place.

Fixes: f530afb974c2 ("blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter")
Signed-off-by: Giuliano Procida <gprocida@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 58be2eaa5aaa..e0ed7317e98c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2331,6 +2331,10 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_freeze_queue(q);
+	/*
+	 * Sync with blk_mq_queue_tag_busy_iter.
+	 */
+	synchronize_rcu();
 
 	set->nr_hw_queues = nr_hw_queues;
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
@@ -2346,10 +2350,6 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
 
 	list_for_each_entry(q, &set->tag_list, tag_set_list)
 		blk_mq_unfreeze_queue(q);
-	/*
-	 * Sync with blk_mq_queue_tag_busy_iter.
-	 */
-	synchronize_rcu();
 }
 EXPORT_SYMBOL_GPL(blk_mq_update_nr_hw_queues);
 
-- 
2.25.1



