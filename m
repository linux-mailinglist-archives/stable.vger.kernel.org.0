Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B5E2F9E8F
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390511AbhARLn1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:43:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:38240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390448AbhARLnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1CBB222BB;
        Mon, 18 Jan 2021 11:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970168;
        bh=rj2Eax+7ExLPE3QuPxlwre5KEV7jBMddBFgcI9QpmMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQEcRDMcK30XmQmzkI+qbPbLOEjbaVCo1NpsR1Cg9gaUaOISdRFDFcWFoqcOoksbv
         lYhwzp56WalfSK04j7fvQ9Vo/7QMM7u5AG6lxeMv/7x9qydjhW5i2BlaehUwO9EtSS
         kcOmOl+OWMbuFo0mB6K9AelfIz9CM7aF54oOBUtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/152] btrfs: merge critical sections of discard lock in workfn
Date:   Mon, 18 Jan 2021 12:33:59 +0100
Message-Id: <20210118113355.860693038@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 8fc058597a283e9a37720abb0e8d68e342b9387d ]

btrfs_discard_workfn() drops discard_ctl->lock just to take it again in
a moment in btrfs_discard_schedule_work(). Avoid that and also reuse
ktime.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/discard.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
index d1a5380e8827d..9e1a06144e32d 100644
--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -328,28 +328,15 @@ void btrfs_discard_queue_work(struct btrfs_discard_ctl *discard_ctl,
 		btrfs_discard_schedule_work(discard_ctl, false);
 }
 
-/**
- * btrfs_discard_schedule_work - responsible for scheduling the discard work
- * @discard_ctl: discard control
- * @override: override the current timer
- *
- * Discards are issued by a delayed workqueue item.  @override is used to
- * update the current delay as the baseline delay interval is reevaluated on
- * transaction commit.  This is also maxed with any other rate limit.
- */
-void btrfs_discard_schedule_work(struct btrfs_discard_ctl *discard_ctl,
-				 bool override)
+static void __btrfs_discard_schedule_work(struct btrfs_discard_ctl *discard_ctl,
+					  u64 now, bool override)
 {
 	struct btrfs_block_group *block_group;
-	const u64 now = ktime_get_ns();
-
-	spin_lock(&discard_ctl->lock);
 
 	if (!btrfs_run_discard_work(discard_ctl))
-		goto out;
-
+		return;
 	if (!override && delayed_work_pending(&discard_ctl->work))
-		goto out;
+		return;
 
 	block_group = find_next_block_group(discard_ctl, now);
 	if (block_group) {
@@ -382,7 +369,24 @@ void btrfs_discard_schedule_work(struct btrfs_discard_ctl *discard_ctl,
 		mod_delayed_work(discard_ctl->discard_workers,
 				 &discard_ctl->work, delay);
 	}
-out:
+}
+
+/*
+ * btrfs_discard_schedule_work - responsible for scheduling the discard work
+ * @discard_ctl:  discard control
+ * @override:     override the current timer
+ *
+ * Discards are issued by a delayed workqueue item.  @override is used to
+ * update the current delay as the baseline delay interval is reevaluated on
+ * transaction commit.  This is also maxed with any other rate limit.
+ */
+void btrfs_discard_schedule_work(struct btrfs_discard_ctl *discard_ctl,
+				 bool override)
+{
+	const u64 now = ktime_get_ns();
+
+	spin_lock(&discard_ctl->lock);
+	__btrfs_discard_schedule_work(discard_ctl, now, override);
 	spin_unlock(&discard_ctl->lock);
 }
 
@@ -487,9 +491,8 @@ static void btrfs_discard_workfn(struct work_struct *work)
 
 	spin_lock(&discard_ctl->lock);
 	discard_ctl->block_group = NULL;
+	__btrfs_discard_schedule_work(discard_ctl, now, false);
 	spin_unlock(&discard_ctl->lock);
-
-	btrfs_discard_schedule_work(discard_ctl, false);
 }
 
 /**
-- 
2.27.0



