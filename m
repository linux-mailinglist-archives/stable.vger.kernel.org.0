Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BBC383152
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240159AbhEQOgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240402AbhEQOeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:34:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15F97613F8;
        Mon, 17 May 2021 14:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261007;
        bh=ln//Pg6dZHhKTER4ykJcOQPJKAQkkz386kNjhSNwFlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6JvZMp3CYa11AeAldhMQrTsWVt8QOPXRXChKy+3Olrve8SbRxHl3bCwQWN0azzkh
         wUwnERz3uUqHTPb7fRxlRnd2mCklZ0KDBMuEY2/00mEhgbrtmaE3xvjYmkz1A9TaUt
         hkhT78+3LgjwbNEAGocjmxIWn5eK39LbXfZekdVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 280/363] dax: Add an enum for specifying dax wakup mode
Date:   Mon, 17 May 2021 16:02:26 +0200
Message-Id: <20210517140312.075682084@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

[ Upstream commit 698ab77aebffe08b312fbcdddeb0e8bd08b78717 ]

Dan mentioned that he is not very fond of passing around a boolean true/false
to specify if only next waiter should be woken up or all waiters should be
woken up. He instead prefers that we introduce an enum and make it very
explicity at the callsite itself. Easier to read code.

This patch should not introduce any change of behavior.

Reviewed-by: Greg Kurz <groug@kaod.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Link: https://lore.kernel.org/r/20210428190314.1865312-2-vgoyal@redhat.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dax.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index b3d27fdc6775..5ecee51c44ee 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -144,6 +144,16 @@ struct wait_exceptional_entry_queue {
 	struct exceptional_entry_key key;
 };
 
+/**
+ * enum dax_wake_mode: waitqueue wakeup behaviour
+ * @WAKE_ALL: wake all waiters in the waitqueue
+ * @WAKE_NEXT: wake only the first waiter in the waitqueue
+ */
+enum dax_wake_mode {
+	WAKE_ALL,
+	WAKE_NEXT,
+};
+
 static wait_queue_head_t *dax_entry_waitqueue(struct xa_state *xas,
 		void *entry, struct exceptional_entry_key *key)
 {
@@ -182,7 +192,8 @@ static int wake_exceptional_entry_func(wait_queue_entry_t *wait,
  * The important information it's conveying is whether the entry at
  * this index used to be a PMD entry.
  */
-static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
+static void dax_wake_entry(struct xa_state *xas, void *entry,
+			   enum dax_wake_mode mode)
 {
 	struct exceptional_entry_key key;
 	wait_queue_head_t *wq;
@@ -196,7 +207,7 @@ static void dax_wake_entry(struct xa_state *xas, void *entry, bool wake_all)
 	 * must be in the waitqueue and the following check will see them.
 	 */
 	if (waitqueue_active(wq))
-		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
+		__wake_up(wq, TASK_NORMAL, mode == WAKE_ALL ? 0 : 1, &key);
 }
 
 /*
@@ -268,7 +279,7 @@ static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
 	if (entry && !dax_is_conflict(entry))
-		dax_wake_entry(xas, entry, false);
+		dax_wake_entry(xas, entry, WAKE_NEXT);
 }
 
 /*
@@ -286,7 +297,7 @@ static void dax_unlock_entry(struct xa_state *xas, void *entry)
 	old = xas_store(xas, entry);
 	xas_unlock_irq(xas);
 	BUG_ON(!dax_is_locked(old));
-	dax_wake_entry(xas, entry, false);
+	dax_wake_entry(xas, entry, WAKE_NEXT);
 }
 
 /*
@@ -524,7 +535,7 @@ static void *grab_mapping_entry(struct xa_state *xas,
 
 		dax_disassociate_entry(entry, mapping, false);
 		xas_store(xas, NULL);	/* undo the PMD join */
-		dax_wake_entry(xas, entry, true);
+		dax_wake_entry(xas, entry, WAKE_ALL);
 		mapping->nrexceptional--;
 		entry = NULL;
 		xas_set(xas, index);
@@ -937,7 +948,7 @@ static int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
 	xas_lock_irq(xas);
 	xas_store(xas, entry);
 	xas_clear_mark(xas, PAGECACHE_TAG_DIRTY);
-	dax_wake_entry(xas, entry, false);
+	dax_wake_entry(xas, entry, WAKE_NEXT);
 
 	trace_dax_writeback_one(mapping->host, index, count);
 	return ret;
-- 
2.30.2



