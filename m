Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7082F3161
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbhALNSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:18:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389251AbhALM5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C34AA23123;
        Tue, 12 Jan 2021 12:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456149;
        bh=rj2Eax+7ExLPE3QuPxlwre5KEV7jBMddBFgcI9QpmMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sMPVk2faf7QZL9LBI3SfJEFfYLVETq4qF3uAWHJNIN9i9BF2+oU517/lH0BOlmBd4
         aean6SM7nk4iwo7oJ9L6rKZkfFr3U/WGTLB5+taTpiMWqi0YRhAQ06gnX5lwyiufOw
         AR6RGXD3x6yhOKz7F7PsgYlbv2SPEgd6+MajyuhoMZaNoDSdm6Kx9iSIhuiggoRLur
         Ngv19oS3d7k9nr7FqZUSKZNvY9udayO9KIQ547mmYdTJ7cmd5n4UhkDb+yz7TUdRPx
         mhKmJMReHFln2fvrDBM9+/rmCZRKaP8iiEWjBWg7MfEmOvvx6tWr3PM0E0YNsCvlgM
         aal1TlcuE+m0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/51] btrfs: merge critical sections of discard lock in workfn
Date:   Tue, 12 Jan 2021 07:54:53 -0500
Message-Id: <20210112125534.70280-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

